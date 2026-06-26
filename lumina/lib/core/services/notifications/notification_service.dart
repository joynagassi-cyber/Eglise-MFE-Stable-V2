import 'package:flutter/foundation.dart';
import '../../../features/tasks/domain/entities/task.dart';

enum NotificationType { event, birthday, reminder, finance, general }

class AppNotification {
  final String id;
  final String title;
  final String body;
  final NotificationType type;
  final DateTime createdAt;
  final bool isRead;
  final Map<String, dynamic>? data;

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.createdAt,
    this.isRead = false,
    this.data,
  });

  AppNotification copyWith({bool? isRead}) {
    return AppNotification(
      id: id,
      title: title,
      body: body,
      type: type,
      createdAt: createdAt,
      isRead: isRead ?? this.isRead,
      data: data,
    );
  }
}

class NotificationService extends ChangeNotifier {
  final List<AppNotification> _notifications = [];

  List<AppNotification> get notifications => List.unmodifiable(_notifications);
  List<AppNotification> get unreadNotifications =>
      _notifications.where((n) => !n.isRead).toList();
  int get unreadCount => unreadNotifications.length;

  void addNotification({
    required String title,
    required String body,
    required NotificationType type,
    Map<String, dynamic>? data,
  }) {
    final notification = AppNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      body: body,
      type: type,
      createdAt: DateTime.now(),
      data: data,
    );
    _notifications.insert(0, notification);
    notifyListeners();
  }

  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      notifyListeners();
    }
  }

  void markAllAsRead() {
    for (var i = 0; i < _notifications.length; i++) {
      _notifications[i] = _notifications[i].copyWith(isRead: true);
    }
    notifyListeners();
  }

  void deleteNotification(String id) {
    _notifications.removeWhere((n) => n.id == id);
    notifyListeners();
  }

  void clearAll() {
    _notifications.clear();
    notifyListeners();
  }

  void scheduleEventReminder(String eventTitle, DateTime eventDate) {
    final daysUntil = eventDate.difference(DateTime.now()).inDays;
    if (daysUntil <= 7 && daysUntil > 0) {
      addNotification(
        title: 'Événement à venir',
        body: '$eventTitle dans $daysUntil jour${daysUntil > 1 ? 's' : ''}',
        type: NotificationType.event,
        data: {'eventDate': eventDate.toIso8601String()},
      );
    }
  }

  void scheduleBirthdayReminder(String memberName, DateTime birthday) {
    final now = DateTime.now();
    final nextBirthday = DateTime(now.year, birthday.month, birthday.day);
    final daysUntil = nextBirthday.difference(now).inDays;
    if (daysUntil <= 7 && daysUntil >= 0) {
      addNotification(
        title: 'Anniversaire',
        body:
            '$memberName fête son anniversaire ${daysUntil == 0 ? "aujourd'hui" : "dans $daysUntil jour${daysUntil > 1 ? 's' : ''}"}',
        type: NotificationType.birthday,
        data: {'memberName': memberName},
      );
    }
  }

  void notifyLowBalance(double balance) {
    if (balance < 100000) {
      addNotification(
        title: 'Solde faible',
        body: 'Le solde actuel est de ${balance.toStringAsFixed(0)} FCFA',
        type: NotificationType.finance,
      );
    }
  }

  void scheduleTaskReminder(Task task) {
    if (task.dueDate == null) return;

    final now = DateTime.now();
    final daysUntil = task.dueDate!.difference(now).inDays;

    if (daysUntil <= 3 &&
        daysUntil >= 0 &&
        task.status != TaskStatus.completed) {
      addNotification(
        title: 'Rappel de tâche',
        body:
            'Échéance proche : ${task.title}${daysUntil == 0 ? " aujourd'hui" : " dans $daysUntil jour${daysUntil > 1 ? 's' : ''}"}',
        type: NotificationType.reminder,
        data: {'taskId': task.id, 'dueDate': task.dueDate?.toIso8601String()},
      );
    }
  }
}
