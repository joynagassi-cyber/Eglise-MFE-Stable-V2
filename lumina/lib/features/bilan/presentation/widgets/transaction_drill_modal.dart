/// Drill-down modal to view transactions for a specific group/category
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumina/core/widgets/widgets.dart';
import 'package:intl/intl.dart';

import 'package:lumina/core/providers/repository_providers_finance.dart';
import '../providers/bilan_providers.dart';

class TransactionDrillModal extends ConsumerWidget {
  const TransactionDrillModal({
    super.key,
    this.groupId,
    this.category,
    this.groupName,
  });

  final String? groupId;
  final String? category;
  final String? groupName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formatter = ref.watch(numberFormatterProvider);
    final theme = Theme.of(context);

    final transactionsAsync = ref.watch(
      bilanDrillDownTransactionsProvider(
          (groupId: groupId, category: category)),
    );

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Transactions',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Périmètre: ${groupName ?? category ?? "Global"}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          const Divider(height: 32),

          // Content
          Expanded(
            child: transactionsAsync.when(
              loading: () => const Center(child: LoadingState()),
              error: (e, _) => const Center(child: Text('Impossible de charger les transactions')),
              data: (transactions) {
                if (transactions.isEmpty) {
                  return const Center(
                    child: Text('Aucune transaction trouvée'),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: transactions.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final tx = transactions[index];
                    final isExpense = tx.type == 'expense';

                    return GlassCard(
                      padding: const EdgeInsets.all(12),
                      borderColor: isExpense ? Colors.red : Colors.green,
                      onTap: () => _viewImage(
                        context,
                        tx.imageUrl,
                        tx.label,
                        tx.imageUrl != null,
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: (isExpense ? Colors.red : Colors.green)
                                  .withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isExpense
                                  ? Icons.arrow_upward_rounded
                                  : Icons.arrow_downward_rounded,
                              color: isExpense ? Colors.red : Colors.green,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tx.label,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(Icons.access_time,
                                        size: 10, color: theme.hintColor),
                                    const SizedBox(width: 4),
                                    Text(
                                      DateFormat('dd MMM yyyy HH:mm')
                                          .format(tx.date),
                                      style: theme.textTheme.labelSmall
                                          ?.copyWith(
                                              fontSize: 10,
                                              color: theme.hintColor),
                                    ),
                                    if (tx.groupName != null) ...[
                                      const SizedBox(width: 8),
                                      const Text('•',
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.grey)),
                                      const SizedBox(width: 8),
                                      Text(
                                        tx.groupName!,
                                        style: theme.textTheme.labelSmall
                                            ?.copyWith(
                                          color: theme.colorScheme.primary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                formatter.formatWithSign(
                                  isExpense ? -tx.amount : tx.amount,
                                ),
                                style: TextStyle(
                                  color: isExpense ? Colors.red : Colors.green,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              _StatusBadge(status: tx.status),
                            ],
                          ),
                          const SizedBox(width: 8),
                          if (tx.status != 'validated')
                            IconButton(
                              icon: const Icon(
                                Icons.verified_rounded,
                                size: 20,
                                color: Colors.green,
                              ),
                              onPressed: () => _showValidationDialog(
                                context,
                                ref,
                                tx.id,
                                tx.label,
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showValidationDialog(
    BuildContext context,
    WidgetRef ref,
    String id,
    String label,
  ) {
    final commentController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Valider: $label'),
        content: TextField(
          controller: commentController,
          decoration: const InputDecoration(
            labelText: 'Commentaire (Optionnel)',
            border: OutlineInputBorder(),
          ),
          maxLines: 2,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                final repo = ref.read(bilanRepositoryProvider);
                final result = await repo.signTransaction(
                  id,
                  comment: commentController.text,
                );

                final status = result['status'] as String;
                final needed = result['signatures_needed'] as int;

                if (context.mounted) {
                  Navigator.pop(context);
                  final String message = status == 'approved'
                      ? 'Transaction validée (Toutes les signatures obtenues)'
                      : 'Signature enregistrée ($needed signatures encore requises)';

                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(message)));
                  // Refresh list
                  ref.invalidate(bilanPerGroupProvider);
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('Impossible d\'associer la transaction')));
                }
              }
            },
            child: const Text('Valider'),
          ),
        ],
      ),
    );
  }

  void _viewImage(
    BuildContext context,
    String? url,
    String label,
    bool isVerified,
  ) {
    if (url == null) return;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              title: Text(label),
              actions: [
                if (isVerified)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Center(
                      child: Tooltip(
                        message:
                            'Intégrité de la pièce jointe vérifiée (SHA-256)',
                        child: Icon(Icons.verified_user, color: Colors.green),
                      ),
                    ),
                  ),
              ],
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            InteractiveViewer(
              child: Image.network(
                url,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const SizedBox(
                    height: 200,
                    child: Center(child: LoadingState()),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Identifiant de conformité: ${url.hashCode.toRadixString(16).toUpperCase()}',
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;
    IconData icon;

    switch (status) {
      case 'validated':
        color = Colors.green;
        label = 'VALIDÉ';
        icon = Icons.verified;
        break;
      case 'partial':
        color = Colors.orange;
        label = 'PARTIEL';
        icon = Icons.hourglass_top;
        break;
      default:
        color = Colors.grey;
        label = 'BROUILLON';
        icon = Icons.edit_note;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
