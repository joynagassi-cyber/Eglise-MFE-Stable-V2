import 'package:fl_chart/fl_chart.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/mutual_aid_request.dart';
import 'package:lumina/core/theme/app_typography.dart';
import 'package:lumina/core/theme/app_spacing.dart';
class MutualAidChart extends StatelessWidget {
  final List<MutualAidRequest> requests;

  const MutualAidChart({super.key, required this.requests});

  @override
  Widget build(BuildContext context) {
    if (requests.isEmpty) return const SizedBox();

    final data = _getChartData();

    return Container(
      height: 200,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: PieChart(
              PieChartData(
                sectionsSpace: 4,
                centerSpaceRadius: 40,
                sections: data.entries.map((e) {
                  return PieChartSectionData(
                    color: _getTypeColor(context, e.key),
                    value: e.value.toDouble(),
                    title: '${e.value}',
                    radius: 50,
                    titleStyle: AppTypography.tiny.copyWith(
                      color: context.colors.textInverse,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: data.keys.map((type) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: _getTypeColor(context, type),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        type,
                        style: AppTypography.tiny
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Map<String, int> _getChartData() {
    final Map<String, int> counts = {};
    for (final r in requests) {
      counts[r.type] = (counts[r.type] ?? 0) + 1;
    }
    return counts;
  }

  Color _getTypeColor(BuildContext context, String type) {
    switch (type) {
      case 'financial':
        return context.colors.successText;
      case 'material':
        return context.colors.warningText;
      case 'emotional':
        return context.colors.brandPrimary;
      case 'practical':
        return context.colors.infoText;
      default:
        return context.colors.textSecondary;
    }
  }
}
