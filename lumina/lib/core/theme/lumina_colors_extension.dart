// lib/core/theme/lumina_colors_extension.dart
//
// Extension de thème Lumina — accès via context.colors
// Fusionne les tokens sémantiques (Design System) + tokens fonctionnels (charts, bible, etc.)
//
// Source de vérité couleurs : lumina_tokens.dart

import 'package:flutter/material.dart';
import 'lumina_tokens.dart';

export 'lumina_tokens.dart';

/// Extension de thème Lumina — accès via context.colors
/// Usage : context.colors.textPrimary, context.colors.bgCard, etc.
@immutable
class LuminaColorsExtension extends ThemeExtension<LuminaColorsExtension> {
  const LuminaColorsExtension({
    // ─── TOKENS SÉMANTIQUES ────────────────────────
    required this.brandPrimary,
    required this.brandSecondary,
    required this.brandPrimaryLight,
    required this.brandPrimaryDark,
    required this.brandPrimaryContainer,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.textDisabled,
    required this.textInverse,
    required this.textOnBrand,
    required this.textLink,
    required this.textLinkHover,
    required this.bgPage,
    required this.bgSecondary,
    required this.bgCard,
    required this.bgCardHover,
    required this.bgElevated,
    required this.bgModal,
    required this.bgOverlay,
    required this.bgScrim,
    required this.surfaceObsidian,
    required this.borderDefault,
    required this.borderSubtle,
    required this.borderStrong,
    required this.borderBrand,
    required this.borderBrandFull,
    required this.borderFocus,
    required this.stateSelectedBg,
    required this.stateHoverBg,
    required this.statePressedBg,
    required this.stateFocusRing,
    required this.glassBadgeBg,
    required this.glassBadgeBorder,
    required this.glassCardBg,
    required this.glassCardBorder,
    required this.glassHeaderBg,
    required this.glassHeaderBorder,
    required this.glassNavBg,
    required this.glassTooltipBg,
    required this.navBg,
    required this.navBorderTop,
    required this.navIconActive,
    required this.navIconInactive,
    required this.navLabelActive,
    required this.navLabelInactive,
    required this.iconPrimary,
    required this.iconSecondary,
    required this.iconBrand,
    required this.iconOnBrand,
    required this.successBg,
    required this.successBorder,
    required this.successText,
    required this.successIcon,
    required this.errorBg,
    required this.errorBorder,
    required this.errorText,
    required this.errorIcon,
    required this.warningBg,
    required this.warningBorder,
    required this.warningIcon,
    required this.warningText,
    required this.infoBg,
    required this.infoBorder,
    required this.infoText,
    required this.infoIcon,

    // ─── TOKENS FONCTIONNELS ────────────────────────────
    required this.shimmerBase,
    required this.shimmerHighlight,
    required this.inputBackground,
    required this.incomeColor,
    required this.expenseColor,
    required this.pendingColor,
    required this.balancePositive,
    required this.balanceNegative,
    required this.badgeSuccessBackground,
    required this.badgeSuccessText,
    required this.badgeWarningBackground,
    required this.badgeWarningText,
    required this.badgeDangerBackground,
    required this.badgeDangerText,
    required this.badgeInfoBackground,
    required this.badgeInfoText,
    required this.chartColor1,
    required this.chartColor2,
    required this.chartColor3,
    required this.chartColor4,
    required this.chartColor5,
    required this.chartColor6,
    required this.chartColor7,
    required this.chartColor8,
    required this.choraleColor,
    required this.hommesColor,
    required this.femmesColor,
    required this.jeunesseColor,
    required this.enfantsColor,
    required this.intercessionColor,
    required this.bibleHighlightYellow,
    required this.bibleHighlightGreen,
    required this.bibleHighlightBlue,
    required this.bibleHighlightPink,
    required this.bibleHighlightRed,
    required this.bibleReaderBackground,
    required this.bibleCardBackground,
    this.dividerColor,
    required this.borderLight,
    required this.brandGradient,
    required this.accentGradient,
    required this.premiumGradient,
    required this.fireFusionGradient,
    required this.hommesGradient,
    required this.femmesGradient,
    required this.choraleGradient,
    required this.enfantsGradient,
    required this.intercessionGradient,
    required this.bgTertiary,
    required this.glassDark,
  });

  // --- Aliases de compatibilité ---
  Color get accent => brandPrimary;
  Color get bgPrimary => bgPage;
  Color get surface => bgCard;
  Color get textHint => textTertiary;
  Color get divider => borderDefault;
  Color get error => errorText;
  Color get success => successText;
  Color get warning => warningText;
  Color get info => infoText;
  Color get surfacePrimary => bgCard;
  Color get iconDisabled => textDisabled;
  Color get softShadow => Colors.black.withValues(alpha: 0.05);
  Color get textSecondaryLight => textSecondary.withValues(alpha: 0.7);
  Color get bgCardElevated => bgElevated;
  Color get bgPrimaryLight => bgSecondary;
  Color get surfaceSecondary => bgSecondary;



