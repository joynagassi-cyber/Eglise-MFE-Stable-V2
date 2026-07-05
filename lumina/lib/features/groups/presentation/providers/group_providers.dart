import 'dart:async';
import 'package:lumina/features/churches/presentation/providers/church_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:lumina/core/providers/repository_providers_content.dart';
import 'package:lumina/core/providers/repository_providers_groups.dart';
import 'package:lumina/core/providers/auth_provider.dart';
import 'package:lumina/core/providers/user_context_provider.dart';
import '../../domain/entities/group.dart';
import '../../domain/entities/group_membership.dart';
import '../../../../core/domain/entities/enums/audit_action.dart';
import '../../../../features/notifications/domain/services/notification_service.dart';

part 'group_providers.g.dart';

@riverpod
Stream<List<Group>> groups(GroupsRef ref) {
  final repo = ref.watch(groupRepositoryProvider);
  final churchAsync = ref.watch(watchActiveChurchProvider);

  return churchAsync.when(
    data: (church) {
      if (church == null) return Stream.value([]);
      return repo.watchGroups(church.id);
    },
    loading: () => Stream.value([]),
    error: (_, __) => Stream.value([]),
  );
}

@riverpod
Future<Group?> groupDetail(GroupDetailRef ref, String id) async {
  final repo = ref.watch(groupRepositoryProvider);
  return repo.getGroup(id);
}

@riverpod
class GroupController extends _$GroupController {
  @override
  FutureOr<void> build() {
    // nothing to initialize
  }

