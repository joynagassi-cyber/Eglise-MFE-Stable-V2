import 'dart:convert';
import 'package:isar/isar.dart';
import '../../domain/entities/service_attendance.dart';

part 'service_attendance_model.g.dart';

@collection
class ServiceAttendanceModel {
  Id isarId = Isar.autoIncrement; // Isar ID

  @Index(unique: true, replace: true)
  late String id; // UUID principal

  @Index(composite: [CompositeIndex('memberId')], unique: true)
  late String serviceId;

  late String memberId;

  String? memberName;
  DateTime? checkInTime;
  bool isPresent = true;
  String? notes;

  DateTime? createdAt;
  DateTime? updatedAt;

  // Sync fields
  bool isSynced = true;
  bool isDeleted = false;

  String? jsonData;

  ServiceAttendance toEntity() {
    if (jsonData != null && jsonData!.isNotEmpty) {
      try {
        return ServiceAttendance.fromJson(jsonDecode(jsonData!));
      } catch (_) { /* jsonData corrupted -- fallback Isar fields */ }
    }
    return ServiceAttendance(
      id: id.toString(), // Or use a separate remoteId field if needed
      serviceId: serviceId,
      memberId: memberId,
      memberName: memberName,
      checkInTime: checkInTime,
      isPresent: isPresent,
      notes: notes,
    );
  }

  static ServiceAttendanceModel fromEntity(ServiceAttendance entity) {
    final model = ServiceAttendanceModel();
    // For Isar, we might want to generate a consistent ID based on serviceId and memberId
    // to avoid duplicates in local DB
    model.isarId = Isar.autoIncrement;
    model.serviceId = entity.serviceId;
    model.memberId = entity.memberId;
    model.memberName = entity.memberName;
    model.checkInTime = entity.checkInTime;
    model.isPresent = entity.isPresent;
    model.notes = entity.notes;

    // Default sync state for items being saved locally first
    model.isSynced = false;
    model.jsonData = jsonEncode(entity.toJson());

    return model;
  }
}