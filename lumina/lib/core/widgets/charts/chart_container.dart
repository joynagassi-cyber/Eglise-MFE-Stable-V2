import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:lumina/core/theme/app_spacing.dart';
class ChartContainer extends StatelessWidget {
  final String title;
  final Widget chart;
  final Widget? legend;
  final VoidCallback? onRefresh;

  const ChartContainer({
    super.key,
    required this.title,
    required this.chart,
    this.legend,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusCard,
        ),
        child: Padding(
          padding: AppSpacing.cardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  if (onRefresh != null)
                    IconButton(
                      icon: Icon(Icons.refresh, size: AppSpacing.iconMd),
                      onPressed: onRefresh,
                      color: context.colors.textSecondary,
                    ),
                ],
              ),
              SizedBox(height: AppSpacing.lg),
              chart,
              if (legend != null) ...[
                SizedBox(height: AppSpacing.md),
                legend!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
