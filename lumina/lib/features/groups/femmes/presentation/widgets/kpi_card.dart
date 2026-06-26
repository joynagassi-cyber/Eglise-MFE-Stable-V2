import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:lumina/core/theme/app_typography.dart';
import 'package:lumina/core/theme/app_spacing.dart';
class KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  const KpiCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colors.bgCard.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(
            value,
            style: AppTypography.h3.copyWith(
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
          Text(
            title,
            style: AppTypography.tiny.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            subtitle,
            style: AppTypography.tiny.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
