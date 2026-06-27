import 'dart:async';
import 'package:isar/isar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lumina/core/data/local/isar_service.dart'
    show IsarService;
import 'package:lumina/core/services/offline_sync_manager.dart';
import 'package:lumina/core/data/models/sync_item_model.dart';
import '../../domain/entities/group.dart';
import '../../domain/entities/group_membership.dart';
import '../../domain/repositories/i_group_repository.dart';
import '../models/group_model.dart';
import '../models/group_membership_model.dart';
import '../models/group_attendance_model.dart';
import '../models/member_transfer_request_model.dart';
import '../../domain/entities/group_attendance.dart';
import '../../domain/entities/member_transfer_request.dart';
import 'package:lumina/core/logging/app_logger.dart';
import 'package:lumina/core/utils/app_date_time.dart';
import 'package:lumina/core/services/device_service.dart';
import 'dart:convert';
import 'package:uuid/uuid.dart';

class GroupRepositoryImpl implements IGroupRepository {
  final SupabaseClient _supabase;
  final IsarService _isarService;
  final OfflineSyncManager _syncManager;

  GroupRepositoryImpl(this._supabase, this._isarService, this._syncManager);

  Map<String, dynamic> _injectChurchId(Map<String, dynamic> json) {
    final existingChurchId = json['church_id']?.toString();
    final trimmedExistingChurchId = existingChurchId?.trim();
    if (trimmedExistingChurchId != null &&
        trimmedExistingChurchId.isNotEmpty) {
      return json;
    }

    final group = json['groups'] as Map<String, dynamic>?;
    final groupChurchId = group?['church_id']?.toString();
    final trimmedGroupChurchId = groupChurchId?.trim();
    if (trimmedGroupChurchId == null || trimmedGroupChurchId.isEmpty) {
      return json;
    }

    return <String, dynamic>{
      ...json,
      'church_id': trimmedGroupChurchId,
    };
  }

  Map<String, dynamic> _sanitizeMembershipPayload(
    Map<String, dynamic> json,
  ) {
    final sanitized = Map<String, dynamic>.from(json);
    sanitized.remove('church_id');
    return sanitized;
  }

  @override
  Future<List<Group>> getGroups(String churchId) async {
    try {
      final List<dynamic> data = await _supabase
          .from('groups').select().eq('church_id', churchId)
          .timeout(const Duration(seconds: 15));

      final groups = data.map((json) => Group.fromJson(json)).toList();

      if (!_isarService.isReady) {
        return groups;
      }

      final isar = _isarService.db;

      await isar.writeTxn(() async {
        for (final json in data) {
          final group = Group.fromJson(json);
          await isar.groupModels.put(GroupModel.fromDomain(group));
        }
      });

      final models =
          await isar.groupModels.filter().churchIdEqualTo(churchId).findAll();
      return models.map((m) => m.toDomain()).toList();
    } catch (e) {
      AppLogger.e('Failed to fetch/sync groups', 'GROUP_REPO', e);
      if (_isarService.isReady) {
        final isar = _isarService.db;
        final models =
            await isar.groupModels.filter().churchIdEqualTo(churchId).findAll();
        return models.map((m) => m.toDomain()).toList();
      }
      return [];
    }
  }

  @override
  Stream<List<Group>> watchGroups(String churchId) {
    if (!_isarService.isReady) {
      return _supabase
          .from('groups')
          .stream(primaryKey: ['id'])
          .eq('church_id', churchId)
          .map((data) => data.map((json) => Group.fromJson(json)).toList());
    }
    return _isarService.db.groupModels
        .filter()
        .churchIdEqualTo(churchId)
        .watch(fireImmediately: true)
        .map((models) => models.map((m) => m.toDomain()).toList());
  }

  @override
  Future<Group?> getGroup(String id) async {
    if (!_isarService.isReady) {
      final response = await _supabase
          .from('groups').select().eq('id', id).single()
          .timeout(const Duration(seconds: 15));
      return Group.fromJson(response);
    }
    final isar = _isarService.db;

    try {
      final response =
          await _supabase.from('groups').select().eq('id', id).single();
      final group = Group.fromJson(response);
      await isar.writeTxn(() async {
        await isar.groupModels.put(GroupModel.fromDomain(group));
      });
      return group;
    } catch (e) {
      AppLogger.e('Failed to fetch/sync group $id', 'GROUP_REPO', e);
    }

    final model =
        await isar.groupModels.filter().originalIdEqualTo(id).findFirst();
    return model?.toDomain();
  }