  Future<void> createGroup({
    required String name,
    required GroupType type,
    String? description,
    String? location,
    String? schedule,
  }) async {
    final church = ref.read(activeChurchProvider).valueOrNull;
    if (church == null) throw Exception('No church selected');

    final group = Group(
      id: DateTime.now().millisecondsSinceEpoch.toString(), // Temp ID gen
      churchId: church.id,
      name: name,
      type: type,
      description: description,
      location: location,
      scheduleDescription: schedule,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(groupRepositoryProvider).createGroup(group);

      // Audit Log
      final userContext = ref.read(userContextNotifierProvider).valueOrNull;
      if (userContext != null) {
        await ref.read(auditRepositoryProvider).logAction(
          action: AuditAction.insert,
          entityType: 'group',
          entityId: group.id,
          newData: group.toJson(),
          actorId: userContext.user.id,
          metadata: {
            'actor_name': userContext.user.email,
            'role_used': userContext.role.label,
            'dashboard_source': 'Admin',
            'church_id': userContext.churchId,
          },
        );
      }

      // Notification: notifier les admins
      final notifService = ref.read(notificationServiceProvider);
      unawaited(notifService.onGroupCreated(
        groupName: group.name,
        groupId: group.id,
      ));
    });
  }

  Future<void> updateGroup(Group group) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(groupRepositoryProvider).updateGroup(group);

      // Audit Log
      final userContext = ref.read(userContextNotifierProvider).valueOrNull;
      if (userContext != null) {
        await ref.read(auditRepositoryProvider).logAction(
          action: AuditAction.update,
          entityType: 'group',
          entityId: group.id,
          newData: group.toJson(),
          actorId: userContext.user.id,
          metadata: {
            'actor_name': userContext.user.email,
            'role_used': userContext.role.label,
            'dashboard_source': 'Admin',
            'church_id': userContext.churchId,
          },
        );
      }
    });
  }

  Future<void> deleteGroup(String id) async {
    final church = ref.read(activeChurchProvider).valueOrNull;
    if (church == null) throw Exception('No church selected');

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(groupRepositoryProvider)
          .deleteGroup(id, churchId: church.id);

      // Audit Log
      final userContext = ref.read(userContextNotifierProvider).valueOrNull;
      if (userContext != null) {
        await ref.read(auditRepositoryProvider).logAction(
          action: AuditAction.delete,
          entityType: 'group',
          entityId: id,
          actorId: userContext.user.id,
          metadata: {
            'actor_name': userContext.user.email,
            'role_used': userContext.role.label,
            'dashboard_source': 'Admin',
            'church_id': userContext.churchId,
          },
        );
      }
    });
  }

  // --- Membership Actions ---

  Future<void> addMemberToGroup({
    required String groupId,
    required String memberId,
    GroupRole role = GroupRole.member,
  }) async {
    final church = ref.read(activeChurchProvider).valueOrNull;
    if (church == null) throw Exception('No church selected');

    final membership = GroupMembership(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      churchId: church.id,
      groupId: groupId,
      memberId: memberId,
      role: role,
      joinedAt: DateTime.now(),
    );

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(groupRepositoryProvider).addMemberToGroup(membership);

      // Audit Log
      final userContext = ref.read(userContextNotifierProvider).valueOrNull;
      if (userContext != null) {
        await ref.read(auditRepositoryProvider).logAction(
          action: AuditAction.insert,
          entityType: 'group_membership',
          entityId: membership.id,
          newData: membership.toJson(),
          actorId: userContext.user.id,
          metadata: {
            'actor_name': userContext.user.email,
            'role_used': userContext.role.label,
            'dashboard_source':
                userContext.role.code == 'leader' ? 'Group' : 'Admin',
            'church_id': userContext.churchId,
          },
        );
      }

      // Notification: notifier les chefs de groupe
      final notifService = ref.read(notificationServiceProvider);
      unawaited(notifService.onMemberJoinedGroup(
        groupId: groupId,
        groupName: '', // On ne peut pas recuperer le nom facilement ici
        memberName: userContext?.user.name ?? 'Un membre',
        memberId: memberId,
      ));
    });
    ref.invalidate(groupMembersProvider(groupId));
  }

  Future<void> requestJoinGroup(String groupId) async {
    final church = ref.read(activeChurchProvider).valueOrNull;
    final currentUserId = ref.read(currentUserIdProvider);
    final userContext = ref.read(userContextNotifierProvider).valueOrNull;

    if (church == null) throw Exception('No church selected');
    if (currentUserId == null) throw Exception('No user selected');

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(groupRepositoryProvider).requestJoinGroup(
            groupId: groupId,
            userId: currentUserId,
            memberId: userContext?.user.memberId,
            churchId: church.id,
          );

      final context = ref.read(userContextNotifierProvider).valueOrNull;
      if (context != null) {
        await ref.read(auditRepositoryProvider).logAction(
              action: AuditAction.insert,
              entityType: 'group_membership',
              entityId: '$groupId:$currentUserId:join-request',
              newData: {
                'group_id': groupId,
                'member_id': context.user.memberId ?? currentUserId,
                'status': 'pending',
              },
              actorId: context.user.id,
              metadata: {
                'actor_name': context.user.email,
                'role_used': context.role.label,
                'dashboard_source': 'Member',
                'church_id': context.churchId,
              },
            );
      }
    });

    ref.invalidate(pendingMembershipsProvider(groupId));
  }

  Future<void> removeMemberFromGroup(
    String groupId,
    String membershipId,
  ) async {
    final church = ref.read(activeChurchProvider).valueOrNull;
    if (church == null) throw Exception('No church selected');

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(groupRepositoryProvider)
          .removeMemberFromGroup(membershipId, churchId: church.id);

      // Audit Log
      final userContext = ref.read(userContextNotifierProvider).valueOrNull;
      if (userContext != null) {
        await ref.read(auditRepositoryProvider).logAction(
          action: AuditAction.delete,
          entityType: 'group_membership',
          entityId: membershipId,
          actorId: userContext.user.id,
          metadata: {
            'actor_name': userContext.user.email,
            'role_used': userContext.role.label,
            'dashboard_source':
                userContext.role.code == 'leader' ? 'Group' : 'Admin',
            'church_id': userContext.churchId,
          },
        );
      }
    });
    ref.invalidate(groupMembersProvider(groupId));
  }

  Future<void> updateMemberRole(
    String groupId,
    String membershipId,
    GroupRole newRole,
  ) async {
    final church = ref.read(activeChurchProvider).valueOrNull;
    if (church == null) throw Exception('No church selected');

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(groupRepositoryProvider)
          .updateMemberRole(membershipId, newRole, churchId: church.id);

      // Audit Log
      final userContext = ref.read(userContextNotifierProvider).valueOrNull;
      if (userContext != null) {
        await ref.read(auditRepositoryProvider).logAction(
              action: AuditAction.update,
              entityType: 'group_membership',
              entityId: membershipId,
              newData: {'role': newRole.name.toUpperCase()},
              actorId: userContext.user.id,
              metadata: {
                'actor_name': userContext.user.email,
                'role_used': userContext.role.label,
                'dashboard_source':
                    userContext.role.code == 'leader' ? 'Group' : 'Admin',
                'church_id': userContext.churchId,
              },
            );
      }
    });
    ref.invalidate(groupMembersProvider(groupId));
  }

  Future<void> updateMembershipStatus(
    String groupId,
    String membershipId,
    MembershipStatus status,
  ) async {
    final church = ref.read(activeChurchProvider).valueOrNull;
    if (church == null) throw Exception('No church selected');

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final userContext = ref.read(userContextNotifierProvider).valueOrNull;
      final approvedBy = userContext?.user.id;
      await ref
          .read(groupRepositoryProvider)
          .updateMembershipStatus(
            membershipId,
            status,
            churchId: church.id,
            approvedBy: approvedBy,
          );

      // Audit Log
      if (userContext != null) {
        await ref.read(auditRepositoryProvider).logAction(
              action: AuditAction.update,
              entityType: 'group_membership',
              entityId: membershipId,
              newData: {'status': status.name.toLowerCase()},
              actorId: userContext.user.id,
              metadata: {
                'actor_name': userContext.user.email,
                'role_used': userContext.role.label,
                'dashboard_source':
                    userContext.role.code == 'leader' ? 'Group' : 'Admin',
                'church_id': userContext.churchId,
              },
            );
      }
    });

    // Invalider les listes affectées
    ref.invalidate(groupMembersProvider(groupId));
    ref.invalidate(pendingMembershipsProvider(groupId));
  }
}

