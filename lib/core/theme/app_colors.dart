import 'package:flutter/material.dart';

abstract final class AppColors {
  static const cream = Color(0xFFFFFDF8);
  static const plum = Color(0xFF3D2B4A);
  static const lavender = Color(0xFFB8A8FF);
  static const rose = Color(0xFFF6B5C8);
  static const sage = Color(0xFFBFD8C1);
  static const gold = Color(0xFFD4AF37);
  static const lilac = Color(0xFF9B87FF);
  static const peach = Color(0xFFFFD4A8);
  static const blue = Color(0xFF93B5E1);
  static const beige = Color(0xFFF8F4EF);
  static const muted = Color(0xFFF0EBF8);
  static const mutedText = Color(0xFF8B7BA8);
  static const softText = Color(0xFF6B5A85);
  static const border = Color(0x33B8A8FF);
  static const danger = Color(0xFFFF6B8A);
  static const deepPurple = Color(0xFF2D1F3D);
  static const deepPurple2 = Color(0xFF4A2860);
  static const success = Color(0xFF75B783);

  static const heroGradient = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [Color(0xFFF5F0FF), Color(0xFFFFF4F8), Color(0xFFF0FAF2)],
  );

  static const primaryGradient = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [lavender, rose],
  );

  static const malaakGradient = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [deepPurple, deepPurple2, Color(0xFF3D3060)],
  );
}
