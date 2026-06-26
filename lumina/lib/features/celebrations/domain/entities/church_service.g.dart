// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'church_service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChurchServiceImpl _$$ChurchServiceImplFromJson(Map<String, dynamic> json) =>
    _$ChurchServiceImpl(
      id: json['id'] as String,
      churchId: json['church_id'] as String,
      type: $enumDecode(_$ServiceTypeEnumMap, json['type']),
      date: DateTime.parse(json['date'] as String),
      title: json['title'] as String?,
      theme: json['theme'] as String?,
      preacherId: json['preacher_id'] as String?,
      preacherName: json['preacher_name'] as String?,
      attendanceCount: (json['attendance_count'] as num?)?.toInt() ?? 0,
      menCount: (json['men_count'] as num?)?.toInt() ?? 0,
      womenCount: (json['women_count'] as num?)?.toInt() ?? 0,
      childrenCount: (json['children_count'] as num?)?.toInt() ?? 0,
      menVisitorsCount: (json['men_visitors_count'] as num?)?.toInt() ?? 0,
      womenVisitorsCount: (json['women_visitors_count'] as num?)?.toInt() ?? 0,
      childrenVisitorsCount:
          (json['children_visitors_count'] as num?)?.toInt() ?? 0,
      notes:
          (json['notes'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      isCompleted: json['is_completed'] as bool? ?? false,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$ChurchServiceImplToJson(_$ChurchServiceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'church_id': instance.churchId,
      'type': _$ServiceTypeEnumMap[instance.type]!,
      'date': instance.date.toIso8601String(),
      'title': instance.title,
      'theme': instance.theme,
      'preacher_id': instance.preacherId,
      'preacher_name': instance.preacherName,
      'attendance_count': instance.attendanceCount,
      'men_count': instance.menCount,
      'women_count': instance.womenCount,
      'children_count': instance.childrenCount,
      'men_visitors_count': instance.menVisitorsCount,
      'women_visitors_count': instance.womenVisitorsCount,
      'children_visitors_count': instance.childrenVisitorsCount,
      'notes': instance.notes,
      'is_completed': instance.isCompleted,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

const _$ServiceTypeEnumMap = {
  ServiceType.sundayService: 'sundayService',
  ServiceType.prayerMeeting: 'prayerMeeting',
  ServiceType.youthService: 'youthService',
  ServiceType.childrenService: 'childrenService',
  ServiceType.specialEvent: 'specialEvent',
};
