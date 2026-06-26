import 'package:intl/intl.dart';
import 'package:lumina/core/extensions/context_extension.dart';
// import 'package:lumina/core/theme/lumina_colors_extension.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import 'package:lumina/core/theme/app_typography.dart';

class MonthlyDonationsChart extends StatelessWidget {
  const MonthlyDonationsChart({super.key});

  @override
  Widget build(BuildContext context) {
//     final theme = Theme.of(context);
    final brandColor = context.colors.brandPrimary;
    final secondaryColor = context.colors.brandSecondary;

    return Container(
      height: 240,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colors.bgCard,
        borderRadius: BorderRadius.circular(AppSpacing.radius2xl),
        boxShadow: AppSpacing.shadowSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Évolution des Dons',
                style: AppTypography.titleSmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.colors.textPrimary,
                ),
              ),
              Icon(
                Icons.trending_up_rounded,
                color: context.colors.successText,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 100000,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => context.colors.bgPage.withValues(alpha: 0.9),
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        NumberFormat.compactCurrency(locale: 'fr_FR', symbol: 'F').format(rod.toY),
                        AppTypography.labelSmall.copyWith(
                          color: context.colors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
                barGroups: [
                  _makeGroup(context, 0, 45000, brandColor, secondaryColor),
                  _makeGroup(context, 1, 72000, brandColor, secondaryColor),
                  _makeGroup(context, 2, 31000, brandColor, secondaryColor),
                  _makeGroup(context, 3, 89000, brandColor, secondaryColor),
                  _makeGroup(context, 4, 54000, brandColor, secondaryColor),
                  _makeGroup(context, 5, 67000, brandColor, secondaryColor),
                ],
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 32,
                      getTitlesWidget: (value, _) {
                        const months = ['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Juin'];
                        if (value.toInt() >= months.length) return const SizedBox.shrink();
                        return Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(
                            months[value.toInt()],
                            style: AppTypography.labelSmall.copyWith(
                              fontSize: 10,
                              color: context.colors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData _makeGroup(
    BuildContext context,
    int x,
    double y,
    Color brandColor,
    Color secondaryColor,
  ) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          gradient: LinearGradient(
            colors: [
              brandColor,
              secondaryColor,
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
          width: 14,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 100000,
            color: context.colors.borderSubtle.withValues(alpha: 0.1),
          ),
        ),
      ],
    );
  }
}