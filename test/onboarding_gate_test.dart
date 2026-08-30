import 'package:flutter_test/flutter_test.dart';
import 'package:malaak_balance/models/initial_map.dart';

void main() {
  test('onboarding is required only while initial map is missing', () {
    expect(needsInitialMap(null), true);
    expect(needsInitialMap(InitialMap(
      primaryConcern: 'unsure', lifeContext: 'self', currentImpact: 'low',
      immediateSafety: const {'level':'none','safeNow':true}, desiredChange: 'أفهم حالي',
      coachingPreference: 'listen', privacyScope: const {'patternAnalysis':true},
    )), false);
  });
}
