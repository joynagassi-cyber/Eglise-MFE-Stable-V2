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

  /// Create a single notification via Supabase RPC
  Future<AppNotificationEntity?> createNotification({
    required String userId,
    required String title,
    required String message,
    String type = 'general',
    String? linkUrl,
    Map<String, dynamic> payload = const {},
    String priority = 'NORMAL',
    String? churchId,
  });

  /// Create notifications for all members of a group
  Future<int> createNotificationsForGroup({
    required String groupId,
    required String title,
    required String message,
    String type = 'general',
    String? linkUrl,
    Map<String, dynamic> payload = const {},
    String priority = 'NORMAL',
  });

  /// Create notifications for all admins of a church
  Future<int> createNotificationsForAdmins({
    required String churchId,
    required String title,
    required String message,
    String type = 'general',
    String? linkUrl,
    Map<String, dynamic> payload = const {},
    String priority = 'NORMAL',
  });

  /// Create notifications for all group leaders of a church
  Future<int> createNotificationsForGroupLeaders({
    required String churchId,
    required String title,
    required String message,
    String type = 'general',
    String? linkUrl,
    Map<String, dynamic> payload = const {},
    String priority = 'NORMAL',
  });

  /// Create notifications for all members of a church
  Future<int> createNotificationsForAllMembers({
    required String churchId,
    required String title,
    required String message,
    String type = 'general',
    String? linkUrl,
    Map<String, dynamic> payload = const {},
    String priority = 'NORMAL',
  });
}