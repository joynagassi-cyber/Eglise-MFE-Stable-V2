import 'dart:convert';
import 'package:isar/isar.dart';
import '../../domain/entities/group_attendance.dart';

part 'group_attendance_model.g.dart';

@collection
class GroupAttendanceModel {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String originalId;

  @Index()
  late String groupId;

  @Index()
  late String churchId;

  @Index()
  late String memberId;

  @Index()
  late DateTime attendanceDate;

  @Enumerated(EnumType.name)
  late AttendanceStatus status;

  String? notes;

  DateTime? createdAt;
  DateTime? updatedAt;

  DateTime? lastSyncedAt;
  bool isDirty = false;

  String? jsonData;

  GroupAttendance toDomain() {
    if (jsonData != null && jsonData!.isNotEmpty) {
      try {
        return GroupAttendance.fromJson(jsonDecode(jsonData!));
      } catch (_) { /* jsonData corrupted -- fallback Isar fields */ }
    }
    return GroupAttendance(
      id: originalId,
      churchId: churchId,
      groupId: groupId,
      memberId: memberId,
      attendanceDate: attendanceDate,
      status: status,
      notes: notes,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static GroupAttendanceModel fromDomain(GroupAttendance domain) {
    return GroupAttendanceModel()
      ..originalId = domain.id
      ..churchId = domain.churchId
      ..groupId = domain.groupId
      ..memberId = domain.memberId
      ..attendanceDate = domain.attendanceDate
      ..status = domain.status
      ..notes = domain.notes
      ..createdAt = domain.createdAt
      ..updatedAt = domain.updatedAt
      ..jsonData = jsonEncode(domain.toJson());
  }
}