import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumina/core/theme/app_text.dart';

class IntercessionStatsChart extends ConsumerWidget {
  final String groupId;
  const IntercessionStatsChart({super.key, required this.groupId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        const Text('Engagement des Intercesseurs',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        const SizedBox(height: 24),
        SizedBox(
          height: 250,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: 50,
              barTouchData: const BarTouchData(enabled: true),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      const titles = [
                        'Lun',
                        'Mar',
                        'Mer',
                        'Jeu',
                        'Ven',
                        'Sam',
                        'Dim'
                      ];
                      return Text(titles[value.toInt() % 7],
                          style: AppText.caption(context));
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
              barGroups: [
                _buildBarGroup(context, 0, 35),
                _buildBarGroup(context, 1, 42),
                _buildBarGroup(context, 2, 28),
                _buildBarGroup(context, 3, 48),
                _buildBarGroup(context, 4, 38),
                _buildBarGroup(context, 5, 45),
                _buildBarGroup(context, 6, 31),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Impact spirituel mesuré par la régularité et la participation aux veillées.',
          textAlign: TextAlign.center,
          style: AppText.caption(context),
        ),
      ],
    );
  }

  BarChartGroupData _buildBarGroup(BuildContext context, int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: const Color(0xFF6366F1),
          width: 16,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 50,
            color: const Color(0xFF6366F1).withValues(alpha: 0.05),
          ),
        ),
      ],
    );
  }
}