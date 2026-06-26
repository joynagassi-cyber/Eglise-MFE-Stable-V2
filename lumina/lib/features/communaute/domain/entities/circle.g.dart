// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'circle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CircleImpl _$$CircleImplFromJson(Map<String, dynamic> json) => _$CircleImpl(
      id: json['id'] as String,
      churchId: json['church_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      iconName: json['icon_name'] as String? ?? 'group',
      colorHex: json['color_hex'] as String? ?? '#7C4DFF',
      memberCount: (json['member_count'] as num?)?.toInt() ?? 0,
      isPrivate: json['is_private'] as bool? ?? false,
      isSynced: json['is_synced'] as bool? ?? true,
      createdBy: json['created_by'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$CircleImplToJson(_$CircleImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'church_id': instance.churchId,
      'name': instance.name,
      'description': instance.description,
      'icon_name': instance.iconName,
      'color_hex': instance.colorHex,
      'member_count': instance.memberCount,
      'is_private': instance.isPrivate,
      'is_synced': instance.isSynced,
      'created_by': instance.createdBy,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

_$CircleMemberImpl _$$CircleMemberImplFromJson(Map<String, dynamic> json) =>
    _$CircleMemberImpl(
      circleId: json['circle_id'] as String,
      memberId: json['member_id'] as String,
      role: json['role'] as String? ?? 'member',
      joinedAt: json['joined_at'] == null
          ? null
          : DateTime.parse(json['joined_at'] as String),
      memberName: json['member_name'] as String?,
      memberPhotoUrl: json['member_photo_url'] as String?,
    );

Map<String, dynamic> _$$CircleMemberImplToJson(_$CircleMemberImpl instance) =>
    <String, dynamic>{
      'circle_id': instance.circleId,
      'member_id': instance.memberId,
      'role': instance.role,
      'joined_at': instance.joinedAt?.toIso8601String(),
      'member_name': instance.memberName,
      'member_photo_url': instance.memberPhotoUrl,
    };
