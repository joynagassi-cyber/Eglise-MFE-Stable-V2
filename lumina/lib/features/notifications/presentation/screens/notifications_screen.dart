// import 'package:lumina/core/theme/lumina_colors_extension.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/services/notifications/notification_provider.dart';
import '../../../../core/services/notifications/notification_service.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import '../../../../core/utils/haptic_helper.dart';
import '../../../../core/widgets/animated_entrance.dart';
import '../../../../core/widgets/empty_state.dart';
// import 'package:lumina/core/extensions/build_context_extensions.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationsProvider);
    final service = ref.watch(notificationServiceProvider);

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
        title: Text('Notifications'),
        actions: [
          if (notifications.isNotEmpty)
            Semantics(
              label: 'Tout marquer comme lu',
              button: true,
              child: TextButton(
                onPressed: () async {
                  await HapticHelper.medium();
                  service.markAllAsRead();
                  await HapticHelper.success();
                },
                child: Text('Tout marquer lu'),
              ),
            ),
          if (notifications.isNotEmpty)
            Semantics(
              label: 'Tout supprimer',
              button: true,
              child: Tooltip(
                message: 'Tout supprimer',
                child: IconButton(
                  icon: Icon(Icons.delete_sweep),
                  onPressed: () async {
                    await HapticHelper.warning();
                    service.clearAll();
                  },
                ),
              ),
            ),
        ],
      ),
      body: notifications.isEmpty
          ? const AnimatedEntrance.fade(
              delay: Duration(milliseconds: 200),
              child: EmptyState(
                icon: Icons.notifications_none_rounded,
                title: 'Aucune notification',
                subtitle: 'Vous serez notifié des événements importants',
              ),
            )
          : ListView.separated(
              padding: AppSpacing.screenPadding,
              itemCount: notifications.length,
              separatorBuilder: (_, __) => Divider(height: 1),
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return AnimatedEntrance.fromLeft(
                  delay: Duration(milliseconds: 50 + (index * 50)),
                  child: _NotificationTile(notification: notification),
                );
              },
            ),
    );
  }
}

class _NotificationTile extends ConsumerWidget {
  final AppNotification notification;

  const _NotificationTile({required this.notification});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final service = ref.watch(notificationServiceProvider);

    return Semantics(
      label: '${notification.title}, ${notification.body}',
      customSemanticsActions: {
        const CustomSemanticsAction(label: 'Supprimer'): () {
          service.deleteNotification(notification.id);
        },
      },
      child: Dismissible(
        key: Key(notification.id),
        direction: DismissDirection.endToStart,
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: AppSpacing.lg),
          child: Icon(
            Icons.delete,
            color: Colors.white,
            size: AppSpacing.iconLg,
          ),
        ),
        onDismissed: (_) async {
          await HapticHelper.medium();
          service.deleteNotification(notification.id);
        },
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () async {
              await HapticHelper.light();
              service.markAsRead(notification.id);
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
                  SizedBox(height: AppSpacing.xs),
                  Text(notification.body),
                  SizedBox(height: AppSpacing.xs),
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
                        decoration: BoxDecoration(color: context.colors.brandPrimary,
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

  IconData _getTypeIcon(NotificationType type) {
    switch (type) {
      case NotificationType.event:
        return Icons.event;
      case NotificationType.birthday:
        return Icons.cake;
      case NotificationType.reminder:
        return Icons.notifications;
      case NotificationType.finance:
        return Icons.account_balance_wallet;
      case NotificationType.general:
        return Icons.info;
    }
  }

  String _getTypeLabel(NotificationType type) {
    switch (type) {
      case NotificationType.event:
        return 'Événement';
      case NotificationType.birthday:
        return 'Anniversaire';
      case NotificationType.reminder:
        return 'Rappel';
      case NotificationType.finance:
        return 'Finance';
      case NotificationType.general:
        return 'Général';
    }
  }

  Color _getTypeColor(BuildContext context, NotificationType type) {
    switch (type) {
      case NotificationType.event:
        return context.colors.brandPrimary;
      case NotificationType.birthday:
        return Colors.pink;
      case NotificationType.reminder:
        return Colors.orange;
      case NotificationType.finance:
        return context.colors.successText;
      case NotificationType.general:
        return Colors.blue;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) return 'À l\'instant';
    if (diff.inHours < 1) return 'Il y a ${diff.inMinutes} min';
    if (diff.inDays < 1) return 'Il y a ${diff.inHours}h';
    if (diff.inDays < 7) return 'Il y a ${diff.inDays}j';
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }
}