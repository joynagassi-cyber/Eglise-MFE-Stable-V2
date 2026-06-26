import 'package:flutter/material.dart';
import 'package:lumina/core/theme/lumina_design_system.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../extensions/context_extension.dart';

/// Un jalon pour la timeline spirituelle
class TimelineNode {
  final String title;
  final String description;
  final IconData icon;
  final bool isAchieved;
  final String? date;
  final Color color;

  TimelineNode({
    required this.title,
    required this.description,
    required this.icon,
    required this.isAchieved,
    this.date,
    required this.color,
  });
}

/// Widget Premium affichant un parcours vertical de croissance spirituelle.
class SpiritualTimeline extends StatelessWidget {
  final List<TimelineNode> nodes;

  const SpiritualTimeline({super.key, required this.nodes});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: nodes.length,
      itemBuilder: (context, index) {
        final node = nodes[index];
        final isLast = index == nodes.length - 1;

        return IntrinsicHeight(
          child: Row(
            children: [
              // --- COLONNE GAUCHE: LIGNE ET POINT ---
              SizedBox(
                width: 60,
                child: Column(
                  children: [
                    // Point lumineux ou icône
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: node.isAchieved ? node.color : context.colors.textTertiary.withOpacity(0.1),
                        shape: BoxShape.circle,
                        boxShadow: node.isAchieved ? [
                          BoxShadow(
                            color: node.color.withOpacity(0.4),
                            blurRadius: 12,
                            spreadRadius: 2,
                          )
                        ] : null,
                      ),
                      child: Icon(
                        node.isAchieved ? node.icon : Icons.lock_outline,
                        color: node.isAchieved ? Colors.white : context.colors.textTertiary,
                        size: 20,
                      ),
                    ).animate(target: node.isAchieved ? 1 : 0).shimmer(duration: 2.seconds),
                    
                    // Ligne de connection
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 2,
                          color: node.isAchieved ? node.color.withOpacity(0.5) : context.colors.textTertiary.withOpacity(0.1),
                        ),
                      ),
                  ],
                ),
              ),

              // --- COLONNE DROITE: CONTENU ---
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, bottom: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        node.title,
                        style: LuminaDesign.h2Of(context).copyWith(
                          fontSize: 18,
                          color: node.isAchieved ? context.colors.textPrimary : context.colors.textTertiary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        node.description,
                        style: LuminaDesign.bodyLargeOf(context).copyWith(
                          fontSize: 14,
                          color: context.colors.textSecondary,
                        ),
                      ),
                      if (node.isAchieved && node.date != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              "Validé le ${node.date}",
                              style: LuminaDesign.labelOf(context).copyWith(color: Colors.green, fontSize: 10),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
