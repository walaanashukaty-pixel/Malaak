import 'package:flutter_test/flutter_test.dart';
import 'package:malaak_balance/services/demo_malaak_service.dart';

void main() {
  test('anger language routes to regulation-first demo response', () {
    final response = DemoMalaakService.reply('أنا كتير معصبة ورح انفجر');
    expect(response, contains('الأمان'));
    expect(response, contains('الشدة'));
  });

  test('relationship uncertainty avoids unsupported reassurance', () {
    final response = DemoMalaakService.reply('زوجي ما رد، بيحبني ولا لا؟');
    expect(response, contains('ما بقدر أعرف'));
    expect(response, contains('الحقائق'));
  });
}
