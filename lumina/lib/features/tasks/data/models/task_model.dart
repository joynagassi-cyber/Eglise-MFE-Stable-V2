import 'dart:convert';
import 'package:isar/isar.dart';
import 'package:lumina/core/logging/app_logger.dart';
import '../../domain/entities/task.dart';

part 'task_model.g.dart';

@Collection()
class TaskModel {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String id;

  late String title;
  String? description;

  @Enumerated(EnumType.name)
  late TaskType type;

  @Enumerated(EnumType.name)
  late TaskStatus status;

  @Enumerated(EnumType.name)
  late TaskPriority priority;

  DateTime? dueDate;
  DateTime? startDate;
  DateTime? completedAt;

  @Index()
  String? assignedToId;

  @Index()
  String? groupId;

  @Index()
  String? churchId;

  int completionPercent = 0;

  late DateTime createdAt;
  late DateTime updatedAt;
  DateTime? lastSyncedAt;

  String? jsonData;

  Task toDomain() {
    if (jsonData != null && jsonData!.isNotEmpty) {
      try {
        return Task.fromJson(jsonDecode(jsonData!));
      } catch (e, stack) {
        AppLogger.e(
            'Error parsing TaskModel from JSON', 'TASK_MODEL', e, stack);
      }
    }
    return Task(
      id: id,
      title: title,
      description: description,
      type: type,
      status: status,
      priority: priority,
      dueDate: dueDate,
      startDate: startDate,
      completedAt: completedAt,
      assignedToId: assignedToId,
      groupId: groupId,
      churchId: churchId,
      completionPercent: completionPercent,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static TaskModel fromDomain(Task task) {
    return TaskModel()
      ..id = task.id
      ..title = task.title
      ..description = task.description
      ..type = task.type
      ..status = task.status
      ..priority = task.priority
      ..dueDate = task.dueDate
      ..startDate = task.startDate
      ..completedAt = task.completedAt
      ..assignedToId = task.assignedToId
      ..groupId = task.groupId
      ..churchId = task.churchId
      ..completionPercent = task.completionPercent
      ..createdAt = task.createdAt
      ..updatedAt = task.updatedAt
      ..jsonData = jsonEncode(task.toJson());
  }
}