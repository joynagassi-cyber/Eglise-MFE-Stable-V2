import 'package:lumina/core/theme/app_typography.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:lumina/core/theme/app_spacing.dart';
// lib/features/finance/presentation/widgets/budget_card.dart
// Carte affichant les détails d'un budget

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumina/core/widgets/widgets.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../domain/entities/budget.dart';
import '../../../rubriques/presentation/providers/category_providers.dart';

class BudgetCard extends ConsumerWidget {
  final Budget budget;

  const BudgetCard({super.key, required this.budget});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final churchId = ref.watch(activeChurchIdProvider);
    final categoriesAsync = ref.watch(categoryListProvider(churchId));
    final categoryName = categoriesAsync.maybeWhen(
      data: (categories) =>
          categories
              .where((c) => c.id == budget.categoryId)
              .firstOrNull
              ?.name ??
          'Catégorie inconnue',
      orElse: () => 'Chargement...',
    );

    final completionRate = budget.completionRate;
    final color = budget.isOverBudget
        ? context.colors.errorText
        : budget.isNearLimit
            ? context.colors.warningText
            : context.colors.successText;

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    categoryName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  child: Text(
                    '${completionRate.toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
              child: AppProgressBar(
                value: (budget.completionRate / 100).clamp(0.0, 1.0),
                color: budget.isOverBudget
                    ? context.colors.errorText
                    : context.colors.brandPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildAmountColumn(context, 'Prévu', budget.plannedAmount, null),
                _buildAmountColumn(context, 'Réalisé', budget.actualAmount, color),
                _buildAmountColumn(
                  context,
                  'Écart',
                  budget.variance,
                  budget.variance > 0 ? context.colors.errorText : context.colors.successText,
                  prefix: budget.variance > 0 ? '+' : '',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountColumn(
    BuildContext context,
    String label,
    double amount,
    Color? color, {
    String prefix = '',
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: context.colors.textTertiary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '$prefix${amount.toStringAsFixed(0)} FCFA',
          style: AppTypography.labelLarge.copyWith(
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}
