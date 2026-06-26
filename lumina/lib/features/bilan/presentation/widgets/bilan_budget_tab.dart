import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import 'package:lumina/core/widgets/widgets.dart';
class BilanBudgetTab extends ConsumerWidget {
  const BilanBudgetTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // For now, these are static UI representations to show what the "Pro Max" budget tab looks like
    // Following what was requested: progress bars with semantic colors

    final budgetCategories = [
      {'name': 'Logement Pastoral', 'budget': 1500.0, 'spent': 1000.0},
      {'name': 'Équipement', 'budget': 2000.0, 'spent': 2200.0}, // Overage
      {'name': 'Œuvres de Charité', 'budget': 800.0, 'spent': 200.0},
      {'name': 'Maintenance', 'budget': 500.0, 'spent': 450.0}, // Warning
    ];

    final double totalBudget = budgetCategories.fold(0.0, (sum, i) => sum + (i['budget'] as double));
    final double totalSpent = budgetCategories.fold(0.0, (sum, i) => sum + (i['spent'] as double));
    final double overallPct = (totalSpent / totalBudget) * 100;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Budget vs Réel',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: AppSpacing.md),
          _buildOverallBudgetCard(context, totalBudget, totalSpent, overallPct),
          const SizedBox(height: AppSpacing.xl),
          const Text(
            'Consommation par Rubrique',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: AppSpacing.sm),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: budgetCategories.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) {
              final cat = budgetCategories[index];
              final String name = cat['name'] as String;
              final double budget = cat['budget'] as double;
              final double spent = cat['spent'] as double;
              final double pct = (spent / budget) * 100;

              return _buildBudgetCategoryBar(context, name, budget, spent, pct);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOverallBudgetCard(BuildContext context, double target, double actual, double pct) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Consommation Globale',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '${pct.toStringAsFixed(1)}%',
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: pct > 100 ? context.colors.errorText : context.colors.brandPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppProgressBar(
            value: (pct > 100 ? 100 : pct) / 100.0,
            height: 12,
            backgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
            color: pct > 100 
                ? context.colors.errorText 
                : (pct > 80 ? context.colors.warningText : context.colors.successText),
            borderRadius: 12,
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Dépensé', style: TextStyle(color: Colors.grey)),
                  Text('${actual.toStringAsFixed(0)} FCFA', style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('Budget', style: TextStyle(color: Colors.grey)),
                  Text('${target.toStringAsFixed(0)} FCFA', style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetCategoryBar(BuildContext context, String name, double target, double actual, double pct) {
    final isOverage = pct > 100;
    final isWarning = pct > 80 && !isOverage;
    
    final barColor = isOverage 
        ? context.colors.errorText 
        : (isWarning ? context.colors.warningText : context.colors.successText);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(name, style: const TextStyle(fontWeight: FontWeight.w500)),
            Text('${actual.toStringAsFixed(0)} FCFA / ${target.toStringAsFixed(0)} FCFA', 
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        const SizedBox(height: 6),
        AppProgressBar(
          value: (pct > 100 ? 100 : pct) / 100.0,
          height: 8,
          backgroundColor: Theme.of(context).brightness == Brightness.dark 
              ? Colors.grey.shade800 : Colors.grey.shade200,
          color: barColor,
          borderRadius: 4,
        ),
        if (isOverage) ...[
          const SizedBox(height: 4),
          Text(
            'Dépassement de ${(actual - target).toStringAsFixed(0)} FCFA',
            style: TextStyle(color: context.colors.errorText, fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ],
      ],
    );
  }
}
