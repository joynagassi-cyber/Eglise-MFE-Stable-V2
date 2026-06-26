// lib/features/reports/data/services/chart_generator_service.dart

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/utils/chart_to_image_converter.dart';

class ChartGeneratorService {
  Future<Uint8List> generatePieChart({
    required Map<String, double> data,
    Size size = const Size(800, 600),
  }) async {
    final widget = _PieChartWidget(data: data);
    return await ChartToImageConverter.convertWidgetToImage(widget, size: size);
  }

  Future<Uint8List> generateLineChart({
    required List<FlSpot> spots,
    Size size = const Size(800, 600),
  }) async {
    final widget = _LineChartWidget(spots: spots);
    return await ChartToImageConverter.convertWidgetToImage(widget, size: size);
  }

  Future<Uint8List> generateBarChart({
    required Map<String, double> data,
    Size size = const Size(800, 600),
  }) async {
    final widget = _BarChartWidget(data: data);
    return await ChartToImageConverter.convertWidgetToImage(widget, size: size);
  }
}

class _PieChartWidget extends StatelessWidget {
  final Map<String, double> data;

  const _PieChartWidget({required this.data});

  @override
  Widget build(BuildContext context) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.red,
      Colors.purple,
      Colors.teal,
    ];
    final total = data.values.fold(0.0, (sum, val) => sum + val);

    final sections = data.entries.toList().asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      final percent = (item.value / total * 100).toStringAsFixed(1);

      return PieChartSectionData(
        value: item.value,
        title: '$percent%',
        color: colors[index % colors.length],
        radius: 100,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(24),
      child: PieChart(
        PieChartData(
          sections: sections,
          sectionsSpace: 2,
          centerSpaceRadius: 40,
        ),
      ),
    );
  }
}

class _LineChartWidget extends StatelessWidget {
  final List<FlSpot> spots;

  const _LineChartWidget({required this.spots});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: Colors.blue,
              barWidth: 3,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: Colors.blue.withValues(alpha: 0.2),
              ),
            ),
          ],
          titlesData: const FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 30),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 40),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: const FlGridData(show: true),
          borderData: FlBorderData(show: true),
        ),
      ),
    );
  }
}

class _BarChartWidget extends StatelessWidget {
  final Map<String, double> data;

  const _BarChartWidget({required this.data});

  @override
  Widget build(BuildContext context) {
    final barGroups = data.entries.toList().asMap().entries.map((entry) {
      return BarChartGroupData(
        x: entry.key,
        barRods: [
          BarChartRodData(
            toY: entry.value.value,
            color: Colors.blue,
            width: 20,
          ),
        ],
      );
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(24),
      child: BarChart(
        BarChartData(
          barGroups: barGroups,
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= 0 && value.toInt() < data.length) {
                    return Text(
                      data.keys.elementAt(value.toInt()),
                      style: const TextStyle(fontSize: 10),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 40),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          gridData: const FlGridData(show: true),
          borderData: FlBorderData(show: true),
        ),
      ),
    );
  }
}