import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumina/core/widgets/widgets.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import 'package:lumina/features/finance/domain/services/currency_service.dart';
import 'package:lumina/features/finance/presentation/providers/finance_providers.dart';
import 'mini_bezier_chart.dart';

class FinanceGlassHeroHeader extends ConsumerWidget {
  final Map<String, double> stats;
 
  const FinanceGlassHeroHeader({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMasked = ref.watch(dataMaskingProvider);
    final balance = stats['balance'] ?? 0;
    final income = stats['income'] ?? 0;

    return Column(
      children: [
        SizedBox(
          height: 180,
          child: Row(
            children: [
              // Carte Solde Total (Glass Primary)
              Expanded(
                flex: 3,
                child: GlassCard(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  backgroundColor: context.colors.brandPrimary.withValues(alpha: 0.1),
                  borderColor: context.colors.brandPrimary.withValues(alpha: 0.3),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Solde Total',
                        style: TextStyle(
                          color: context.colors.brandPrimary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          isMasked
                              ? '••••••••'
                              : CurrencyService.format(balance, 'XAF'),
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                      _miniStatRow(
                        label: 'Revenus',
                        amount: income,
                        icon: Icons.south_west,
                        color: context.colors.successText,
                        isMasked: isMasked,
                        context: context,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),

              // Carte Tendance (Glass Secondary)
              Expanded(
                flex: 2,
                child: GlassCard(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tendance',
                        style: TextStyle(
                          color: context.colors.textSecondary,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        height: 60,
                        child: ref.watch(financeTrendProvider).when(
                              data: (trend) => MiniBezierChart(
                                data: (trend['data'] as List<double>),
                                isPositive: (trend['growth'] as double) >= 0,
                              ),
                              loading: () => const Center(
                                  child: LoadingDots(
                                size: 24,
                                color: Colors.white,
                              )),
                              error: (_, __) => const Icon(Icons.error_outline),
                            ),
                      ),
                      const Spacer(),
                      ref.watch(financeTrendProvider).when(
                            data: (trend) {
                              final growth = trend['growth'] as double;
                              final isPositive = growth >= 0;
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${isPositive ? '+' : ''}${growth.toStringAsFixed(1)}%',
                                    style: TextStyle(
                                      color: isPositive
                                          ? context.colors.successText
                                          : context.colors.errorText,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Icon(
                                    isPositive
                                        ? Icons.trending_up
                                        : Icons.trending_down,
                                    color: isPositive
                                        ? context.colors.successText
                                        : context.colors.errorText,
                                    size: 14,
                                  ),
                                ],
                              );
                            },
                            loading: () => const LoadingState(),
                            error: (_, __) => const SizedBox(),
                          ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _miniStatRow({
    required String label,
    required double amount,
    required IconData icon,
    required Color color,
    required bool isMasked,
    required BuildContext context,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 12),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: context.colors.textSecondary,
              ),
            ),
            Text(
              isMasked
                  ? '••••'
                  : CurrencyService.format(amount, 'XAF')
                      .replaceAll(' FCFA', ''),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
