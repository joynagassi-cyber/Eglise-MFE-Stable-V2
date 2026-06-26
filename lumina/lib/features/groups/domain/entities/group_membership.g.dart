// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_membership.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GroupMembershipImpl _$$GroupMembershipImplFromJson(
        Map<String, dynamic> json) =>
    _$GroupMembershipImpl(
      id: json['id'] as String,
      churchId: json['church_id'] as String,
      groupId: json['group_id'] as String,
      memberId: json['member_id'] as String,
      role: $enumDecodeNullable(_$GroupRoleEnumMap, json['role'],
              unknownValue: GroupRole.member) ??
          GroupRole.member,
      status: $enumDecodeNullable(_$MembershipStatusEnumMap, json['status'],
              unknownValue: MembershipStatus.pending) ??
          MembershipStatus.pending,
      joinedAt: json['joined_at'] == null
          ? null
          : DateTime.parse(json['joined_at'] as String),
    );

Map<String, dynamic> _$$GroupMembershipImplToJson(
        _$GroupMembershipImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'church_id': instance.churchId,
      'group_id': instance.groupId,
      'member_id': instance.memberId,
      'role': _$GroupRoleEnumMap[instance.role]!,
      'status': _$MembershipStatusEnumMap[instance.status]!,
      'joined_at': instance.joinedAt?.toIso8601String(),
    };

const _$GroupRoleEnumMap = {
  GroupRole.member: 'MEMBER',
  GroupRole.leader: 'LEADER',
  GroupRole.coLeader: 'CO_LEADER',
};

const _$MembershipStatusEnumMap = {
  MembershipStatus.pending: 'pending',
  MembershipStatus.active: 'active',
  MembershipStatus.rejected: 'rejected',
};
