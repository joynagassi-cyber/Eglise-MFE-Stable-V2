import "package:lumina/core/widgets/widgets.dart";
import 'package:fl_chart/fl_chart.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/services/bilan_service.dart';
import '../../../finance/domain/services/currency_service.dart';
import '../../../../core/widgets/loading_state.dart';

class BilanBreakdownChart extends ConsumerWidget {
  final String dimension;

  const BilanBreakdownChart({required this.dimension, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final breakdownAsync = ref.watch(bilanBreakdownProvider(dimension));

    return breakdownAsync.when(
      data: (items) {
        if (items.isEmpty) {
          return Center(child: Text("Aucune donnée"));
        }

        // Simple Pie Chart for Category/Group
        if (dimension == 'category' || dimension == 'group') {
          return PieChart(
            PieChartData(
              sectionsSpace: 4,
              centerSpaceRadius: 40,
              sections: items.map((item) {
                final isDark = Theme.of(context).brightness == Brightness.dark;
                return PieChartSectionData(
                  value: item.totalExpense.abs() + item.totalIncome,
                  title: item.key,
                  color: Colors
                      .primaries[items.indexOf(item) % Colors.primaries.length],
                  radius: 60,
                  titleStyle: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                );
              }).toList(),
            ),
          );
        }

        // Bar Chart for Month (Item #01)
        return BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: items.fold<double>(
                    0.0,
                    (max, item) =>
                        item.totalIncome > max ? item.totalIncome : max) *
                1.2,
            barTouchData: BarTouchData(
              enabled: true,
              touchTooltipData: BarTouchTooltipData(
                getTooltipColor: (_) => context.colors.brandPrimary.withOpacity(0.8),
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  return BarTooltipItem(
                    '${items[groupIndex].key}\n',
                    const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text: CurrencyService.format(rod.toY, 'XAF'),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ],
                  );
                },
              ),
            ),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index >= 0 && index < items.length) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          items[index].key.substring(0, 3).toUpperCase(),
                          style: const TextStyle(
                              fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
              leftTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            gridData: const FlGridData(show: false),
            borderData: FlBorderData(show: false),
            barGroups: items.asMap().entries.map((entry) {
              return BarChartGroupData(
                x: entry.key,
                barRods: [
                  BarChartRodData(
                    toY: entry.value.totalIncome,
                    color: context.colors.brandPrimary,
                    width: 16,
                    borderRadius: BorderRadius.circular(4),
                    backDrawRodData: BackgroundBarChartRodData(
                      show: true,
                      toY: entry.value.totalIncome * 1.2,
                      color: context.colors.brandPrimary.withOpacity(0.1),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        );
      },
      loading: () => Center(child: LoadingState()),
      error: (err, _) => Center(child: Text('Impossible de charger le graphique')),
    );
  }
}
