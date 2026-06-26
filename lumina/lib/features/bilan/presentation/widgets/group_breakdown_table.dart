/// Group breakdown table for BILAN dashboard
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumina/core/widgets/widgets.dart';
import '../providers/bilan_providers.dart';
import 'transaction_drill_modal.dart';

class GroupBreakdownTable extends ConsumerWidget {
  const GroupBreakdownTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(bilanPerGroupProvider);
    final formatter = ref.watch(numberFormatterProvider);
    final theme = Theme.of(context);

    return dataAsync.when(
      loading: () => const Center(child: LoadingState()),
      error: (e, _) => const Center(child: Text('Impossible de charger la répartition')),
      data: (groups) {
        if (groups.isEmpty) {
          return Center(
            child: Text(
              'Aucune transaction sur cette période',
              style: theme.textTheme.bodyLarge,
            ),
          );
        }

        return Card(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(
                theme.colorScheme.surfaceContainerHighest,
              ),
              columns: const [
                DataColumn(label: Text('Groupe')),
                DataColumn(label: Text('Entrées'), numeric: true),
                DataColumn(label: Text('Sorties'), numeric: true),
                DataColumn(label: Text('Solde'), numeric: true),
                DataColumn(label: Text('#TX'), numeric: true),
                DataColumn(label: Text('%'), numeric: true),
              ],
              rows: groups.map((group) {
                final isPositive = group.net >= 0;
                return DataRow(
                  cells: [
                    DataCell(
                      Text(
                        group.groupName,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      onTap: () =>
                          _onGroupTap(context, group.groupId, group.groupName),
                    ),
                    DataCell(
                      Text(
                        formatter.formatCurrency(
                          group.income,
                          showSymbol: false,
                        ),
                        style: const TextStyle(color: Colors.green),
                      ),
                    ),
                    DataCell(
                      Text(
                        formatter.formatCurrency(
                          group.expense,
                          showSymbol: false,
                        ),
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                    DataCell(
                      Text(
                        formatter.formatWithSign(group.net),
                        style: TextStyle(
                          color: isPositive ? Colors.blue : Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    DataCell(Text('${group.txCount}')),
                    DataCell(
                      Text(
                        formatter.formatPercentage(group.percentOfTotal ?? 0),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  void _onGroupTap(BuildContext context, String groupId, String groupName) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) =>
          TransactionDrillModal(groupId: groupId, groupName: groupName),
    );
  }
}