  @override
  Future<void> createGroup(Group group) async {
    final deviceId = await DeviceService.getDeviceIdStatic();
    final userId = _supabase.auth.currentUser?.id ?? 'unknown';
    final uuid = group.id.isEmpty ? const Uuid().v4() : group.id;

    final newGroup = group.copyWith(
      id: uuid,
      createdAt: AppDateTime.nowUtc(),
      updatedAt: AppDateTime.nowUtc(),
    );

    final data = newGroup.toJson();
    data['id'] = uuid;

    if (_isarService.isReady) {
      final isar = _isarService.db;
      final model = GroupModel.fromDomain(newGroup)
        ..isDirty = true
        ..version = 1
        ..deviceId = deviceId
        ..createdBy = userId
        ..updatedBy = userId;

      await isar.writeTxn(() async {
        await isar.groupModels.put(model);
      });
    } else {
      await _supabase.from('groups').insert(data).timeout(const Duration(seconds: 15));
    }
  }

  @override
  Future<void> updateGroup(Group group) async {
    final deviceId = await DeviceService.getDeviceIdStatic();
    final userId = _supabase.auth.currentUser?.id ?? 'unknown';
    final updatedGroup = group.copyWith(updatedAt: AppDateTime.nowUtc());
    final data = updatedGroup.toJson();

    if (_isarService.isReady) {
      final isar = _isarService.db;
      final existing = await isar.groupModels.filter().originalIdEqualTo(group.id).findFirst();
      final currentVersion = existing?.version ?? 0;

      final model = GroupModel.fromDomain(updatedGroup)
        ..isarId = existing?.isarId ?? Isar.autoIncrement
        ..isDirty = true
        ..version = currentVersion + 1
        ..deviceId = deviceId
        ..createdBy = existing?.createdBy ?? userId
        ..updatedBy = userId;

      await isar.writeTxn(() async {
        await isar.groupModels.put(model);
      });
    } else {
      await _supabase.from('groups').update(data).eq('id', group.id).timeout(const Duration(seconds: 15));
    }
  }

  @override
  Future<void> deleteGroup(String id, {required String churchId}) async {
    final deviceId = await DeviceService.getDeviceIdStatic();
    final userId = _supabase.auth.currentUser?.id ?? 'unknown';

    if (_isarService.isReady) {
      final isar = _isarService.db;
      final existing = await isar.groupModels.filter().originalIdEqualTo(id).findFirst();

      if (existing != null) {
        existing
          ..isDeleted = true
          ..deletedAt = DateTime.now()
          ..deletedBy = userId
          ..updatedAt = DateTime.now()
          ..updatedBy = userId
          ..version = existing.version + 1;

        await isar.writeTxn(() async {
          await isar.groupModels.put(existing);
        });
      }
    } else {
      await _supabase.from('groups').update({
        'is_deleted': true,
        'deleted_at': DateTime.now().toIso8601String(),
        'deleted_by': userId,
      }).eq('id', id).timeout(const Duration(seconds: 15));
    }
  }

  // --- Membership ---

  @override
  Future<List<GroupMembership>> getGroupMembers(String groupId) async {
    if (!_isarService.isReady) {
      final List<dynamic> data = await _supabase
          .from('group_memberships')
          .select('*, members(first_name, last_name), groups(church_id, label, code)')
          .eq('group_id', groupId);
      return data.map((json) {
        final membershipJson = _injectChurchId(Map<String, dynamic>.from(json));
        var membership = GroupMembership.fromJson(membershipJson);
        final memberData = json['members'] as Map<String, dynamic>?;
        if (memberData != null) {
          membership = membership.copyWith(
            memberName:
                '${memberData['first_name']} ${memberData['last_name']}',
          );
        }
        return membership;
      }).toList();
    }
    final isar = _isarService.db;

    try {
      final List<dynamic> data = await _supabase
          .from('group_memberships')
          .select('*, members(first_name, last_name), groups(church_id, label, code)')
          .eq('group_id', groupId);

      await isar.writeTxn(() async {
        for (final json in data) {
          final membershipJson = _injectChurchId(Map<String, dynamic>.from(json));
          var membership = GroupMembership.fromJson(membershipJson);
          // Hand-populate enrichment from join
          final memberData = json['members'] as Map<String, dynamic>?;
          if (memberData != null) {
            membership = membership.copyWith(
              memberName:
                  '${memberData['first_name']} ${memberData['last_name']}',
            );
          }
          await isar.groupMembershipModels.put(
            GroupMembershipModel.fromDomain(membership),
          );
        }
      });
    } catch (e) {
      AppLogger.e(
          'Failed to fetch/sync group members for $groupId', 'GROUP_REPO', e);
    }

    final models = await isar.groupMembershipModels
        .filter()
        .groupIdEqualTo(groupId)
        .findAll();
    return models.map((m) => m.toDomain()).toList();
  }

