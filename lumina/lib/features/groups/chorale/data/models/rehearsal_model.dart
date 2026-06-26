import 'dart:convert';
import 'package:isar/isar.dart';
import '../../domain/entities/rehearsal.dart';

part 'rehearsal_model.g.dart';

@collection
class RehearsalModel {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String id;

  @Index()
  late DateTime date;

  String? location;
  String? description;

  @Index()
  late String groupId;

  @Index()
  late String churchId;

  String? eventId;

  int attendanceCount = 0;

  DateTime? createdAt;

  bool isDeleted = false;
  DateTime? lastSyncedAt;

  String? jsonData;

  static RehearsalModel fromDomain(Rehearsal rehearsal) {
    return RehearsalModel()
      ..id = rehearsal.id
      ..date = rehearsal.date
      ..location = rehearsal.location
      ..description = rehearsal.description
      ..groupId = rehearsal.groupId
      ..churchId = rehearsal.churchId
      ..eventId = rehearsal.eventId
      ..attendanceCount = rehearsal.attendanceCount
      ..createdAt = rehearsal.createdAt
      ..lastSyncedAt = DateTime.now()
      ..jsonData = jsonEncode(rehearsal.toJson());
  }

  Rehearsal toDomain() {
    if (jsonData != null && jsonData!.isNotEmpty) {
      try {
        return Rehearsal.fromJson(jsonDecode(jsonData!));
      } catch (_) { /* jsonData corrupted -- fallback Isar fields */ }
    }
    return Rehearsal(
      id: id,
      date: date,
      location: location,
      description: description,
      groupId: groupId,
      churchId: churchId,
      eventId: eventId,
      attendanceCount: attendanceCount,
      createdAt: createdAt,
    );
  }
}