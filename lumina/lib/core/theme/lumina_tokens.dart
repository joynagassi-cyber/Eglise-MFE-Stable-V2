import 'package:flutter/material.dart';

/// ============================================================
/// LUMINA DESIGN SYSTEM — TOKENS OFFICIELS
/// Source : lumina-design-system.json
/// NE PAS MODIFIER MANUELLEMENT — Source de vérité unique
/// ============================================================

// ─────────────────────────────────────────
// COULEURS BRAND (invariantes, sans mode)
// ─────────────────────────────────────────
abstract final class LuminaBrand {
  static const orange  = Color(0xFFFF8C00); // brand/orange — gradient début
  static const red     = Color(0xFFFF2D00); // brand/red    — gradient fin
  static const amber   = Color(0xFFFFB020); // brand/amber  — accent, étoiles
  static const coral   = Color(0xFFFF6040); // brand/coral  — hover, milieu gradient

  // Palette orange complète
  static const orange50  = Color(0xFFFFF3E0);
  static const orange100 = Color(0xFFFFE0B2);
  static const orange200 = Color(0xFFFFCC80);
  static const orange300 = Color(0xFFFFB040);
  static const orange400 = Color(0xFFFFA000);
  static const orange500 = Color(0xFFFF8C00); // = brand/orange
  static const orange600 = Color(0xFFFF6500);
  static const orange700 = Color(0xFFFF4500);
  static const orange800 = Color(0xFFFF2D00); // = brand/red
  static const orange900 = Color(0xFFCC1000);
}

// ─────────────────────────────────────────
// TOKENS SÉMANTIQUES — LIGHT MODE
// ─────────────────────────────────────────
abstract final class LuminaLight {
  // Texte
  static const textPrimary   = Color(0xFF121212); // text/primary
  static const textSecondary = Color(0xFF444444); // text/secondary
  static const textTertiary  = Color(0xFF757575); // text/tertiary
  static const textDisabled  = Color(0xFFB0B0B0); // text/disabled
  static const textInverse   = Color(0xFFFFFFFF); // text/inverse
  static const textOnBrand   = Color(0xFFFFFFFF); // text/onBrand
  static const textLink      = Color(0xFFD47000); // text/link
  static const textLinkHover = Color(0xFFB85C00); // text/linkHover

  // Fonds
  static const bgPage        = Color(0xFFFFFFFF); // bg/page      — niveau 0
  static const bgSecondary   = Color(0xFFFAFAFA); // bg/secondary — niveau 0b
  static const bgCard        = Color(0xFFF7F7F7); // bg/card      — niveau 1
  static const bgCardHover   = Color(0xFFF0F0F0); // bg/cardHover
  static const bgElevated    = Color(0xFFEDEDED); // bg/elevated  — niveau 2
  static const bgModal       = Color(0xFFFFFFFF); // bg/modal     — niveau 3

  // Overlays (avec opacité)
  static const bgOverlay = Color(0x73000000); // bg/overlay — 45%
  static const bgScrim   = Color(0x99000000); // bg/scrim   — 60%

  // Bordures
  static const borderDefault   = Color(0x1A000000); // border/default  — 10%
  static const borderSubtle    = Color(0x0F000000); // border/subtle   — 6%
  static const borderStrong    = Color(0x33000000); // border/strong   — 20%
  static const borderBrand     = Color(0x80FF8C00); // border/brand    — 50%
  static const borderBrandFull = Color(0xFFFF8C00); // border/brandFull
  static const borderFocus     = Color(0xFFFF8C00); // border/focus

  // États
  static const stateSelectedBg  = Color(0x1FFF8C00); // state/selectedBg — 12%
  static const stateHoverBg     = Color(0x0A000000); // state/hoverBg    — 4%
  static const statePressedBg   = Color(0x14FF8C00); // state/pressedBg  — 8%
  static const stateFocusRing   = Color(0x59FF8C00); // state/focusRing  — 35%

