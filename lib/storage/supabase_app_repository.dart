import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/app_state.dart';
import '../models/initial_map.dart';
import '../models/hypothesis_item.dart';
import '../models/journey_plan.dart';
import '../models/learning_journey_state.dart';
import '../models/user_preferences.dart';
import 'app_repository.dart';

class SupabaseAppRepository implements SyncableAppRepository, HypothesisAppRepository {
  SupabaseAppRepository({required this.prefs, required this.client});

  final SharedPreferences prefs;
  final SupabaseClient client;

  static const _legacyKey = 'malaak_app_state_v2';
  static const _prefix = 'malaak_app_state_v3';
  static const _legacyClaimKey = 'malaak_v2_imported_to_user';

  DateTime? _lastSyncAt;
  String? _lastSyncError;

  String get _accountId => client.auth.currentUser?.id ?? 'guest';
  String get _localKey => '${_prefix}_$_accountId';
  String get _dirtyKey => '${_localKey}_dirty';

  @override
  bool get isAuthenticated => client.auth.currentUser != null;

  @override
  bool get hasPendingLocalChanges => prefs.getBool(_dirtyKey) ?? false;

  @override
  String? get userEmail => client.auth.currentUser?.email;

  @override
  DateTime? get lastSyncAt => _lastSyncAt;

  @override
  String? get lastSyncError => _lastSyncError;

  @override
  Future<AppStateData> load() async {
    var local = await _loadLocal();
    final user = client.auth.currentUser;
    if (user == null) return local;

    if (hasPendingLocalChanges && _hasMeaningfulData(local)) {
      final uploaded = await _tryUpload(local);
      if (uploaded) return local;
      return local;
    }

    try {
      final raw = await client.rpc('malaak_get_state');
      final remoteMap = _asMap(raw);
      final hasProfile = remoteMap['hasProfile'] == true;

      if (!hasProfile) {
        local = _seedDisplayNameFromAuth(local, user);
        if (_hasMeaningfulData(local)) {
          final uploaded = await _tryUpload(local);
          await _saveLocal(local, dirty: !uploaded);
          return local;
        }
      }

      final remoteMapState = AppStateData.fromJson(remoteMap);
      final initialMap = await _loadInitialMapFromCloud();
      final journeyPlan = await _loadJourneyPlanFromCloud();
      final learningJourneys = await _loadLearningJourneysFromCloud();
      var remote = remoteMapState;
      if (initialMap != null) remote = remote.copyWith(initialMap: initialMap);
      if (journeyPlan != null) remote = remote.copyWith(journeyPlan: journeyPlan);
      if (learningJourneys.isNotEmpty) remote = remote.copyWith(learningJourneys: learningJourneys);
      await _saveLocal(remote, dirty: false);
      _lastSyncAt = DateTime.now();
      _lastSyncError = null;
      return remote;
    } catch (error) {
      _lastSyncError = error.toString();
      return local;
    }
  }

  @override
  Future<void> save(AppStateData state) async {
    await _saveLocal(state, dirty: isAuthenticated);
    if (!isAuthenticated) return;
    await _tryUpload(state);
  }

  @override
  Future<AppStateData> sync() async {
    final local = await _loadLocal();
    if (!isAuthenticated) return local;

    if (hasPendingLocalChanges) {
      final uploaded = await _tryUpload(local);
      if (uploaded) return local;
      return local;
    }

    try {
      final raw = await client.rpc('malaak_get_state');
      final remoteMapState = AppStateData.fromJson(_asMap(raw));
      final initialMap = await _loadInitialMapFromCloud();
      final journeyPlan = await _loadJourneyPlanFromCloud();
      final learningJourneys = await _loadLearningJourneysFromCloud();
      var remote = remoteMapState;
      if (initialMap != null) remote = remote.copyWith(initialMap: initialMap);
      if (journeyPlan != null) remote = remote.copyWith(journeyPlan: journeyPlan);
      if (learningJourneys.isNotEmpty) remote = remote.copyWith(learningJourneys: learningJourneys);
      await _saveLocal(remote, dirty: false);
      _lastSyncAt = DateTime.now();
      _lastSyncError = null;
      return remote;
    } catch (error) {
      _lastSyncError = error.toString();
      return local;
    }
  }

  Future<AppStateData> _loadLocal() async {
    final raw = prefs.getString(_localKey);
    if (raw != null && raw.isNotEmpty) return _decode(raw);

    if (isAuthenticated) {
      final claimedBy = prefs.getString(_legacyClaimKey);
      final legacy = prefs.getString(_legacyKey);
      if ((claimedBy == null || claimedBy == _accountId) && legacy != null && legacy.isNotEmpty) {
        await prefs.setString(_legacyClaimKey, _accountId);
        return _decode(legacy);
      }
    }
    return AppStateData();
  }

  AppStateData _decode(String raw) {
    try {
      return AppStateData.fromJson(Map<String, dynamic>.from(jsonDecode(raw) as Map));
    } catch (_) {
      return AppStateData();
    }
  }

  Future<void> _saveLocal(AppStateData state, {required bool dirty}) async {
    await prefs.setString(_localKey, jsonEncode(state.toJson()));
    await prefs.setBool(_dirtyKey, dirty);
  }

