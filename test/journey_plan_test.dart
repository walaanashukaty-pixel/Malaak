import 'package:flutter_test/flutter_test.dart';
import 'package:malaak_balance/models/journey_plan.dart';

void main() {
  test('journey plan parses Supabase snake_case and serializes local camelCase', () {
    final plan = JourneyPlan.fromJson({
      'id': 'p1',
      'version': 3,
      'primary_domain': 'attachment',
      'primary_goal': 'بناء أمان أكبر',
      'support_domain': 'overthinking',
      'support_goal': 'الخروج من الحلقة',
      'monitor_domains': ['relationship'],
      'later_domains': ['childhood'],
      'reasoning_summary_ar': 'تركيز واحد حاليًا',
      'based_on_formulation_version': 4,
      'review_due_at': '2026-09-10T00:00:00Z',
      'status': 'active',
    });
    expect(plan.primaryDomain, 'attachment');
    expect(plan.supportDomain, 'overthinking');
    expect(plan.monitorDomains, ['relationship']);
    expect(plan.toJson()['primaryDomain'], 'attachment');
  });

  test('missing old snapshot plan remains backward compatible', () {
    expect(JourneyPlan.tryFromJson(null), isNull);
  });
}
