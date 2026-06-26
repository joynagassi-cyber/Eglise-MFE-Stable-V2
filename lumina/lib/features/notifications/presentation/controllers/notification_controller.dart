import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumina/core/providers/repository_providers_content.dart';
import 'package:lumina/features/notifications/domain/entities/app_notification_entity.dart';

part 'notification_controller.g.dart';

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
Future<int> unreadNotificationCount(Ref ref) {
  final repo = ref.watch(notificationRepositoryProvider);
  return repo.getUnreadCount();
}
