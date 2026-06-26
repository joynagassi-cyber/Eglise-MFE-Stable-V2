import 'dart:convert';
import 'package:isar/isar.dart';
import '../../domain/entities/app_notification_entity.dart';

part 'notification_model.g.dart';

@collection
class NotificationModel {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String remoteId;

  late String userId;
  late String title;
  late String message;
  late String type;
  String? linkUrl;
  String? payloadJson; // JSON-encoded payload
  bool isRead = false;
  DateTime? readAt;
  String priority = 'NORMAL';
  DateTime? createdAt;

  // Pattern Local-First 2026
  int version = 1;
  bool isDeleted = false;
  String deviceId = 'unknown';

  // Sync fields
  bool isSynced = true;
  DateTime? lastSyncedAt;

  String? jsonData;

  AppNotificationEntity toEntity() {
    if (jsonData != null && jsonData!.isNotEmpty) {
      try {
        return AppNotificationEntity.fromJson(jsonDecode(jsonData!));
      } catch (_) { /* jsonData corrupted -- fallback Isar fields */ }
    }
    Map<String, dynamic> payload = {};
    if (payloadJson != null && payloadJson!.isNotEmpty) {
      try {
        payload = Map<String, dynamic>.from(
          Uri.splitQueryString(payloadJson!),
        );
      } catch (_) { /* jsonData corrupted -- fallback Isar fields */ }
    }

    return AppNotificationEntity(
      id: remoteId,
      userId: userId,
      title: title,
      message: message,
      type: type,
      linkUrl: linkUrl,
      payload: payload,
      isRead: isRead,
      readAt: readAt,
      priority: priority,
      createdAt: createdAt ?? DateTime.now(),
    );
  }

  static NotificationModel fromEntity(AppNotificationEntity entity) {
    final model = NotificationModel()
      ..isarId = Isar.autoIncrement
      ..remoteId = entity.id
      ..userId = entity.userId
      ..title = entity.title
      ..message = entity.message
      ..type = entity.type
      ..linkUrl = entity.linkUrl
      ..isRead = entity.isRead
      ..readAt = entity.readAt
      ..priority = entity.priority
      ..createdAt = entity.createdAt
      ..isSynced = false;

    // Encode payload as query string for simple Isar storage
    if (entity.payload.isNotEmpty) {
      model.payloadJson =
          entity.payload.entries.map((e) => '${e.key}=${e.value}').join('&');
    }

    model.jsonData = jsonEncode(entity.toJson());

    return model;
  }
}