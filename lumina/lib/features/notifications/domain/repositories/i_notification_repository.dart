import '../entities/app_notification_entity.dart';

abstract class INotificationRepository {
  /// Fetch all notifications for the current user
  Future<List<AppNotificationEntity>> getNotifications({
    int limit = 50,
    int offset = 0,
    bool? isRead,
  });

  /// Get unread count
  Future<int> getUnreadCount();

  /// Mark a single notification as read
  Future<void> markAsRead(String id);

  /// Mark all notifications as read
  Future<void> markAllAsRead();

  /// Delete a notification
  Future<void> deleteNotification(String id);

  /// Clear all notifications
  Future<void> clearAll();

  /// Watch notifications stream (real-time)
  Stream<List<AppNotificationEntity>> watchNotifications();
}