import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import 'package:lumina/core/widgets/widgets.dart';
import '../providers/dashboard_kpi_provider.dart';
import '../../../finance/presentation/widgets/v2/mini_bezier_chart.dart';

class FinanceOverviewChart extends ConsumerWidget {
  const FinanceOverviewChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final financeChartAsync = ref.watch(superadminFinanceChartProvider);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.colors.bgCard,
        borderRadius: BorderRadius.circular(LuminaRadius.xl2),
        border: Border.all(
          color: context.colors.borderSubtle.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.black.withOpacity(0.4)
                : Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Évolution des Recettes',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontFamily: LuminaFont.display,
                    ),
              ),
              Icon(
                Icons.trending_up_rounded,
                color: context.colors.successText,
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          financeChartAsync.when(
            data: (chartData) {
              if (chartData.isEmpty || chartData.every((e) => e == 0)) {
                return SizedBox(
                  height: 120,
                  child: Center(
                    child: Text('Aucune donnée financière'),
                  ),
                );
              }

              final currentMonthTotal = chartData.last;

              final formatter = NumberFormat.currency(
                  locale: 'fr_FR', symbol: 'FCFA', decimalDigits: 0);

              return Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ce mois-ci',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          formatter.format(currentMonthTotal),
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: context.colors.successText,
                                    fontFamily: LuminaFont.display,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: SizedBox(
                      height: 80,
                      child: MiniBezierChart(
                        data: chartData.every((e) => e == 0)
                            ? [1, 1, 1, 1, 1, 1]
                            : chartData,
                        color: context.colors.successText,
                        isPositive: true,
                      ),
                    ),
                  ),
                ],
              );
            },
            loading: () => SizedBox(
              height: 120,
              child: Center(child: ShimmerBox(height: 80, borderRadius: 16)),
            ),
            error: (err, stack) => SizedBox(
              height: 120,
              child: LuminaErrorWidget(
                message: 'Erreur de chargement des finances.',
                onRetry: () => ref.invalidate(superadminFinanceChartProvider),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
