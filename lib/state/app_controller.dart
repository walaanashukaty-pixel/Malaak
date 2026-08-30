import 'package:flutter/foundation.dart';

import '../models/app_state.dart';
import '../models/journal_entry.dart';
import '../models/initial_map.dart';
import '../models/hypothesis_item.dart';
import '../models/journey_progress.dart';
import '../models/journey_plan.dart';
import '../models/memory_item.dart';
import '../models/malaak_message.dart';
import '../models/user_preferences.dart';
import '../services/demo_malaak_service.dart';
import '../services/malaak_gateway.dart';
import '../storage/app_repository.dart';

class AppController extends ChangeNotifier {
  AppController(this.repository, {this.malaakGateway});

  final AppRepository repository;
  final MalaakResponder? malaakGateway;

  AppStateData state = AppStateData();
  bool loaded = false;
  bool syncing = false;
  String? syncError;

  Future<void> load() async {
    state = await repository.load();
    loaded = true;
    syncError = cloudRepository?.lastSyncError;
    notifyListeners();
  }

  Future<void> reloadForSession() => load();

  Future<void> _commit(AppStateData next) async {
    state = next;
    notifyListeners();
    await repository.save(state);
    syncError = cloudRepository?.lastSyncError;
    notifyListeners();
  }

  Future<void> addJournal(String body) async {
    final entry = JournalEntry(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      body: body,
      createdAt: DateTime.now(),
      includeInReports: state.preferences.includeInReports,
    );
    await _commit(state.copyWith(journals: [entry, ...state.journals]));
  }

  Future<void> setJourneyStatus(String id, String status) async {
    final map = Map<String, JourneyProgress>.from(state.journeys);
    final old = map[id] ?? JourneyProgress(domainId: id);
    map[id] = old.copyWith(status: status, updatedAt: DateTime.now());
    await _commit(state.copyWith(journeys: map));
  }

  Future<void> completePractice(String id) async {
    final map = Map<String, JourneyProgress>.from(state.journeys);
    final old = map[id] ?? JourneyProgress(domainId: id);
    map[id] = old.copyWith(
      completedPractices: old.completedPractices + 1,
      updatedAt: DateTime.now(),
    );
    await _commit(state.copyWith(journeys: map));
  }

  Future<void> updatePreferences(UserPreferences preferences) =>
      _commit(state.copyWith(preferences: preferences));

  Future<void> setDisplayName(String name) =>
      updatePreferences(state.preferences.copyWith(displayName: name.trim()));

  Future<void> saveInitialMap(InitialMap map) => _commit(
        state.copyWith(
          initialMap: map,
          preferences: state.preferences.copyWith(
            allowPatterns: map.patternAnalysisEnabled,
            allowJournalAnalysis: map.journalAnalysisEnabled,
          ),
        ),
      );

  HypothesisAppRepository? get hypothesisRepository =>
      repository is HypothesisAppRepository ? repository as HypothesisAppRepository : null;

  Future<List<HypothesisItem>> loadHypotheses() async {
    final source = hypothesisRepository;
    if (source == null || !cloudAuthenticated) return const [];
    try {
      return await source.loadHypotheses();
    } catch (error) {
      syncError = error.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> rejectHypothesis(String id, {String? feedback}) async {
    final source = hypothesisRepository;
    if (source == null || !cloudAuthenticated) {
      throw StateError('cloud_authentication_required');
    }
    try {
      await source.rejectHypothesis(id, feedback: feedback);
      syncError = null;
      notifyListeners();
    } catch (error) {
      syncError = error.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteMemory(String id) => _commit(
        state.copyWith(
          memories: state.memories.where((item) => item.id != id).toList(),
        ),
      );

  Future<void> addMemory(
    MemoryType type,
    String value, {
    String confidence = 'medium',
  }) async {
    if (!state.preferences.allowPatterns &&
        (type == MemoryType.pattern || type == MemoryType.hypothesis)) {
      return;
    }
    final item = MemoryItem(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      type: type,
      value: value,
      createdAt: DateTime.now(),
      confidence: confidence,
    );
    await _commit(state.copyWith(memories: [item, ...state.memories]));
  }

  Future<void> sendToMalaak(String input) async {
    final now = DateTime.now();
    final user = MalaakMessage(
      id: 'u${now.microsecondsSinceEpoch}',
      text: input,
      isUser: true,
      createdAt: now,
    );
    await _commit(state.copyWith(messages: [...state.messages, user]));

    final result = malaakGateway == null
        ? MalaakGatewayResult(reply: DemoMalaakService.reply(input))
        : await malaakGateway!.reply(input, state: state);
    final bot = MalaakMessage(
      id: 'm${DateTime.now().microsecondsSinceEpoch}',
      text: result.reply,
      isUser: false,
      createdAt: DateTime.now(),
    );
    final turn = result.turn;
    final nextTurns = turn == null ? state.coachingTurns : [...state.coachingTurns, turn];
    final followUp = turn?.followUp;
    final nextFollowUps = followUp == null || followUp.timing == 'none' || followUp.prompt.trim().isEmpty
        ? state.pendingFollowUps
        : [...state.pendingFollowUps.where((item) => item.id != followUp.id), followUp];
    await _commit(state.copyWith(
      messages: [...state.messages, bot],
      coachingTurns: nextTurns,
      pendingFollowUps: nextFollowUps,
    ));
    if (cloudAuthenticated && !hasPendingLocalChanges) {
      await syncNow();
    }
  }

  Future<void> completeFollowUp(String id) async {
    final now = DateTime.now();
    final turns = state.coachingTurns.map((turn) {
      final follow = turn.followUp;
      if (follow?.id != id) return turn;
      return turn.copyWith(followUp: follow!.copyWith(completedAt: now));
    }).toList();
    final pending = state.pendingFollowUps.where((item) => item.id != id).toList();
    await _commit(state.copyWith(coachingTurns: turns, pendingFollowUps: pending));
  }

  Future<void> syncNow() async {
    final cloud = cloudRepository;
    if (cloud == null || !cloud.isAuthenticated || syncing) return;
    syncing = true;
    syncError = null;
    notifyListeners();
    try {
      state = await cloud.sync();
      syncError = cloud.lastSyncError;
    } finally {
      syncing = false;
      notifyListeners();
    }
  }

  SyncableAppRepository? get cloudRepository =>
      repository is SyncableAppRepository ? repository as SyncableAppRepository : null;

  bool get cloudAuthenticated => cloudRepository?.isAuthenticated ?? false;
  bool get hasPendingLocalChanges => cloudRepository?.hasPendingLocalChanges ?? false;
  String? get userEmail => cloudRepository?.userEmail;
  DateTime? get lastSyncAt => cloudRepository?.lastSyncAt;
  JourneyPlan? get journeyPlan => state.journeyPlan;

  int get reportableJournalCount =>
      state.journals.where((entry) => entry.includeInReports).length;
}