  final Color brandPrimary, brandSecondary;
  final Color brandPrimaryLight, brandPrimaryDark, brandPrimaryContainer;
  final Color textPrimary, textSecondary, textTertiary, textDisabled;
  final Color textInverse, textOnBrand, textLink, textLinkHover;
  final Color bgPage, bgSecondary, bgCard, bgCardHover, bgElevated, bgModal;
  final Color bgOverlay, bgScrim, surfaceObsidian;
  final Color borderDefault, borderSubtle, borderStrong;
  final Color borderBrand, borderBrandFull, borderFocus;
  final Color stateSelectedBg, stateHoverBg, statePressedBg, stateFocusRing;
  final Color glassBadgeBg, glassBadgeBorder, glassCardBg, glassCardBorder;
  final Color glassHeaderBg, glassHeaderBorder, glassNavBg, glassTooltipBg;
  final Color navBg, navBorderTop, navIconActive, navIconInactive;
  final Color navLabelActive, navLabelInactive;
  final Color iconPrimary, iconSecondary, iconBrand, iconOnBrand;
  final Color successBg, successBorder, successText, successIcon;
  final Color errorBg, errorBorder, errorText, errorIcon;
  final Color warningBg, warningBorder, warningIcon, warningText;
  final Color infoBg, infoBorder, infoText, infoIcon;

  final Color shimmerBase, shimmerHighlight, inputBackground;
  final Color incomeColor, expenseColor, pendingColor;
  final Color balancePositive, balanceNegative;
  final Color badgeSuccessBackground, badgeSuccessText;
  final Color badgeWarningBackground, badgeWarningText;
  final Color badgeDangerBackground, badgeDangerText;
  final Color badgeInfoBackground, badgeInfoText;
  final Color chartColor1, chartColor2, chartColor3, chartColor4;
  final Color chartColor5, chartColor6, chartColor7, chartColor8;
  final Color choraleColor, hommesColor, femmesColor;
  final Color jeunesseColor, enfantsColor, intercessionColor;
  final Color bibleHighlightYellow, bibleHighlightGreen, bibleHighlightBlue;
  final Color bibleHighlightPink, bibleHighlightRed;
  final Color bibleReaderBackground, bibleCardBackground;
  final Color? dividerColor;
  final Color borderLight;

  final LinearGradient brandGradient, accentGradient, premiumGradient, fireFusionGradient;
  final LinearGradient hommesGradient, femmesGradient, choraleGradient, enfantsGradient, intercessionGradient;

  final Color bgTertiary, glassDark;

  // --- Legacy Aliases for Backward Compatibility ---
  Color get brandPrimaryFire => brandPrimary;
  Color get textPrimaryLight => textPrimary;

  Color get textSecondaryDark => textSecondary;
  Color get bgCardLight => bgCard;
  Color get bgCardDark => bgCard;
  Color get bgPageLight => bgPage;
  Color get bgPageDark => bgPage;

  Color get brandSecondaryLight => brandSecondary;
  Color get brandSecondaryDark => brandSecondary;
  Color get brandSecondaryContainer => brandPrimaryContainer;

  /// Variation of bgCard (using bgSecondary by default)
  Color bgCardVariant(BuildContext context) => bgSecondary;