  // Glass
  static const glassBadgeBg      = Color(0x1AFF8C00); // glass/badgeBg    blur 6px
  static const glassBadgeBorder  = Color(0x4DFF8C00); // glass/badgeBorder
  static const glassCardBg       = Color(0xB3FFFFFF); // glass/cardBg     blur 12px
  static const glassCardBorder   = Color(0x0F000000); // glass/cardBorder
  static const glassHeaderBg     = Color(0xE0FFFFFF); // glass/headerBg   blur 20px
  static const glassHeaderBorder = Color(0x33FF8C00); // glass/headerBorder
  static const glassNavBg        = Color(0xF2FFFFFF); // glass/navBg      blur 24px
  static const glassTooltipBg    = Color(0xEBFFFFFF); // glass/tooltipBg  blur 8px

  // Navigation
  static const navBg            = Color(0xF2FFFFFF); // nav/bg
  static const navBorderTop     = Color(0x40FF8C00); // nav/borderTop   — 25%
  static const navIconActive    = Color(0xFFFF6500); // nav/iconActive
  static const navIconInactive  = Color(0xFFAAAAAA); // nav/iconInactive
  static const navLabelActive   = Color(0xFFFF6500); // nav/labelActive
  static const navLabelInactive = Color(0xFFAAAAAA); // nav/labelInactive

  // Icônes
  static const iconPrimary   = Color(0xFF333333); // icon/primary
  static const iconSecondary = Color(0xFF888888); // icon/secondary
  static const iconBrand     = Color(0xFFFF6500); // icon/brand
  static const iconOnBrand   = Color(0xFFFFFFFF); // icon/onBrand

  // Sémantique — Succès
  static const successBg     = Color(0xFFF0FDF4); // semantic/successBg
  static const successBorder = Color(0xFFBBF7D0); // semantic/successBorder
  static const successText   = Color(0xFF166534); // semantic/successText
  static const successIcon   = Color(0xFF16A34A); // semantic/successIcon

  // Sémantique — Erreur
  static const errorBg     = Color(0xFFFFF1F2); // semantic/errorBg
  static const errorBorder = Color(0xFFFECDD5); // semantic/errorBorder
  static const errorText   = Color(0xFF991B1B); // semantic/errorText
  static const errorIcon   = Color(0xFFDC2626); // semantic/errorIcon

  // Sémantique — Warning
  static const warningBg     = Color(0xFFFFFBEB); // semantic/warningBg
  static const warningBorder = Color(0xFFFDE68A); // semantic/warningBorder
  static const warningIcon   = Color(0xFFD97706); // semantic/warningIcon
  static const warningText   = Color(0xFF92400E); // semantic/warningText

  // Sémantique — Info
  static const infoBg     = Color(0xFFEFF6FF); // semantic/infoBg
  static const infoBorder = Color(0xFFBFDBFE); // semantic/infoBorder
  static const infoText   = Color(0xFF1E40AF); // semantic/infoText
  static const infoIcon   = Color(0xFF2563EB); // semantic/infoIcon
}

// ─────────────────────────────────────────
// TOKENS SÉMANTIQUES — DARK MODE
// ─────────────────────────────────────────
abstract final class LuminaDark {
  // Texte
  static const textPrimary   = Color(0xFFF0F0F0); // text/primary
  static const textSecondary = Color(0xFFA8A8A8); // text/secondary
  static const textTertiary  = Color(0xFF6B6B6B); // text/tertiary
  static const textDisabled  = Color(0xFF444444); // text/disabled
  static const textInverse   = Color(0xFF0A0A0A); // text/inverse
  static const textOnBrand   = Color(0xFFFFFFFF); // text/onBrand
  static const textLink      = Color(0xFFFF9A30); // text/link
  static const textLinkHover = Color(0xFFFFB060); // text/linkHover

