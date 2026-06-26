// lib/core/theme/app_text.dart
// Système de typographie premium pour Lumina
// Permet un accès facile aux styles du thème sans contourner le système

import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';

/// Classe utilitaire pour accéder facilement aux styles de texte du thème
/// Respecte le design system avec Poppins (titres) et Open Sans (corps)
class AppText {
  AppText._();

  // ==========================================
  // DISPLAY STYLES (57px, 45px, 36px)
  // ==========================================

  static TextStyle displayLarge(BuildContext context) =>
      Theme.of(context).textTheme.displayLarge!;

  static TextStyle displayMedium(BuildContext context) =>
      Theme.of(context).textTheme.displayMedium!;

  static TextStyle displaySmall(BuildContext context) =>
      Theme.of(context).textTheme.displaySmall!;

  // ==========================================
  // HEADLINE STYLES (32px, 28px, 24px)
  // ==========================================

  static TextStyle headlineLarge(BuildContext context,
      {FontWeight weight = FontWeight.w700}) {
    return Theme.of(context).textTheme.headlineLarge!.copyWith(
          fontWeight: weight,
        );
  }

  static TextStyle headlineMedium(BuildContext context,
      {FontWeight weight = FontWeight.w700}) {
    return Theme.of(context).textTheme.headlineMedium!.copyWith(
          fontWeight: weight,
        );
  }

  static TextStyle headlineSmall(BuildContext context,
      {FontWeight weight = FontWeight.w600}) {
    return Theme.of(context).textTheme.headlineSmall!.copyWith(
          fontWeight: weight,
        );
  }

  // ==========================================
  // TITLE STYLES (22px, 16px, 14px)
  // ==========================================

  static TextStyle titleLarge(BuildContext context,
      {FontWeight weight = FontWeight.w600}) {
    return Theme.of(context).textTheme.titleLarge!.copyWith(
          fontWeight: weight,
        );
  }

  static TextStyle titleMedium(BuildContext context,
      {FontWeight weight = FontWeight.w600}) {
    return Theme.of(context).textTheme.titleMedium!.copyWith(
          fontWeight: weight,
        );
  }

  static TextStyle titleSmall(BuildContext context,
      {FontWeight weight = FontWeight.w600}) {
    return Theme.of(context).textTheme.titleSmall!.copyWith(
          fontWeight: weight,
        );
  }

  // ==========================================
  // BODY STYLES (16px, 14px, 12px)
  // ==========================================

  static TextStyle bodyLarge(BuildContext context,
      {FontWeight weight = FontWeight.w400, Color? color, double? height}) {
    return Theme.of(context).textTheme.bodyLarge!.copyWith(
          fontWeight: weight,
          color: color,
          height: height ?? 1.5,
        );
  }

