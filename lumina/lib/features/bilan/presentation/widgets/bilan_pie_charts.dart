/// Pie charts for BILAN dashboard (by group and category)
library;

import 'package:fl_chart/fl_chart.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumina/core/widgets/widgets.dart';
import '../providers/bilan_providers.dart';

class BilanPieCharts extends ConsumerWidget {
  const BilanPieCharts({super.key});

  List<Color> _getChartColors(BuildContext context) {
    final colors = context.colors;
    return [
      colors.chartColor1,
      colors.chartColor2,
      colors.chartColor3,
      colors.chartColor4,
      colors.chartColor5,
      colors.chartColor6,
      colors.chartColor7,
      colors.chartColor8,
    ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(bilanPerGroupProvider);
    final formatter = ref.watch(numberFormatterProvider);
    final theme = Theme.of(context);

    return dataAsync.when(
      loading: () => const SizedBox(
        height: 250,
        child: Center(child: LoadingState()),
      ),
      error: (e, _) =>
          const SizedBox(height: 250, child: Center(child: Text('Impossible de charger les graphiques'))),
      data: (groups) {
        if (groups.isEmpty) {
          return const SizedBox(
            height: 250,
            child: Center(child: Text('Aucune donnée')),
          );
        }

        // Calculate total income for percentage
        final totalIncome = groups.fold<double>(
          0.0,
          (sum, g) => sum + g.income,
        );

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Répartition par groupe',
                  style: theme.textTheme.titleSmall,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    // Pie Chart
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: 180,
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 2,
                            centerSpaceRadius: 40,
                            sections: groups.asMap().entries.map((entry) {
                              final idx = entry.key;
                              final group = entry.value;
                              final pct = totalIncome > 0
                                  ? (group.income / totalIncome * 100)
                                  : 0.0;
                              final chartColors = _getChartColors(context);

                              return PieChartSectionData(
                                value: group.income.toDouble(),
                                title: pct >= 5
                                    ? '${pct.toStringAsFixed(0)}%'
                                    : '',
                                color: chartColors[idx % chartColors.length],
                                radius: 50,
                                titleStyle: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                    // Legend
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: groups.asMap().entries.map((entry) {
                          final idx = entry.key;
                          final group = entry.value;
                          final chartColors = _getChartColors(context);
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: chartColors[idx % chartColors.length],
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    group.groupName,
                                    style: theme.textTheme.labelSmall,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  formatter.formatCompact(group.income),
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
