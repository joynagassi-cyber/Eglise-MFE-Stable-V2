import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:intl/intl.dart';
import 'package:lumina/core/theme/app_spacing.dart';
class BilanSealDialog extends StatelessWidget {
  final int year;
  final int month;
  final double totalIncome;
  final double totalExpense;
  final double netBalance;
  final VoidCallback onConfirm;

  const BilanSealDialog({
    super.key,
    required this.year,
    required this.month,
    required this.totalIncome,
    required this.totalExpense,
    required this.netBalance,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final currencyFormatter =
        NumberFormat.currency(locale: 'fr_FR', symbol: 'FCFA');

    final monthNames = [
      'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
      'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'
    ];
    final monthName = monthNames[month - 1];

    Future<void> handleConfirm() async {
      Navigator.of(context).pop();
      onConfirm();
    }

    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.lock, color: context.colors.errorText),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Sceller $monthName $year',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? Colors.white12 : Colors.black12,
                ),
              ),
              child: Column(
                children: [
                  _TotauxRow(
                    label: 'Entrées',
                    amount: currencyFormatter.format(totalIncome),
                    color: context.colors.successText,
                  ),
                  const Divider(),
                  _TotauxRow(
                    label: 'Sorties',
                    amount: currencyFormatter.format(totalExpense),
                    color: context.colors.errorText,
                  ),
                  const Divider(thickness: 2),
                  _TotauxRow(
                    label: 'Solde Net',
                    amount: currencyFormatter.format(netBalance),
                    color: netBalance >= 0 ? context.colors.successText : context.colors.errorText,
                    isBold: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text('Attention : Cette action est irréversible et verrouillera toutes les transactions de ce mois. Le hash calculé garantira l\'intégrité des données.',
              style: TextStyle(
                color: context.colors.errorText,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            const Text(
              'Veuillez vous assurer que toutes les transactions sont correctes.',
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.l10n.cancel),
        ),
        FilledButton.icon(
          onPressed: handleConfirm,
          icon: const Icon(Icons.lock),
          label: const Text('Confirmer & Sceller'),
          style: FilledButton.styleFrom(
            backgroundColor: context.colors.errorText,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}

class _TotauxRow extends StatelessWidget {
  final String label;
  final String amount;
  final Color color;
  final bool isBold;

  const _TotauxRow({
    required this.label,
    required this.amount,
    required this.color,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              color: color,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }
}