  static TextStyle bodyMedium(BuildContext context,
      {FontWeight weight = FontWeight.w400, Color? color, double? height}) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
          fontWeight: weight,
          color: color,
          height: height ?? 1.5,
        );
  }

  static TextStyle bodySmall(BuildContext context,
      {FontWeight weight = FontWeight.w400, Color? color, double? height}) {
    return Theme.of(context).textTheme.bodySmall!.copyWith(
          fontWeight: weight,
          color: color,
          height: height ?? 1.4,
        );
  }

  // ==========================================
  // LABEL STYLES (14px, 12px, 11px)
  // ==========================================

  static TextStyle labelLarge(BuildContext context,
      {FontWeight weight = FontWeight.w500}) {
    return Theme.of(context).textTheme.labelLarge!.copyWith(
          fontWeight: weight,
        );
  }

  static TextStyle labelMedium(BuildContext context,
      {FontWeight weight = FontWeight.w500}) {
    return Theme.of(context).textTheme.labelMedium!.copyWith(
          fontWeight: weight,
        );
  }

  static TextStyle labelSmall(BuildContext context,
      {FontWeight weight = FontWeight.w500}) {
    return Theme.of(context).textTheme.labelSmall!.copyWith(
          fontWeight: weight,
        );
  }

  // ==========================================
  // CONVENIENCE STYLES (Backward Compatibility)
  // ==========================================

  /// Titre principal (h1) - 32px bold
  static TextStyle h1(BuildContext context) => headlineLarge(context);

  /// Titre secondaire (h2) - 28px bold
  static TextStyle h2(BuildContext context) => headlineMedium(context);

  /// Sous-titre (h3) - 24px semibold
  static TextStyle h3(BuildContext context) => headlineSmall(context);

  /// Titre de section (h4) - 20px semibold
  static TextStyle h4(BuildContext context) => titleLarge(context);

  /// Corps de texte standard
  static TextStyle body(BuildContext context) => bodyLarge(context);

  /// Texte secondaire
  static TextStyle caption(BuildContext context) => bodySmall(context);

  /// Texte de bouton
  static TextStyle button(BuildContext context) =>
      labelLarge(context, weight: FontWeight.w600);

  /// Lien cliquable
  static TextStyle link(BuildContext context) => bodyMedium(
        context,
        weight: FontWeight.w600,
        color: Theme.of(context).colorScheme.primary,
      );

  // ==========================================
  // ACCESSIBILITY-FOCUSED STYLES
  // ==========================================

  /// Style pour texte important (haute lisibilité)
  static TextStyle emphasized(BuildContext context) => bodyLarge(
        context,
        weight: FontWeight.w600,
      );

  /// Style pour texte désactivé
  static TextStyle disabled(BuildContext context) {
    return bodyMedium(
      context,
      color: context.colors.textDisabled,
    );
  }

  /// Style pour texte d'erreur
  static TextStyle error(BuildContext context) => bodyMedium(
        context,
        color: context.colors.errorText,
      );

  /// Style pour texte de succès
  static TextStyle success(BuildContext context) => bodyMedium(
        context,
        color: context.colors.successText,
      );

  /// Style pour texte en gras (body bold)
  static TextStyle bodyBold(BuildContext context) => bodyMedium(
        context,
        weight: FontWeight.w700,
      );
}

/// Extension sur BuildContext pour accéder facilement aux styles
extension AppTextExtension on BuildContext {
  TextStyle get displayLarge => AppText.displayLarge(this);
  TextStyle get displayMedium => AppText.displayMedium(this);
  TextStyle get displaySmall => AppText.displaySmall(this);
  TextStyle get headlineLarge => AppText.headlineLarge(this);
  TextStyle get headlineMedium => AppText.headlineMedium(this);
  TextStyle get headlineSmall => AppText.headlineSmall(this);
  TextStyle get titleLarge => AppText.titleLarge(this);
  TextStyle get titleMedium => AppText.titleMedium(this);
  TextStyle get titleSmall => AppText.titleSmall(this);
  TextStyle get bodyLarge => AppText.bodyLarge(this);
  TextStyle get bodyMedium => AppText.bodyMedium(this);
  TextStyle get bodySmall => AppText.bodySmall(this);
  TextStyle get labelLarge => AppText.labelLarge(this);
  TextStyle get labelMedium => AppText.labelMedium(this);
  TextStyle get labelSmall => AppText.labelSmall(this);
  TextStyle get h1 => AppText.h1(this);
  TextStyle get h2 => AppText.h2(this);
  TextStyle get h3 => AppText.h3(this);
  TextStyle get h4 => AppText.h4(this);
  TextStyle get body => AppText.body(this);
  TextStyle get caption => AppText.caption(this);
  TextStyle get button => AppText.button(this);
  TextStyle get link => AppText.link(this);
  TextStyle get emphasized => AppText.emphasized(this);
  TextStyle get disabled => AppText.disabled(this);
  TextStyle get error => AppText.error(this);
  TextStyle get success => AppText.success(this);
  TextStyle get bodyBold => AppText.bodyBold(this);
}