  // Fonds
  static const bgPage        = Color(0xFF0A0A0A); // bg/page      — niveau 0
  static const bgSecondary   = Color(0xFF111111); // bg/secondary — niveau 0b
  static const bgCard        = Color(0xFF1A1A1A); // bg/card      — niveau 1
  static const bgCardHover   = Color(0xFF202020); // bg/cardHover
  static const bgElevated    = Color(0xFF222222); // bg/elevated  — niveau 2
  static const bgModal       = Color(0xFF2A2A2A); // bg/modal     — niveau 3

  // Overlays
  static const bgOverlay = Color(0xB3000000); // bg/overlay — 70%
  static const bgScrim   = Color(0xD9000000); // bg/scrim   — 85%

  // Bordures
  static const borderDefault   = Color(0x1AFFFFFF); // border/default  — 10%
  static const borderSubtle    = Color(0x0FFFFFFF); // border/subtle   — 6%
  static const borderStrong    = Color(0x2EFFFFFF); // border/strong   — 18%
  static const borderBrand     = Color(0x80FF8C00); // border/brand    — 50%
  static const borderBrandFull = Color(0xFFFF8C00); // border/brandFull
  static const borderFocus     = Color(0xFFFF8C00); // border/focus

  // États
  static const stateSelectedBg  = Color(0x26FF8C00); // state/selectedBg — 15%
  static const stateHoverBg     = Color(0x0DFFFFFF); // state/hoverBg    — 5%
  static const statePressedBg   = Color(0x1AFF8C00); // state/pressedBg  — 10%
  static const stateFocusRing   = Color(0x66FF8C00); // state/focusRing  — 40%

  // Glass
  static const glassBadgeBg      = Color(0x1FFF8C00); // glass/badgeBg    blur 6px
  static const glassBadgeBorder  = Color(0x40FF8C00); // glass/badgeBorder
  static const glassCardBg       = Color(0x991A1A1A); // glass/cardBg     blur 12px
  static const glassCardBorder   = Color(0x0FFFFFFF); // glass/cardBorder
  static const glassHeaderBg     = Color(0xD90A0A0A); // glass/headerBg   blur 20px
  static const glassHeaderBorder = Color(0x26FF8C00); // glass/headerBorder
  static const glassNavBg        = Color(0xF20F0F0F); // glass/navBg      blur 24px
  static const glassTooltipBg    = Color(0xE62A2A2A); // glass/tooltipBg  blur 8px

  // Navigation
  static const navBg            = Color(0xF20F0F0F); // nav/bg
  static const navBorderTop     = Color(0x33FF8C00); // nav/borderTop — 20%
  static const navIconActive    = Color(0xFFFF8C00); // nav/iconActive
  static const navIconInactive  = Color(0xFF555555); // nav/iconInactive
  static const navLabelActive   = Color(0xFFFF8C00); // nav/labelActive
  static const navLabelInactive = Color(0xFF555555); // nav/labelInactive

  // Icônes
  static const iconPrimary   = Color(0xFFD0D0D0); // icon/primary
  static const iconSecondary = Color(0xFF7A7A7A); // icon/secondary
  static const iconBrand     = Color(0xFFFF8C00); // icon/brand
  static const iconOnBrand   = Color(0xFFFFFFFF); // icon/onBrand

  // Sémantique — Succès
  static const successBg     = Color(0xFF0D2B1A); // semantic/successBg
  static const successBorder = Color(0xFF1A4D30); // semantic/successBorder
  static const successText   = Color(0xFF4ADE80); // semantic/successText
  static const successIcon   = Color(0xFF22C55E); // semantic/successIcon

  // Sémantique — Erreur
  static const errorBg     = Color(0xFF2B0A0A); // semantic/errorBg
  static const errorBorder = Color(0xFF5C1515); // semantic/errorBorder
  static const errorText   = Color(0xFFFCA5A5); // semantic/errorText
  static const errorIcon   = Color(0xFFEF4444); // semantic/errorIcon

