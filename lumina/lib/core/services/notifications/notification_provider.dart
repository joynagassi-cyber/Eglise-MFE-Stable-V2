import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'notification_service.dart';

final notificationServiceProvider =
    ChangeNotifierProvider<NotificationService>((ref) {
  return NotificationService();
});

final unreadCountProvider = Provider<int>((ref) {
  return ref.watch(notificationServiceProvider).unreadCount;
});

final notificationsProvider = Provider<List<AppNotification>>((ref) {
  return ref.watch(notificationServiceProvider).notifications;
});
