import 'package:flutter_test/flutter_test.dart';
import 'package:malaak_balance/models/app_state.dart';
import 'package:malaak_balance/models/initial_map.dart';

void main() {
  test('initial map round-trips through AppStateData without inventing fields', () {
    final map = InitialMap(
      primaryConcern: 'overthinking',
      lifeContext: 'multiple',
      currentImpact: 'moderate',
      immediateSafety: const {'level': 'none', 'safeNow': true},
      desiredChange: 'بدي راسي يهدى وأعرف شو أعمل',
      coachingPreference: 'organize',
      privacyScope: const {'patternAnalysis': true, 'journalAnalysis': false},
    );
    final decoded = AppStateData.fromJson(AppStateData(initialMap: map).toJson());
    expect(decoded.initialMap?.primaryConcern, 'overthinking');
    expect(decoded.initialMap?.currentImpact, 'moderate');
    expect(decoded.initialMap?.privacyScope['patternAnalysis'], true);
  });

  test('cloud snake-case initial map parses to canonical model', () {
    final map = InitialMap.fromJson({
      'primary_concern': 'relationship',
      'life_context': 'marriage',
      'current_impact': 'high',
      'immediate_safety': {'level': 'none', 'safeNow': true},
      'desired_change': 'أحكي بدون انفجار',
      'coaching_preference': 'calm',
      'privacy_scope': {'patternAnalysis': true},
    });
    expect(map.primaryConcern, 'relationship');
    expect(map.coachingPreference, 'calm');
    expect(map.toJson()['desiredChange'], 'أحكي بدون انفجار');
  });
}
