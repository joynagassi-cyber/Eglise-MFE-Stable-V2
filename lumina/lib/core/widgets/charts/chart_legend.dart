import 'package:flutter/material.dart';
import 'package:lumina/core/theme/app_spacing.dart';
class ChartLegend extends StatelessWidget {
  final List<LegendItem> items;

  const ChartLegend({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.sm,
      children: items.map((item) => _LegendItemWidget(item: item)).toList(),
    );
  }
}

class _LegendItemWidget extends StatelessWidget {
  final LegendItem item;

  const _LegendItemWidget({required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: item.color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          item.label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class LegendItem {
  final String label;
  final Color color;

  const LegendItem({
    required this.label,
    required this.color,
  });
}