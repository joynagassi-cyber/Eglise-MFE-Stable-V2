// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuditLogImpl _$$AuditLogImplFromJson(Map<String, dynamic> json) =>
    _$AuditLogImpl(
      id: json['id'] as String,
      entityType: json['entity_type'] as String,
      entityId: json['entity_id'] as String,
      action: $enumDecode(_$AuditActionEnumMap, json['action']),
      oldData: json['old_value'] as Map<String, dynamic>?,
      newData: json['new_value'] as Map<String, dynamic>?,
      actorId: json['actor_id'] as String?,
      ipAddress: json['ip_address'] as String?,
      userAgent: json['user_agent'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      occurredAt: DateTime.parse(json['occurred_at'] as String),
    );

Map<String, dynamic> _$$AuditLogImplToJson(_$AuditLogImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'entity_type': instance.entityType,
      'entity_id': instance.entityId,
      'action': _$AuditActionEnumMap[instance.action]!,
      'old_value': instance.oldData,
      'new_value': instance.newData,
      'actor_id': instance.actorId,
      'ip_address': instance.ipAddress,
      'user_agent': instance.userAgent,
      'metadata': instance.metadata,
      'occurred_at': instance.occurredAt.toIso8601String(),
    };

const _$AuditActionEnumMap = {
  AuditAction.insert: 'insert',
  AuditAction.update: 'update',
  AuditAction.delete: 'delete',
  AuditAction.login: 'login',
  AuditAction.logout: 'logout',
  AuditAction.register: 'register',
  AuditAction.upload: 'upload',
  AuditAction.seal: 'seal',
  AuditAction.export_: 'export_',
  AuditAction.backup: 'backup',
};
