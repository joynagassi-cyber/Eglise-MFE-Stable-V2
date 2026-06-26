import 'dart:convert';
import 'package:isar/isar.dart';
import '../../domain/entities/group_project.dart';

part 'group_project_model.g.dart';

@collection
class GroupProjectModel {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String id;

  @Index()
  late String groupId;

  @Index()
  late String churchId;

  late String title;
  String? description;
  late int budgetTarget;
  late int budgetSpent;
  DateTime? startDate;
  DateTime? endDate;

  @enumerated
  late ProjectStatus status;

  DateTime? createdAt;
  DateTime? updatedAt;

  bool isDeleted = false;
  DateTime? lastSyncedAt;
  String? jsonData;

  static GroupProjectModel fromDomain(GroupProject project) {
    return GroupProjectModel()
      ..id = project.id
      ..churchId = project.churchId
      ..groupId = project.groupId
      ..title = project.title
      ..description = project.description
      ..budgetTarget = project.budgetTarget
      ..budgetSpent = project.budgetSpent
      ..startDate = project.startDate
      ..endDate = project.endDate
      ..status = project.status
      ..createdAt = project.createdAt
      ..updatedAt = project.updatedAt
      ..lastSyncedAt = DateTime.now()
      ..jsonData = jsonEncode(project.toJson());
  }

  GroupProject toDomain() {
    if (jsonData != null && jsonData!.isNotEmpty) {
      try {
        return GroupProject.fromJson(jsonDecode(jsonData!));
      } catch (_) { /* jsonData corrupted -- fallback Isar fields */ }
    }
    return GroupProject(
      id: id,
      churchId: churchId,
      groupId: groupId,
      title: title,
      description: description,
      budgetTarget: budgetTarget,
      budgetSpent: budgetSpent,
      startDate: startDate,
      endDate: endDate,
      status: status,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}