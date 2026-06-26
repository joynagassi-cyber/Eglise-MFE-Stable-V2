import 'package:freezed_annotation/freezed_annotation.dart';

part 'group_attendance.freezed.dart';
part 'group_attendance.g.dart';
// ignore_for_file: invalid_annotation_target

enum AttendanceStatus {
  @JsonValue('PRESENT')
  present,
  @JsonValue('ABSENT')
  absent,
  @JsonValue('LATE')
  late,
  @JsonValue('EXCUSED')
  excused,
}

@freezed
class GroupAttendance with _$GroupAttendance {
  const factory GroupAttendance({
    required String id,
    @JsonKey(name: 'church_id') required String churchId,
    @JsonKey(name: 'group_id') required String groupId,
    @JsonKey(name: 'member_id') required String memberId,
    @JsonKey(name: 'attendance_date') required DateTime attendanceDate,
    @Default(AttendanceStatus.present)
    @JsonKey(unknownEnumValue: AttendanceStatus.present)
    AttendanceStatus status,
    String? notes,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _GroupAttendance;

  factory GroupAttendance.fromJson(Map<String, dynamic> json) =>
      _$GroupAttendanceFromJson(json);
}