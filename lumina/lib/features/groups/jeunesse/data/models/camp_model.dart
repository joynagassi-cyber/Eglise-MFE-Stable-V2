import 'dart:convert';
import 'package:isar/isar.dart';
import '../../domain/entities/camp.dart';

part 'camp_model.g.dart';

@collection
class CampModel {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String id;

  @Index()
  late String churchId;

  @Index()
  late String groupId;

  late String name;
  String? description;
  late DateTime startDate;
  late DateTime endDate;
  String? eventId;
  late double budgetTarget;
  late double budgetActual;
  late int capacity;
  late int registeredCount;
  late String themeColor;

  @enumerated
  late CampStatus status;

  DateTime? createdAt;
  DateTime? updatedAt;

  bool isDeleted = false;
  DateTime? lastSyncedAt;
  String? jsonData;

  static CampModel fromDomain(Camp camp) {
    return CampModel()
      ..id = camp.id
      ..churchId = camp.churchId
      ..groupId = camp.groupId
      ..name = camp.name
      ..description = camp.description
      ..startDate = camp.startDate
      ..endDate = camp.endDate
      ..eventId = camp.eventId
      ..budgetTarget = camp.budgetTarget
      ..budgetActual = camp.budgetActual
      ..capacity = camp.capacity
      ..registeredCount = camp.registeredCount
      ..themeColor = camp.themeColor
      ..status = camp.status
      ..createdAt = camp.createdAt
      ..updatedAt = camp.updatedAt
      ..lastSyncedAt = DateTime.now()
      ..jsonData = jsonEncode(camp.toJson());
  }

  Camp toDomain() {
    if (jsonData != null && jsonData!.isNotEmpty) {
      try {
        return Camp.fromJson(jsonDecode(jsonData!));
      } catch (_) { /* jsonData corrupted -- fallback Isar fields */ }
    }
    return Camp(
      id: id,
      churchId: churchId,
      groupId: groupId,
      name: name,
      description: description,
      startDate: startDate,
      endDate: endDate,
      eventId: eventId,
      budgetTarget: budgetTarget,
      budgetActual: budgetActual,
      capacity: capacity,
      registeredCount: registeredCount,
      themeColor: themeColor,
      status: status,
      createdAt: createdAt ?? DateTime.now(),
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}