  @override
  Future<List<GroupMembership>> getMemberGroups(String memberId) async {
    if (!_isarService.isReady) {
      final List<dynamic> data = await _supabase
          .from('group_memberships')
          .select('*, groups(church_id, label, code)')
          .eq('member_id', memberId);
      return data
          .map((json) => GroupMembership.fromJson(
                _injectChurchId(Map<String, dynamic>.from(json)),
              ))
          .toList();
    }
    final isar = _isarService.db;

    try {
      final List<dynamic> data = await _supabase
          .from('group_memberships')
          .select('*, groups(church_id, label, code)')
          .eq('member_id', memberId);

      await isar.writeTxn(() async {
        for (final json in data) {
          final membership = GroupMembership.fromJson(
            _injectChurchId(Map<String, dynamic>.from(json)),
          );
          await isar.groupMembershipModels.put(
            GroupMembershipModel.fromDomain(membership),
          );
        }
      });
    } catch (e) {
      AppLogger.e(
          'Failed to fetch/sync member groups for $memberId', 'GROUP_REPO', e);
    }

    final models = await isar.groupMembershipModels
        .filter()
        .memberIdEqualTo(memberId)
        .findAll();
    return models.map((m) => m.toDomain()).toList();
  }

  @override
  Future<void> addMemberToGroup(GroupMembership membership) async {
    final deviceId = await DeviceService.getDeviceIdStatic();
    final userId = _supabase.auth.currentUser?.id ?? 'unknown';
    final uuid = membership.id.isEmpty ? const Uuid().v4() : membership.id;

    final newMembership = membership.copyWith(id: uuid);
    final data = _sanitizeMembershipPayload(newMembership.toJson());
    data['id'] = uuid;

    if (_isarService.isReady) {
      final isar = _isarService.db;
      final model = GroupMembershipModel.fromDomain(newMembership)
        ..isDirty = true
        ..version = 1
        ..deviceId = deviceId
        ..createdBy = userId
        ..updatedBy = userId;

      await isar.writeTxn(() async {
        await isar.groupMembershipModels.put(model);
      });
    } else {
      await _supabase.from('group_memberships').insert(data);
    }
  }

