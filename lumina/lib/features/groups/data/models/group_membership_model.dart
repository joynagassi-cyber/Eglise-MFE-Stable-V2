import 'dart:convert';
import 'package:isar/isar.dart';
import '../../domain/entities/group_membership.dart';

part 'group_membership_model.g.dart';

@collection
class GroupMembershipModel {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String originalId;

  @Index()
  late String churchId;

  @Index()
  late String groupId;

  @Index()
  late String memberId;

  @Enumerated(EnumType.name)
  late GroupRole role;

  DateTime? joinedAt;
  String? memberName;

  DateTime? createdAt;
  DateTime? updatedAt;

  DateTime? lastSyncedAt;
  bool isDirty = false;

  int version = 1;
  String deviceId = 'unknown';
  String createdBy = 'unknown';
  String updatedBy = 'unknown';

  bool isDeleted = false;
  DateTime? deletedAt;
  String? deletedBy;

  String? jsonData;

  GroupMembership toDomain() {
    if (jsonData != null && jsonData!.isNotEmpty) {
      try {
        final decoded = jsonDecode(jsonData!);
        if (decoded is Map<String, dynamic>) {
          final enriched = Map<String, dynamic>.from(decoded);
          enriched.putIfAbsent('church_id', () => churchId);
          return GroupMembership.fromJson(enriched);
        }
      } catch (_) { /* jsonData corrupted -- fallback Isar fields */ }
    }
    return GroupMembership(
      id: originalId,
      churchId: churchId,
      groupId: groupId,
      memberId: memberId,
      role: role,
      joinedAt: joinedAt,
      memberName: memberName,
    );
  }

  static GroupMembershipModel fromDomain(GroupMembership membership) {
    return GroupMembershipModel()
      ..originalId = membership.id
      ..churchId = membership.churchId
      ..groupId = membership.groupId
      ..memberId = membership.memberId
      ..role = membership.role
      ..joinedAt = membership.joinedAt
      ..memberName = membership.memberName
      ..jsonData = jsonEncode(membership.toJson());
  }
}
