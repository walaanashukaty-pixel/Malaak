import 'package:flutter_test/flutter_test.dart';
import 'package:malaak_balance/models/hypothesis_item.dart';

void main() {
  test('snake-case hypothesis row parses without client-mutable evidence fields', () {
    final item = HypothesisItem.fromJson({
      'id': 'h1',
      'domain': 'attachment',
      'pattern_key': 'attachment_alarm',
      'statement_ar': 'المسافة بعد الخلاف ممكن تفعّل خوف الفقد عندك.',
      'status': 'repeated',
      'confidence_label': 'medium',
      'support_count': 4,
      'distinct_days': 3,
      'distinct_contexts': 1,
      'last_seen_at': '2026-08-29T10:00:00Z',
      'user_feedback': null,
    });

    expect(item.id, 'h1');
    expect(item.status, HypothesisStatus.repeated);
    expect(item.statusLabel, 'نمط متكرر');
    expect(item.statementAr.contains('ممكن'), true);
  });

  test('rejected hypothesis is not routing eligible', () {
    final item = HypothesisItem.fromJson({
      'id': 'h2',
      'domain': 'needs',
      'pattern_key': 'people_pleasing',
      'statement_ar': 'في إشارة أولية لصعوبة قول لا.',
      'status': 'user_rejected',
      'confidence_label': 'low',
    });

    expect(item.status, HypothesisStatus.rejected);
    expect(item.routingEligible, false);
    expect(item.canReject, false);
  });
}
