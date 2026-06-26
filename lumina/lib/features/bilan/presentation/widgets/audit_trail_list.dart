/// Widget to display audit trail for a transaction or global activity
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:lumina/core/providers/repository_providers_finance.dart';
import 'package:lumina/core/widgets/widgets.dart';
class AuditTrailList extends ConsumerWidget {
  const AuditTrailList({super.key, this.transactionId});

  final String? transactionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Audit logs provider (future)
    final auditLogsAsync = ref.watch(
      FutureProvider((ref) async {
        final repo = ref.read(bilanRepositoryProvider);
        return repo.getAuditLogs(recordId: transactionId);
      }),
    );

    final theme = Theme.of(context);

    return auditLogsAsync.when(
      loading: () => const Center(child: LoadingState()),
      error: (e, _) => const Center(child: Text('Impossible de charger la piste d\'audit')),
      data: (logs) {
        if (logs.isEmpty) {
          return const Center(child: Text('Aucun log d\'audit trouvé'));
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: logs.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, index) {
            final log = logs[index];
            return ListTile(
              leading: _getActionIcon(log.action),
              title: Text(
                _getActionLabel(log.action),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Par: ${log.changedByRole ?? "Utilisateur"} • ${DateFormat('dd MMM yyyy HH:mm').format(log.createdAt)}',
                    style: theme.textTheme.labelSmall,
                  ),
                  if (log.newData != null &&
                      log.newData!.containsKey('comment'))
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        'Commentaire: ${log.newData!['comment']}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _getActionIcon(String action) {
    switch (action.toUpperCase()) {
      case 'INSERT':
        return const Icon(Icons.add_circle, color: Colors.green);
      case 'UPDATE':
        return const Icon(Icons.edit, color: Colors.blue);
      case 'VALIDATE':
        return const Icon(Icons.check_circle, color: Colors.indigo);
      case 'SEAL':
        return const Icon(Icons.lock, color: Colors.grey);
      case 'REJECT':
        return const Icon(Icons.cancel, color: Colors.red);
      default:
        return const Icon(Icons.history);
    }
  }

  String _getActionLabel(String action) {
    switch (action.toUpperCase()) {
      case 'INSERT':
        return 'Création';
      case 'UPDATE':
        return 'Modification';
      case 'VALIDATE':
        return 'Validation';
      case 'SEAL':
        return 'Verrouillage';
      case 'REJECT':
        return 'Rejet';
      default:
        return 'Action inconnue';
    }
  }
}