  @override
  Future<void> requestJoinGroup({
    required String groupId,
    required String userId,
    required String churchId,
    String? memberId,
  }) async {
    final resolvedMemberId = (memberId ?? userId).trim();
    if (resolvedMemberId.isEmpty) {
      throw StateError('Impossible de résoudre le membre courant');
    }

    final now = AppDateTime.nowIso();
    final deviceId = await DeviceService.getDeviceIdStatic();
    final authUserId = _supabase.auth.currentUser?.id ?? 'unknown';

    if (_isarService.isReady) {
      final isar = _isarService.db;
      final existing = await isar.groupMembershipModels
          .filter()
          .groupIdEqualTo(groupId)
          .memberIdEqualTo(resolvedMemberId)
          .findFirst();

      final requestId = existing?.originalId ?? const Uuid().v4();

      await isar.writeTxn(() async {
        if (existing == null) {
          final domain = GroupMembership(
            id: requestId,
            churchId: churchId,
            groupId: groupId,
            memberId: resolvedMemberId,
            role: GroupRole.member,
            joinedAt: DateTime.now(),
          );
          final newModel = GroupMembershipModel.fromDomain(domain)
            ..isDirty = true
            ..version = 1
            ..deviceId = deviceId
            ..createdBy = authUserId
            ..updatedBy = authUserId;
          await isar.groupMembershipModels.put(newModel);
        } else {
          existing.version++;
          existing.updatedBy = authUserId;
          await isar.groupMembershipModels.put(existing);
        }
      });
    } else {
      final existing = await _supabase
          .from('group_memberships')
          .select('id, status, is_active')
          .eq('group_id', groupId)
          .eq('member_id', resolvedMemberId)
          .maybeSingle();

      if (existing != null) {
        final existingStatus = (existing['status'] as String? ?? '').toLowerCase();
        if (existingStatus == 'active' || existing['is_active'] == true) {
          return;
        }

        await _supabase.from('group_memberships').update({
          'status': 'pending',
          'is_active': false,
          'joined_at': now,
        }).eq('id', existing['id']);
        return;
      }

      await _supabase.from('group_memberships').insert({
        'id': const Uuid().v4(),
        'group_id': groupId,
        'member_id': resolvedMemberId,
        'role': 'MEMBER',
        'status': 'pending',
        'joined_at': now,
        'is_active': false,
      });
    }
  }

  @override
  Future<void> removeMemberFromGroup(String membershipId,
      {required String churchId}) async {
    final userId = _supabase.auth.currentUser?.id ?? 'unknown';

    if (_isarService.isReady) {
      final isar = _isarService.db;
      final existing = await isar.groupMembershipModels.filter().originalIdEqualTo(membershipId).findFirst();

      if (existing != null) {
        existing
          ..isDeleted = true
          ..deletedAt = DateTime.now()
          ..updatedBy = userId
          ..version = existing.version + 1;

        await isar.writeTxn(() async {
          await isar.groupMembershipModels.put(existing);
        });
      }
    } else {
      await _supabase.from('group_memberships').delete().eq('id', membershipId);
    }
  }

  @override
  Future<void> updateMemberRole(String membershipId, GroupRole newRole,
      {required String churchId}) async {
    final userId = _supabase.auth.currentUser?.id ?? 'unknown';

    if (_isarService.isReady) {
      final isar = _isarService.db;
      final membership = await isar.groupMembershipModels
          .filter()
          .originalIdEqualTo(membershipId)
          .findFirst();

      if (membership != null) {
        membership
          ..role = newRole
          ..version = membership.version + 1
          ..updatedBy = userId;

        await isar.writeTxn(() async {
          await isar.groupMembershipModels.put(membership);
        });
      }
    } else {
      await _supabase
          .from('group_memberships')
          .update({'role': newRole.name.toUpperCase()}).eq('id', membershipId);
    }
  }

  @override
  Future<void> updateMembershipStatus(
      String membershipId, MembershipStatus status,
      {required String churchId, String? approvedBy}) async {
    final deviceId = await DeviceService.getDeviceIdStatic();
    final userId = _supabase.auth.currentUser?.id ?? 'unknown';

    if (_isarService.isReady) {
      final isar = _isarService.db;
      final membership = await isar.groupMembershipModels
          .filter()
          .originalIdEqualTo(membershipId)
          .findFirst();

      if (membership != null) {
        // Update the jsonData to reflect the new status
        final domain = membership.toDomain().copyWith(status: status);
        final updatedModel = GroupMembershipModel.fromDomain(domain)
          ..isarId = membership.isarId
          ..isDirty = true
          ..version = membership.version + 1
          ..deviceId = deviceId
          ..createdBy = membership.createdBy
          ..updatedBy = userId;

        await isar.writeTxn(() async {
          await isar.groupMembershipModels.put(updatedModel);
        });
        
        // PHASE 5: SyncOperationModel supprimé → SyncItemModel direct
        await _isarService.queueSyncItem(SyncItemModel()
          ..tableName = 'group_memberships'
          ..action = 'UPDATE'
          ..jsonData = jsonEncode({
            'id': membershipId,
            'status': status.name.toLowerCase(),
            'is_active': status == MembershipStatus.active,
          })
          ..createdAt = DateTime.now()
          ..localId = membershipId
          ..churchId = churchId
          ..operationId = const Uuid().v4()
          ..deviceId = deviceId
          ..userId = userId);
      }
    } else {
      final isApproved = status == MembershipStatus.active;
      await _supabase.from('group_memberships').update({
        'status': status.name.toLowerCase(),
        'is_active': isApproved,
      }).eq('id', membershipId);
    }
  }