  Color get sidebarBackground => bgSecondary;
  Color get cardElevated => bgElevated;
  LinearGradient get brandPrimaryGradient => brandGradient;
  LinearGradient get brandPrimaryGradientFire => brandGradient;
  LinearGradient get premiumFusionGradient => premiumGradient;
  LinearGradient get jeunesseGradient => LinearGradient(
        colors: [jeunesseColor, jeunesseColor.withValues(alpha: 0.7)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );


  /// Effet de lueur "Fire" basé sur brandPrimary
  List<BoxShadow> get brandGlow => [
        BoxShadow(
          color: brandPrimary.withValues(alpha: 0.15),
          blurRadius: 12.0,
          spreadRadius: 2,
        ),
      ];

  /// Effet de lueur secondaire basé sur brandSecondary
  List<BoxShadow> get brandGlowSecondary => [
        BoxShadow(
          color: brandSecondary.withValues(alpha: 0.12),
          blurRadius: 12.0,
          spreadRadius: 0,
        ),
      ];

  // ═══════════════════════════════════════════════════════════════════
  // LIGHT (source : LuminaLight + tokens fonctionnels)
  // ═══════════════════════════════════════════════════════════════════
  static const light = LuminaColorsExtension(
    // Tokens sémantiques — LuminaLight
    textPrimary: LuminaLight.textPrimary,
    textSecondary: LuminaLight.textSecondary,
    textTertiary: LuminaLight.textTertiary,
    textDisabled: LuminaLight.textDisabled,
    textInverse: LuminaLight.textInverse,
    textOnBrand: LuminaLight.textOnBrand,
    textLink: LuminaLight.textLink,
    textLinkHover: LuminaLight.textLinkHover,
    bgPage: LuminaLight.bgPage,
    bgSecondary: LuminaLight.bgSecondary,
    bgCard: LuminaLight.bgCard,
    bgCardHover: LuminaLight.bgCardHover,
    bgElevated: LuminaLight.bgElevated,
    bgModal: LuminaLight.bgModal,
    bgOverlay: LuminaLight.bgOverlay,
    bgScrim: LuminaLight.bgScrim,
    borderDefault: LuminaLight.borderDefault,
    borderSubtle: LuminaLight.borderSubtle,
    borderStrong: LuminaLight.borderStrong,
    borderBrand: LuminaLight.borderBrand,
    borderBrandFull: LuminaLight.borderBrandFull,
    borderFocus: LuminaLight.borderFocus,
    stateSelectedBg: LuminaLight.stateSelectedBg,
    stateHoverBg: LuminaLight.stateHoverBg,
    statePressedBg: LuminaLight.statePressedBg,
    stateFocusRing: LuminaLight.stateFocusRing,
    glassBadgeBg: LuminaLight.glassBadgeBg,
    glassBadgeBorder: LuminaLight.glassBadgeBorder,
    glassCardBg: LuminaLight.glassCardBg,
    glassCardBorder: LuminaLight.glassCardBorder,
    glassHeaderBg: LuminaLight.glassHeaderBg,
    glassHeaderBorder: LuminaLight.glassHeaderBorder,
    glassNavBg: LuminaLight.glassNavBg,
    glassTooltipBg: LuminaLight.glassTooltipBg,
    navBg: LuminaLight.navBg,
    navBorderTop: LuminaLight.navBorderTop,
    navIconActive: LuminaLight.navIconActive,
    navIconInactive: LuminaLight.navIconInactive,
    navLabelActive: LuminaLight.navLabelActive,
    navLabelInactive: LuminaLight.navLabelInactive,
    iconPrimary: LuminaLight.iconPrimary,
    iconSecondary: LuminaLight.iconSecondary,
    iconBrand: LuminaLight.iconBrand,
    iconOnBrand: LuminaLight.iconOnBrand,
    brandPrimary: LuminaBrand.orange,
    brandSecondary: LuminaBrand.amber,
    successBg: LuminaLight.successBg,
    successBorder: LuminaLight.successBorder,
    successText: LuminaLight.successText,
    successIcon: LuminaLight.successIcon,
    errorBg: LuminaLight.errorBg,
    errorBorder: LuminaLight.errorBorder,
    errorText: LuminaLight.errorText,
    errorIcon: LuminaLight.errorIcon,
    warningBg: LuminaLight.warningBg,
    warningBorder: LuminaLight.warningBorder,
    warningIcon: LuminaLight.warningIcon,
    warningText: LuminaLight.warningText,
    infoBg: LuminaLight.infoBg,
    infoBorder: LuminaLight.infoBorder,
    infoText: LuminaLight.infoText,
    infoIcon: LuminaLight.infoIcon,

    // Tokens fonctionnels — Light
    shimmerBase: Color(0xFFE2E8F0),
    shimmerHighlight: Color(0xFFF1F5F9),
    inputBackground: Color(0xFFF8FAFC),
    incomeColor: Color(0xFF10B981),
    expenseColor: Color(0xFFEF4444),
    pendingColor: Color(0xFFF59E0B),
    balancePositive: Color(0xFF10B981),
    balanceNegative: Color(0xFFEF4444),
    badgeSuccessBackground: Color(0xFFA7F3D0),
    badgeSuccessText: Color(0xFF065F46),
    badgeWarningBackground: Color(0xFFFDE68A),
    badgeWarningText: Color(0xFF92400E),
    badgeDangerBackground: Color(0xFFFECACA),
    badgeDangerText: Color(0xFF991B1B),
    badgeInfoBackground: Color(0xFFBAE6FD),
    badgeInfoText: Color(0xFF075985),
    chartColor1: LuminaBrand.orange,
    chartColor2: LuminaBrand.red,
    chartColor3: Color(0xFFEC4899),
    chartColor4: Color(0xFFF59E0B),
    chartColor5: Color(0xFF10B981),
    chartColor6: Color(0xFF3B82F6),
    chartColor7: Color(0xFFEF4444),
    chartColor8: Color(0xFF14B8A6),
    choraleColor: LuminaBrand.orange,
    hommesColor: Color(0xFF3B82F6),
    femmesColor: Color(0xFFEC4899),
    jeunesseColor: Color(0xFF10B981),
    enfantsColor: Color(0xFFF59E0B),
    intercessionColor: LuminaBrand.amber,
    bibleHighlightYellow: Color(0xFFFFC107),
    bibleHighlightGreen: Color(0xFF4CAF50),
    bibleHighlightBlue: Color(0xFF42A5F5),
    bibleHighlightPink: Color(0xFFEC407A),
    bibleHighlightRed: Color(0xFFEF5350),
    bibleReaderBackground: Color(0xFFFFFFFF),
    bibleCardBackground: Color(0xFFFFFFFF),
    dividerColor: Color(0xFFE2E8F0),
    borderLight: Color(0xFFE2E8F0),
    brandGradient: LinearGradient(
      colors: [LuminaBrand.orange, LuminaBrand.red],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    accentGradient: LinearGradient(
      colors: [LuminaBrand.amber, LuminaBrand.orange],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    brandPrimaryLight: Color(0xFFFF9666),
    brandPrimaryDark: Color(0xFFC2410C),
    brandPrimaryContainer: Color(0xFFFFEDD5),
    premiumGradient: LinearGradient(
      colors: [Color(0xFF0F172A), LuminaBrand.red, LuminaBrand.orange],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    fireFusionGradient: LinearGradient(
      colors: [LuminaBrand.red, LuminaBrand.orange],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    hommesGradient: LinearGradient(
      colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    femmesGradient: LinearGradient(
      colors: [Color(0xFFEC4899), Color(0xFFBE185D)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    choraleGradient: LinearGradient(
      colors: [LuminaBrand.orange, Color(0xFFEA580C)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    enfantsGradient: LinearGradient(
      colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    intercessionGradient: LinearGradient(
      colors: [LuminaBrand.amber, Color(0xFFD97706)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    surfaceObsidian: Color(0xFF050505),
    bgTertiary: LuminaLight.bgElevated,
    glassDark: Color(0xCC1A1A1A), // LuminaDark.glassCardBg with 0.8 alpha
  );

  // ═══════════════════════════════════════════════════════════════════
  // DARK (source : LuminaDark + tokens fonctionnels)
  // ═══════════════════════════════════════════════════════════════════
  static const dark = LuminaColorsExtension(
    // Tokens sémantiques — LuminaDark
    textPrimary: LuminaDark.textPrimary,
    textSecondary: LuminaDark.textSecondary,
    textTertiary: LuminaDark.textTertiary,
    textDisabled: LuminaDark.textDisabled,
    textInverse: LuminaDark.textInverse,
    textOnBrand: LuminaDark.textOnBrand,
    textLink: LuminaDark.textLink,
    textLinkHover: LuminaDark.textLinkHover,
    bgPage: LuminaDark.bgPage,
    bgSecondary: LuminaDark.bgSecondary,
    bgCard: LuminaDark.bgCard,
    bgCardHover: LuminaDark.bgCardHover,
    bgElevated: LuminaDark.bgElevated,
    bgModal: LuminaDark.bgModal,
    bgOverlay: LuminaDark.bgOverlay,
    bgScrim: LuminaDark.bgScrim,
    borderDefault: LuminaDark.borderDefault,
    borderSubtle: LuminaDark.borderSubtle,
    borderStrong: LuminaDark.borderStrong,
    borderBrand: LuminaDark.borderBrand,
    borderBrandFull: LuminaDark.borderBrandFull,
    borderFocus: LuminaDark.borderFocus,
    stateSelectedBg: LuminaDark.stateSelectedBg,
    stateHoverBg: LuminaDark.stateHoverBg,
    statePressedBg: LuminaDark.statePressedBg,
    stateFocusRing: LuminaDark.stateFocusRing,
    glassBadgeBg: LuminaDark.glassBadgeBg,
    glassBadgeBorder: LuminaDark.glassBadgeBorder,
    glassCardBg: LuminaDark.glassCardBg,
    glassCardBorder: LuminaDark.glassCardBorder,
    glassHeaderBg: LuminaDark.glassHeaderBg,
    glassHeaderBorder: LuminaDark.glassHeaderBorder,
    glassNavBg: LuminaDark.glassNavBg,
    glassTooltipBg: LuminaDark.glassTooltipBg,
    navBg: LuminaDark.navBg,
    navBorderTop: LuminaDark.navBorderTop,
    navIconActive: LuminaDark.navIconActive,
    navIconInactive: LuminaDark.navIconInactive,
    navLabelActive: LuminaDark.navLabelActive,
    navLabelInactive: LuminaDark.navLabelInactive,
    iconPrimary: LuminaDark.iconPrimary,
    iconSecondary: LuminaDark.iconSecondary,
    iconBrand: LuminaDark.iconBrand,
    iconOnBrand: LuminaDark.iconOnBrand,
    brandPrimary: LuminaBrand.orange,
    brandSecondary: LuminaBrand.amber,
    successBg: LuminaDark.successBg,
    successBorder: LuminaDark.successBorder,
    successText: LuminaDark.successText,
    successIcon: LuminaDark.successIcon,
    errorBg: LuminaDark.errorBg,
    errorBorder: LuminaDark.errorBorder,
    errorText: LuminaDark.errorText,
    errorIcon: LuminaDark.errorIcon,
    warningBg: LuminaDark.warningBg,
    warningBorder: LuminaDark.warningBorder,
    warningIcon: LuminaDark.warningIcon,
    warningText: LuminaDark.warningText,
    infoBg: LuminaDark.infoBg,
    infoBorder: LuminaDark.infoBorder,
    infoText: LuminaDark.infoText,
    infoIcon: LuminaDark.infoIcon,

    // Tokens fonctionnels — Dark
    shimmerBase: Color(0xFF27272A),
    shimmerHighlight: Color(0xFF3F3F46),
    inputBackground: Color(0xFF18181B),
    incomeColor: Color(0xFF10B981),
    expenseColor: Color(0xFFEF4444),
    pendingColor: Color(0xFFF59E0B),
    balancePositive: Color(0xFF10B981),
    balanceNegative: Color(0xFFEF4444),
    badgeSuccessBackground: Color(0xFF065F46),
    badgeSuccessText: Color(0xFFA7F3D0),
    badgeWarningBackground: Color(0xFF92400E),
    badgeWarningText: Color(0xFFFDE68A),
    badgeDangerBackground: Color(0xFF991B1B),
    badgeDangerText: Color(0xFFFECACA),
    badgeInfoBackground: Color(0xFF075985),
    badgeInfoText: Color(0xFFBAE6FD),
    chartColor1: LuminaBrand.orange,
    chartColor2: LuminaBrand.red,
    chartColor3: Color(0xFFEC4899),
    chartColor4: Color(0xFFF59E0B),
    chartColor5: Color(0xFF10B981),
    chartColor6: Color(0xFF3B82F6),
    chartColor7: Color(0xFFEF4444),
    chartColor8: Color(0xFF14B8A6),
    choraleColor: LuminaBrand.orange,
    hommesColor: Color(0xFF3B82F6),
    femmesColor: Color(0xFFEC4899),
    jeunesseColor: Color(0xFF10B981),
    enfantsColor: Color(0xFFF59E0B),
    intercessionColor: LuminaBrand.amber,
    bibleHighlightYellow: Color(0xFFFFC107),
    bibleHighlightGreen: Color(0xFF4CAF50),
    bibleHighlightBlue: Color(0xFF42A5F5),
    bibleHighlightPink: Color(0xFFEC407A),
    bibleHighlightRed: Color(0xFFEF5350),
    bibleReaderBackground: Color(0xFF1A1A2E),
    bibleCardBackground: Color(0xFF2A2A4A),
    dividerColor: Color(0xFF334155),
    borderLight: Color(0xFF334155),
    brandGradient: LinearGradient(
      colors: [LuminaBrand.orange, LuminaBrand.red],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    accentGradient: LinearGradient(
      colors: [LuminaBrand.amber, LuminaBrand.orange],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    brandPrimaryLight: Color(0xFFEA580C),
    brandPrimaryDark: Color(0xFF9A3412),
    brandPrimaryContainer: Color(0xFF431407),
    premiumGradient: LinearGradient(
      colors: [Color(0xFF020617), LuminaBrand.red, LuminaBrand.orange],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    fireFusionGradient: LinearGradient(
      colors: [LuminaBrand.red, LuminaBrand.orange],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    hommesGradient: LinearGradient(
      colors: [Color(0xFF2563EB), Color(0xFF1E40AF)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    femmesGradient: LinearGradient(
      colors: [Color(0xFFDB2777), Color(0xFF9D174D)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    choraleGradient: LinearGradient(
      colors: [LuminaBrand.orange, Color(0xFF9A3412)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    enfantsGradient: LinearGradient(
      colors: [Color(0xFFD97706), Color(0xFF92400E)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    intercessionGradient: LinearGradient(
      colors: [LuminaBrand.amber, Color(0xFF92400E)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    surfaceObsidian: Color(0xFF050505),
    bgTertiary: LuminaDark.bgElevated,
    glassDark: Color(0xE61A1A1A), // LuminaDark.glassCardBg with 0.9 alpha
  );

  // ═══════════════════════════════════════════════════════════════════
  // ACCESSOR HELPER (compatibilité ancienne API)
  // ═══════════════════════════════════════════════════════════════════

  /// Usage: LuminaColors.of(context).textPrimary
  static LuminaColorsExtension of(BuildContext context) =>
      Theme.of(context).extension<LuminaColorsExtension>()!;

  // ═══════════════════════════════════════════════════════════════════
  // THEME EXTENSION OVERRIDES
  // ═══════════════════════════════════════════════════════════════════

  @override
  LuminaColorsExtension copyWith({
    Color? textPrimary,
    Color? textSecondary,
    Color? bgPage,
    Color? bgSecondary,
    Color? bgCard,
    Color? brandPrimary,
    Color? brandSecondary,
    // Add other fields as needed for copyWith
  }) {
    return LuminaColorsExtension(
      brandPrimary: brandPrimary ?? this.brandPrimary,
      brandSecondary: brandSecondary ?? this.brandSecondary,
      brandPrimaryLight: brandPrimaryLight,
      brandPrimaryDark: brandPrimaryDark,
      brandPrimaryContainer: brandPrimaryContainer,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary,
      textDisabled: textDisabled,
      textInverse: textInverse,
      textOnBrand: textOnBrand,
      textLink: textLink,
      textLinkHover: textLinkHover,
      bgPage: bgPage ?? this.bgPage,
      bgSecondary: bgSecondary ?? this.bgSecondary,
      bgCard: bgCard ?? this.bgCard,
      bgCardHover: bgCardHover,
      bgElevated: bgElevated,
      bgModal: bgModal,
      bgOverlay: bgOverlay,
      bgScrim: bgScrim,
      surfaceObsidian: surfaceObsidian,
      borderDefault: borderDefault,
      borderSubtle: borderSubtle,
      borderStrong: borderStrong,
      borderBrand: borderBrand,
      borderBrandFull: borderBrandFull,
      borderFocus: borderFocus,
      stateSelectedBg: stateSelectedBg,
      stateHoverBg: stateHoverBg,
      statePressedBg: statePressedBg,
      stateFocusRing: stateFocusRing,
      glassBadgeBg: glassBadgeBg,
      glassBadgeBorder: glassBadgeBorder,
      glassCardBg: glassCardBg,
      glassCardBorder: glassCardBorder,
      glassHeaderBg: glassHeaderBg,
      glassHeaderBorder: glassHeaderBorder,
      glassNavBg: glassNavBg,
      glassTooltipBg: glassTooltipBg,
      navBg: navBg,
      navBorderTop: navBorderTop,
      navIconActive: navIconActive,
      navIconInactive: navIconInactive,
      navLabelActive: navLabelActive,
      navLabelInactive: navLabelInactive,
      iconPrimary: iconPrimary,
      iconSecondary: iconSecondary,
      iconBrand: iconBrand,
      iconOnBrand: iconOnBrand,
      successBg: successBg,
      successBorder: successBorder,
      successText: successText,
      successIcon: successIcon,
      errorBg: errorBg,
      errorBorder: errorBorder,
      errorText: errorText,
      errorIcon: errorIcon,
      warningBg: warningBg,
      warningBorder: warningBorder,
      warningIcon: warningIcon,
      warningText: warningText,
      infoBg: infoBg,
      infoBorder: infoBorder,
      infoText: infoText,
      infoIcon: infoIcon,
      shimmerBase: shimmerBase,
      shimmerHighlight: shimmerHighlight,
      inputBackground: inputBackground,
      incomeColor: incomeColor,
      expenseColor: expenseColor,
      pendingColor: pendingColor,
      balancePositive: balancePositive,
      balanceNegative: balanceNegative,
      badgeSuccessBackground: badgeSuccessBackground,
      badgeSuccessText: badgeSuccessText,
      badgeWarningBackground: badgeWarningBackground,
      badgeWarningText: badgeWarningText,
      badgeDangerBackground: badgeDangerBackground,
      badgeDangerText: badgeDangerText,
      badgeInfoBackground: badgeInfoBackground,
      badgeInfoText: badgeInfoText,
      chartColor1: chartColor1,
      chartColor2: chartColor2,
      chartColor3: chartColor3,
      chartColor4: chartColor4,
      chartColor5: chartColor5,
      chartColor6: chartColor6,
      chartColor7: chartColor7,
      chartColor8: chartColor8,
      choraleColor: choraleColor,
      hommesColor: hommesColor,
      femmesColor: femmesColor,
      jeunesseColor: jeunesseColor,
      enfantsColor: enfantsColor,
      intercessionColor: intercessionColor,
      bibleHighlightYellow: bibleHighlightYellow,
      bibleHighlightGreen: bibleHighlightGreen,
      bibleHighlightBlue: bibleHighlightBlue,
      bibleHighlightPink: bibleHighlightPink,
      bibleHighlightRed: bibleHighlightRed,
      bibleReaderBackground: bibleReaderBackground,
      bibleCardBackground: bibleCardBackground,
      dividerColor: dividerColor,
      borderLight: borderLight,
      brandGradient: brandGradient,
      accentGradient: accentGradient,
      premiumGradient: premiumGradient,
      fireFusionGradient: fireFusionGradient,
      hommesGradient: hommesGradient,
      femmesGradient: femmesGradient,
      choraleGradient: choraleGradient,
      enfantsGradient: enfantsGradient,
      intercessionGradient: intercessionGradient,
      bgTertiary: bgTertiary,
      glassDark: glassDark,
    );
  }

  @override
  LuminaColorsExtension lerp(LuminaColorsExtension? other, double t) {
    if (other is! LuminaColorsExtension) return this;
    return LuminaColorsExtension(
      brandPrimary: Color.lerp(brandPrimary, other.brandPrimary, t)!,
      brandSecondary: Color.lerp(brandSecondary, other.brandSecondary, t)!,
      brandPrimaryLight: Color.lerp(brandPrimaryLight, other.brandPrimaryLight, t)!,
      brandPrimaryDark: Color.lerp(brandPrimaryDark, other.brandPrimaryDark, t)!,
      brandPrimaryContainer: Color.lerp(brandPrimaryContainer, other.brandPrimaryContainer, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      textDisabled: Color.lerp(textDisabled, other.textDisabled, t)!,
      textInverse: Color.lerp(textInverse, other.textInverse, t)!,
      textOnBrand: Color.lerp(textOnBrand, other.textOnBrand, t)!,
      textLink: Color.lerp(textLink, other.textLink, t)!,
      textLinkHover: Color.lerp(textLinkHover, other.textLinkHover, t)!,
      bgPage: Color.lerp(bgPage, other.bgPage, t)!,
      bgSecondary: Color.lerp(bgSecondary, other.bgSecondary, t)!,
      bgCard: Color.lerp(bgCard, other.bgCard, t)!,
      bgCardHover: Color.lerp(bgCardHover, other.bgCardHover, t)!,
      bgElevated: Color.lerp(bgElevated, other.bgElevated, t)!,
      bgModal: Color.lerp(bgModal, other.bgModal, t)!,
      bgOverlay: Color.lerp(bgOverlay, other.bgOverlay, t)!,
      bgScrim: Color.lerp(bgScrim, other.bgScrim, t)!,
      surfaceObsidian: Color.lerp(surfaceObsidian, other.surfaceObsidian, t)!,
      borderDefault: Color.lerp(borderDefault, other.borderDefault, t)!,
      borderSubtle: Color.lerp(borderSubtle, other.borderSubtle, t)!,
      borderStrong: Color.lerp(borderStrong, other.borderStrong, t)!,
      borderBrand: Color.lerp(borderBrand, other.borderBrand, t)!,
      borderBrandFull: Color.lerp(borderBrandFull, other.borderBrandFull, t)!,
      borderFocus: Color.lerp(borderFocus, other.borderFocus, t)!,
      stateSelectedBg: Color.lerp(stateSelectedBg, other.stateSelectedBg, t)!,
      stateHoverBg: Color.lerp(stateHoverBg, other.stateHoverBg, t)!,
      statePressedBg: Color.lerp(statePressedBg, other.statePressedBg, t)!,
      stateFocusRing: Color.lerp(stateFocusRing, other.stateFocusRing, t)!,
      glassBadgeBg: Color.lerp(glassBadgeBg, other.glassBadgeBg, t)!,
      glassBadgeBorder: Color.lerp(glassBadgeBorder, other.glassBadgeBorder, t)!,
      glassCardBg: Color.lerp(glassCardBg, other.glassCardBg, t)!,
      glassCardBorder: Color.lerp(glassCardBorder, other.glassCardBorder, t)!,
      glassHeaderBg: Color.lerp(glassHeaderBg, other.glassHeaderBg, t)!,
      glassHeaderBorder: Color.lerp(glassHeaderBorder, other.glassHeaderBorder, t)!,
      glassNavBg: Color.lerp(glassNavBg, other.glassNavBg, t)!,
      glassTooltipBg: Color.lerp(glassTooltipBg, other.glassTooltipBg, t)!,
      navBg: Color.lerp(navBg, other.navBg, t)!,
      navBorderTop: Color.lerp(navBorderTop, other.navBorderTop, t)!,
      navIconActive: Color.lerp(navIconActive, other.navIconActive, t)!,
      navIconInactive: Color.lerp(navIconInactive, other.navIconInactive, t)!,
      navLabelActive: Color.lerp(navLabelActive, other.navLabelActive, t)!,
      navLabelInactive: Color.lerp(navLabelInactive, other.navLabelInactive, t)!,
      iconPrimary: Color.lerp(iconPrimary, other.iconPrimary, t)!,
      iconSecondary: Color.lerp(iconSecondary, other.iconSecondary, t)!,
      iconBrand: Color.lerp(iconBrand, other.iconBrand, t)!,
      iconOnBrand: Color.lerp(iconOnBrand, other.iconOnBrand, t)!,
      successBg: Color.lerp(successBg, other.successBg, t)!,
      successBorder: Color.lerp(successBorder, other.successBorder, t)!,
      successText: Color.lerp(successText, other.successText, t)!,
      successIcon: Color.lerp(successIcon, other.successIcon, t)!,
      errorBg: Color.lerp(errorBg, other.errorBg, t)!,
      errorBorder: Color.lerp(errorBorder, other.errorBorder, t)!,
      errorText: Color.lerp(errorText, other.errorText, t)!,
      errorIcon: Color.lerp(errorIcon, other.errorIcon, t)!,
      warningBg: Color.lerp(warningBg, other.warningBg, t)!,
      warningBorder: Color.lerp(warningBorder, other.warningBorder, t)!,
      warningIcon: Color.lerp(warningIcon, other.warningIcon, t)!,
      warningText: Color.lerp(warningText, other.warningText, t)!,
      infoBg: Color.lerp(infoBg, other.infoBg, t)!,
      infoBorder: Color.lerp(infoBorder, other.infoBorder, t)!,
      infoText: Color.lerp(infoText, other.infoText, t)!,
      infoIcon: Color.lerp(infoIcon, other.infoIcon, t)!,
      shimmerBase: Color.lerp(shimmerBase, other.shimmerBase, t)!,
      shimmerHighlight: Color.lerp(shimmerHighlight, other.shimmerHighlight, t)!,
      inputBackground: Color.lerp(inputBackground, other.inputBackground, t)!,
      incomeColor: Color.lerp(incomeColor, other.incomeColor, t)!,
      expenseColor: Color.lerp(expenseColor, other.expenseColor, t)!,
      pendingColor: Color.lerp(pendingColor, other.pendingColor, t)!,
      balancePositive: Color.lerp(balancePositive, other.balancePositive, t)!,
      balanceNegative: Color.lerp(balanceNegative, other.balanceNegative, t)!,
      badgeSuccessBackground: Color.lerp(badgeSuccessBackground, other.badgeSuccessBackground, t)!,
      badgeSuccessText: Color.lerp(badgeSuccessText, other.badgeSuccessText, t)!,
      badgeWarningBackground: Color.lerp(badgeWarningBackground, other.badgeWarningBackground, t)!,
      badgeWarningText: Color.lerp(badgeWarningText, other.badgeWarningText, t)!,
      badgeDangerBackground: Color.lerp(badgeDangerBackground, other.badgeDangerBackground, t)!,
      badgeDangerText: Color.lerp(badgeDangerText, other.badgeDangerText, t)!,
      badgeInfoBackground: Color.lerp(badgeInfoBackground, other.badgeInfoBackground, t)!,
      badgeInfoText: Color.lerp(badgeInfoText, other.badgeInfoText, t)!,
      chartColor1: Color.lerp(chartColor1, other.chartColor1, t)!,
      chartColor2: Color.lerp(chartColor2, other.chartColor2, t)!,
      chartColor3: Color.lerp(chartColor3, other.chartColor3, t)!,
      chartColor4: Color.lerp(chartColor4, other.chartColor4, t)!,
      chartColor5: Color.lerp(chartColor5, other.chartColor5, t)!,
      chartColor6: Color.lerp(chartColor6, other.chartColor6, t)!,
      chartColor7: Color.lerp(chartColor7, other.chartColor7, t)!,
      chartColor8: Color.lerp(chartColor8, other.chartColor8, t)!,
      choraleColor: Color.lerp(choraleColor, other.choraleColor, t)!,
      hommesColor: Color.lerp(hommesColor, other.hommesColor, t)!,
      femmesColor: Color.lerp(femmesColor, other.femmesColor, t)!,
      jeunesseColor: Color.lerp(jeunesseColor, other.jeunesseColor, t)!,
      enfantsColor: Color.lerp(enfantsColor, other.enfantsColor, t)!,
      intercessionColor: Color.lerp(intercessionColor, other.intercessionColor, t)!,
      bibleHighlightYellow: Color.lerp(bibleHighlightYellow, other.bibleHighlightYellow, t)!,
      bibleHighlightGreen: Color.lerp(bibleHighlightGreen, other.bibleHighlightGreen, t)!,
      bibleHighlightBlue: Color.lerp(bibleHighlightBlue, other.bibleHighlightBlue, t)!,
      bibleHighlightPink: Color.lerp(bibleHighlightPink, other.bibleHighlightPink, t)!,
      bibleHighlightRed: Color.lerp(bibleHighlightRed, other.bibleHighlightRed, t)!,
      bibleReaderBackground: Color.lerp(bibleReaderBackground, other.bibleReaderBackground, t)!,
      bibleCardBackground: Color.lerp(bibleCardBackground, other.bibleCardBackground, t)!,
      dividerColor: Color.lerp(dividerColor, other.dividerColor, t),
      borderLight: Color.lerp(borderLight, other.borderLight, t)!,
      brandGradient: LinearGradient.lerp(brandGradient, other.brandGradient, t)!,
      accentGradient: LinearGradient.lerp(accentGradient, other.accentGradient, t)!,
      premiumGradient: LinearGradient.lerp(premiumGradient, other.premiumGradient, t)!,
      fireFusionGradient: LinearGradient.lerp(fireFusionGradient, other.fireFusionGradient, t)!,
      hommesGradient: LinearGradient.lerp(hommesGradient, other.hommesGradient, t)!,
      femmesGradient: LinearGradient.lerp(femmesGradient, other.femmesGradient, t)!,
      choraleGradient: LinearGradient.lerp(choraleGradient, other.choraleGradient, t)!,
      enfantsGradient: LinearGradient.lerp(enfantsGradient, other.enfantsGradient, t)!,
      intercessionGradient: LinearGradient.lerp(intercessionGradient, other.intercessionGradient, t)!,
      bgTertiary: Color.lerp(bgTertiary, other.bgTertiary, t)!,
      glassDark: Color.lerp(glassDark, other.glassDark, t)!,
    );
  }
}

