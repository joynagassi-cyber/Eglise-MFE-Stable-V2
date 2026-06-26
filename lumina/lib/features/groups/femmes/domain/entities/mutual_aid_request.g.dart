// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mutual_aid_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MutualAidRequestImpl _$$MutualAidRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$MutualAidRequestImpl(
      id: json['id'] as String,
      churchId: json['church_id'] as String,
      groupId: json['group_id'] as String,
      requesterId: json['requester_id'] as String,
      type: json['type'] as String,
      description: json['description'] as String?,
      status: json['status'] as String? ?? 'active',
      responsesCount: (json['responses_count'] as num?)?.toInt() ?? 0,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$MutualAidRequestImplToJson(
        _$MutualAidRequestImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'church_id': instance.churchId,
      'group_id': instance.groupId,
      'requester_id': instance.requesterId,
      'type': instance.type,
      'description': instance.description,
      'status': instance.status,
      'responses_count': instance.responsesCount,
      'created_at': instance.createdAt?.toIso8601String(),
    };
