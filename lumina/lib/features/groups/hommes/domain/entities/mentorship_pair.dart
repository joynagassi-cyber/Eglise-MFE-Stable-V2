import 'package:freezed_annotation/freezed_annotation.dart';

part 'mentorship_pair.freezed.dart';
part 'mentorship_pair.g.dart';
// ignore_for_file: invalid_annotation_target

enum MentorshipStatus {
  @JsonValue('active')
  active,
  @JsonValue('completed')
  completed,
  @JsonValue('terminated')
  terminated,
}

@freezed
class MentorshipPair with _$MentorshipPair {
  const MentorshipPair._();

  const factory MentorshipPair({
    required String id,
    @JsonKey(name: 'group_id') required String groupId,
    @JsonKey(name: 'church_id') required String churchId,
    @JsonKey(name: 'mentor_id') required String mentorId,
    @JsonKey(name: 'mentee_id') required String menteeId,
    @Default(MentorshipStatus.active) MentorshipStatus status,
    @JsonKey(name: 'next_session_at') DateTime? nextSessionAt,
    @JsonKey(name: 'last_session_at') DateTime? lastSessionAt,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    // Joined fields from Supabase
    @JsonKey(name: 'mentor_name') String? mentorName,
    @JsonKey(name: 'mentee_name') String? menteeName,
  }) = _MentorshipPair;

  factory MentorshipPair.fromJson(Map<String, dynamic> json) =>
      _$MentorshipPairFromJson(json);
}