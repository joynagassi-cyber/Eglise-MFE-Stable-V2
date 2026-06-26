import '../entities/group.dart';
import '../entities/group_attendance.dart';
import '../entities/group_membership.dart';
import '../entities/member_transfer_request.dart';

abstract class IGroupRepository {
  // Group CRUD
  Future<List<Group>> getGroups(String churchId);
  Future<Group?> getGroup(String id);
  Stream<List<Group>> watchGroups(String churchId);
  Future<void> createGroup(Group group);
  Future<void> updateGroup(Group group);
  Future<void> deleteGroup(String id, {required String churchId});

  // Membership
  Future<List<GroupMembership>> getGroupMembers(String groupId);
  Future<List<GroupMembership>> getMemberGroups(String memberId);
  Future<void> addMemberToGroup(GroupMembership membership);
  Future<void> requestJoinGroup({
    required String groupId,
    required String userId,
    required String churchId,
    String? memberId,
  });
  Future<void> removeMemberFromGroup(String membershipId,
      {required String churchId});
  Future<void> updateMemberRole(String membershipId, GroupRole newRole,
      {required String churchId});
  Future<void> updateMembershipStatus(
      String membershipId, MembershipStatus status,
      {required String churchId, String? approvedBy});
  Future<List<GroupMembership>> getPendingMemberships(String groupId);

  // Attendance
  Future<void> saveAttendance(List<GroupAttendance> attendance);
  Future<List<GroupAttendance>> getAttendance(String groupId, DateTime date);
  Stream<List<GroupAttendance>> watchAttendance(String groupId, DateTime date);
  Future<List<GroupAttendance>> getGroupAttendanceHistory(String groupId,
      {DateTime? since});
  Future<List<GroupAttendance>> getMemberAttendanceHistory(String memberId);

  // Member Transfers
  Future<String> createTransferRequest(MemberTransferRequest request);
  Future<void> updateTransferStatus(String requestId, TransferStatus status,
      {String? notes, String? approvedBy, required String churchId});
  Future<List<MemberTransferRequest>> getTransferRequests(
      {String? groupId, String? memberId});
  // Admin subscriptions
  Future<List<String>> getSubscribedGroupIdsForAdmin(String userId);
  Future<void> subscribeAdminToGroup(String userId, String groupId);
  Future<void> unsubscribeAdminFromGroup(String userId, String groupId);
}
