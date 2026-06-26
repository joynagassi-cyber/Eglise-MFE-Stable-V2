// ============================================================
// FICHIER : lib/core/models/notification_item.dart
// DESCRIPTION : Modèle pour les notifications utilisateur
// DÉPENDANCES : flutter/material.dart (pour IconData et Color)
// ============================================================

import 'package:flutter/material.dart';

class NotificationItem {
  final String id;
  final String userId;
  final NotificationType type;
  final String title;
  final String body;
  final Map<String, dynamic>? data;
  final bool isRead;
  final DateTime createdAt;

  const NotificationItem({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.body,
    this.data,
    this.isRead = false,
    required this.createdAt,
  });

  String? get targetRoute => data?['route'] as String?;
  String? get targetEntityId => data?['entity_id'] as String?;

  String get timeAgo {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inMinutes < 1) return 'À l\'instant';
    if (diff.inMinutes < 60) return 'Il y a ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'Il y a ${diff.inHours}h';
    if (diff.inDays < 7) return 'Il y a ${diff.inDays}j';
    return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
  }

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      type: NotificationType.fromString(json['type'] as String? ?? 'info'),
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      data: json['data'] as Map<String, dynamic>?,
      isRead: json['is_read'] as bool? ?? false,
      createdAt: DateTime.parse(
        json['created_at'] as String? ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type': type.name,
      'title': title,
      'body': body,
      'data': data,
      'is_read': isRead,
      'created_at': createdAt.toIso8601String(),
    };
  }

  NotificationItem copyWith({
    String? id,
    String? userId,
    NotificationType? type,
    String? title,
    String? body,
    Map<String, dynamic>? data,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      title: title ?? this.title,
      body: body ?? this.body,
      data: data ?? this.data,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationItem &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

enum NotificationType {
  info,
  success,
  warning,
  error,
  transaction,
  event,
  announcement,
  prayer,
  member,
  approval;

  static NotificationType fromString(String value) {
    return switch (value) {
      'info' => NotificationType.info,
      'success' => NotificationType.success,
      'warning' => NotificationType.warning,
      'error' => NotificationType.error,
      'transaction' => NotificationType.transaction,
      'event' => NotificationType.event,
      'announcement' => NotificationType.announcement,
      'prayer' => NotificationType.prayer,
      'member' => NotificationType.member,
      'approval' => NotificationType.approval,
      _ => NotificationType.info,
    };
  }

  IconData get icon => switch (this) {
        NotificationType.info => Icons.info_outline_rounded,
        NotificationType.success => Icons.check_circle_outline_rounded,
        NotificationType.warning => Icons.warning_amber_rounded,
        NotificationType.error => Icons.error_outline_rounded,
        NotificationType.transaction => Icons.receipt_long_rounded,
        NotificationType.event => Icons.event_rounded,
        NotificationType.announcement => Icons.campaign_rounded,
        NotificationType.prayer => Icons.volunteer_activism_rounded,
        NotificationType.member => Icons.person_rounded,
        NotificationType.approval => Icons.approval_rounded,
      };

  Color get color => switch (this) {
        NotificationType.info => const Color(0xFF3B82F6),
        NotificationType.success => const Color(0xFF22C55E),
        NotificationType.warning => const Color(0xFFF59E0B),
        NotificationType.error => const Color(0xFFEF4444),
        NotificationType.transaction => const Color(0xFF6366F1),
        NotificationType.event => const Color(0xFFA855F7),
        NotificationType.announcement => const Color(0xFFF59E0B),
        NotificationType.prayer => const Color(0xFFEC4899),
        NotificationType.member => const Color(0xFF14B8A6),
        NotificationType.approval => const Color(0xFF0EA5E9),
      };
}
