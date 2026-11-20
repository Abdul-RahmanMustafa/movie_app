import 'package:flutter/material.dart';

abstract final class AppColors {
  static const Color background = Color(0xFF121312);
  static const Color surface = Color(0xFF282A28);
  // Existing theme brand colour (kept for backwards compatibility).
  static const Color primary = Color(0xFFFFBB3B);

  // Figma layer fill used by auth links and the Home bottom navigation.
  static const Color accent = Color(0xFFF6BD00);
  static const Color white = Color(0xFFFFFFFF);
  static const Color success = Color(0xFF57AA53);
  static const Color error = Color(0xFFE82626);
}
