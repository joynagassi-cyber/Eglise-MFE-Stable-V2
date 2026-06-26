import 'package:freezed_annotation/freezed_annotation.dart';

part 'group_project.freezed.dart';
part 'group_project.g.dart';
// ignore_for_file: invalid_annotation_target

enum ProjectStatus {
  @JsonValue('planned')
  planned,
  @JsonValue('in_progress')
  inProgress,
  @JsonValue('completed')
  completed,
}

@freezed
class GroupProject with _$GroupProject {
  const GroupProject._();

  const factory GroupProject({
    required String id,
    @JsonKey(name: 'group_id') required String groupId,
    @JsonKey(name: 'church_id') required String churchId,
    required String title,
    String? description,
    @JsonKey(name: 'budget_target') @Default(0) int budgetTarget,
    @JsonKey(name: 'budget_spent') @Default(0) int budgetSpent,
    @JsonKey(name: 'start_date') DateTime? startDate,
    @JsonKey(name: 'end_date') DateTime? endDate,
    @Default(ProjectStatus.planned) ProjectStatus status,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _GroupProject;

  factory GroupProject.fromJson(Map<String, dynamic> json) =>
      _$GroupProjectFromJson(json);

  double get progress =>
      budgetTarget > 0 ? (budgetSpent / budgetTarget).clamp(0.0, 1.0) : 0.0;
}