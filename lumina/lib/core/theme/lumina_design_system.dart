// lib/core/theme/lumina_design_system.dart
//
// Lumina Design System 2.2 — MODE-AWARE EDITION
//
// ⚠️  CHANGEMENT CRITIQUE : Toutes les couleurs et typographies sont
//     désormais CONTEXTUELLES (via BuildContext) pour supporter
//     automatiquement le mode clair ET le mode sombre.
//
//     AVANT (cassé) :  LuminaDesign.textPrimary  → toujours noir
//     APRÈS (ok)   :  context.colors.textPrimary → noir en light, blanc en dark
//
//     Les anciens getters statiques sont DEPRECATED mais gardés pour
//     compatibilité. Ils émettent un warning au compile-time.
//
// RÈGLE D'OR : Dans un widget build(), TOUJOURS utiliser context.colors
//              OU context.textTheme. JAMAIS LuminaDesign.textPrimary.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../extensions/context_extension.dart';
import '../widgets/loading_dots.dart';

/// ═══════════════════════════════════════════════════════════════════════════════
/// LUMINA DESIGN SYSTEM — Couleurs, Espacements, Typographie
///
/// MODE-AWARE : Utilise context.colors et context.textTheme dans build()
/// ═══════════════════════════════════════════════════════════════════════════════
class LuminaDesign {
  // ─── SPACING & RADII (invariants, pas affectés par le mode) ───
  static const double radiusLg = 20.0;
  static const double radiusMd = 12.0;
  static const double radiusSm = 8.0;
  static const double radiusFull = 100.0;

  static const double paddingLg = 24.0;
  static const double paddingMd = 16.0;
  static const double paddingSm = 8.0;

  // ─── BRAND COLORS (invariants — ne changent pas avec le mode) ───
  static const Color primary = Color(0xFFFF5722);    // Orange Feu
  static const Color primaryDark = Color(0xFFE64A19);
  static const Color secondary = Color(0xFFFFC107);  // Ambre / Or
  static const Color accent = Color(0xFF2196F3);     // Bleu Spirituel

  // ─── ⚠️ DEPRECATED — Ces couleurs sont hardcodées LIGHT uniquement ───
  // Utilise context.colors.textPrimary / context.colors.bgPage / etc.
  @Deprecated('Use context.colors.textPrimary instead — this is light-only')
  static const Color textPrimary = Color(0xFF1A1C1E);
  @Deprecated('Use context.colors.textSecondary instead — this is light-only')
  static const Color textSecondary = Color(0xFF42474E);
  @Deprecated('Use context.colors.textTertiary instead — this is light-only')
  static const Color textTertiary = Color(0xFF72777F);
  @Deprecated('Use context.colors.bgPage instead — this is light-only')
  static const Color surface = Color(0xFFFFFFFF);
  @Deprecated('Use context.colors.bgPage instead — this is light-only')
  static const Color background = Color(0xFFF1F3F5);
  @Deprecated('Use context.colors.bgCard instead — this is light-only')
  static const Color card = Color(0xFFFFFFFF);

  // ─── TYPOGRAPHY — MODE-AWARE via BuildContext ───
  //
  // AVANT : LuminaDesign.h1 → toujours noir
  // APRÈS : context.textTheme.displayLarge → adapté au mode
  //
  // Pour compatibilité transitoire, les getters statiques restent
  // mais sont deprecated. Les nouveaux getters contextuels sont
  // dans l'extension LuminaTypographyExtension ci-dessous.

  @Deprecated('Use context.textTheme.displayLarge instead')
  static TextStyle get h1 => GoogleFonts.outfit(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: textPrimary,
    letterSpacing: -0.5,
  );

  @Deprecated('Use context.textTheme.headlineMedium instead')
  static TextStyle get h2 => GoogleFonts.outfit(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );

  @Deprecated('Use context.textTheme.bodyLarge instead')
  static TextStyle get bodyLarge => GoogleFonts.inter(
    fontSize: 15,
    color: textPrimary,
    height: 1.5,
  );

