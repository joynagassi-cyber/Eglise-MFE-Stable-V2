import 'dart:convert';
import 'package:isar/isar.dart';
import '../../domain/entities/discipleship_program.dart';

part 'discipleship_program_model.g.dart';

@collection
class DiscipleshipProgramModel {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String id;

  @Index()
  late String churchId;

  @Index()
  late String groupId;

  late String title;
  String? description;
  String? mentorId;
  late String menteeId;
  late int progressPercentage;

  @enumerated
  late DiscipleshipStatus status;

  late DateTime startDate;
  DateTime? lastMeetingDate;
  DateTime? createdAt;
  DateTime? updatedAt;

  bool isDeleted = false;
  DateTime? lastSyncedAt;
  String? jsonData;

  static DiscipleshipProgramModel fromDomain(DiscipleshipProgram program) {
    return DiscipleshipProgramModel()
      ..id = program.id
      ..churchId = program.churchId
      ..groupId = program.groupId
      ..title = program.title
      ..description = program.description
      ..mentorId = program.mentorId
      ..menteeId = program.menteeId
      ..progressPercentage = program.progressPercentage
      ..status = program.status
      ..startDate = program.startDate
      ..lastMeetingDate = program.lastMeetingDate
      ..createdAt = program.createdAt
      ..updatedAt = program.updatedAt
      ..lastSyncedAt = DateTime.now()
      ..jsonData = jsonEncode(program.toJson());
  }

  DiscipleshipProgram toDomain() {
    if (jsonData != null && jsonData!.isNotEmpty) {
      try {
        return DiscipleshipProgram.fromJson(jsonDecode(jsonData!));
      } catch (_) { /* jsonData corrupted -- fallback Isar fields */ }
    }
    return DiscipleshipProgram(
      id: id,
      churchId: churchId,
      groupId: groupId,
      title: title,
      description: description,
      mentorId: mentorId,
      menteeId: menteeId,
      progressPercentage: progressPercentage,
      status: status,
      startDate: startDate,
      lastMeetingDate: lastMeetingDate,
      createdAt: createdAt ?? DateTime.now(),
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}