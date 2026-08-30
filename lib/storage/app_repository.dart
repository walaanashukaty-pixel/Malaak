import '../models/hypothesis_item.dart';
import '../models/app_state.dart';

abstract class AppRepository {
  Future<AppStateData> load();
  Future<void> save(AppStateData state);
}

abstract class SyncableAppRepository implements AppRepository {
  Future<AppStateData> sync();
  bool get isAuthenticated;
  bool get hasPendingLocalChanges;
  String? get userEmail;
  DateTime? get lastSyncAt;
  String? get lastSyncError;
}


abstract class HypothesisAppRepository {
  Future<List<HypothesisItem>> loadHypotheses();
  Future<void> rejectHypothesis(String hypothesisId, {String? feedback});
}
