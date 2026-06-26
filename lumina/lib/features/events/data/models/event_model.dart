import 'dart:convert';
import 'package:isar/isar.dart';
import '../../domain/entities/event.dart';
import '../../domain/entities/event_type.dart';

part 'event_model.g.dart';

@collection
class EventModel {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String id;

  @Index()
  late String churchId;

  @Index()
  late String typeId;

  @Index()
  late DateTime date;

  DateTime? endDate;

  @Index(caseSensitive: false)
  String? title;
  @Index(caseSensitive: false)
  String? description;
  String? location;
  String? managerId;
  String? officiantName;
  int? estimatedParticipants;
  int? actualParticipants;
  int? maxSeats;
  double? estimatedBudget;
  double? actualBudget;
  String? budgetAccountId;
  List<String> participantsIds = [];
  late String status;
  late String color;
  String? notes;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? createdBy;
  String? updatedBy;

  int version = 1;
  String deviceId = 'unknown';

  bool isDeleted = false;
  DateTime? deletedAt;
  String? deletedBy;

  DateTime? lastSyncedAt;

  String? jsonData;

  static EventModel fromDomain(Event event) {
    return EventModel()
      ..id = event.id
      ..churchId = event.churchId
      ..typeId = event.type.value
      ..date = event.date
      ..endDate = event.endDate
      ..title = event.title
      ..description = event.description
      ..location = event.location
      ..managerId = event.managerId
      ..officiantName = event.officiantName
      ..estimatedParticipants = event.estimatedParticipants
      ..actualParticipants = event.actualParticipants
      ..maxSeats = event.maxSeats
      ..estimatedBudget = event.estimatedBudget
      ..actualBudget = event.actualBudget
      ..budgetAccountId = event.budgetAccountId
      ..participantsIds = event.participantsIds
      ..status = event.status
      ..color = event.color
      ..notes = event.notes
      ..createdAt = event.createdAt
      ..updatedAt = event.updatedAt
      ..createdBy = event.createdBy
      ..updatedBy = event.updatedBy
      ..lastSyncedAt = DateTime.now()
      ..jsonData = jsonEncode(event.toJson());
  }

  Event toDomain() {
    if (jsonData != null && jsonData!.isNotEmpty) {
      try {
        return Event.fromJson(jsonDecode(jsonData!));
      } catch (_) { /* jsonData corrupted -- fallback Isar fields */ }
    }
    return Event(
      id: id,
      churchId: churchId,
      type: EventType.fromString(typeId),
      date: date,
      endDate: endDate,
      title: title ?? '',
      description: description,
      location: location,
      managerId: managerId,
      officiantName: officiantName,
      estimatedParticipants: estimatedParticipants,
      actualParticipants: actualParticipants,
      maxSeats: maxSeats,
      estimatedBudget: estimatedBudget,
      actualBudget: actualBudget,
      budgetAccountId: budgetAccountId,
      participantsIds: participantsIds,
      status: status,
      color: color,
      notes: notes,
      createdAt: createdAt,
      updatedAt: updatedAt,
      createdBy: createdBy,
      updatedBy: updatedBy,
    );
  }
}