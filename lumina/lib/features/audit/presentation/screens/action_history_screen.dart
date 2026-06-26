// import 'package:lumina/core/theme/lumina_colors_extension.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import 'package:lumina/core/widgets/widgets.dart';
import '../../domain/services/audit_service.dart';
import '../../domain/models/audit_log.dart';
// import 'package:lumina/core/extensions/build_context_extensions.dart';

class ActionHistoryScreen extends ConsumerWidget {
  const ActionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logsAsync = ref.watch(auditLogsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Historique des Actions'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () => _showFilterSheet(context, ref),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterChips(context, ref),
          Expanded(
            child: logsAsync.when(
              data: (logs) {
                if (logs.isEmpty) {
                  return const EmptyState(
                    title: 'Aucune action trouvée',
                    subtitle: 'L\'historique des activités est vide pour le moment',
                    icon: Icons.history,
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  itemCount: logs.length,
                  separatorBuilder: (context, index) =>
                      Divider(height: 1),
                  itemBuilder: (context, index) {
                    final log = logs[index];
                    return _ActionLogTile(log: log);
                  },
                );
              },
              loading: () => Center(child: LoadingState()),
              error: (err, st) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline,
                      size: 48,
                      color: context.colors.errorText,
                    ),
                    SizedBox(height: 16),
                    Text('Impossible de charger l\'historique'),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => ref.refresh(auditLogsProvider),
                      child: Text('Réessayer'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(BuildContext context, WidgetRef ref) {
    final actor = ref.watch(auditFilterActorProvider);
    final entityType = ref.watch(auditFilterEntityTypeProvider);
    final action = ref.watch(auditFilterActionProvider);
    final startDate = ref.watch(auditFilterStartDateProvider);
    final endDate = ref.watch(auditFilterEndDateProvider);

    if (actor == null &&
        entityType == null &&
        action == null &&
        startDate == null &&
        endDate == null) {
      return const SizedBox.shrink();
    }

    final dateFormat = DateFormat('dd/MM/yy');

    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: 4,
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          if (actor != null)
            _buildChip(
              context,
              ref,
              'Acteur: $actor',
              () => ref.read(auditFilterActorProvider.notifier).state = null,
            ),
          if (entityType != null)
            _buildChip(
              context,
              ref,
              'Entité: $entityType',
              () =>
                  ref.read(auditFilterEntityTypeProvider.notifier).state = null,
            ),
          if (action != null)
            _buildChip(
              context,
              ref,
              'Action: $action',
              () => ref.read(auditFilterActionProvider.notifier).state = null,
            ),
          if (startDate != null || endDate != null)
            _buildChip(
              context,
              ref,
              'Période: ${startDate != null ? dateFormat.format(startDate) : '?'} - ${endDate != null ? dateFormat.format(endDate) : '?'}',
              () {
                ref.read(auditFilterStartDateProvider.notifier).state = null;
                ref.read(auditFilterEndDateProvider.notifier).state = null;
              },
            ),
        ],
      ),
    );
  }

  Widget _buildChip(BuildContext context, WidgetRef ref, String label, VoidCallback onDeleted) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(label, style: const TextStyle(fontSize: 12)),
        deleteIcon: Icon(Icons.close, size: 14),
        onDeleted: onDeleted,
        backgroundColor: context.colors.brandPrimaryContainer.withValues(alpha: 0.3),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  void _showFilterSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Filtrage Avancé',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 24),
              Text(
                'Type de donnée',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: ['finance_transaction', 'member', 'group', 'donor']
                    .map((type) {
                  final isSelected =
                      ref.watch(auditFilterEntityTypeProvider) == type;
                  return ChoiceChip(
                    label: Text(type),
                    selected: isSelected,
                    onSelected: (val) => ref
                        .read(auditFilterEntityTypeProvider.notifier)
                        .state = val ? type : null,
                  );
                }).toList(),
              ),
              SizedBox(height: 24),
              Text(
                'Action',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: [
                  'INSERT',
                  'UPDATE',
                  'DELETE',
                  'LOGIN',
                  'SEAL',
                  'EXPORT_',
                ].map((act) {
                  final isSelected =
                      ref.watch(auditFilterActionProvider) == act;
                  return ChoiceChip(
                    label: Text(act),
                    selected: isSelected,
                    onSelected: (val) => ref
                        .read(auditFilterActionProvider.notifier)
                        .state = val ? act : null,
                  );
                }).toList(),
              ),
              SizedBox(height: 24),
              Text(
                'Période',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: Icon(Icons.calendar_today, size: 16),
                      label: Text(
                        ref.watch(auditFilterStartDateProvider) != null
                            ? DateFormat(
                                'dd/MM/yy',
                              ).format(ref.watch(auditFilterStartDateProvider)!)
                            : 'Début',
                      ),
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2024),
                          lastDate: DateTime.now(),
                          locale: const Locale('fr', 'FR'),
                          helpText: 'Date de début',
                          cancelText: 'Annuler',
                          confirmText: 'Confirmer',
                        );
                        if (date != null) {
                          ref
                              .read(auditFilterStartDateProvider.notifier)
                              .state = date;
                        }
                      },
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: Icon(Icons.calendar_today, size: 16),
                      label: Text(
                        ref.watch(auditFilterEndDateProvider) != null
                            ? DateFormat(
                                'dd/MM/yy',
                              ).format(ref.watch(auditFilterEndDateProvider)!)
                            : 'Fin',
                      ),
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2024),
                          lastDate: DateTime.now(),
                          locale: const Locale('fr', 'FR'),
                          helpText: 'Date de fin',
                          cancelText: 'Annuler',
                          confirmText: 'Confirmer',
                        );
                        if (date != null) {
                          ref.read(auditFilterEndDateProvider.notifier).state =
                              date;
                        }
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        ref.read(auditFilterStartDateProvider.notifier).state =
                            null;
                        ref.read(auditFilterEndDateProvider.notifier).state =
                            null;
                        ref.read(auditFilterActionProvider.notifier).state =
                            null;
                        ref.read(auditFilterEntityTypeProvider.notifier).state =
                            null;
                        ref.read(auditFilterActorProvider.notifier).state =
                            null;
                        Navigator.pop(context);
                      },
                      child: Text('Réinitialiser'),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Appliquer'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionLogTile extends StatelessWidget {
  final AuditLog log;

  const _ActionLogTile({required this.log});

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('HH:mm');
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildActionIcon(context, log.action.name),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      log.actorName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      '${dateFormat.format(log.occurredAt)} • ${timeFormat.format(log.occurredAt)}',
                      style: TextStyle(color: context.colors.textSecondaryLight,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2),
                Text(
                  '${log.summary} (${log.roleUsed})',
                  style: const TextStyle(fontSize: 14),
                ),
                if (log.dashboardSource != 'Principal')
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: context.colors.brandPrimaryContainer.withValues(
                          alpha: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Dashboard: ${log.dashboardSource}',
                        style: TextStyle(fontSize: 11,
                          color: context.colors.brandPrimary,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionIcon(BuildContext context, String actionName) {
    Color color;
    IconData icon;

    switch (actionName.toLowerCase()) {
      case 'insert':
        color = context.colors.successText;
        icon = Icons.add_circle_outline;
        break;
      case 'update':
        color = context.colors.warningText;
        icon = Icons.edit_outlined;
        break;
      case 'delete':
        color = context.colors.errorText;
        icon = Icons.delete_outline;
        break;
      case 'login':
        color = context.colors.brandPrimary;
        icon = Icons.login;
        break;
      default:
        color = context.colors.infoText;
        icon = Icons.info_outline;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }
}