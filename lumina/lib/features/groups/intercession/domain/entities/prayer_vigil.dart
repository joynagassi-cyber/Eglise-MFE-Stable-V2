import 'package:freezed_annotation/freezed_annotation.dart';

part 'prayer_vigil.freezed.dart';
part 'prayer_vigil.g.dart';
// ignore_for_file: invalid_annotation_target

@freezed
class PrayerVigil with _$PrayerVigil {
  const factory PrayerVigil({
    required String id,
    @JsonKey(name: 'church_id') required String churchId,
    @JsonKey(name: 'group_id') required String groupId,
    @JsonKey(name: 'event_id') String? eventId,
    required String title,
    String? description,
    @JsonKey(name: 'start_time') required DateTime startTime,
    @JsonKey(name: 'end_time') required DateTime endTime,
    @JsonKey(name: 'participants_count') @Default(0) int participantsCount,
    @Default('scheduled') String status,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _PrayerVigil;

  factory PrayerVigil.fromJson(Map<String, dynamic> json) =>
      _$PrayerVigilFromJson(json);
}