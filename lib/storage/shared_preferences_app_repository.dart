import 'dart:convert'; import 'package:shared_preferences/shared_preferences.dart'; import '../models/app_state.dart'; import 'app_repository.dart';
class SharedPreferencesAppRepository implements AppRepository {
  SharedPreferencesAppRepository(this.prefs); final SharedPreferences prefs; static const _key='malaak_app_state_v2';
  @override Future<AppStateData> load() async { final raw=prefs.getString(_key); if(raw==null||raw.isEmpty)return AppStateData(); try{return AppStateData.fromJson(Map<String,dynamic>.from(jsonDecode(raw)));}catch(_){return AppStateData();} }
  @override Future<void> save(AppStateData state)=>prefs.setString(_key,jsonEncode(state.toJson())).then((_){});
}
