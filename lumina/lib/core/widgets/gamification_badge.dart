// lib/core/widgets/gamification_badge.dart

import 'package:flutter/material.dart';
import '../constants/app_assets.dart';
import 'package:lumina/core/theme/app_spacing.dart';
enum BadgeType { gold, silver, bronze }

class GamificationBadge extends StatelessWidget {
  final BadgeType type;
  final double size;
  final String? label;

  const GamificationBadge({
    super.key,
    required this.type,
    this.size = 60,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    String assetPath;
    switch (type) {
      case BadgeType.gold:
        assetPath = AppAssets.badgeGold;
        break;
      case BadgeType.silver:
        assetPath = AppAssets.badgeSilver;
        break;
      case BadgeType.bronze:
        assetPath = AppAssets.badgeBronze;
        break;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          assetPath,
          height: size,
          width: size,
          fit: BoxFit.contain,
        ),
        if (label != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            label!,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ],
    );
  }
}
