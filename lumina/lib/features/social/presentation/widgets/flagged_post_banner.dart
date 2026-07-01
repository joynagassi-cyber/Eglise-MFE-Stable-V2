// lib/features/social/presentation/widgets/flagged_post_banner.dart
// Bannière affichée sur les posts signalés par la modération IA

import 'package:flutter/material.dart';
import 'package:lumina/core/theme/lumina_design_system.dart';

class FlaggedPostBanner extends StatelessWidget {
  final String reason;
  final int severity;

  const FlaggedPostBanner({
    super.key,
    required this.reason,
    this.severity = 0,
  });

  @override
  Widget build(BuildContext context) {
    final isSevere = severity >= 70;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isSevere
            ? Colors.red.shade50
            : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(LuminaDesign.radiusSm),
        border: Border.all(
          color: isSevere
              ? Colors.red.shade200
              : Colors.orange.shade200,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isSevere ? Icons.warning_rounded : Icons.info_outline_rounded,
            size: 18,
            color: isSevere ? Colors.red.shade700 : Colors.orange.shade700,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isSevere ? '🚨 Publication signalée' : '⚠️ Attention requise',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isSevere ? Colors.red.shade800 : Colors.orange.shade800,
                  ),
                ),
                if (reason.isNotEmpty)
                  Text(
                    reason,
                    style: TextStyle(
                      fontSize: 11,
                      color: isSevere ? Colors.red.shade700 : Colors.orange.shade700,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          if (severity > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSevere ? Colors.red.shade100 : Colors.orange.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$severity%',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: isSevere ? Colors.red.shade800 : Colors.orange.shade800,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
