// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shepherd.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ShepherdImpl _$$ShepherdImplFromJson(Map<String, dynamic> json) =>
    _$ShepherdImpl(
      id: json['id'] as String,
      churchId: json['church_id'] as String,
      memberId: json['member_id'] as String,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      photoUrl: json['photo_url'] as String?,
      level: json['level'] as String? ?? 'DEBUTANT',
      specialties: (json['specialties'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      supervisedGroupIds: (json['supervised_group_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      bio: json['bio'] as String?,
      ordainedAt: json['ordained_at'] == null
          ? null
          : DateTime.parse(json['ordained_at'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$ShepherdImplToJson(_$ShepherdImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'church_id': instance.churchId,
      'member_id': instance.memberId,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'photo_url': instance.photoUrl,
      'level': instance.level,
      'specialties': instance.specialties,
      'supervised_group_ids': instance.supervisedGroupIds,
      'bio': instance.bio,
      'ordained_at': instance.ordainedAt?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
