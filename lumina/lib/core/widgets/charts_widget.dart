// lib/core/widgets/charts_widget.dart
// Widgets de charts premium et interactifs pour Lumina
// Utilise AppChartTheme pour cohérence

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../theme/app_chart_theme.dart';

const Duration _chartAnimationDuration = Duration(milliseconds: 300);

/// Widget LineChart premium avec standards unifiés
class AppLineChart extends StatelessWidget {
  final List<FlSpot> spots;
  final List<String> xLabels;
  final String Function(double)? yLabelFormatter;
  final String Function(double)? tooltipFormatter;
  final Gradient? lineGradient;
  final Color? lineColor;
  final bool isCurved;
  final bool showDots;
  final bool showArea;
  final Duration animationDuration;

  const AppLineChart({
    super.key,
    required this.spots,
    required this.xLabels,
    this.yLabelFormatter,
    this.tooltipFormatter,
    this.lineGradient,
    this.lineColor,
    this.isCurved = true,
    this.showDots = true,
    this.showArea = true,
    this.animationDuration = _chartAnimationDuration,
  });

  @override
  Widget build(BuildContext context) {

//     final isDark = theme.brightness == Brightness.dark;
    final color = lineColor ?? AppChartTheme.chartColors[0];
    final labelStyle = AppChartTheme.axisLabelStyle(context);

    return RepaintBoundary(
      child: LineChart(
        LineChartData(
          lineTouchData: AppChartTheme.defaultLineTouchData(
            context: context,
            valueFormatter: tooltipFormatter,
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 44,
                getTitlesWidget: (value, meta) {
                  final formatted = yLabelFormatter != null
                      ? yLabelFormatter!(value)
                      : value.toInt().toString();
                  return Text(
                    formatted,
                    style: labelStyle,
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 32,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < xLabels.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        xLabels[index],
                        style: labelStyle.copyWith(fontSize: 11),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: AppChartTheme.defaultBorderData(context),
          gridData: AppChartTheme.defaultGridData(context),
          lineBarsData: [
            AppChartTheme.createLineChartBar(
              context: context,
              spots: spots,
              color: color,
              isCurved: isCurved,
              showDots: showDots,
              showBelowBar: showArea,
            ),
          ],
          minX: 0,
          maxX: (spots.length - 1).toDouble(),
          minY: 0,
        ),
      ),
    );
  }
}

/// Widget BarChart premium avec standards unifiés
class AppBarChart extends StatelessWidget {
  final List<double> values;
  final List<String> xLabels;
  final String Function(double)? tooltipFormatter;
  final List<LinearGradient>? barGradients;
  final Duration animationDuration;

  const AppBarChart({
    super.key,
    required this.values,
    required this.xLabels,
    this.tooltipFormatter,
    this.barGradients,
    this.animationDuration = _chartAnimationDuration,
  });

  @override
  Widget build(BuildContext context) {

//     final isDark = theme.brightness == Brightness.dark;
    final labelStyle = AppChartTheme.axisLabelStyle(context);

    return RepaintBoundary(
      child: BarChart(
        BarChartData(
          barTouchData: AppChartTheme.defaultBarTouchData(
            context: context,
            valueFormatter: tooltipFormatter,
          ),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 32,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < xLabels.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        xLabels[index],
                        style: labelStyle.copyWith(fontSize: 11),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: AppChartTheme.defaultBorderData(context),
          gridData: const FlGridData(show: false),
          barGroups: List.generate(
            values.length,
            (index) {
              final Color baseColor = AppChartTheme.getChartColor(index);

              return BarChartGroupData(
                x: index,
                barRods: [
                  AppChartTheme.createBarChartRod(
                    value: values[index],
                    color: baseColor,
                    showGradient: true,
                  ),
                ],
              );
            },
          ),
          maxY: values.isEmpty
              ? 100
              : values.reduce((a, b) => a > b ? a : b) * 1.2,
          groupsSpace: 16,
        ),
        swapAnimationDuration: animationDuration,
      ),
    );
  }
}

/// Widget PieChart premium avec standards unifiés
class AppPieChart extends StatefulWidget {
  final List<PieChartSectionData> sections;
  final Duration animationDuration;
  final double centerSpaceRadius;
  final Widget? centerWidget;

  const AppPieChart({
    super.key,
    required this.sections,
    this.animationDuration = _chartAnimationDuration,
    this.centerSpaceRadius = 60,
    this.centerWidget,
  });

  @override
  State<AppPieChart> createState() => _AppPieChartState();
}

class _AppPieChartState extends State<AppPieChart> {
  int _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: PieChart(
        PieChartData(
          sections: widget.sections.asMap().entries.map((entry) {
            final index = entry.key;
            final section = entry.value;
            final isSelected = index == _selectedIndex;

            return PieChartSectionData(
              value: section.value,
              color: section.color,
              title: section.title,
              radius: isSelected ? section.radius + 10 : section.radius,
              titleStyle: section.titleStyle,
              gradient: LinearGradient(
                colors: [
                  section.color,
                  section.color.withValues(alpha: 0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            );
          }).toList(),
          centerSpaceRadius: widget.centerSpaceRadius,
          sectionsSpace: 2,
          pieTouchData: PieTouchData(
            touchCallback: (event, response) {
              setState(() {
                if (response != null &&
                    response.touchedSection != null &&
                    event is FlTapUpEvent) {
                  final index = response.touchedSection!.touchedSectionIndex;
                  _selectedIndex = _selectedIndex == index ? -1 : index;
                }
              });
            },
          ),
        ),
        swapAnimationDuration: widget.animationDuration,
      ),
    );
  }
}
