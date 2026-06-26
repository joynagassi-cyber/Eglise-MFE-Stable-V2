// ============================================================
// FICHIER : lib/core/models/activity_item.dart
// DESCRIPTION : Modèle pour les éléments de la liste "Activités récentes"
// DÉPENDANCES : flutter/material.dart (pour IconData et Color)
// ============================================================

import 'package:flutter/material.dart';

class ActivityItem {
  final String id;
  final String title;
  final String description;
  final ActivityType type;
  final String? actorName;
  final String? actorAvatarUrl;
  final String? entityId;
  final String? route;
  final DateTime timestamp;

  const ActivityItem({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    this.actorName,
    this.actorAvatarUrl,
    this.entityId,
    this.route,
    required this.timestamp,
  });

  String get timeAgo {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inMinutes < 1) return 'À l\'instant';
    if (diff.inMinutes < 60) return 'Il y a ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'Il y a ${diff.inHours}h';
    if (diff.inDays < 7) return 'Il y a ${diff.inDays}j';
    return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
  }

  factory ActivityItem.fromJson(Map<String, dynamic> json) {
    return ActivityItem(
      id: json['id'] as String,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      type: ActivityType.fromString(json['type'] as String? ?? 'general'),
      actorName: json['actor_name'] as String?,
      actorAvatarUrl: json['actor_avatar_url'] as String?,
      entityId: json['entity_id'] as String?,
      route: json['route'] as String?,
      timestamp: DateTime.parse(
        json['timestamp'] as String? ??
            json['created_at'] as String? ??
            DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.name,
      'actor_name': actorName,
      'actor_avatar_url': actorAvatarUrl,
      'entity_id': entityId,
      'route': route,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  ActivityItem copyWith({
    String? id,
    String? title,
    String? description,
    ActivityType? type,
    String? actorName,
    String? actorAvatarUrl,
    String? entityId,
    String? route,
    DateTime? timestamp,
  }) {
    return ActivityItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      actorName: actorName ?? this.actorName,
      actorAvatarUrl: actorAvatarUrl ?? this.actorAvatarUrl,
      entityId: entityId ?? this.entityId,
      route: route ?? this.route,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivityItem &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

enum ActivityType {
  memberJoined,
  memberAdd,
  transactionCreated,
  transactionApproved,
  transactionRejected,
  eventCreated,
  eventUpdated,
  event,
  announcementPublished,
  prayerRequestCreated,
  attendanceRecorded,
  groupUpdated,
  system,
  task,
  general;

  static ActivityType fromString(String value) {
    return switch (value) {
      'member_joined' => ActivityType.memberJoined,
      'member_add' => ActivityType.memberAdd,
      'transaction_created' => ActivityType.transactionCreated,
      'transaction_approved' => ActivityType.transactionApproved,
      'transaction_rejected' => ActivityType.transactionRejected,
      'event_created' => ActivityType.eventCreated,
      'event_updated' => ActivityType.eventUpdated,
      'event' => ActivityType.event,
      'announcement_published' => ActivityType.announcementPublished,
      'prayer_request_created' => ActivityType.prayerRequestCreated,
      'attendance_recorded' => ActivityType.attendanceRecorded,
      'group_updated' => ActivityType.groupUpdated,
      'system' => ActivityType.system,
      'task' => ActivityType.task,
      _ => ActivityType.general,
    };
  }

  IconData get icon => switch (this) {
        ActivityType.memberJoined || ActivityType.memberAdd => Icons.person_add_rounded,
        ActivityType.transactionCreated => Icons.receipt_long_rounded,
        ActivityType.transactionApproved => Icons.check_circle_rounded,
        ActivityType.transactionRejected => Icons.cancel_rounded,
        ActivityType.eventCreated || ActivityType.eventUpdated || ActivityType.event => Icons.event_rounded,
        ActivityType.announcementPublished => Icons.campaign_rounded,
        ActivityType.prayerRequestCreated => Icons.volunteer_activism_rounded,
        ActivityType.attendanceRecorded => Icons.how_to_reg_rounded,
        ActivityType.groupUpdated => Icons.group_work_rounded,
        ActivityType.system => Icons.settings_suggest_rounded,
        ActivityType.task => Icons.task_alt_rounded,
        ActivityType.general => Icons.info_outline_rounded,
      };

  Color get color => switch (this) {
        ActivityType.memberJoined || ActivityType.memberAdd => const Color(0xFF22C55E),
        ActivityType.transactionCreated => const Color(0xFF3B82F6),
        ActivityType.transactionApproved => const Color(0xFF22C55E),
        ActivityType.transactionRejected => const Color(0xFFEF4444),
        ActivityType.eventCreated || ActivityType.eventUpdated || ActivityType.event => const Color(0xFFA855F7),
        ActivityType.announcementPublished => const Color(0xFFF59E0B),
        ActivityType.prayerRequestCreated => const Color(0xFFEC4899),
        ActivityType.attendanceRecorded => const Color(0xFF14B8A6),
        ActivityType.groupUpdated => const Color(0xFF6366F1),
        ActivityType.system => const Color(0xFF64748B),
        ActivityType.task => const Color(0xFFF59E0B),
        ActivityType.general => const Color(0xFF94A3B8),
      };

  String get label => switch (this) {
        ActivityType.memberJoined || ActivityType.memberAdd => 'Nouveau membre',
        ActivityType.transactionCreated => 'Transaction',
        ActivityType.transactionApproved => 'Approuvée',
        ActivityType.transactionRejected => 'Rejetée',
        ActivityType.eventCreated || ActivityType.event => 'Événement créé',
        ActivityType.eventUpdated => 'Événement modifié',
        ActivityType.announcementPublished => 'Annonce',
        ActivityType.prayerRequestCreated => 'Prière',
        ActivityType.attendanceRecorded => 'Présence',
        ActivityType.groupUpdated => 'Groupe modifié',
        ActivityType.system => 'Système',
        ActivityType.task => 'Tâche',
        ActivityType.general => 'Activité',
      };
}
