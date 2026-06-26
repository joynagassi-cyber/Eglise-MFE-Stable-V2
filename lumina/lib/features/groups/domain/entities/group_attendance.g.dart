// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_attendance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GroupAttendanceImpl _$$GroupAttendanceImplFromJson(
        Map<String, dynamic> json) =>
    _$GroupAttendanceImpl(
      id: json['id'] as String,
      churchId: json['church_id'] as String,
      groupId: json['group_id'] as String,
      memberId: json['member_id'] as String,
      attendanceDate: DateTime.parse(json['attendance_date'] as String),
      status: $enumDecodeNullable(_$AttendanceStatusEnumMap, json['status'],
              unknownValue: AttendanceStatus.present) ??
          AttendanceStatus.present,
      notes: json['notes'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$GroupAttendanceImplToJson(
        _$GroupAttendanceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'church_id': instance.churchId,
      'group_id': instance.groupId,
      'member_id': instance.memberId,
      'attendance_date': instance.attendanceDate.toIso8601String(),
      'status': _$AttendanceStatusEnumMap[instance.status]!,
      'notes': instance.notes,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

const _$AttendanceStatusEnumMap = {
  AttendanceStatus.present: 'PRESENT',
  AttendanceStatus.absent: 'ABSENT',
  AttendanceStatus.late: 'LATE',
  AttendanceStatus.excused: 'EXCUSED',
};
