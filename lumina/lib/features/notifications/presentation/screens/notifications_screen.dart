import 'dart:async';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import '../../../../core/utils/haptic_helper.dart';
import '../../../../core/widgets/animated_entrance.dart';
import '../../../../core/widgets/empty_state.dart';
import '../controllers/notification_controller.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationListProvider);
    final controller = ref.watch(notificationControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        leading: Semantics(
          label: 'Retour',
          button: true,
          child: IconButton(
            icon: Icon(Icons.arrow_back),
            tooltip: 'Retour',
            onPressed: () async {
              await HapticHelper.light();
              if (context.mounted) {
                context.pop();
              }
            },
          ),
        ),
        title: const Text('Notifications'),
        actions: [
          if (notificationsAsync is AsyncData &&
              notificationsAsync.valueOrNull != null &&
              notificationsAsync.valueOrNull!.isNotEmpty)
            Semantics(
              label: 'Tout marquer comme lu',
              button: true,
              child: TextButton(
                onPressed: () async {
                  await HapticHelper.medium();
                  await controller.markAllAsRead();
                  await HapticHelper.success();
                },
                child: const Text('Tout marquer lu'),
              ),
            ),
          if (notificationsAsync is AsyncData &&
              notificationsAsync.valueOrNull != null &&
              notificationsAsync.valueOrNull!.isNotEmpty)
            Semantics(
              label: 'Tout supprimer',
              button: true,
              child: Tooltip(
                message: 'Tout supprimer',
                child: IconButton(
                  icon: const Icon(Icons.delete_sweep),
                  onPressed: () async {
                    await HapticHelper.warning();
                    await controller.clearAll();
                  },
                ),
              ),
            ),
        ],
      ),
      body: notificationsAsync.when(
        data: (notifications) {
          if (notifications.isEmpty) {
            return const AnimatedEntrance.fade(
              delay: Duration(milliseconds: 200),
              child: EmptyState(
                icon: Icons.notifications_none_rounded,
                title: 'Aucune notification',
                subtitle: 'Vous serez notifie des evenements importants',
              ),
            );
          }
          return ListView.separated(
            padding: AppSpacing.screenPadding,
            itemCount: notifications.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return AnimatedEntrance.fromLeft(
                delay: Duration(milliseconds: 50 + (index * 50)),
                child: _NotificationTile(notification: notification),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => AnimatedEntrance.fade(
          delay: const Duration(milliseconds: 200),
          child: EmptyState(
            icon: Icons.error_outline,
            title: 'Erreur de chargement',
            subtitle: error.toString(),
          ),
        ),
      ),
    );
  }


}

class _NotificationTile extends ConsumerWidget {
  final NotificationDisplayItem notification;

  const _NotificationTile({required this.notification});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final controller = ref.watch(notificationControllerProvider.notifier);

    return Semantics(
      label: '${notification.title}, ${notification.body}',
      customSemanticsActions: {
        const CustomSemanticsAction(label: 'Supprimer'): () {
          unawaited(controller.deleteNotification(notification.id));
        },
      },
      child: Dismissible(
        key: Key(notification.id),
        direction: DismissDirection.endToStart,
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: AppSpacing.lg),
          child: const Icon(
            Icons.delete,
            color: Colors.white,
            size: AppSpacing.iconLg,
          ),
        ),
        onDismissed: (_) async {
          await HapticHelper.medium();
          await controller.deleteNotification(notification.id);
        },
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () async {
              await HapticHelper.light();
              await controller.markAsRead(notification.id);
            },
            child: ListTile(
              leading: Semantics(
                label: 'Type: ${_getTypeLabel(notification.type)}',
                child: CircleAvatar(
                  backgroundColor: _getTypeColor(
                    context,
                    notification.type,
                  ).withValues(alpha: 0.2),
                  child: Icon(
                    _getTypeIcon(notification.type),
                    color: _getTypeColor(context, notification.type),
                    size: AppSpacing.iconMd,
                  ),
                ),
              ),
              title: Text(
                notification.title,
                style: TextStyle(
                  fontWeight:
                      notification.isRead ? FontWeight.normal : FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.xs),
                  Text(notification.body),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    _formatDate(notification.createdAt),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: context.colors.textSecondary,
                    ),
                  ),
                ],
              ),
              trailing: notification.isRead
                  ? null
                  : Semantics(
                      label: 'Non lu',
                      child: Container(
                        width: AppSpacing.sm,
                        height: AppSpacing.sm,
                        decoration: BoxDecoration(
                          color: context.colors.brandPrimary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
              tileColor: notification.isRead
                  ? null
                  : context.colors.bgCard.withValues(alpha: 0.5),
            ),
          ),
        ),
      ),
    );
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'event':
        return Icons.event;
      case 'birthday':
        return Icons.cake;
      case 'reminder':
        return Icons.notifications;
      case 'finance':
        return Icons.account_balance_wallet;
      case 'group':
        return Icons.groups;
      case 'announcement':
        return Icons.campaign;
      case 'member':
        return Icons.person_add;
      case 'approval':
        return Icons.approval;
      case 'system':
        return Icons.settings;
      default:
        return Icons.info;
    }
  }

  String _getTypeLabel(String type) {
    switch (type) {
      case 'event':
        return 'Evenement';
      case 'birthday':
        return 'Anniversaire';
      case 'reminder':
        return 'Rappel';
      case 'finance':
        return 'Finance';
      case 'group':
        return 'Groupe';
      case 'announcement':
        return 'Annonce';
      case 'member':
        return 'Membre';
      case 'approval':
        return 'Approbation';
      case 'system':
        return 'Systeme';
      default:
        return 'General';
    }
  }

  Color _getTypeColor(BuildContext context, String type) {
    switch (type) {
      case 'event':
        return context.colors.brandPrimary;
      case 'birthday':
        return Colors.pink;
      case 'reminder':
        return Colors.orange;
      case 'finance':
        return context.colors.successText;
      case 'group':
        return Colors.teal;
      case 'announcement':
        return Colors.amber;
      case 'member':
        return Colors.indigo;
      case 'approval':
        return Colors.purple;
      case 'system':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) return "A l'instant";
    if (diff.inHours < 1) return 'Il y a ${diff.inMinutes} min';
    if (diff.inDays < 1) return 'Il y a ${diff.inHours}h';
    if (diff.inDays < 7) return 'Il y a ${diff.inDays}j';
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }
}