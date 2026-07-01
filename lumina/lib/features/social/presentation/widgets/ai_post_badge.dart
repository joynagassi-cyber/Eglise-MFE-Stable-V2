// lib/features/social/presentation/widgets/ai_post_badge.dart
// Badge "Verset du Jour" pour les posts générés automatiquement par l'IA

import 'package:flutter/material.dart';
import 'package:lumina/core/theme/lumina_design_system.dart';

class AiPostBadge extends StatelessWidget {
  final String? bibleVerse;
  final String? bibleText;

  const AiPostBadge({
    super.key,
    this.bibleVerse,
    this.bibleText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [LuminaDesign.primary, LuminaDesign.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: LuminaDesign.primary.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.auto_awesome, size: 12, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            bibleVerse != null ? '✝️ $bibleVerse' : '✨ Verset du Jour',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