  // Sémantique — Warning
  static const warningBg     = Color(0xFF2B1A00); // semantic/warningBg
  static const warningBorder = Color(0xFF4D3000); // semantic/warningBorder
  static const warningIcon   = Color(0xFFF59E0B); // semantic/warningIcon
  static const warningText   = Color(0xFFFBBF24); // semantic/warningText

  // Sémantique — Info
  static const infoBg     = Color(0xFF0A1628); // semantic/infoBg
  static const infoBorder = Color(0xFF1A3055); // semantic/infoBorder
  static const infoText   = Color(0xFF93C5FD); // semantic/infoText
  static const infoIcon   = Color(0xFF60A5FA); // semantic/infoIcon
}

// ─────────────────────────────────────────
// TOKENS DIMENSIONNELS (invariants)
// ─────────────────────────────────────────
abstract final class LuminaRadius {
  static const sm  = 8.0;   // borderRadius/sm  — badges, chips
  static const md  = 12.0;  // borderRadius/md  — cartes compactes
  static const lg  = 16.0;  // borderRadius/lg  — cartes principales
  static const xl  = 20.0;  // borderRadius/xl  — modales, sheets
  static const xl2 = 24.0;  // borderRadius/2xl — hero cards
  static const xl3 = 32.0;  // borderRadius/3xl — surfaces immersives
  static const full = 9999.0; // borderRadius/full — pill, avatars
}

abstract final class LuminaIcon {
  static const xxs  = 12.0; // sizing/icon-xxs
  static const xs   = 16.0; // sizing/icon-xs  — inline dans texte
  static const sm   = 20.0; // sizing/icon-sm  — labels, chips
  static const md   = 24.0; // sizing/icon-md  — standard UI
  static const lg   = 28.0; // sizing/icon-lg  — navigation, boutons
  static const xl   = 32.0; // sizing/icon-xl  — heroes, onboarding
  static const xl2  = 40.0; // sizing/icon-2xl — large UI elements
  static const xxl  = 48.0; // sizing/icon-2xl — illustrations
  static const mega = 64.0;
  static const giga = 80.0;
}

abstract final class LuminaTouch {
  static const minimum = 44.0; // sizing/touch-min    — WCAG minimum
  static const lumina  = 56.0; // sizing/touch-lumina — recommandation Lumina
}

abstract final class LuminaFont {
  static const display = 'Plus Jakarta Sans'; // fontFamily/display — titres
  static const body    = 'Lora';              // fontFamily/body    — corps

  // Tailles (sp)
  static const sizeDisplay = 40.0; // fontSize/display
  static const sizeH1      = 34.0; // fontSize/h1
  static const sizeH2      = 28.0; // fontSize/h2
  static const sizeH3      = 22.0; // fontSize/h3
  static const sizeH4      = 19.0; // fontSize/h4
  static const sizeBodyLg  = 18.0; // fontSize/bodyLg
  static const sizeBody    = 16.0; // fontSize/body
  static const sizeBodySm  = 15.0; // fontSize/bodySm
  static const sizeUi      = 15.0; // fontSize/ui
  static const sizeUiSm    = 13.0; // fontSize/uiSm
  static const sizeCaption  = 12.0; // fontSize/caption
  static const sizeOverline = 11.0; // fontSize/overline

  // Poids
  static const weightRegular  = FontWeight.w400;
  static const weightMedium   = FontWeight.w500;
  static const weightSemiBold = FontWeight.w600;
  static const weightBold     = FontWeight.w700;

  // ═══════════════════════════════════════════════════════════════════════════
  // TAILLES AJOUTÉES AUTOMATIQUEMENT par fix_errors_v2.py
  // ═══════════════════════════════════════════════════════════════════════════
  static const double xxs  = 8.0;
  static const double xs   = 12.0;
  static const double sm   = 16.0;
  static const double md   = 20.0;
  static const double lg   = 24.0;
  static const double xl   = 28.0;
  static const double xxl  = 36.0;
  static const double mega = 48.0;
  static const double giga = 64.0;
  // ═══════════════════════════════════════════════════════════════════════════
}
