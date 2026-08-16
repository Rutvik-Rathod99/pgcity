import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum AppFontFamily {
  inter('Inter', 'Clean & Modern'),
  sfPro('SF Pro (Apple/Mac)', 'Cupertino Elegance'),
  ubuntu('Ubuntu', 'Canonical Ubuntu Linux'),
  plusJakartaSans('Plus Jakarta Sans', 'Tech & Bold'),
  outfit('Outfit', 'Geometric & Premium'),
  dmSans('DM Sans', 'Editorial & Crisp'),
  montserrat('Montserrat', 'Modern Urban Sans'),
  nunito('Nunito', 'Soft & Rounded'),
  firaSans('Fira Sans', 'Mozilla Technical'),
  roboto('Roboto', 'Google Android Classic'),
  poppins('Poppins', 'Friendly & Geometric'),
  jetBrainsMono('JetBrains Mono', 'Developer Monospace');

  final String label;
  final String subtitle;
  const AppFontFamily(this.label, this.subtitle);
}

class AppTypography {
  static AppFontFamily currentFont = AppFontFamily.inter;

  static TextStyle _font({
    required double fontSize,
    required FontWeight fontWeight,
    Color? color,
    double? height,
    double? letterSpacing,
  }) {
    switch (currentFont) {
      case AppFontFamily.sfPro:
        return GoogleFonts.manrope(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          height: height,
          letterSpacing: letterSpacing ?? -0.2,
        );
      case AppFontFamily.ubuntu:
        return GoogleFonts.ubuntu(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          height: height,
          letterSpacing: letterSpacing,
        );
      case AppFontFamily.dmSans:
        return GoogleFonts.dmSans(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          height: height,
          letterSpacing: letterSpacing,
        );
      case AppFontFamily.montserrat:
        return GoogleFonts.montserrat(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          height: height,
          letterSpacing: letterSpacing,
        );
      case AppFontFamily.nunito:
        return GoogleFonts.nunito(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          height: height,
          letterSpacing: letterSpacing,
        );
      case AppFontFamily.firaSans:
        return GoogleFonts.firaSans(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          height: height,
          letterSpacing: letterSpacing,
        );
      case AppFontFamily.jetBrainsMono:
        return GoogleFonts.jetBrainsMono(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          height: height,
          letterSpacing: letterSpacing,
        );
      case AppFontFamily.outfit:
        return GoogleFonts.outfit(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          height: height,
          letterSpacing: letterSpacing,
        );
      case AppFontFamily.plusJakartaSans:
        return GoogleFonts.plusJakartaSans(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          height: height,
          letterSpacing: letterSpacing,
        );
      case AppFontFamily.roboto:
        return GoogleFonts.roboto(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          height: height,
          letterSpacing: letterSpacing,
        );
      case AppFontFamily.poppins:
        return GoogleFonts.poppins(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          height: height,
          letterSpacing: letterSpacing,
        );
      case AppFontFamily.inter:
        return GoogleFonts.inter(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          height: height,
          letterSpacing: letterSpacing,
        );
    }
  }

  // Serif (Fraunces) - Headings & Brand (inherits theme text color if null)
  static TextStyle displayLarge({Color? color}) => GoogleFonts.fraunces(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: color,
    height: 1.15,
  );

  static TextStyle displayMedium({Color? color}) => GoogleFonts.fraunces(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: color,
    height: 1.2,
  );

  static TextStyle displaySmall({Color? color}) => GoogleFonts.fraunces(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: color,
  );

  static TextStyle brand({Color? color}) => GoogleFonts.fraunces(
    fontSize: 17,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.2,
    color: color,
  );

  // Dynamic Sans Body & UI (inherits theme text color if null)
  static TextStyle titleLarge({Color? color}) =>
      _font(fontSize: 16, fontWeight: FontWeight.w700, color: color);

  static TextStyle titleMedium({Color? color}) =>
      _font(fontSize: 14, fontWeight: FontWeight.w600, color: color);

  static TextStyle titleSmall({Color? color}) =>
      _font(fontSize: 13, fontWeight: FontWeight.w600, color: color);

  static TextStyle bodyLarge({Color? color}) => _font(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: color,
    height: 1.5,
  );

  static TextStyle bodyMedium({Color? color}) => _font(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: color,
    height: 1.45,
  );

  static TextStyle bodySmall({Color? color}) =>
      _font(fontSize: 12, fontWeight: FontWeight.w400, color: color);

  static TextStyle button({Color? color}) =>
      _font(fontSize: 13, fontWeight: FontWeight.w700, color: color);

  // Monospace (JetBrains Mono) - Badges, Prices, Status, Tags
  static TextStyle monoBadge({Color? color}) => GoogleFonts.jetBrainsMono(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    color: color,
  );

  static TextStyle monoPrice({Color? color}) => GoogleFonts.jetBrainsMono(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: color,
  );

  static TextStyle monoLabel({Color? color}) => GoogleFonts.jetBrainsMono(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.4,
    color: color,
  );

  static TextStyle monoStatus({Color? color}) => GoogleFonts.jetBrainsMono(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    color: color,
  );
}
