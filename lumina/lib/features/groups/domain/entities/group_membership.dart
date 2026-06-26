import 'package:freezed_annotation/freezed_annotation.dart';

part 'group_membership.freezed.dart';
part 'group_membership.g.dart';
// ignore_for_file: invalid_annotation_target

enum GroupRole {
  @JsonValue('MEMBER')
  member,
  @JsonValue('LEADER')
  leader,
  @JsonValue('CO_LEADER')
  coLeader,
}

enum MembershipStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('active')
  active,
  @JsonValue('rejected')
  rejected,
}

@freezed
class GroupMembership with _$GroupMembership {
  const factory GroupMembership({
    required String id,
    @JsonKey(name: 'church_id') required String churchId,
    @JsonKey(name: 'group_id') required String groupId,
    @JsonKey(name: 'member_id') required String memberId,
    @Default(GroupRole.member)
    @JsonKey(unknownEnumValue: GroupRole.member)
    GroupRole role,
    @Default(MembershipStatus.pending)
    @JsonKey(unknownEnumValue: MembershipStatus.pending)
    MembershipStatus status,
    @JsonKey(name: 'joined_at') DateTime? joinedAt,
    @JsonKey(includeFromJson: false, includeToJson: false) String? memberName,
  }) = _GroupMembership;

  factory GroupMembership.fromJson(Map<String, dynamic> json) =>
      _$GroupMembershipFromJson(json);
}