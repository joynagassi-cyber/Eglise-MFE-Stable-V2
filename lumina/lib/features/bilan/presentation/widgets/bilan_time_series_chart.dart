/// Time series chart for BILAN dashboard
library;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumina/core/widgets/widgets.dart';
import '../providers/bilan_providers.dart';

class BilanTimeSeriesChart extends ConsumerWidget {
  const BilanTimeSeriesChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(bilanPerGroupProvider);
    final formatter = ref.watch(numberFormatterProvider);
    final theme = Theme.of(context);

    return dataAsync.when(
      loading: () => const SizedBox(
        height: 200,
        child: Center(child: LoadingState()),
      ),
      error: (e, _) =>
          const SizedBox(height: 200, child: Center(child: Text('Impossible de charger l\'évolution'))),
      data: (groups) {
        if (groups.isEmpty) {
          return const SizedBox(
            height: 200,
            child: Center(child: Text('Aucune donnée')),
          );
        }

        // Prepare data for chart
        final incomeSpots = <FlSpot>[];
        final expenseSpots = <FlSpot>[];

        for (var i = 0; i < groups.length; i++) {
          incomeSpots.add(FlSpot(i.toDouble(), groups[i].income));
          expenseSpots.add(FlSpot(i.toDouble(), groups[i].expense));
        }

        final maxY = groups.fold<double>(0.0, (max, g) {
          final highest = g.income > g.expense ? g.income : g.expense;
          return highest > max ? highest : max;
        });

        return GlassCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Évolution par groupe',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 200,
                child: LineChart(
                  LineChartData(
                    lineTouchData: LineTouchData(
                      touchTooltipData: LineTouchTooltipData(
                        getTooltipColor: (_) =>
                            theme.colorScheme.surface.withOpacity(0.9),
                        tooltipPadding: const EdgeInsets.all(8),
                        getTooltipItems: (touchedSpots) {
                          return touchedSpots.map((spot) {
                            final group = groups[spot.x.toInt()];
                            final isIncome = spot.barIndex == 0;
                            return LineTooltipItem(
                              '${group.groupName}\n',
                              theme.textTheme.labelMedium!.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              children: [
                                TextSpan(
                                  text: '${isIncome ? "Entrées" : "Sorties"}: ',
                                  style: theme.textTheme.labelSmall,
                                ),
                                TextSpan(
                                  text: formatter.formatCurrency(spot.y),
                                  style: theme.textTheme.labelSmall!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: isIncome ? Colors.green : Colors.red,
                                  ),
                                ),
                              ],
                            );
                          }).toList();
                        },
                      ),
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: maxY > 0 ? maxY / 4 : 1000,
                      getDrawingHorizontalLine: (value) => FlLine(
                          color: theme.dividerColor.withOpacity(0.1),
                          strokeWidth: 1),
                    ),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 60,
                          getTitlesWidget: (value, meta) => Text(
                            formatter.formatCompact(value),
                            style: theme.textTheme.labelSmall
                                ?.copyWith(fontSize: 9),
                          ),
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          getTitlesWidget: (value, meta) {
                            final idx = value.toInt();
                            if (idx >= 0 && idx < groups.length) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  groups[idx].groupName.length > 4
                                      ? groups[idx]
                                          .groupName
                                          .substring(0, 4)
                                          .toUpperCase()
                                      : groups[idx].groupName.toUpperCase(),
                                  style: theme.textTheme.labelSmall?.copyWith(
                                      fontSize: 8, fontWeight: FontWeight.bold),
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: incomeSpots,
                        isCurved: true,
                        color: Colors.green,
                        barWidth: 4,
                        isStrokeCapRound: true,
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            colors: [
                              Colors.green.withValues(alpha: 0.3),
                              Colors.green.withValues(alpha: 0.0),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        dotData: const FlDotData(show: false),
                      ),
                      LineChartBarData(
                        spots: expenseSpots,
                        isCurved: true,
                        color: Colors.red,
                        barWidth: 4,
                        isStrokeCapRound: true,
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            colors: [
                              Colors.red.withValues(alpha: 0.3),
                              Colors.red.withValues(alpha: 0.0),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        dotData: const FlDotData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _LegendItem(color: Colors.green, label: 'Entrées'),
                  SizedBox(width: 24),
                  _LegendItem(color: Colors.red, label: 'Sorties'),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}