  @override
  Future<List<GroupMembership>> getPendingMemberships(String groupId) async {
    try {
      final List<dynamic> data = await _supabase
          .from('group_memberships')
          .select('*, members(first_name, last_name, avatar_url), groups(church_id, label, code)')
          .eq('group_id', groupId)
          .eq('status', 'pending');

      return data.map((json) {
        var membership = GroupMembership.fromJson(
          _injectChurchId(Map<String, dynamic>.from(json)),
        );
        final memberData = json['members'] as Map<String, dynamic>?;
        if (memberData != null) {
          membership = membership.copyWith(
            memberName:
                '${memberData['first_name']} ${memberData['last_name']}',
          );
        }
        return membership;
      }).toList();
    } catch (e) {
      AppLogger.e(
          'Failed to fetch pending memberships for $groupId', 'GROUP_REPO', e);
      return [];
    }
  }

  // --- Admin Subscriptions ---
  @override
  Future<List<String>> getSubscribedGroupIdsForAdmin(String userId) async {
    try {
      final List<dynamic> data = await _supabase
          .from('admin_group_subscriptions')
          .select('group_id')
          .eq('user_id', userId);
      return data.map((e) => e['group_id'] as String).toList();
    } catch (e) {
      AppLogger.w(
        'Failed to load admin group subscriptions for $userId',
        'GROUP_REPO',
      );
      return [];
    }
  }

  @override
  Future<void> subscribeAdminToGroup(String userId, String groupId) async {
    try {
      await _supabase.from('admin_group_subscriptions').insert({
        'user_id': userId,
        'group_id': groupId,
      });
    } catch (e) {
      AppLogger.w(
          'Failed to subscribe admin online, registering for offline sync',
          'GROUP_REPO');
      // Nothing else to do here if the table is not yet exposed in the Data API.
    }
  }

  @override
  Future<void> unsubscribeAdminFromGroup(String userId, String groupId) async {
    try {
      await _supabase
          .from('admin_group_subscriptions')
          .delete()
          .eq('user_id', userId)
          .eq('group_id', groupId);
    } catch (e) {
      AppLogger.w(
          'Failed to unsubscribe admin online, registering for offline sync',
          'GROUP_REPO');
      // Nothing else to do here if the table is not yet exposed in the Data API.
    }
  }

// --- Attendance ---

  @override
  Future<void> saveAttendance(List<GroupAttendance> attendance) async {
    if (_isarService.isReady) {
      final isar = _isarService.db;
      final models = attendance.map((a) {
        final m = GroupAttendanceModel.fromDomain(a);
        m.lastSyncedAt = AppDateTime.nowUtc();
        return m;
      }).toList();

      await isar.writeTxn(() async {
        await isar.groupAttendanceModels.putAll(models);
      });
    }

    try {
      final List<Map<String, dynamic>> jsonList =
          attendance.map((a) => a.toJson()..remove('id')).toList();
      await _supabase.from('group_attendance').upsert(
            jsonList,
            onConflict: 'group_id, member_id, attendance_date',
          );
    } catch (e) {
      AppLogger.w(
          'Failed to save attendance online, registering for offline sync',
          'GROUP_REPO');
      if (_isarService.isReady) {
        for (final item in attendance) {
          await _syncManager.registerAction(
            entityType: 'group_attendance',
            action: 'UPSERT',
            payload: item.toJson(),
            recordId: item.id,
            churchId: item.toJson()['church_id']?.toString() ?? '',
          );
        }
      }
    }
  }

