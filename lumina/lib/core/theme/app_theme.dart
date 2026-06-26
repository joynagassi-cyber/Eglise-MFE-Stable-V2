// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_typography.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import 'lumina_colors_extension.dart';
export 'lumina_colors_extension.dart';

class AppTheme {
  AppTheme._();

  // Constantes de Design System (Aliasing)
  static const double cardRadius = AppSpacing.radius2xl; // 24.0
  static const double buttonRadius = AppSpacing.radiusLg; // 16.0
  static const double inputRadius = AppSpacing.radiusLg; // 16.0

  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      // Utilise Inter via AppTypography pour cohérence
      textTheme: AppTypography.lightTextTheme,

      colorScheme: ColorScheme.fromSeed(
        seedColor: LuminaBrand.orange,
        brightness: Brightness.light,
      ),

      // Focus indicators pour accessibilité (WCAG 2.1)
      focusColor: LuminaBrand.orange.withValues(alpha: 0.2),
      indicatorColor: LuminaBrand.orange,

      scaffoldBackgroundColor: LuminaLight.bgPage,

      // Extensions de thème
      extensions: const [
        LuminaColorsExtension.light,
      ],

      // Card Theme Modernisé
      cardTheme: CardThemeData(
        color: LuminaLight.bgCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cardRadius),
          side: const BorderSide(color: LuminaLight.borderSubtle, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),

      // Input Decoration (Champs de saisie)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: LuminaLight.bgCard,
        contentPadding: AppSpacing.inputPadding,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(inputRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(inputRadius),
          borderSide: const BorderSide(color: LuminaLight.borderSubtle),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(inputRadius),
          borderSide: const BorderSide(
            color: LuminaBrand.orange,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(inputRadius),
          borderSide: const BorderSide(color: LuminaLight.errorBorder),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(inputRadius),
          borderSide: const BorderSide(color: LuminaLight.errorBorder, width: 2),
        ),
        labelStyle: const TextStyle(color: LuminaLight.textSecondary),
      ),

      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: LuminaBrand.orange,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: AppSpacing.buttonPadding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonRadius),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: LuminaBrand.orange,
          side: const BorderSide(color: LuminaBrand.orange),
          padding: AppSpacing.buttonPadding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonRadius),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: LuminaLight.textPrimary),
        titleTextStyle: AppTypography.lightTextTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),

      dividerTheme: const DividerThemeData(
        color: LuminaLight.borderSubtle,
        thickness: 1,
      ),

      // Ripple Effect Identity (CAS 08)
      splashFactory: InkRipple.splashFactory,
      splashColor: LuminaBrand.orange.withOpacity(0.12),
      highlightColor: LuminaBrand.orange.withOpacity(0.06),
    );
  }

  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      // Utilise Inter via AppTypography pour cohérence
      textTheme: AppTypography.darkTextTheme,
      colorScheme: ColorScheme.fromSeed(
        seedColor: LuminaBrand.orange,
        brightness: Brightness.dark,
      ),

      // Focus indicators pour accessibilité
      focusColor: LuminaBrand.orange.withOpacity(0.3),

      scaffoldBackgroundColor: LuminaDark.bgPage,

      // Extensions de thème
      extensions: const [
        LuminaColorsExtension.dark,
      ],

      // Ripple Effect Identity (CAS 08)
      splashFactory: InkRipple.splashFactory,
      splashColor: LuminaBrand.orange.withOpacity(0.12),
      highlightColor: LuminaBrand.orange.withOpacity(0.06),

      cardTheme: CardThemeData(
        color: LuminaDark.bgCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cardRadius),
          side: const BorderSide(color: LuminaDark.borderStrong, width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: LuminaDark.bgCard,
        contentPadding: AppSpacing.inputPadding,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(inputRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(inputRadius),
          borderSide: const BorderSide(color: LuminaDark.borderStrong),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(inputRadius),
          borderSide: const BorderSide(
            color: LuminaBrand.orange,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(inputRadius),
          borderSide: const BorderSide(color: LuminaDark.errorBorder),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(inputRadius),
          borderSide: const BorderSide(color: LuminaDark.errorBorder, width: 2),
        ),
        labelStyle: const TextStyle(color: LuminaDark.textSecondary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: LuminaBrand.orange,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: AppSpacing.buttonPadding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonRadius),
          ),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: LuminaDark.textPrimary),
        titleTextStyle: AppTypography.darkTextTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      dividerTheme: const DividerThemeData(
        color: LuminaDark.borderStrong,
        thickness: 1,
      ),
    );
  }
}

