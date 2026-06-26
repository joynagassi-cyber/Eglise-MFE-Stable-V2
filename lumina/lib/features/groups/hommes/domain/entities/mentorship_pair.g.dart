// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mentorship_pair.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MentorshipPairImpl _$$MentorshipPairImplFromJson(Map<String, dynamic> json) =>
    _$MentorshipPairImpl(
      id: json['id'] as String,
      groupId: json['group_id'] as String,
      churchId: json['church_id'] as String,
      mentorId: json['mentor_id'] as String,
      menteeId: json['mentee_id'] as String,
      status: $enumDecodeNullable(_$MentorshipStatusEnumMap, json['status']) ??
          MentorshipStatus.active,
      nextSessionAt: json['next_session_at'] == null
          ? null
          : DateTime.parse(json['next_session_at'] as String),
      lastSessionAt: json['last_session_at'] == null
          ? null
          : DateTime.parse(json['last_session_at'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      mentorName: json['mentor_name'] as String?,
      menteeName: json['mentee_name'] as String?,
    );

Map<String, dynamic> _$$MentorshipPairImplToJson(
        _$MentorshipPairImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'group_id': instance.groupId,
      'church_id': instance.churchId,
      'mentor_id': instance.mentorId,
      'mentee_id': instance.menteeId,
      'status': _$MentorshipStatusEnumMap[instance.status]!,
      'next_session_at': instance.nextSessionAt?.toIso8601String(),
      'last_session_at': instance.lastSessionAt?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'mentor_name': instance.mentorName,
      'mentee_name': instance.menteeName,
    };

const _$MentorshipStatusEnumMap = {
  MentorshipStatus.active: 'active',
  MentorshipStatus.completed: 'completed',
  MentorshipStatus.terminated: 'terminated',
};
