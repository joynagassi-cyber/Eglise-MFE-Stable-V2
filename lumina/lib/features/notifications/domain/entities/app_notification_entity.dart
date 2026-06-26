import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_notification_entity.freezed.dart';
part 'app_notification_entity.g.dart';

@freezed
class AppNotificationEntity with _$AppNotificationEntity {
  const factory AppNotificationEntity({
    required String id,
    required String userId,
    required String title,
    required String message,
    required String type,
    String? linkUrl,
    @Default({}) Map<String, dynamic> payload,
    @Default(false) bool isRead,
    DateTime? readAt,
    @Default('NORMAL') String priority,
    DateTime? createdAt,
  }) = _AppNotificationEntity;

  factory AppNotificationEntity.fromJson(Map<String, dynamic> json) =>
      _$AppNotificationEntityFromJson(json);
}