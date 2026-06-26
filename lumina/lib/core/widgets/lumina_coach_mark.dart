import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:lumina/core/theme/lumina_design_system.dart';
import '../extensions/context_extension.dart';

/// Utilitaire pour créer des "Coach Marks" (bulles d'aide contextuelles)
/// conformes au Design System Lumina 2.2 (mode-aware).
class LuminaCoachMark {
  /// Crée un style de bulle standard pour Lumina
  static Widget buildContent({
    required BuildContext context,
    required String title,
    required String description,
    required int step,
    required int total,
  }) {
    return Container(
      padding: const EdgeInsets.all(LuminaDesign.paddingLg),
      decoration: BoxDecoration(
        color: context.colors.bgCard,
        borderRadius: BorderRadius.circular(LuminaDesign.radiusMd),
        boxShadow: LuminaDesign.shadowLg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title.toUpperCase(),
                style: LuminaDesign.labelOf(context).copyWith(color: LuminaDesign.primary),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: LuminaDesign.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(LuminaDesign.radiusSm),
                ),
                child: Text(
                  "$step/$total",
                  style: LuminaDesign.labelOf(context).copyWith(color: LuminaDesign.primary, fontSize: 10),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            description,
            style: LuminaDesign.bodyLargeOf(context).copyWith(fontSize: 15, height: 1.4),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "Appuyez pour continuer",
                style: LuminaDesign.labelOf(context).copyWith(color: context.colors.textTertiary, fontSize: 10),
              ),
              SizedBox(width: 4),
              Icon(Icons.touch_app, size: 14, color: context.colors.textTertiary),
            ],
          ),
        ],
      ),
    );
  }

  /// Helper pour générer un TargetFocus standard
  static TargetFocus target({
    required GlobalKey key,
    required String identify,
    required String title,
    required String description,
    required int step,
    required int total,
    ContentAlign align = ContentAlign.bottom,
    ShapeLightFocus shape = ShapeLightFocus.RRect,
  }) {
    return TargetFocus(
      identify: identify,
      keyTarget: key,
      shape: shape,
      radius: LuminaDesign.radiusMd,
      paddingFocus: 8,
      contents: [
        TargetContent(
          align: align,
          builder: (context, controller) => buildContent(
            context: context,
            title: title,
            description: description,
            step: step,
            total: total,
          ),
        ),
      ],
    );
  }

  /// Affiche le tutoriel
  static void show(
    BuildContext context, {
    required List<TargetFocus> targets,
    VoidCallback? onFinish,
    VoidCallback? onSkip,
  }) {
    TutorialCoachMark(
      targets: targets,
      colorShadow: LuminaDesign.primary,
      opacityShadow: 0.8,
      textSkip: "PASSER",
      paddingFocus: 10,
      onFinish: onFinish,
      onSkip: () {
        onSkip?.call();
        return true;
      },
    ).show(context: context);
  }
}
