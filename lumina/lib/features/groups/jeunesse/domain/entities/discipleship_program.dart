import 'package:equatable/equatable.dart';

enum DiscipleshipStatus { active, completed, onHold }

class DiscipleshipProgram extends Equatable {
  final String id;
  final String churchId;
  final String groupId;
  final String title;
  final String? description;
  final String? mentorId;
  final String menteeId;
  final int progressPercentage;
  final DiscipleshipStatus status;
  final DateTime startDate;
  final DateTime? lastMeetingDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  const DiscipleshipProgram({
    required this.id,
    required this.churchId,
    required this.groupId,
    required this.title,
    this.description,
    this.mentorId,
    required this.menteeId,
    this.progressPercentage = 0,
    this.status = DiscipleshipStatus.active,
    required this.startDate,
    this.lastMeetingDate,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        churchId,
        groupId,
        title,
        description,
        mentorId,
        menteeId,
        progressPercentage,
        status,
        startDate,
        lastMeetingDate,
        createdAt,
        updatedAt,
      ];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'church_id': churchId,
      'group_id': groupId,
      'title': title,
      'description': description,
      'mentor_id': mentorId,
      'mentee_id': menteeId,
      'progress_percentage': progressPercentage,
      'status': status.name,
      'start_date': startDate.toIso8601String(),
      'last_meeting_date': lastMeetingDate?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory DiscipleshipProgram.fromJson(Map<String, dynamic> json) {
    return DiscipleshipProgram(
      id: json['id'] as String,
      churchId: json['church_id'] as String? ?? '',
      groupId: json['group_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      mentorId: json['mentor_id'] as String?,
      menteeId: json['mentee_id'] as String,
      progressPercentage: json['progress_percentage'] as int? ?? 0,
      status: DiscipleshipStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => DiscipleshipStatus.active,
      ),
      startDate: DateTime.parse(json['start_date'] as String),
      lastMeetingDate: json['last_meeting_date'] != null
          ? DateTime.parse(json['last_meeting_date'] as String)
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.now(),
    );
  }

  DiscipleshipProgram copyWith({
    String? title,
    String? description,
    String? mentorId,
    String? menteeId,
    int? progressPercentage,
    DiscipleshipStatus? status,
    DateTime? lastMeetingDate,
    DateTime? updatedAt,
  }) {
    return DiscipleshipProgram(
      id: id,
      churchId: churchId,
      groupId: groupId,
      title: title ?? this.title,
      description: description ?? this.description,
      mentorId: mentorId ?? this.mentorId,
      menteeId: menteeId ?? this.menteeId,
      progressPercentage: progressPercentage ?? this.progressPercentage,
      status: status ?? this.status,
      startDate: startDate,
      lastMeetingDate: lastMeetingDate ?? this.lastMeetingDate,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}