@riverpod
Future<List<GroupMembership>> groupMembers(
  GroupMembersRef ref,
  String groupId,
) {
  return ref.watch(groupRepositoryProvider).getGroupMembers(groupId);
}

@riverpod
Future<List<GroupMembership>> memberGroups(
  MemberGroupsRef ref,
  String memberId,
) {
  return ref.watch(groupRepositoryProvider).getMemberGroups(memberId);
}

@riverpod
Future<List<GroupMembership>> pendingMemberships(
  PendingMembershipsRef ref,
  String groupId,
) {
  return ref.watch(groupRepositoryProvider).getPendingMemberships(groupId);
}

@riverpod
Future<List<GroupMembership>> myMemberGroups(
  MyMemberGroupsRef ref,
) async {
  final memberId = ref.watch(userContextNotifierProvider).valueOrNull?.user.memberId;
  if (memberId == null) return [];
  final groups = await ref.watch(groupRepositoryProvider).getMemberGroups(memberId);
  return groups.where((g) => g.status == MembershipStatus.active).toList();
}

@riverpod
Future<List<GroupMembership>> myPendingGroupRequests(
  MyPendingGroupRequestsRef ref,
) async {
  final memberId = ref.watch(userContextNotifierProvider).valueOrNull?.user.memberId;
  if (memberId == null) return [];
  final groups = await ref.watch(groupRepositoryProvider).getMemberGroups(memberId);
  return groups.where((g) => g.status == MembershipStatus.pending).toList();
}

// --- Admin Group Providers ---

@riverpod
Future<List<Group>> availableGroupsForAdmin(
  AvailableGroupsForAdminRef ref,
) async {
  final churchId = ref.watch(activeChurchIdProvider);
  if (churchId.isEmpty) return [];

  final repo = ref.watch(groupRepositoryProvider);
  return repo.getGroups(churchId);
}

@riverpod
class AdminGroupSubscription extends _$AdminGroupSubscription {
  @override
  Future<List<String>> build() async {
    final userId = ref.watch(userContextNotifierProvider).valueOrNull?.user.id;
    if (userId == null) return [];

    final repo = ref.watch(groupRepositoryProvider);
    return repo.getSubscribedGroupIdsForAdmin(userId);
  }

  Future<void> subscribe(String groupId) async {
    final userId = ref.read(userContextNotifierProvider).valueOrNull?.user.id;
    if (userId == null) return;

    await ref
        .read(groupRepositoryProvider)
        .subscribeAdminToGroup(userId, groupId);
    ref.invalidateSelf();
  }

  Future<void> unsubscribe(String groupId) async {
    final userId = ref.read(userContextNotifierProvider).valueOrNull?.user.id;
    if (userId == null) return;

    await ref
        .read(groupRepositoryProvider)
        .unsubscribeAdminFromGroup(userId, groupId);
    ref.invalidateSelf();
  }
}
