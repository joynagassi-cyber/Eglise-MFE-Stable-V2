import 'package:flutter/material.dart';
import 'package:lumina/core/theme/lumina_design_system.dart';
import '../extensions/context_extension.dart';

/// Barre de progression Premium avec effet de "Glow" (éclat).
/// Utilisée pour symboliser la maturité spirituelle ou l'avancement des tâches.
class LuminaProgress extends StatelessWidget {
  final double progress; // Entre 0.0 et 1.0
  final Color? color;
  final String? label;

  const LuminaProgress({
    super.key,
    required this.progress,
    this.color,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final baseColor = color ?? LuminaDesign.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label!.toUpperCase(), style: LuminaDesign.labelOf(context)),
              Text("${(progress * 100).toInt()}%", 
                style: LuminaDesign.labelOf(context).copyWith(color: baseColor, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
        ],
        Container(
          height: 12,
          width: double.infinity,
          decoration: BoxDecoration(
            color: context.colors.textTertiary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(LuminaDesign.radiusFull),
          ),
          child: Stack(
            children: [
              // La barre de progression avec ombre interne "Glow"
              AnimatedContainer(
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOutCubic,
                width: MediaQuery.of(context).size.width * progress,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      baseColor.withOpacity(0.8),
                      baseColor,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(LuminaDesign.radiusFull),
                  boxShadow: [
                    BoxShadow(
                      color: baseColor.withOpacity(0.3),
                      blurRadius: 4.0,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
