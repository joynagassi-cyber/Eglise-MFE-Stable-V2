import 'dart:convert';
import 'package:isar/isar.dart';
import '../../domain/entities/group.dart';

part 'group_model.g.dart';

@collection
class GroupModel {
  Id isarId = Isar.autoIncrement;

  @Index()
  late String churchId;

  @Index(unique: true, replace: true)
  late String originalId;

  @Index(caseSensitive: false)
  late String name;
  String? description;

  @Enumerated(EnumType.name)
  late GroupType type;

  String? leaderId;

  @Index(caseSensitive: false)
  String? location;
  String? scheduleDescription;

  DateTime? createdAt;
  DateTime? updatedAt;
  bool isActive = true;

  DateTime? lastSyncedAt;
  bool isDirty = false;
  
  int version = 1;
  String deviceId = 'unknown';
  String createdBy = 'unknown';
  String updatedBy = 'unknown';

  bool isDeleted = false;
  DateTime? deletedAt;
  String? deletedBy;

  String? jsonData;

  Group toDomain() {
    if (jsonData != null && jsonData!.isNotEmpty) {
      try {
        return Group.fromJson(jsonDecode(jsonData!));
      } catch (_) { /* jsonData corrupted -- fallback Isar fields */ }
    }
    return Group(
      id: originalId,
      churchId: churchId,
      name: name,
      description: description,
      type: type,
      leaderId: leaderId,
      location: location,
      scheduleDescription: scheduleDescription,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isActive: isActive,
    );
  }

  static GroupModel fromDomain(Group group) {
    return GroupModel()
      ..originalId = group.id
      ..churchId = group.churchId
      ..name = group.name
      ..description = group.description
      ..type = group.type
      ..leaderId = group.leaderId
      ..location = group.location
      ..scheduleDescription = group.scheduleDescription
      ..createdAt = group.createdAt
      ..updatedAt = group.updatedAt
      ..isActive = group.isActive
      ..jsonData = jsonEncode(group.toJson());
  }
}