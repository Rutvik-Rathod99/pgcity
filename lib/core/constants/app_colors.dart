import 'package:flutter/material.dart';

/// PGCity Design System Color Tokens matching PRD and Screen Specs
class AppColors {
  // Brand Core
  static const Color navy = Color(0xFF141F29);
  static const Color navy2 = Color(0xFF1E303D);
  static const Color cream = Color(0xFFF6F1E6);
  static const Color paper = Color(0xFFFFFDF8);
  static const Color marigold = Color(0xFFE2A63B);
  static const Color marigoldDark = Color(0xFF8A5E13);
  static const Color teal = Color(0xFF2C6E63);
  static const Color tealLight = Color(0xFFE4EFEA);

  // Typography & Neutral
  static const Color ink = Color(0xFF1A2229);
  static const Color inkSoft = Color(0xFF5B6672);
  static const Color line = Color(0xFFE1D8C4);
  static const Color lineDark = Color(0xFF33475A);

  // Status & Feedback
  static const Color success = Color(0xFF2C6E63);
  static const Color successLight = Color(0xFFE4EFEA);
  static const Color warning = Color(0xFFC98C2E);
  static const Color warningLight = Color(0xFFFBF2E1);
  static const Color error = Color(0xFFB5482E);
  static const Color errorLight = Color(0xFFFBEBE6);
  static const Color likedRed = Color(0xFFC94B4B);

  // Map & Surfaces
  static const Color mapBg = Color(0xFFDCE7DE);
  static const Color mapRoad = Color(0xFFEFE9D8);
  static const Color mapBlock = Color(0xFFD7CFAE);
  static const Color mapPark = Color(0xFFCFE0D4);

  // Shadows
  static const BoxShadow softShadow = BoxShadow(
    color: Color.fromRGBO(20, 31, 41, 0.08),
    blurRadius: 16,
    offset: Offset(0, 4),
  );

  static const BoxShadow cardShadow = BoxShadow(
    color: Color.fromRGBO(20, 31, 41, 0.12),
    blurRadius: 20,
    offset: Offset(0, 6),
  );

  static const BoxShadow pinShadow = BoxShadow(
    color: Color.fromRGBO(20, 31, 41, 0.25),
    blurRadius: 8,
    offset: Offset(0, 3),
  );
}
