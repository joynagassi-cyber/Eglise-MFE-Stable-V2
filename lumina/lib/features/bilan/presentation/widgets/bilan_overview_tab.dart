import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import 'package:lumina/core/widgets/widgets.dart';
import '../providers/bilan_providers.dart';
import 'kpi_row.dart';
import 'bilan_breakdown_chart.dart';
import 'bilan_time_series_chart.dart';
import 'bilan_heatmap.dart';

class BilanOverviewTab extends ConsumerWidget {
  const BilanOverviewTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(consolidatedBilanProvider);

    return summaryAsync.when(
      loading: () => const FireSkeletonBudgetDashboard(),
      error: (e, st) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: context.colors.errorText),
            SizedBox(height: 16),
            Text('Impossible de charger la vue d\'ensemble'),
            ElevatedButton(
              onPressed: () => ref.invalidate(consolidatedBilanProvider),
              child: Text('Réessayer'),
            ),
          ],
        ),
      ),
      data: (summary) => SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // KPI Grid using the actual BilanKpiRow which has delta logic built-in
            AnimatedEntrance.fromTop(
              child: BilanKpiRow(),
            ),
            SizedBox(height: AppSpacing.lg),

            // Main Charts
            AnimatedEntrance.fade(
              delay: Duration(milliseconds: 200),
              child: Column(
                children: [
                   SizedBox(
                    height: 300,
                    child: BilanTimeSeriesChart(),
                  ),
                  SizedBox(height: AppSpacing.lg),
                  SizedBox(
                    height: 300,
                    child: BilanBreakdownChart(
                      dimension: 'category',
                    ),
                  ),
                  SizedBox(height: AppSpacing.lg),
                  SizedBox(
                    height: 300,
                    child: BilanHeatmap(),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}
