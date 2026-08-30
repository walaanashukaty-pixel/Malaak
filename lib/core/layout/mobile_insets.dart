import 'package:flutter/widgets.dart';

/// Centralizes mobile-only inset rules so Android IME and floating navigation
/// spacing stay consistent across the app.
class MobileInsets {
  const MobileInsets._();

  static const double _composerGap = 12;
  static const double _floatingNavReserve = 96;

  static bool keyboardOpen(BuildContext context) =>
      isKeyboardOpen(MediaQuery.viewInsetsOf(context).bottom);

  static bool isKeyboardOpen(double viewInsetsBottom) => viewInsetsBottom > 0;

  static double composerBottomPadding(BuildContext context) =>
      composerBottomPaddingFrom(
        viewInsetsBottom: MediaQuery.viewInsetsOf(context).bottom,
        viewPaddingBottom: MediaQuery.viewPaddingOf(context).bottom,
      );

  static double composerBottomPaddingFrom({
    required double viewInsetsBottom,
    required double viewPaddingBottom,
  }) {
    if (isKeyboardOpen(viewInsetsBottom)) return _composerGap;
    return _floatingNavReserve + viewPaddingBottom;
  }
}
