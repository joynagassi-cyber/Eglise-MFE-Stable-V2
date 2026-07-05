import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:lumina/core/providers/repository_providers_content.dart';
import 'package:lumina/features/notifications/domain/entities/app_notification_entity.dart';

part 'notification_controller.g.dart';

/// ViewModel léger pour l'affichage des notifications dans l'UI
class NotificationDisplayItem {
  final String id;
  final String title;
  final String body;
  final String type;
  final DateTime createdAt;
  final bool isRead;
  final Map<String, dynamic>? data;

  NotificationDisplayItem({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.createdAt,
    this.isRead = false,
    this.data,
  });

  factory NotificationDisplayItem.fromEntity(AppNotificationEntity entity) {
    return NotificationDisplayItem(
      id: entity.id,
      title: entity.title,
      body: entity.message,
      type: entity.type,
      createdAt: entity.createdAt ?? DateTime.now(),
      isRead: entity.isRead,
      data: entity.payload as Map<String, dynamic>?,
    );
  }
}

@riverpod
class NotificationController extends _$NotificationController {
  @override
  Future<List<AppNotificationEntity>> build() async {
    final repo = ref.watch(notificationRepositoryProvider);
    return repo.getNotifications();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() {
      final repo = ref.read(notificationRepositoryProvider);
      return repo.getNotifications();
    });
  }

  Future<void> markAsRead(String id) async {
    final repo = ref.read(notificationRepositoryProvider);
    await repo.markAsRead(id);
    ref.invalidateSelf();
  }

  Future<void> markAllAsRead() async {
    final repo = ref.read(notificationRepositoryProvider);
    await repo.markAllAsRead();
    ref.invalidateSelf();
  }

  Future<void> deleteNotification(String id) async {
    final repo = ref.read(notificationRepositoryProvider);
    await repo.deleteNotification(id);
    ref.invalidateSelf();
  }

  Future<void> clearAll() async {
    final repo = ref.read(notificationRepositoryProvider);
    await repo.clearAll();
    ref.invalidateSelf();
  }
}

@riverpod
Future<int> unreadNotificationCount(UnreadNotificationCountRef ref) {
  final repo = ref.watch(notificationRepositoryProvider);
  return repo.getUnreadCount();
}

/// Provider qui expose les notifications comme des [NotificationDisplayItem]
/// pour l'UI, en mappant depuis [AppNotificationEntity]
@riverpod
Future<List<NotificationDisplayItem>> notificationList(
  NotificationListRef ref,
) async {
  final entities = await ref.watch(notificationControllerProvider.future);
  return entities.map(NotificationDisplayItem.fromEntity).toList();
}
