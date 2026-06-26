/// Consolidation table showing eliminated internal transfers (Double bookkeeping removal)
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumina/core/widgets/widgets.dart';
import '../providers/bilan_providers.dart';

class ConsolidationTable extends ConsumerWidget {
  const ConsolidationTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transfersAsync = ref.watch(internalTransfersProvider);
    final formatter = ref.watch(numberFormatterProvider);
    final theme = Theme.of(context);

    return transfersAsync.when(
      loading: () => const Center(child: LoadingState()),
      error: (e, _) => const Center(child: Text('Impossible de charger le tableau de consolidation')),
      data: (transfers) {
        if (transfers.isEmpty) return const SizedBox.shrink();

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.layers_clear,
                      size: 20,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Éliminations de Consolidation',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Ces transferts internes sont soustraits du total consolidé pour éviter le double comptage.',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 16),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: transfers.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final tx = transfers[index];
                    return ListTile(
                      dense: true,
                      title: Text(tx.label),
                      subtitle: Text(tx.groupName ?? 'Groupe inconnu'),
                      trailing: Text(
                        '- ${formatter.formatCurrency(tx.amount)}',
                        style: TextStyle(
                          color: theme.colorScheme.error,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
                const Divider(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total éliminé:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      formatter.formatCurrency(
                        transfers.fold<double>(
                          0.0,
                          (sum, tx) => sum + tx.amount,
                        ),
                      ),
                      style: TextStyle(
                        color: theme.colorScheme.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}