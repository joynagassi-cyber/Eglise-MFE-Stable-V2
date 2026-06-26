// lib/features/membres/presentation/screens/member_stats_screen.dart
// Écran de statistiques démographiques des membres

import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:lumina/core/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import '../../../../core/utils/haptic_helper.dart';
import '../providers/member_statistics_provider.dart';
import '../../domain/entities/enums/enums.dart';

class MemberStatsScreen extends ConsumerWidget {
  const MemberStatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(memberStatisticsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Semantics(
          label: 'Statistiques Membres',
          header: true,
          child: Text(
            'Statistiques Membres',
            style: theme.textTheme.titleLarge,
          ),
        ),
        centerTitle: true,
        leading: Semantics(
          label: 'Retour',
          button: true,
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              await HapticHelper.light();
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
          ),
        ),
      ),
      body: statsAsync.when(
        data: (stats) => ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            AnimatedEntrance.fromBottom(
              delay: const Duration(milliseconds: 100),
              child: _buildKpiSection(context, stats),
            ),
            const SizedBox(height: AppSpacing.xl),
            AnimatedEntrance.fromBottom(
              delay: const Duration(milliseconds: 200),
              child: _buildGenderChart(context, stats),
            ),
            const SizedBox(height: AppSpacing.md),
            AnimatedEntrance.fromBottom(
              delay: const Duration(milliseconds: 300),
              child: _buildStatusChart(context, stats),
            ),
            const SizedBox(height: AppSpacing.md),
            AnimatedEntrance.fromBottom(
              delay: const Duration(milliseconds: 400),
              child: _buildAgeChart(context, stats),
            ),
            const SizedBox(height: AppSpacing.md),
            AnimatedEntrance.fromBottom(
              delay: const Duration(milliseconds: 500),
              child: _buildGrowthChart(context, stats),
            ),
          ],
        ),
        loading: () => ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: const [
            ShimmerBox(height: 120, borderRadius: 16),
            SizedBox(height: AppSpacing.md),
            ShimmerBox(height: 200, borderRadius: 16),
            SizedBox(height: AppSpacing.md),
            ShimmerBox(height: 200, borderRadius: 16),
          ],
        ),
        error: (err, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline,
                  size: AppSpacing.iconHero,
                  color: context.colors.errorText,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Erreur lors du chargement',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  '$err',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Section KPI Cards
  Widget _buildKpiSection(BuildContext context, MemberStatistics stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Vue d\'ensemble',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _KpiCard(
                title: 'Total',
                value: '${stats.total}',
                icon: Icons.people,
                color: context.colors.brandPrimary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _KpiCard(
                title: 'Actifs',
                value: '${stats.activeCount}',
                icon: Icons.check_circle,
                color: context.colors.successText,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _KpiCard(
                title: 'Baptisés',
                value: '${stats.baptizedCount}',
                icon: Icons.water_drop,
                color: context.colors.infoText,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _KpiCard(
                title: 'Leaders',
                value: '${stats.leaderCount}',
                icon: Icons.star,
                color: context.colors.warningText,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _KpiCard(
          title: 'Âge Moyen',
          value: '${stats.averageAge.toStringAsFixed(1)} ans',
          icon: Icons.calendar_today,
          color: context.colors.textSecondary,
        ),
      ],
    );
  }

  /// Graphique Genre
  Widget _buildGenderChart(BuildContext context, MemberStatistics stats) {
    if (stats.total == 0) return const SizedBox.shrink();

    final sections = <PieChartSectionData>[];

    stats.byGender.forEach((gender, count) {
      if (count > 0) {
        sections.add(
          PieChartSectionData(
            value: count.toDouble(),
            title: '${(count / stats.total * 100).toStringAsFixed(0)}%',
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            color: _getGenderColor(context, gender),
            radius: 80,
          ),
        );
      }
    });

    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Répartition par Genre',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: PieChart(
                    PieChartData(
                      sections: sections,
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: stats.byGender.entries
                        .where((e) => e.value > 0)
                        .map(
                          (e) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    color: _getGenderColor(context, e.key),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    '${e.key.label}: ${e.value}',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Graphique Statut
  Widget _buildStatusChart(BuildContext context, MemberStatistics stats) {
    if (stats.total == 0) return const SizedBox.shrink();

    final barGroups = <BarChartGroupData>[];
    var index = 0;

    stats.byStatus.forEach((status, count) {
      if (count > 0) {
        barGroups.add(
          BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: count.toDouble(),
                color: Color(status.colorValue),
                width: 24,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(4),
                ),
              ),
            ],
          ),
        );
      }
      index++;
    });

    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Membres par Statut',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                barGroups: barGroups,
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) => Text(
                        value.toInt().toString(),
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final statuses = stats.byStatus.entries
                            .where((e) => e.value > 0)
                            .toList();
                        if (value.toInt() >= statuses.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            statuses[value.toInt()].key.label,
                            style: const TextStyle(fontSize: 10),
                          ),
                        );
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
                borderData: FlBorderData(show: false),
                gridData: const FlGridData(show: false),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Graphique Âge
  Widget _buildAgeChart(BuildContext context, MemberStatistics stats) {
    final barGroups = <BarChartGroupData>[];
    var index = 0;

    stats.byAgeRange.forEach((range, count) {
      barGroups.add(
        BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: count.toDouble(),
              color: context.colors.textSecondary,
              width: 20,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(4),
              ),
            ),
          ],
        ),
      );
      index++;
    });

    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Répartition par Âge',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                barGroups: barGroups,
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) => Text(
                        value.toInt().toString(),
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final ranges = stats.byAgeRange.keys.toList();
                        if (value.toInt() >= ranges.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            ranges[value.toInt()],
                            style: const TextStyle(fontSize: 9),
                          ),
                        );
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
                borderData: FlBorderData(show: false),
                gridData: const FlGridData(show: false),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Graphique Croissance
  Widget _buildGrowthChart(BuildContext context, MemberStatistics stats) {
    final spots = <FlSpot>[];
    var index = 0;

    stats.growthByMonth.forEach((month, count) {
      spots.add(FlSpot(index.toDouble(), count.toDouble()));
      index++;
    });

    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Croissance (12 derniers mois)',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    curveSmoothness: 0.35,
                    color: context.colors.brandPrimary,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) =>
                          FlDotCirclePainter(
                        radius: 4,
                        color: context.colors.brandPrimary,
                        strokeWidth: 2,
                        strokeColor: Colors.white,
                      ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          context.colors.brandPrimary.withValues(alpha: 0.3),
                          context.colors.brandPrimary.withValues(alpha: 0.05),
                        ],
                      ),
                    ),
                  ),
                ],
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) => Text(
                        value.toInt().toString(),
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 2,
                      getTitlesWidget: (value, meta) {
                        final months = stats.growthByMonth.keys.toList();
                        if (value.toInt() >= months.length) {
                          return const SizedBox.shrink();
                        }
                        final monthStr = months[value.toInt()];
                        // Afficher MM/YY
                        final parts = monthStr.split('-');
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            '${parts[1]}/${parts[0].substring(2)}',
                            style: const TextStyle(fontSize: 9),
                          ),
                        );
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
                borderData: FlBorderData(show: false),
                gridData: const FlGridData(
                  show: true,
                  drawVerticalLine: false,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getGenderColor(BuildContext context, Gender gender) {
    switch (gender) {
      case Gender.male:
        return context.colors.infoText;
      case Gender.female:
        return context.colors.errorText;
      case Gender.other:
        return context.colors.textSecondary;
    }
  }
}

/// Widget KPI Card
class _KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _KpiCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      label: '$title: $value',
      child: GlassCard(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: AppSpacing.borderRadiusMd,
              ),
              child: Icon(icon, color: color, size: AppSpacing.iconMd),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  Text(
                    title,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: context.colors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
