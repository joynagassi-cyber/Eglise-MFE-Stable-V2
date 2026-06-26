import 'package:lumina/features/groups/domain/entities/group.dart';

enum MemberGroupStatus { pending, active, rejected }

class MemberGroup {
  final String id;
  final String memberId;
  final String groupId;
  final String groupName;
  final GroupType groupType;
  final bool isPrimary;
  final MemberGroupStatus status;
  final String? approvedBy;
  final DateTime? approvedAt;
  final DateTime joinedAt;

  const MemberGroup({
    required this.id,
    required this.memberId,
    required this.groupId,
    required this.groupName,
    required this.groupType,
    required this.isPrimary,
    required this.status,
    this.approvedBy,
    this.approvedAt,
    required this.joinedAt,
  });

  factory MemberGroup.fromJson(Map<String, dynamic> json) => MemberGroup(
        id: json['id'] as String,
        memberId: json['member_id'] as String,
        groupId: json['group_id'] as String,
        groupName: json['groups']?['label'] as String? ?? '',
        groupType: GroupType.values.firstWhere(
          (e) => e.name == json['groups']?['code'],
          orElse: () => GroupType.hommes,
        ),
        isPrimary: json['is_primary'] as bool? ?? false,
        status: MemberGroupStatus.values.firstWhere(
          (e) => e.name == json['status'],
          orElse: () => MemberGroupStatus.pending,
        ),
        approvedBy: json['approved_by'] as String?,
        approvedAt: json['approved_at'] != null
            ? DateTime.parse(json['approved_at'] as String)
            : null,
        joinedAt: DateTime.parse(json['joined_at'] as String),
      );
}

class GroupJoinRequest {
  final String id;
  final String memberId;
  final String groupId;
  final String groupName;
  final GroupType groupType;
  final String status; // 'pending' | 'approved' | 'rejected'
  final String? rejectionReason;
  final DateTime createdAt;

  const GroupJoinRequest({
    required this.id,
    required this.memberId,
    required this.groupId,
    required this.groupName,
    required this.groupType,
    required this.status,
    this.rejectionReason,
    required this.createdAt,
  });

  factory GroupJoinRequest.fromJson(Map<String, dynamic> json) =>
      GroupJoinRequest(
        id: json['id'] as String,
        memberId: json['member_id'] as String,
        groupId: json['group_id'] as String,
        groupName: json['groups']?['label'] as String? ?? '',
        groupType: GroupType.values.firstWhere(
          (e) => e.name == json['groups']?['code'],
          orElse: () => GroupType.chorale,
        ),
        status: json['status'] as String,
        rejectionReason: json['rejection_reason'] as String?,
        createdAt: DateTime.parse(json['created_at'] as String),
      );
}