  Future<bool> _tryUpload(AppStateData state) async {
    if (!isAuthenticated) return false;
    try {
      final writableState = Map<String, dynamic>.from(state.toJson())..remove('journeyPlan');
      await client.rpc('malaak_sync_state', params: {'p_state': writableState});
      if (state.initialMap != null) {
        await client.rpc('malaak_save_initial_map', params: {'p_map': state.initialMap!.toJson()});
      }
      await _saveLearningJourneysToCloud(state.learningJourneys);
      await prefs.setBool(_dirtyKey, false);
      _lastSyncAt = DateTime.now();
      _lastSyncError = null;
      return true;
    } catch (error) {
      await prefs.setBool(_dirtyKey, true);
      _lastSyncError = error.toString();
      return false;
    }
  }

  @override
  Future<List<HypothesisItem>> loadHypotheses() async {
    final user = client.auth.currentUser;
    if (user == null) return const [];
    final raw = await client
        .from('malaak_hypotheses')
        .select()
        .eq('user_id', user.id)
        .order('last_seen_at', ascending: false);
    return (raw as List)
        .map((row) => HypothesisItem.fromJson(Map<String, dynamic>.from(row as Map)))
        .where((item) => item.id.isNotEmpty && item.statementAr.trim().isNotEmpty)
        .toList(growable: false);
  }

  @override
  Future<void> rejectHypothesis(String hypothesisId, {String? feedback}) async {
    if (!isAuthenticated) throw StateError('authentication_required');
    final cleaned = feedback?.trim();
    await client.rpc(
      'malaak_reject_hypothesis',
      params: {
        'p_hypothesis_id': hypothesisId,
        'p_feedback': cleaned == null || cleaned.isEmpty ? null : cleaned,
      },
    );
    _lastSyncAt = DateTime.now();
    _lastSyncError = null;
  }

  Future<Map<String, LearningJourneyState>> _loadLearningJourneysFromCloud() async {
    final user = client.auth.currentUser;
    if (user == null) return const <String, LearningJourneyState>{};
    final raw = await client
        .from('malaak_learning_states')
        .select('domain_id,state,updated_at')
        .eq('user_id', user.id);
    final result = <String, LearningJourneyState>{};
    for (final row in raw as List) {
      final map = Map<String, dynamic>.from(row as Map);
      final domainId = (map['domain_id'] as String?)?.trim() ?? '';
      if (domainId.isEmpty || map['state'] is! Map) continue;
      final stateMap = Map<String, dynamic>.from(map['state'] as Map);
      stateMap['domainId'] = domainId;
      stateMap['updatedAt'] ??= map['updated_at'];
      result[domainId] = LearningJourneyState.fromJson(stateMap);
    }
    return result;
  }

  Future<void> _saveLearningJourneysToCloud(Map<String, LearningJourneyState> states) async {
    final user = client.auth.currentUser;
    if (user == null) return;
    for (final entry in states.entries) {
      await client.from('malaak_learning_states').upsert({
        'user_id': user.id,
        'domain_id': entry.key,
        'state': entry.value.toJson(),
        'updated_at': DateTime.now().toIso8601String(),
      }, onConflict: 'user_id,domain_id');
    }
  }

  Future<JourneyPlan?> _loadJourneyPlanFromCloud() async {
    final user = client.auth.currentUser;
    if (user == null) return null;
    final raw = await client
        .from('malaak_journey_plans')
        .select()
        .eq('user_id', user.id)
        .order('version', ascending: false)
        .limit(1)
        .maybeSingle();
    if (raw == null) return null;
    return JourneyPlan.fromJson(Map<String, dynamic>.from(raw));
  }

  Future<InitialMap?> _loadInitialMapFromCloud() async {
    final user = client.auth.currentUser;
    if (user == null) return null;
    final raw = await client
        .from('malaak_initial_maps')
        .select()
        .eq('user_id', user.id)
        .maybeSingle();
    if (raw == null) return null;
    return InitialMap.fromJson(Map<String, dynamic>.from(raw));
  }

  Map<String, dynamic> _asMap(dynamic raw) {
    if (raw is Map<String, dynamic>) return raw;
    if (raw is Map) return Map<String, dynamic>.from(raw);
    return <String, dynamic>{};
  }

  AppStateData _seedDisplayNameFromAuth(AppStateData state, User user) {
    if (state.preferences.displayName.trim().isNotEmpty) return state;
    final name = (user.userMetadata?['display_name'] as String?)?.trim() ?? '';
    if (name.isEmpty) return state;
    return state.copyWith(
      preferences: state.preferences.copyWith(displayName: name),
    );
  }

  bool _hasMeaningfulData(AppStateData state) {
    final prefsData = state.preferences;
    final nonDefaultPreferences = prefsData.displayName.trim().isNotEmpty ||
        prefsData.allowPatterns != const UserPreferences().allowPatterns ||
        prefsData.allowJournalAnalysis != const UserPreferences().allowJournalAnalysis ||
        prefsData.includeInReports != const UserPreferences().includeInReports;
    return nonDefaultPreferences ||
        state.initialMap != null ||
        state.journeyPlan != null ||
        state.journals.isNotEmpty ||
        state.journeys.isNotEmpty ||
        state.memories.isNotEmpty ||
        state.messages.isNotEmpty ||
        state.coachingTurns.isNotEmpty ||
        state.pendingFollowUps.isNotEmpty ||
        state.learningJourneys.isNotEmpty;
  }
}
