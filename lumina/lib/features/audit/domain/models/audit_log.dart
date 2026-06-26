// lib/features/audit/domain/models/audit_log.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/domain/entities/enums/audit_action.dart';

part 'audit_log.freezed.dart';
part 'audit_log.g.dart';
// ignore_for_file: invalid_annotation_target

@freezed
class AuditLog with _$AuditLog {
  const AuditLog._();

  const factory AuditLog({
    required String id,
    @JsonKey(name: 'entity_type') required String entityType,
    @JsonKey(name: 'entity_id') required String entityId,
    required AuditAction action,
    @JsonKey(name: 'old_value') Map<String, dynamic>? oldData,
    @JsonKey(name: 'new_value') Map<String, dynamic>? newData,
    @JsonKey(name: 'actor_id') String? actorId,
    @JsonKey(name: 'ip_address') String? ipAddress,
    @JsonKey(name: 'user_agent') String? userAgent,
    Map<String, dynamic>? metadata,
    @JsonKey(name: 'occurred_at') required DateTime occurredAt,
  }) = _AuditLog;

  factory AuditLog.fromJson(Map<String, dynamic> json) =>
      _$AuditLogFromJson(json);

  String get summary => '${action.label} sur $entityType';

  String get actorName =>
      metadata?['actor_name'] as String? ?? 'Utilisateur inconnu';
  String get roleUsed => metadata?['role_used'] as String? ?? 'N/A';
  String get dashboardSource =>
      metadata?['dashboard_source'] as String? ?? 'Principal';

  bool get isDataModification =>
      action == AuditAction.insert ||
      action == AuditAction.update ||
      action == AuditAction.delete;
}