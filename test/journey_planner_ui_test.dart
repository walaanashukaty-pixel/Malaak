import 'package:flutter_test/flutter_test.dart';
import 'package:malaak_balance/models/journey_plan.dart';

void main() {
  test('planner output carries one primary/support and monitor/later lists without scores', () {
    final plan = JourneyPlan.fromJson({
      'id': 'p1', 'version': 1,
      'primaryDomain': 'attachment', 'primaryGoal': 'بناء أمان أكبر',
      'supportDomain': 'overthinking', 'supportGoal': 'الخروج من الحلقة',
      'monitorDomains': ['relationship'], 'laterDomains': ['childhood'],
      'reasoningSummaryAr': 'تركيز واحد', 'basedOnFormulationVersion': 2,
      'status': 'active',
    });
    expect(plan.primaryDomain, 'attachment');
    expect(plan.supportDomain, 'overthinking');
    expect(plan.monitorDomains.length, lessThanOrEqualTo(2));
    expect(plan.reasoningSummaryAr.contains('%'), isFalse);
  });
}