  @Deprecated('Use context.textTheme.labelSmall instead')
  static TextStyle get label => GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: textTertiary,
    letterSpacing: 0.8,
  );

  // ─── SHADOWS (invariants) ───
  static List<BoxShadow> get shadowSm => [
    BoxShadow(
      color: Colors.black.withOpacity(0.02),
      blurRadius: 4,
      offset: const Offset(0, 1),
    ),
  ];

  static List<BoxShadow> get shadowLg => [
    BoxShadow(
      color: Colors.black.withOpacity(0.04),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];

  // ─── HELPERS CONTEXTUELS (mode-aware) ───
  //
  // Utilisation : LuminaDesign.textPrimaryOf(context)
  // C'est un pont entre l'ancienne API et context.colors.

  static Color textPrimaryOf(BuildContext context) => context.colors.textPrimary;
  static Color textSecondaryOf(BuildContext context) => context.colors.textSecondary;
  static Color textTertiaryOf(BuildContext context) => context.colors.textTertiary;
  static Color bgPageOf(BuildContext context) => context.colors.bgPage;
  static Color bgCardOf(BuildContext context) => context.colors.bgCard;
  static Color borderDefaultOf(BuildContext context) => context.colors.borderDefault;

  static TextStyle h1Of(BuildContext context) => GoogleFonts.outfit(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: context.colors.textPrimary,
    letterSpacing: -0.5,
  );

  static TextStyle h2Of(BuildContext context) => GoogleFonts.outfit(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: context.colors.textPrimary,
  );

  static TextStyle bodyLargeOf(BuildContext context) => GoogleFonts.inter(
    fontSize: 15,
    color: context.colors.textPrimary,
    height: 1.5,
  );

  static TextStyle labelOf(BuildContext context) => GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: context.colors.textTertiary,
    letterSpacing: 0.8,
  );
}

/// ═══════════════════════════════════════════════════════════════════════════════
/// Widget de Carte Standardisé Lumina — MODE-AWARE
/// ═══════════════════════════════════════════════════════════════════════════════
class LuminaCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color? color;
  final EdgeInsets? padding;

  const LuminaCard({
    super.key,
    required this.child,
    this.onTap,
    this.color,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final cardColor = color ?? colors.bgCard;
    final borderColor = colors.borderSubtle;

    return Container(
      margin: const EdgeInsets.only(bottom: LuminaDesign.paddingSm),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(LuminaDesign.radiusMd),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: LuminaDesign.shadowSm,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(LuminaDesign.radiusMd),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(LuminaDesign.paddingMd),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// ═══════════════════════════════════════════════════════════════════════════════
/// Bouton Primaire Lumina — MODE-AWARE (le bouton orange reste inchangé
/// car les couleurs brand sont invariantes)
/// ═══════════════════════════════════════════════════════════════════════════════
class LuminaButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;

  const LuminaButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: LuminaDesign.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(LuminaDesign.radiusMd),
          ),
        ),
        child: isLoading
          ? const LoadingDots(color: Colors.white, size: 24)
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 18),
                  const SizedBox(width: 10),
                ],
                Text(
                  label.toUpperCase(),
                  style: LuminaDesign.labelOf(context).copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
      ),
    );
  }
}

/// ═══════════════════════════════════════════════════════════════════════════════
/// Extension pratique pour accéder aux typographies mode-aware
/// ═══════════════════════════════════════════════════════════════════════════════
extension LuminaTypographyX on BuildContext {
  /// Titre H1 mode-aware (noir en light, blanc en dark)
  TextStyle get h1 => LuminaDesign.h1Of(this);

  /// Titre H2 mode-aware
  TextStyle get h2 => LuminaDesign.h2Of(this);

  /// Corps de texte large mode-aware
  TextStyle get bodyLargeText => LuminaDesign.bodyLargeOf(this);

  /// Label mode-aware
  TextStyle get labelText => LuminaDesign.labelOf(this);
}