  @override
  Future<List<GroupAttendance>> getAttendance(
    String groupId,
    DateTime date,
  ) async {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    if (!_isarService.isReady) {
      final List<dynamic> data = await _supabase
          .from('group_attendance')
          .select()
          .eq('group_id', groupId)
          .eq('attendance_date', normalizedDate.toIso8601String());
      return data.map((json) => GroupAttendance.fromJson(json)).toList();
    }
    final isar = _isarService.db;

    try {
      final List<dynamic> data = await _supabase
          .from('group_attendance')
          .select()
          .eq('group_id', groupId)
          .eq('attendance_date', normalizedDate.toIso8601String());

      await isar.writeTxn(() async {
        for (final json in data) {
          final attendance = GroupAttendance.fromJson(json);
          await isar.groupAttendanceModels.put(
            GroupAttendanceModel.fromDomain(attendance),
          );
        }
      });
    } catch (e) {
      AppLogger.e('Failed to fetch/sync attendance for $groupId on $date',
          'GROUP_REPO', e);
    }

    final models = await isar.groupAttendanceModels
        .filter()
        .groupIdEqualTo(groupId)
        .attendanceDateEqualTo(normalizedDate)
        .findAll();
    return models.map((m) => m.toDomain()).toList();
  }

  @override
  Stream<List<GroupAttendance>> watchAttendance(String groupId, DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    if (!_isarService.isReady) {
      return _supabase
          .from('group_attendance')
          .stream(primaryKey: ['id'])
          .eq('group_id', groupId)
          .map((data) => data
              .where((json) =>
                  json['attendance_date'] == normalizedDate.toIso8601String())
              .map((json) => GroupAttendance.fromJson(json))
              .toList());
    }
    return _isarService.db.groupAttendanceModels
        .filter()
        .groupIdEqualTo(groupId)
        .attendanceDateEqualTo(normalizedDate)
        .watch(fireImmediately: true)
        .map((models) => models.map((m) => m.toDomain()).toList());
  }

  @override
  Future<List<GroupAttendance>> getGroupAttendanceHistory(
    String groupId, {
    DateTime? since,
  }) async {
    if (!_isarService.isReady) {
      var query =
          _supabase.from('group_attendance').select().eq('group_id', groupId);

      if (since != null) {
        query = query.gte('attendance_date', since.toIso8601String());
      }
      final List<dynamic> data =
          await query.order('attendance_date', ascending: false);
      return data.map((json) => GroupAttendance.fromJson(json)).toList();
    }
    final isar = _isarService.db;
    var query =
        _supabase.from('group_attendance').select().eq('group_id', groupId);

    if (since != null) {
      query = query.gte('attendance_date', since.toIso8601String());
    }

    try {
      final List<dynamic> data =
          await query.order('attendance_date', ascending: false);
      await isar.writeTxn(() async {
        for (final json in data) {
          final attendance = GroupAttendance.fromJson(json);
          await isar.groupAttendanceModels.put(
            GroupAttendanceModel.fromDomain(attendance),
          );
        }
      });
    } catch (e) {
      AppLogger.e('Failed to fetch/sync attendance history for $groupId',
          'GROUP_REPO', e);
    }

    var isarQuery = isar.groupAttendanceModels.filter().groupIdEqualTo(groupId);
    if (since != null) {
      isarQuery = isarQuery
          .attendanceDateGreaterThan(since.subtract(const Duration(days: 1)));
    }

    final models = await isarQuery.sortByAttendanceDateDesc().findAll();
    return models.map((m) => m.toDomain()).toList();
  }

  // --- Member Transfers ---

  @override
  Future<String> createTransferRequest(MemberTransferRequest request) async {
    if (_isarService.isReady) {
      final isar = _isarService.db;
      final model = MemberTransferRequestModel.fromDomain(request);
      model.lastSyncedAt = AppDateTime.nowUtc();

      await isar.writeTxn(() async {
        await isar.memberTransferRequestModels.put(model);
      });
    }

    try {
      final json = request.toJson()..remove('id');
      final response = await _supabase
          .from('member_transfer_requests')
          .insert(json)
          .select('id')
          .single();
      return response['id'] as String;
    } catch (e) {
      AppLogger.w(
          'Failed to create transfer request online, registering for offline sync',
          'GROUP_REPO');
      if (_isarService.isReady) {
        await _syncManager.registerAction(
          entityType: 'member_transfer_requests',
          action: 'INSERT',
          payload: request.toJson(),
          recordId: request.id,
          churchId: request.toJson()['from_church_id']?.toString() ?? '',
        );
      }
      return request.id;
    }
  }

