import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import 'package:lumina/core/widgets/widgets.dart';
class FinanceSection extends StatelessWidget {
  final List<dynamic> recentTransactions;
  final VoidCallback onCreateExpense;

  const FinanceSection({
    super.key,
    required this.recentTransactions,
    required this.onCreateExpense,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionHeader(
          title: 'Finances Récentes',
          icon: Icons.receipt_long,
          trailingLabel: 'Dépense',
          onTrailingTap: onCreateExpense,
        ),
        const SizedBox(height: AppSpacing.md),
        if (recentTransactions.isEmpty)
          const EmptyState(
            icon: Icons.money_off,
            title: 'Aucune transaction',
            subtitle: 'Ce groupe n\'a pas encore de flux financier.',
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: recentTransactions.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final tx = recentTransactions[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: tx.isIncome
                      ? context.colors.successText.withValues(alpha: 0.1)
                      : context.colors.errorText.withValues(alpha: 0.1),
                  child: Icon(
                    tx.isIncome ? Icons.add : Icons.remove,
                    color: tx.isIncome ? context.colors.successText : context.colors.errorText,
                  ),
                ),
                title: Text(tx.description),
                subtitle: Text(tx.date.toString()),
                trailing: Text(
                  '${tx.amount} F',
                  style: TextStyle(
                    fontWeight: LuminaFont.weightBold,
                    color: context.colors.textPrimary,
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}
