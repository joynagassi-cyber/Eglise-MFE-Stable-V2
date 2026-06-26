import 'package:freezed_annotation/freezed_annotation.dart';

part 'service_attendance.freezed.dart';
part 'service_attendance.g.dart';

@freezed
class ServiceAttendance with _$ServiceAttendance {
  const factory ServiceAttendance({
    required String id,
    required String serviceId,
    required String memberId,
    String? memberName, // Snapshot in case member is deleted
    DateTime? checkInTime,
    @Default(true) bool isPresent,
    String? notes,
  }) = _ServiceAttendance;

  factory ServiceAttendance.fromJson(Map<String, dynamic> json) =>
      _$ServiceAttendanceFromJson(json);
}