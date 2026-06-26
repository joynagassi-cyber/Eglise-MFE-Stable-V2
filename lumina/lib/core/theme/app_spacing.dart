// lib/core/theme/app_spacing.dart
// Constantes de spacing et animations pour le design system

import 'package:flutter/material.dart';

/// Constantes de spacing standardisées
class AppSpacing {
  AppSpacing._();

  // ==========================================
  // SPACING (basé sur un système de 4px)
  // ==========================================

  /// 2px - Extra extra small
  static const double xxs = 2.0;

  /// 4px - Extra small
  static const double xs = 4.0;

  /// 8px - Small
  static const double sm = 8.0;

  /// 12px - Small-medium
  static const double smd = 12.0;

  /// 16px - Medium (base)
  static const double md = 16.0;

  /// 20px - Medium-large
  static const double mlg = 20.0;

  /// 24px - Large
  static const double lg = 24.0;

  /// 32px - Extra large
  static const double xl = 32.0;

  /// 48px - 2X large
  static const double xxl = 48.0;

  /// 64px - 3X large
  static const double xxxl = 64.0;

  // ==========================================
  // PADDING PRESETS
  // ==========================================

  /// Padding pour les écrans (horizontal - valeur numérique)
  static const double screenHorizontalPadding = 24.0;

  /// Padding pour les écrans (horizontal - EdgeInsets)
  static const EdgeInsets screenPadding =
      EdgeInsets.symmetric(horizontal: screenHorizontalPadding);

  /// Padding pour les cartes
  static const EdgeInsets cardPadding = EdgeInsets.all(20);

  /// Padding pour les boutons
  static const EdgeInsets buttonPadding =
      EdgeInsets.symmetric(horizontal: 24, vertical: 16);

  /// Padding pour les inputs
  static const EdgeInsets inputPadding =
      EdgeInsets.symmetric(horizontal: 20, vertical: 18);

  // ==========================================
  // RADIUS
  // ==========================================

  /// 4px - Extra small radius
  static const double radiusXs = 4.0;

  /// 8px - Small radius
  static const double radiusSm = 8.0;

  /// 12px - Medium radius
  static const double radiusMd = 12.0;

  /// 16px - Large radius (buttons, inputs)
  static const double radiusLg = 16.0;

  /// 20px - Extra large radius
  static const double radiusXl = 20.0;

  /// 24px - 2X large radius (Card radius)
  static const double radius2xl = 24.0;

  /// 32px - 3X large radius (Surfaces immersives)
  static const double radius3xl = 32.0;

  /// 9999px - Full (pills, avatars)
  static const double radiusFull = 9999.0;

  // Lumina Aliases
  static const double radiusCard = radius2xl;

  // ==========================================
  // BORDER RADIUS PRESETS
  // ==========================================

  static BorderRadius get borderRadiusSm => BorderRadius.circular(radiusSm);
  static BorderRadius get borderRadiusMd => BorderRadius.circular(radiusMd);
  static BorderRadius get borderRadiusLg => BorderRadius.circular(radiusLg);
  static BorderRadius get borderRadiusXl => BorderRadius.circular(radiusXl);
  static BorderRadius get borderRadiusCard => BorderRadius.circular(radiusCard);

  // ==========================================
  // ANIMATIONS
  // ==========================================

  /// 150ms - Animations rapides (hover, focus)
  static const Duration animationFast = Duration(milliseconds: 150);

  /// 200ms - Animations standard
  static const Duration animationNormal = Duration(milliseconds: 200);

  /// 300ms - Animations moyennes (transitions)
  static const Duration animationMedium = Duration(milliseconds: 300);

  /// 500ms - Animations lentes (entrées/sorties)
  static const Duration animationSlow = Duration(milliseconds: 500);

  /// Courbe d'animation par défaut
  static const Curve animationCurve = Curves.easeInOut;

  /// Courbe pour les entrées
  static const Curve animationCurveIn = Curves.easeIn;

  /// Courbe pour les sorties
  static const Curve animationCurveOut = Curves.easeOut;

  // ==========================================
  // ICON SIZES
  // ==========================================

  /// 16px - Extra small icons
  static const double iconXs = 16.0;

  /// 20px - Small icons (in buttons, badges)
  static const double iconSm = 20.0;

  /// 24px - Medium icons
  static const double iconMd = 24.0;

  /// 28px - Standard icons
  static const double iconLg = 28.0;

  /// 32px - Large icons
  static const double iconXl = 32.0;

  /// 48px - Extra large icons (Hero/Illustrations)
  static const double iconXxl = 48.0;

  /// 48px - Hero icons (empty states)
  static const double iconHero = 48.0;

  /// 60px - Feature icons
  static const double iconFeature = 60.0;

  // Aliases for compatibility
  static const double iconSmSize = iconSm;
  static const double iconMdSize = iconMd;
  static const double iconLgSize = iconLg;

  // ==========================================
  // TOUCH TARGETS (Accessibilité)
  // ==========================================

  /// 44px - Taille minimale pour les zones tactiles (WCAG)
  static const double minTouchTarget = 44.0;

  /// 56px - Taille recommandée pour les zones tactiles (Lumina)
  static const double recommendedTouchTarget = 56.0;

  /// 56px - Taille des boutons principaux
  static const double buttonHeight = 56.0;

  /// 52px - Hauteur des inputs
  static const double inputHeight = 52.0;

  // ==========================================
  // SHADOWS
  // ==========================================

  /// Ombre légère pour les cartes
  static List<BoxShadow> get shadowSm => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];

  /// Ombre moyenne pour les cartes élevées
  static List<BoxShadow> get shadowMd => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.06),
          blurRadius: 12.0,
          offset: const Offset(0, 4),
        ),
      ];

  /// Ombre forte pour les modales, FAB
  static List<BoxShadow> get shadowLg => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 12.0,
          offset: const Offset(0, 8),
        ),
      ];

  static BorderRadiusGeometry get borderRadiusFull =>
      BorderRadius.circular(radiusFull);

  /// Ombre colorée pour les boutons primaires (Deep Purple)
  static List<BoxShadow> shadowPrimary(Color color) => [
        BoxShadow(
          color: color.withValues(alpha: 0.3),
          blurRadius: 12.0,
          offset: const Offset(0, 8),
        ),
      ];

  // ==========================================
  // LUMINA MFE-JC EFFECTS
  // ==========================================

  /// Soft divine glow for Lumina buttons
  static List<BoxShadow> get luminaGlow => [
        BoxShadow(
          color: Colors.white.withValues(alpha: 0.5),
          blurRadius: 12.0,
          spreadRadius: 2,
        ),
      ];

  /// Ultra-fine border for luxury cards/buttons
  static BorderSide get luminaHairline => BorderSide(
        color: const Color(0xFFD4AF37).withValues(alpha: 0.3),
        width: 0.5,
      );

  /// Divine Fire Glow
  static List<BoxShadow> get fireGlow => [
        BoxShadow(
          color: const Color(0xFFFF4D00).withValues(alpha: 0.4),
          blurRadius: 12.0,
          spreadRadius: 2,
        ),
        BoxShadow(
          color: const Color(0xFFFFD700).withValues(alpha: 0.2),
          blurRadius: 12.0,
          spreadRadius: 2.0,
        ),
      ];
}
