// lib/core/theme/app_colors.dart
// 
// Classe de compatibilité Lumina — Assure le pont entre l'ancienne API et LuminaColorsExtension
// 

import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'lumina_colors_extension.dart';
export 'lumina_colors_extension.dart';

abstract final class AppColors {
  AppColors._();

  // --- Constantes Statiques (Invariantes ou Fallback) ---
  static const Color brandOrange = LuminaBrand.orange;
  static const Color brandRed    = LuminaBrand.red;
  static const Color brandAmber  = LuminaBrand.amber;
  
  static const Color surfaceDark = LuminaDark.bgSecondary;
  static const Color secondaryContainer = Color(0xFFF1F5F9); // Light fallback
  
  static const Color white       = Colors.white;
  static const Color black       = Colors.black;
  static const Color transparent = Colors.transparent;
  
  static const Color luminaBlue   = Color(0xFF3B82F6);
  static const Color luminaGold   = LuminaBrand.amber;
  static const Color luminaPurple = Color(0xFF8B5CF6);
  static const Color luminaTeal   = Color(0xFF14B8A6);
  static const Color luminaGreen  = Color(0xFF10B981);
  static const Color luminaIndigo = Color(0xFF6366F1);
  static const Color luminaPink   = Color(0xFFEC4899);
  
  static const Color dividerLight = LuminaLight.borderSubtle;

  // --- Méthodes de Compatibilité (dépendent du Context) ---
  
  static bool isDark(BuildContext context) => Theme.of(context).brightness == Brightness.dark;

  static Color bg(BuildContext context) => context.colors.bgPage;
  static Color surface(BuildContext context) => context.colors.bgSecondary;
  static Color card(BuildContext context) => context.colors.bgCard;
  
  static Color textPrimary(BuildContext context) => context.colors.textPrimary;
  static Color textSecondary(BuildContext context) => context.colors.textSecondary;
  static Color textSecondaryOf(BuildContext context) => context.colors.textSecondary;
  static Color textTertiary(BuildContext context) => context.colors.textTertiary;
  static Color textHint(BuildContext context) => context.colors.textTertiary;
  
  static Color errorOf(BuildContext context) => context.colors.errorText;
  static Color successOf(BuildContext context) => context.colors.successText;
  static Color warningOf(BuildContext context) => context.colors.warningText;
  static Color infoOf(BuildContext context) => context.colors.infoText;
  
  static Color divider(BuildContext context) => context.colors.borderDefault;
  static Color brandSecondaryLight(BuildContext context) => context.colors.brandSecondary;
  static Color brandSecondaryDark(BuildContext context) => context.colors.brandSecondary;
  static Color brandPrimaryLight(BuildContext context) => context.colors.brandPrimary;
  static Color brandPrimaryDark(BuildContext context) => context.colors.brandPrimary;

  // Gradients
  static LinearGradient get fireGradient => const LinearGradient(
    colors: [LuminaBrand.orange, LuminaBrand.red],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient get darkGradient => const LinearGradient(
    colors: [Color(0xFF0F172A), Color(0xFF020617)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