  @override
  Future<void> updateTransferStatus(
    String requestId,
    TransferStatus status, {
    String? notes,
    String? approvedBy,
    required String churchId,
  }) async {
    if (_isarService.isReady) {
      final isar = _isarService.db;
      await isar.writeTxn(() async {
        final request = await isar.memberTransferRequestModels
            .filter()
            .originalIdEqualTo(requestId)
            .findFirst();

        if (request != null) {
          request.status = status;
          if (notes != null) request.notes = notes;
          if (approvedBy != null) request.approvedBy = approvedBy;
          request.approvedAt = AppDateTime.nowUtc();
          request.lastSyncedAt = AppDateTime.nowUtc();
          await isar.memberTransferRequestModels.put(request);
        }
      });
    }

    try {
      final updates = {
        'status': status.name.toUpperCase(),
        if (notes != null) 'notes': notes,
        if (approvedBy != null) 'approved_by': approvedBy,
        'approved_at': AppDateTime.nowIso(),
      };
      await _supabase
          .from('member_transfer_requests')
          .update(updates)
          .eq('id', requestId);
    } catch (e) {
      AppLogger.w(
          'Failed to update transfer status online, registering for offline sync',
          'GROUP_REPO');
      if (_isarService.isReady) {
        await _syncManager.registerAction(
          entityType: 'member_transfer_requests',
          action: 'UPDATE',
          payload: {
            'id': requestId,
            'status': status.name.toUpperCase(),
            if (notes != null) 'notes': notes,
            if (approvedBy != null) 'approved_by': approvedBy,
            'approved_at': AppDateTime.nowIso(),
          },
          recordId: requestId,
          churchId: churchId,
        );
      }
    }
  }

  @override
  Future<List<MemberTransferRequest>> getTransferRequests({
    String? groupId,
    String? memberId,
  }) async {
    if (!_isarService.isReady) {
      var query = _supabase.from('member_transfer_requests').select();
      if (groupId != null) {
        query = query.eq('from_group_id', groupId);
      }
      if (memberId != null) query = query.eq('member_id', memberId);

      final List<dynamic> data = await query;
      return data.map((json) => MemberTransferRequest.fromJson(json)).toList();
    }
    final isar = _isarService.db;
    var query = _supabase.from('member_transfer_requests').select();

    if (groupId != null) query = query.eq('from_group_id', groupId);
    if (memberId != null) query = query.eq('member_id', memberId);

    try {
      final List<dynamic> data = await query;
      await isar.writeTxn(() async {
        for (final json in data) {
          final request = MemberTransferRequest.fromJson(json);
          await isar.memberTransferRequestModels.put(
            MemberTransferRequestModel.fromDomain(request),
          );
        }
      });
    } catch (e) {
      AppLogger.e('Failed to fetch/sync transfer requests', 'GROUP_REPO', e);
    }

    final models = await isar.memberTransferRequestModels
        .filter()
        .optional(groupId != null, (q) => q.fromGroupIdEqualTo(groupId!))
        .optional(memberId != null, (q) => q.memberIdEqualTo(memberId!))
        .findAll();
    return models.map((m) => m.toDomain()).toList();
  }

  @override
  Future<List<GroupAttendance>> getMemberAttendanceHistory(
      String memberId) async {
    if (!_isarService.isReady) {
      final List<dynamic> data = await _supabase
          .from('group_attendance')
          .select()
          .eq('member_id', memberId)
          .order('attendance_date', ascending: false);
      return data.map((json) => GroupAttendance.fromJson(json)).toList();
    }
    final isar = _isarService.db;

    try {
      final List<dynamic> data = await _supabase
          .from('group_attendance')
          .select()
          .eq('member_id', memberId)
          .order('attendance_date', ascending: false);

      await isar.writeTxn(() async {
        for (final json in data) {
          final attendance = GroupAttendance.fromJson(json);
          await isar.groupAttendanceModels.put(
            GroupAttendanceModel.fromDomain(attendance),
          );
        }
      });
    } catch (e) {
      AppLogger.e(
          'Failed to fetch/sync member attendance history for $memberId',
          'GROUP_REPO',
          e);
    }

    final models = await isar.groupAttendanceModels
        .filter()
        .memberIdEqualTo(memberId)
        .sortByAttendanceDateDesc()
        .findAll();
    return models.map((m) => m.toDomain()).toList();
  }
}
