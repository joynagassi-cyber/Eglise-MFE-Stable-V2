/// KPI Row widget for BILAN dashboard
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumina/core/widgets/skeletons/fire_skeleton_system.dart';

import '../providers/bilan_providers.dart';

class BilanKpiRow extends ConsumerWidget {
  const BilanKpiRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final consolidatedAsync = ref.watch(consolidatedBilanProvider);
    final variationAsync = ref.watch(bilanVariationProvider);
    final formatter = ref.watch(numberFormatterProvider);

    return consolidatedAsync.when(
      loading: () => const _KpiRowSkeleton(),
      error: (e, _) => const Center(child: Text('Impossible de charger les indicateurs')),
      data: (bilan) {
        final variations = variationAsync.value ?? {};

        return LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxWidth < 500;
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _KpiCard(
                  label: 'Entrées',
                  value: formatter.formatCurrency(bilan.totalIncome),
                  icon: Icons.arrow_downward,
                  color: Colors.green,
                  compact: isCompact,
                  variation: variations['income'],
                ),
                _KpiCard(
                  label: 'Sorties',
                  value: formatter.formatCurrency(bilan.totalExpense),
                  icon: Icons.arrow_upward,
                  color: Colors.red,
                  compact: isCompact,
                  variation: variations['expense'],
                ),
                _KpiCard(
                  label: 'Solde Net',
                  value: formatter.formatWithSign(bilan.netBalance),
                  icon: bilan.netBalance >= 0
                      ? Icons.trending_up
                      : Icons.trending_down,
                  color: bilan.netBalance >= 0 ? Colors.blue : Colors.orange,
                  compact: isCompact,
                  variation: variations['net'],
                ),
                _KpiCard(
                  label: 'Transactions',
                  value: '${bilan.txCount}',
                  icon: Icons.receipt_long,
                  color: Colors.purple,
                  compact: isCompact,
                ),
                _KpiCard(
                  label: 'Intégrité',
                  value: bilan.txCount > 0 
                      ? '${((bilan.sealedCount / bilan.txCount) * 100).toStringAsFixed(0)}%'
                      : '100%',
                  icon: Icons.verified_user,
                  color: Colors.teal,
                  compact: isCompact,
                ),
                if (bilan.internalEliminated > 0)
                  _KpiCard(
                    label: 'Transferts éliminés',
                    value: formatter.formatCurrency(bilan.internalEliminated),
                    icon: Icons.swap_horiz,
                    color: Colors.grey,
                    compact: isCompact,
                    isSecondary: true,
                  ),
              ],
            );
          },
        );
      },
    );
  }
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.compact = false,
    this.isSecondary = false,
    this.variation,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final bool compact;
  final bool isSecondary;
  final BilanVariation? variation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: compact ? double.infinity : 155,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isSecondary
            ? theme.colorScheme.surfaceContainerHighest
            : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
          if (variation != null) ...[
            const SizedBox(height: 4),
            _VariationBadge(variation: variation!),
          ],
        ],
      ),
    );
  }
}

class _VariationBadge extends StatelessWidget {
  const _VariationBadge({required this.variation});
  final BilanVariation variation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPositive = variation.percentage >= 0;
    final color = isPositive ? Colors.green : Colors.red;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isPositive ? Icons.trending_up : Icons.trending_down,
          size: 14,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(
          '${variation.percentage.toStringAsFixed(1)}%',
          style: theme.textTheme.labelSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          'vs N-1',
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }
}

class _KpiRowSkeleton extends StatelessWidget {
  const _KpiRowSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _SkeletonCard(),
        _SkeletonCard(),
        _SkeletonCard(),
        _SkeletonCard(),
      ],
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();

  @override
  Widget build(BuildContext context) {
    return FireShimmer(
      child: Container(
        width: 150,
        height: 80,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}