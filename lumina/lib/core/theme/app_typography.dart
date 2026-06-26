// lib/core/theme/app_typography.dart
// Typographie selon le Lumina Design System (Plus Jakarta Sans & Lora)

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'lumina_tokens.dart';

/// Styles typographiques de l'application basés sur le JSON Lumina Design System
class AppTypography {
  AppTypography._();

  /// Police Titres : Plus Jakarta Sans (Moderne, Géométrique)
  static String get headlineFont =>
      GoogleFonts.plusJakartaSans().fontFamily ?? 'Plus Jakarta Sans';

  /// Police Corps : Lora (Élégant, Spirituel, Serif)
  static String get bodyFont => GoogleFonts.lora().fontFamily ?? 'Lora';

  /// Alias pour la police éditoriale (Lora)
  static String get editorialFont => bodyFont;

  /// Alias pour la police de titres (Plus Jakarta Sans)
  static String get primaryFont => headlineFont;

  // ==========================================
  // TEXT THEME - MODE CLAIR
  // ==========================================

  static TextTheme get lightTextTheme {
    return TextTheme(
      displayLarge: GoogleFonts.plusJakartaSans(
        fontSize: 40,
        fontWeight: FontWeight.w800,
        color: LuminaLight.textPrimary,
        height: 1.2,
      ),
      headlineLarge: GoogleFonts.plusJakartaSans(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: LuminaLight.textPrimary,
        height: 1.2,
      ),
      headlineMedium: GoogleFonts.plusJakartaSans(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        color: LuminaLight.textPrimary,
        height: 1.2,
      ),
      headlineSmall: GoogleFonts.plusJakartaSans(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: LuminaLight.textPrimary,
        height: 1.2,
      ),
      titleLarge: GoogleFonts.plusJakartaSans(
        fontSize: 19,
        fontWeight: FontWeight.w600,
        color: LuminaLight.textPrimary,
        height: 1.45,
      ),
      bodyLarge: GoogleFonts.lora(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        color: LuminaLight.textPrimary,
        height: 1.65,
      ),
      bodyMedium: GoogleFonts.lora(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: LuminaLight.textPrimary,
        height: 1.45,
      ),
      bodySmall: GoogleFonts.lora(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: LuminaLight.textPrimary,
        height: 1.45,
      ),
      labelLarge: GoogleFonts.plusJakartaSans(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: LuminaLight.textPrimary,
        height: 1.45,
      ),
      labelSmall: GoogleFonts.plusJakartaSans(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: LuminaLight.textPrimary,
        height: 1.45,
        letterSpacing: 0.8,
      ),
    );
  }

  // ==========================================
  // TEXT THEME - MODE SOMBRE
  // ==========================================

  static TextTheme get darkTextTheme {
    final light = lightTextTheme;
    return light.apply(
      displayColor: LuminaDark.textPrimary,
      bodyColor: LuminaDark.textPrimary,
    );
  }

  // ==========================================
  // CONVENIENCE GETTERS (LUMINA TOKENS)
  // ==========================================

  /// h1 = 32px (JSON fontSize/h1)
  static TextStyle get h1 => lightTextTheme.headlineLarge!;

  /// h2 = 26px (JSON fontSize/h2)
  static TextStyle get h2 => lightTextTheme.headlineMedium!;

  /// h3 = 22px (JSON fontSize/h3)
  static TextStyle get h3 => lightTextTheme.headlineSmall!;

  /// h4 = 19px (JSON fontSize/h4)
  static TextStyle get h4 => lightTextTheme.titleLarge!;

  /// display = 40px (JSON fontSize/display)
  static TextStyle get display => lightTextTheme.displayLarge!;

  /// bodyLarge (lora 18px)
  static TextStyle get bodyLargeStyle => lightTextTheme.bodyLarge!;

  /// bodyMedium (lora 16px)
  static TextStyle get bodyMediumStyle => lightTextTheme.bodyMedium!;

  /// bodySmall (lora 15px)
  static TextStyle get bodySmallStyle => lightTextTheme.bodySmall!;

  /// ui (plus jakarta sans 15px)
  static TextStyle get uiStyle => lightTextTheme.labelLarge!;

  /// uiSmall (plus jakarta sans 13px)
  static TextStyle get uiSmallStyle => GoogleFonts.plusJakartaSans(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        height: 1.45,
      );

  /// caption (lora 12px)
  static TextStyle get caption => GoogleFonts.lora(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.45,
      );

  /// overline (plus jakarta sans 11px)
  static TextStyle get overline => lightTextTheme.labelSmall!;

  // App Compat Getters
  static TextStyle get titleLarge => h4;
  static TextStyle get titleMedium => uiStyle.copyWith(fontWeight: FontWeight.w600);
  static TextStyle get titleSmall => uiSmallStyle.copyWith(fontWeight: FontWeight.w600);
  static TextStyle get bodyLarge => bodyLargeStyle;
  static TextStyle get bodyMedium => bodyMediumStyle;
  static TextStyle get bodySmall => bodySmallStyle;
  static TextStyle get labelLarge => uiStyle;
  static TextStyle get labelMedium => uiSmallStyle;
  static TextStyle get labelSmall => overline;
  static TextStyle get tiny => caption.copyWith(fontSize: 10);

  // Missing Getters for backwards compatibility
  static TextStyle get headlineLarge => h1;
  static TextStyle get headlineMedium => h2;
  static TextStyle get headlineSmall => h3;
  static TextStyle get headingLarge => h1;
  static TextStyle get editorialSection => h3.copyWith(fontFamily: editorialFont);
  static TextStyle get editorialDisplay => display.copyWith(fontFamily: editorialFont);
}
