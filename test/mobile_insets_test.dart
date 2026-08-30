import 'package:flutter_test/flutter_test.dart';
import 'package:malaak_balance/core/layout/mobile_insets.dart';

void main() {
  test('keyboard is open only when the bottom IME inset is positive', () {
    expect(MobileInsets.isKeyboardOpen(0), isFalse);
    expect(MobileInsets.isKeyboardOpen(0.1), isTrue);
  });

  test('composer reserves the floating navigation only when keyboard is closed', () {
    expect(
      MobileInsets.composerBottomPaddingFrom(
        viewInsetsBottom: 0,
        viewPaddingBottom: 24,
      ),
      120,
    );
    expect(
      MobileInsets.composerBottomPaddingFrom(
        viewInsetsBottom: 300,
        viewPaddingBottom: 24,
      ),
      12,
    );
  });
}
