import 'package:freezed_annotation/freezed_annotation.dart';

part 'permanent_prayer_subject.freezed.dart';
part 'permanent_prayer_subject.g.dart';
// ignore_for_file: invalid_annotation_target

@freezed
class PermanentPrayerSubject with _$PermanentPrayerSubject {
  const factory PermanentPrayerSubject({
    required String id,
    @JsonKey(name: 'church_id') required String churchId,
    @JsonKey(name: 'group_id') required String groupId,
    required String category,
    required String subject,
    String? description,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _PermanentPrayerSubject;

  factory PermanentPrayerSubject.fromJson(Map<String, dynamic> json) =>
      _$PermanentPrayerSubjectFromJson(json);
}