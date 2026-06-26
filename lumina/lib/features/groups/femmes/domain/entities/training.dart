import 'package:freezed_annotation/freezed_annotation.dart';

part 'training.freezed.dart';
part 'training.g.dart';
// ignore_for_file: invalid_annotation_target

@freezed
class Training with _$Training {
  const factory Training({
    required String id,
    @JsonKey(name: 'church_id') required String churchId,
    @JsonKey(name: 'group_id') required String groupId,
    required String title,
    String? description,
    String? trainer,
    @JsonKey(name: 'next_session') DateTime? nextSession,
    int? capacity,
    @JsonKey(name: 'enrolled_count') @Default(0) int enrolledCount,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _Training;

  factory Training.fromJson(Map<String, dynamic> json) =>
      _$TrainingFromJson(json);
}