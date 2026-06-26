import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:lumina/core/theme/app_spacing.dart';
class FinanceStatCard extends StatelessWidget {
  final String title;
  final String value;
  final String change;
  final String trend;

  const FinanceStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.change,
    required this.trend,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: context.colors.bgCard,
        borderRadius: AppSpacing.borderRadiusMd,
        border: Border.all(
          color: context.colors.borderSubtle,
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.xs),
                decoration: BoxDecoration(
                  color: _getColor(context, isDark).withValues(alpha: 0.1),
                  borderRadius: AppSpacing.borderRadiusSm,
                ),
                child: Icon(
                  _getIcon(),
                  size: AppSpacing.iconXs,
                  color: _getColor(context, isDark),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xs,
                  vertical: AppSpacing.xxs,
                ),
                decoration: BoxDecoration(
                  color: _getColor(context, isDark).withValues(alpha: 0.1),
                  borderRadius: AppSpacing.borderRadiusSm,
                ),
                child: Text(
                  change,
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: _getColor(context, isDark),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.colors.textPrimary,
            ),
          ),
          SizedBox(height: AppSpacing.xxs),
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Color _getColor(BuildContext context, bool isDark) {
    switch (trend) {
      case 'positive':
        return context.colors.successText;
      case 'negative':
        return context.colors.errorText;
      case 'warning':
        return context.colors.warningText;
      case 'info':
        return context.colors.infoText;
      default:
        return context.colors.textSecondary;
    }
  }

  IconData _getIcon() {
    switch (trend) {
      case 'positive':
        return Icons.trending_up;
      case 'negative':
        return Icons.trending_down;
      case 'warning':
        return Icons.warning;
      case 'info':
        return Icons.info;
      default:
        return Icons.trending_flat;
    }
  }
}
