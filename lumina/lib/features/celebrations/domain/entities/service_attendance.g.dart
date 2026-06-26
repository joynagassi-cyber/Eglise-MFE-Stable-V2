// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_attendance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ServiceAttendanceImpl _$$ServiceAttendanceImplFromJson(
        Map<String, dynamic> json) =>
    _$ServiceAttendanceImpl(
      id: json['id'] as String,
      serviceId: json['service_id'] as String,
      memberId: json['member_id'] as String,
      memberName: json['member_name'] as String?,
      checkInTime: json['check_in_time'] == null
          ? null
          : DateTime.parse(json['check_in_time'] as String),
      isPresent: json['is_present'] as bool? ?? true,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$$ServiceAttendanceImplToJson(
        _$ServiceAttendanceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'service_id': instance.serviceId,
      'member_id': instance.memberId,
      'member_name': instance.memberName,
      'check_in_time': instance.checkInTime?.toIso8601String(),
      'is_present': instance.isPresent,
      'notes': instance.notes,
    };
