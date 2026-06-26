// lib/core/extensions/context_extension.dart
// ═══════════════════════════════════════════════════════════════════════════
// Extension BuildContext pour accès au design system
// AUTO-GÉNÉRÉ LORS DU REFACTORING MASSIF
// ═══════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:lumina/core/theme/lumina_colors_extension.dart';
import 'package:lumina/l10n/app_localizations.dart';

extension BuildContextExtension on BuildContext {
  /// Accès à LuminaColorsExtension
  LuminaColorsExtension get colors {
    final colorsExtension = Theme.of(this).extension<LuminaColorsExtension>();
    if (colorsExtension != null) {
      return colorsExtension;
    }

    throw StateError(
      'LuminaColorsExtension is missing from ThemeData for this BuildContext.',
    );
  }

  /// TextTheme du thème courant
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Accès aux localisations
  AppLocalizations get l10n {
    final localizations = AppLocalizations.of(this);
    if (localizations != null) {
      return localizations;
    }

    throw StateError(
      'AppLocalizations is not available for this BuildContext. '
      'Make sure MaterialApp includes AppLocalizations.localizationsDelegates '
      'and AppLocalizations.supportedLocales.',
    );
  }

  /// ColorScheme du thème courant
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// ThemeData complet
  ThemeData get theme => Theme.of(this);

  /// Vrai si le thème actuel est en mode sombre
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  /// Brightness courant
  Brightness get brightness => Theme.of(this).brightness;

  /// Taille de l'écran
  Size get screenSize => _requireMediaQuery().size;

  /// Padding du SafeArea
  EdgeInsets get safeArea => _requireMediaQuery().viewPadding;

  /// Est-ce que l'appareil est en portrait?
  bool get isPortrait =>
      _requireMediaQuery().orientation == Orientation.portrait;

  /// Est-ce que l'appareil est en landscape?
  bool get isLandscape =>
      _requireMediaQuery().orientation == Orientation.landscape;

  // Getters additionnels pour compatibilité (fusionnés depuis AppContextExtensions)
  Color get bgPrimary => colors.bgPage;
  Color get accent => colors.brandPrimary;
  Color get bgCardObsidian => colors.surfaceObsidian;
  Color get surfacePrimary => colors.bgCard;
  Color get softShadow => const Color(0x33000000);

  LinearGradient get brandPrimaryGradientFire => colors.brandGradient;
  LinearGradient get premiumFusionGradient => colors.premiumGradient;
  LinearGradient get jeunesseGradient => LinearGradient(colors: [
        colors.jeunesseColor,
        colors.jeunesseColor.withValues(alpha: 0.7)
      ]);

  MediaQueryData _requireMediaQuery() {
    final mediaQuery = MediaQuery.maybeOf(this);
    if (mediaQuery != null) {
      return mediaQuery;
    }

    throw StateError(
      'MediaQuery is not available for this BuildContext.',
    );
  }
}
