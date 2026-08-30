import 'package:flutter_test/flutter_test.dart';
import 'package:malaak_balance/services/malaak_gateway.dart';

void main() {
  test('structured V5 edge response parses exact intervention revision', () {
    final result = MalaakGatewayResult.fromResponseData({
      'reply': 'خلينا ناخدها بخطوة صغيرة.',
      'turn': {
        'mode': 'coach',
        'state': 'moderate_activation',
        'need': 'connection',
        'pattern': 'reassurance_loop',
        'patternConfidence': 'high',
        'goal': 'أخفف الفحص',
        'interventionCode': 'UNCERTAINTY_001',
        'interventionVersion': 7,
        'interventionId': '18b4492a-fdf6-4b64-a2de-5b955bb3b4e9',
        'action': 'انتظري عشر دقايق بدون فحص.',
        'followUp': {
          'timing': 'later_today',
          'prompt': 'كيف مشي الانتظار؟',
          'journeyDomainId': 'attachment',
        },
      },
    });

    expect(result.reply, contains('خطوة'));
    expect(result.turn?.interventionCode, 'UNCERTAINTY_001');
    expect(result.turn?.interventionVersion, 7);
    expect(result.turn?.interventionId, '18b4492a-fdf6-4b64-a2de-5b955bb3b4e9');
    expect(result.turn?.followUp?.journeyDomainId, 'attachment');
  });

  test('text-only fallback remains displayable without fabricating coaching metadata', () {
    final result = MalaakGatewayResult.fromResponseData({'reply': 'صار عطل مؤقت.', 'turn': null});
    expect(result.reply, 'صار عطل مؤقت.');
    expect(result.turn, isNull);
  });
}
