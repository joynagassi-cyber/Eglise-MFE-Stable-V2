// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'module.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ModuleImpl _$$ModuleImplFromJson(Map<String, dynamic> json) => _$ModuleImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      code: json['code'] as String? ?? '',
      description: json['description'] as String,
      icon: json['icon'] as String,
      category: $enumDecode(_$ModuleCategoryEnumMap, json['category']),
      order: (json['order'] as num).toInt(),
      visibility: $enumDecode(_$ModuleVisibilityEnumMap, json['visibility']),
      requiredPermissions: (json['required_permissions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isPublicTeam: json['is_public_team'] as bool? ?? false,
      routes: (json['routes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      isActive: json['is_active'] as bool? ?? true,
    );

Map<String, dynamic> _$$ModuleImplToJson(_$ModuleImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'code': instance.code,
      'description': instance.description,
      'icon': instance.icon,
      'category': _$ModuleCategoryEnumMap[instance.category]!,
      'order': instance.order,
      'visibility': _$ModuleVisibilityEnumMap[instance.visibility]!,
      'required_permissions': instance.requiredPermissions,
      'is_public_team': instance.isPublicTeam,
      'routes': instance.routes,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'is_active': instance.isActive,
    };

const _$ModuleCategoryEnumMap = {
  ModuleCategory.community: 'community',
  ModuleCategory.organization: 'organization',
  ModuleCategory.administration: 'administration',
  ModuleCategory.spiritual: 'spiritual',
};

const _$ModuleVisibilityEnumMap = {
  ModuleVisibility.public: 'public',
  ModuleVisibility.team: 'team',
  ModuleVisibility.private: 'private',
  ModuleVisibility.superAdmin: 'super_admin',
};
