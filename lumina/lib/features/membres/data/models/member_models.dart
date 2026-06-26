import 'package:freezed_annotation/freezed_annotation.dart';

part 'member_models.freezed.dart';
part 'member_models.g.dart';
// ignore_for_file: invalid_annotation_target

@freezed
class Member with _$Member {
  const factory Member({
    required String id,
    @JsonKey(name: 'church_id') required String churchId,
    @JsonKey(name: 'user_id') String? userId,
    @JsonKey(name: 'first_name') required String firstName,
    @JsonKey(name: 'last_name') required String lastName,
    @JsonKey(name: 'display_name') String? displayName,
    String? gender, // male, female
    @JsonKey(name: 'birth_date') DateTime? birthDate,
    String? phone,
    String? email,
    String? address,
    @JsonKey(name: 'photo_url') String? photoUrl,
    @JsonKey(name: 'photo_r2_key') String? photoR2Key,
    @JsonKey(name: 'member_number') String? memberNumber,
    @Default('active') String status,
    @JsonKey(name: 'membership_date') DateTime? membershipDate,
    @JsonKey(name: 'baptism_date') DateTime? baptismDate,
    @JsonKey(name: 'shepherd_id') String? shepherdId,
    @JsonKey(name: 'family_id') String? familyId,
    @JsonKey(name: 'marital_status') String? maritalStatus,
    String? occupation,
    String? notes,
    List<String>? tags,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _Member;

  factory Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);
}

@freezed
class FamilyRelationship with _$FamilyRelationship {
  const factory FamilyRelationship({
    required String id,
    @JsonKey(name: 'church_id') required String churchId,
    @JsonKey(name: 'member_id') required String memberId,
    @JsonKey(name: 'related_member_id') required String relatedMemberId,
    @JsonKey(name: 'relationship_type')
    required String relationshipType, // spouse, parent, child, sibling, other
    @JsonKey(name: 'is_primary') @Default(false) bool isPrimary,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _FamilyRelationship;

  factory FamilyRelationship.fromJson(Map<String, dynamic> json) =>
      _$FamilyRelationshipFromJson(json);
}

@freezed
class MemberHistory with _$MemberHistory {
  const factory MemberHistory({
    required String id,
    @JsonKey(name: 'church_id') required String churchId,
    @JsonKey(name: 'member_id') required String memberId,
    @JsonKey(name: 'event_type')
    required String
        eventType, // created, updated, status_changed, baptized, married, transferred, deleted
    @JsonKey(name: 'event_date') required DateTime eventDate,
    String? description,
    @JsonKey(name: 'performed_by') String? performedBy,
    Map<String, dynamic>? metadata,
  }) = _MemberHistory;

  factory MemberHistory.fromJson(Map<String, dynamic> json) =>
      _$MemberHistoryFromJson(json);
}

@freezed
class SpiritualTracking with _$SpiritualTracking {
  const factory SpiritualTracking({
    required String id,
    @JsonKey(name: 'church_id') required String churchId,
    @JsonKey(name: 'member_id') required String memberId,
    @JsonKey(name: 'shepherd_id') String? shepherdId,
    @JsonKey(name: 'last_contact_date') DateTime? lastContactDate,
    @JsonKey(name: 'next_follow_up_date') DateTime? nextFollowUpDate,
    @JsonKey(name: 'spiritual_level') String? spiritualLevel,
    @JsonKey(name: 'prayer_requests') String? prayerRequests,
    String? notes,
    @JsonKey(name: 'growth_milestones') List<String>? growthMilestones,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _SpiritualTracking;

  factory SpiritualTracking.fromJson(Map<String, dynamic> json) =>
      _$SpiritualTrackingFromJson(json);
}