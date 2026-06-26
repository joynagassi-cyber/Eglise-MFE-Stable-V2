// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rbac_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PermissionImpl _$$PermissionImplFromJson(Map<String, dynamic> json) =>
    _$PermissionImpl(
      id: json['id'] as String,
      code: json['code'] as String,
      label: json['label'] as String,
      description: json['description'] as String?,
      module: json['module'] as String,
      category: json['category'] as String,
      isSensitive: json['is_sensitive'] as bool? ?? false,
    );

Map<String, dynamic> _$$PermissionImplToJson(_$PermissionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'label': instance.label,
      'description': instance.description,
      'module': instance.module,
      'category': instance.category,
      'is_sensitive': instance.isSensitive,
    };

_$RoleImpl _$$RoleImplFromJson(Map<String, dynamic> json) => _$RoleImpl(
      id: json['id'] as String,
      code: json['code'] as String,
      label: json['label'] as String,
      isSuper: json['is_super'] as bool? ?? false,
      priorityLevel: (json['priority_level'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$RoleImplToJson(_$RoleImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'label': instance.label,
      'is_super': instance.isSuper,
      'priority_level': instance.priorityLevel,
    };
