import 'package:equatable/equatable.dart';

enum TaskType { program, checklist, general }

enum TaskStatus { pending, inProgress, completed, cancelled }

enum TaskPriority { low, normal, high, urgent }

class Task extends Equatable {
  final String id;
  final String title;
  final String? description;
  final TaskType type;
  final TaskStatus status;
  final TaskPriority priority;
  final DateTime? dueDate;
  final DateTime? startDate;
  final DateTime? completedAt;
  final String? assignedToId;
  final String? groupId;
  final String? churchId;
  final int completionPercent;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Task({
    required this.id,
    required this.title,
    this.description,
    required this.type,
    this.status = TaskStatus.pending,
    this.priority = TaskPriority.normal,
    this.dueDate,
    this.startDate,
    this.completedAt,
    this.assignedToId,
    this.groupId,
    this.churchId,
    this.completionPercent = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  Task copyWith({
    String? title,
    String? description,
    TaskType? type,
    TaskStatus? status,
    TaskPriority? priority,
    DateTime? dueDate,
    DateTime? startDate,
    DateTime? completedAt,
    String? assignedToId,
    String? groupId,
    String? churchId,
    int? completionPercent,
    DateTime? updatedAt,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      startDate: startDate ?? this.startDate,
      completedAt: completedAt ?? this.completedAt,
      assignedToId: assignedToId ?? this.assignedToId,
      groupId: groupId ?? this.groupId,
      churchId: churchId ?? this.churchId,
      completionPercent: completionPercent ?? this.completionPercent,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      type: TaskType.values.firstWhere(
        (e) => e.name == (json['type'] as String).toLowerCase(),
        orElse: () => TaskType.general,
      ),
      status: TaskStatus.values.firstWhere(
        (e) => e.name == (json['status'] as String).toLowerCase(),
        orElse: () => TaskStatus.pending,
      ),
      priority: TaskPriority.values.firstWhere(
        (e) => e.name == (json['priority'] as String).toLowerCase(),
        orElse: () => TaskPriority.normal,
      ),
      dueDate: json['due_date'] != null
          ? DateTime.parse(json['due_date'] as String)
          : null,
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'] as String)
          : null,
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
      assignedToId: json['assignee_id'] as String?,
      groupId: json['group_id'] as String?,
      churchId: json['church_id'] as String?,
      completionPercent: json['completion_percent'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.name.toUpperCase(),
      'status': status.name.toUpperCase(),
      'priority': priority.name.toUpperCase(),
      'due_date': dueDate?.toIso8601String(),
      'start_date': startDate?.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'assignee_id': assignedToId,
      'group_id': groupId,
      'church_id': churchId,
      'completion_percent': completionPercent,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        type,
        status,
        priority,
        dueDate,
        startDate,
        completedAt,
        assignedToId,
        groupId,
        churchId,
        completionPercent,
        createdAt,
        updatedAt,
      ];
}