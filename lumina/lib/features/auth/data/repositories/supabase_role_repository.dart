import 'package:isar/isar.dart';
import 'package:lumina/core/logging/app_logger.dart';
import 'package:lumina/core/data/local/isar_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/auth/domain/entities/church_role.dart';
import '../../../../core/auth/domain/entities/user_role.dart';
import '../../../../core/auth/domain/entities/enums/permission.dart';
import '../../domain/repositories/role_repository.dart';
import '../models/role_model.dart';
import '../../../../core/utils/app_date_time.dart';

/// Implémentation du repository de rôles avec Supabase + Isar
class SupabaseRoleRepository implements RoleRepository {
  final SupabaseClient supabase;
  final IsarService _isarService;

  SupabaseRoleRepository({required this.supabase, required IsarService isar})
      : _isarService = isar;

  Isar get isar => _isarService.db;

  static const String _collectionName = 'roles';

  @override
  Future<List<ChurchRole>> getAllRoles({
    required String churchId,
    bool includeInactive = false,
  }) async {
    try {
      var dbQuery =
          supabase.from(_collectionName).select().eq('church_id', churchId);
      if (!includeInactive) {
        dbQuery = dbQuery.eq('is_active', true);
      }
      final data = await dbQuery;
      final roleModels =
          (data as List).map((r) => RoleModel.fromSupabase(r)).toList();

      if (_isarService.isReady) {
        await isar.writeTxn(() async {
          await isar.roleModels.filter().churchIdEqualTo(churchId).deleteAll();
          await isar.roleModels.putAll(roleModels);
        });
      }
      return roleModels.map((m) => m.toDomain()).toList();
    } catch (e) {
      if (_isarService.isReady) {
        var query = isar.roleModels.filter().churchIdEqualTo(churchId);
        if (!includeInactive) query = query.isActiveEqualTo(true);
        final models = await query.findAll();
        return models.map((m) => m.toDomain()).toList();
      }
      return [];
    }
  }

  @override
  Future<ChurchRole?> getRoleById(String roleId) async {
    if (_isarService.isReady) {
      final model =
          await isar.roleModels.filter().idEqualTo(roleId).findFirst();
      if (model != null) return model.toDomain();
    }

    try {
      final data = await supabase
          .from(_collectionName)
          .select()
          .eq('id', roleId)
          .maybeSingle();
      if (data == null) return null;
      final roleModel = RoleModel.fromSupabase(data);
      if (_isarService.isReady) {
        await isar.writeTxn(() async {
          await isar.roleModels.put(roleModel);
        });
      }
      return roleModel.toDomain();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<ChurchRole>> getSystemRoles({required String churchId}) async {
    final allRoles = await getAllRoles(churchId: churchId);
    return allRoles.where((r) => r.isSystemRole).toList();
  }

  @override
  Future<List<ChurchRole>> getCustomRoles({
    required String churchId,
    bool includeInactive = false,
  }) async {
    final allRoles =
        await getAllRoles(churchId: churchId, includeInactive: includeInactive);
    return allRoles.where((r) => !r.isSystemRole).toList();
  }

  @override
  Future<ChurchRole> createRole(ChurchRole role) async {
    try {
      final data = RoleModel.fromDomain(role).toSupabase();
      final response =
          await supabase.from(_collectionName).insert(data).select().single();
      final roleModel = RoleModel.fromSupabase(response);
      if (_isarService.isReady) {
        await isar.writeTxn(() async {
          await isar.roleModels.put(roleModel);
        });
      }
      return roleModel.toDomain();
    } catch (e) {
      if (_isarService.isReady) {
        final roleModel = RoleModel.fromDomain(role)
          ..isSynced = false
          ..pendingDeletion = false;
        await isar.writeTxn(() async {
          await isar.roleModels.put(roleModel);
        });
      }
      return role;
    }
  }

  @override
  Future<ChurchRole> updateRole(ChurchRole role) async {
    if (role.isSystemRole) {
      throw Exception('Les rôles système ne peuvent pas être modifiés');
    }
    try {
      final data = RoleModel.fromDomain(role).toSupabase();
      final response = await supabase
          .from(_collectionName)
          .update(data)
          .eq('id', role.id)
          .select()
          .single();
      final roleModel = RoleModel.fromSupabase(response);
      if (_isarService.isReady) {
        await isar.writeTxn(() async {
          await isar.roleModels.put(roleModel);
        });
      }
      return roleModel.toDomain();
    } catch (e) {
      if (_isarService.isReady) {
        final roleModel = RoleModel.fromDomain(role)..isSynced = false;
        await isar.writeTxn(() async {
          await isar.roleModels.put(roleModel);
        });
      }
      return role;
    }
  }

  @override
  Future<void> deleteRole(String roleId) async {
    final role = await getRoleById(roleId);
    if (role == null || role.isSystemRole) return;
    try {
      await supabase.from(_collectionName).delete().eq('id', roleId);
      if (_isarService.isReady) {
        await isar.writeTxn(() async {
          await isar.roleModels.filter().idEqualTo(roleId).deleteFirst();
        });
      }
    } catch (e) {
      if (_isarService.isReady) {
        final model =
            await isar.roleModels.filter().idEqualTo(roleId).findFirst();
        if (model != null) {
          model.pendingDeletion = true;
          await isar.writeTxn(() async {
            await isar.roleModels.put(model);
          });
        }
      }
      rethrow;
    }
  }

  @override
  List<Permission> getAllPermissions() => Permission.values;

  @override
  Map<String, List<Permission>> getPermissionsByModule() {
    final grouped = <String, List<Permission>>{};
    for (final p in Permission.values) {
      grouped.putIfAbsent(p.module, () => []).add(p);
    }
    return grouped;
  }

  @override
  Future<bool> roleHasPermission(
      {required String roleId, required Permission permission}) async {
    final role = await getRoleById(roleId);
    return role?.hasPermission(permission) ?? false;
  }

  @override
  Future<ChurchRole> addPermissionsToRole(
      {required String roleId, required Set<Permission> permissions}) async {
    final role = await getRoleById(roleId);
    if (role == null) throw Exception('Rôle introuvable');
    return updateRole(role.copyWith(
        permissions: {...role.permissions, ...permissions},
        updatedAt: AppDateTime.nowUtc()));
  }

  @override
  Future<ChurchRole> removePermissionsFromRole(
      {required String roleId, required Set<Permission> permissions}) async {
    final role = await getRoleById(roleId);
    if (role == null) throw Exception('Rôle introuvable');
    return updateRole(role.copyWith(
        permissions: role.permissions.difference(permissions),
        updatedAt: AppDateTime.nowUtc()));
  }

  @override
  Future<ChurchRole?> getUserRole(
      {required String userId, required String churchId}) async {
    try {
      final data = await supabase
          .from('user_roles')
          .select('role_id')
          .eq('user_id', userId)
          .limit(1)
          .maybeSingle();
      if (data == null) return null;
      return await getRoleById(data["role_id"]);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> assignRoleToUser(
      {required String userId,
      required String churchId,
      required String roleId,
      String? groupId}) async {
    await supabase.from('user_roles').insert({
      'user_id': userId,
      'church_id': churchId,
      'role_id': roleId,
      if (groupId != null) 'group_id': groupId,
    });
  }

  @override
  Future<void> changeUserRole(
      {required String userId,
      required String churchId,
      required String newRoleId}) async {
    final existing = await supabase
        .from('user_roles')
        .select('id')
        .eq('user_id', userId)
        .eq('church_id', churchId)
        .limit(1)
        .maybeSingle();
    if (existing == null) {
      await assignRoleToUser(
          userId: userId, churchId: churchId, roleId: newRoleId);
    } else {
      await supabase
          .from('user_roles')
          .update({'role_id': newRoleId}).eq('id', existing['id']);
    }
  }

  @override
  Future<List<String>> getUsersByRole(
      {required String churchId, required String roleId}) async {
    try {
      final data = await supabase
          .from('user_roles')
          .select('user_id')
          .eq('role_id', roleId);
      return (data as List).map((r) => r['user_id'] as String).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<ChurchRole?> assignDefaultRole(
      {required String userId, String? churchId}) async {
    try {
      final data = await supabase
          .from(_collectionName)
          .select('id, church_id')
          .eq('code', 'membre')
          .maybeSingle();
      if (data == null) return null;
      final roleId = data['id'];
      final targetChurchId = churchId ?? data['church_id'] as String;
      await assignRoleToUser(
          userId: userId, churchId: targetChurchId, roleId: roleId);
      return await getRoleById(roleId);
    } catch (e) {
      AppLogger.e('Error assigning default role', 'ROLE_REPO', e);
      return null;
    }
  }

  @override
  Future<void> syncRoles({required String churchId}) async {
    final data =
        await supabase.from(_collectionName).select().eq('church_id', churchId);
    final roleModels =
        (data as List).map((r) => RoleModel.fromSupabase(r)).toList();
    if (_isarService.isReady) {
      await isar.writeTxn(() async {
        await isar.roleModels.filter().churchIdEqualTo(churchId).deleteAll();
        await isar.roleModels.putAll(roleModels);
      });
    }
  }

  @override
  Future<void> seedSystemRoles({required String churchId}) async {
    final systemRoles = [
      ChurchRole.admin(churchId: churchId),
      ChurchRole.pasteur(churchId: churchId),
      ChurchRole.leader(churchId: churchId),
      ChurchRole.technicien(churchId: churchId),
      ChurchRole.secretaire(churchId: churchId),
      ChurchRole.tresorier(churchId: churchId),
      ChurchRole.berger(churchId: churchId),
      ChurchRole.observateur(churchId: churchId),
      ChurchRole.membre(churchId: churchId),
    ];
    for (final role in systemRoles) {
      try {
        await createRole(role);
      } catch (e) {
        AppLogger.e('Error marking roles as inactive', 'ROLE_REPO', e);
      }
    }
  }

  @override
  Stream<List<ChurchRole>> watchRoles({required String churchId}) async* {
    if (!_isarService.isReady) {
      yield* supabase
          .from(_collectionName)
          .stream(primaryKey: ['id'])
          .eq('church_id', churchId)
          .map((records) => records
              .where((r) => r['is_active'] == true)
              .map((r) => RoleModel.fromSupabase(r).toDomain())
              .toList());
      return;
    }
    yield* isar.roleModels
        .filter()
        .churchIdEqualTo(churchId)
        .isActiveEqualTo(true)
        .watch(fireImmediately: true)
        .map((models) => models.map((m) => m.toDomain()).toList());
  }

  @override
  Stream<ChurchRole?> watchRole(String roleId) async* {
    if (!_isarService.isReady) {
      yield* supabase
          .from(_collectionName)
          .stream(primaryKey: ['id'])
          .eq('id', roleId)
          .map((data) => data.isEmpty
              ? null
              : RoleModel.fromSupabase(data.first).toDomain());
      return;
    }
    yield* isar.roleModels
        .filter()
        .idEqualTo(roleId)
        .watch(fireImmediately: true)
        .map((models) => models.isEmpty ? null : models.first.toDomain());
  }

  @override
  Future<List<UserRole>> getAvailableRolesForUser(String userId) async {
    try {
      final data = await supabase
          .from('user_roles')
          .select('role_id, roles(code, label, is_super, priority_level)')
          .eq('user_id', userId);
      final list = data as List;
      return list.map((item) {
        final role = item['roles'];
        return UserRole(
          roleId: item['role_id'] as String? ?? '',
          roleCode: role['code'] ?? '',
          roleLabel: role['label'] ?? '',
          isSuper: role['is_super'] ?? false,
          priorityLevel: role['priority_level'] ?? 100,
        );
      }).toList();
    } catch (e) {
      AppLogger.e('Error fetching available roles', 'ROLE_REPO', e);
      return [];
    }
  }

  @override
  Future<void> switchActiveRole(
      {required String userId, required String roleId, String? groupId}) async {
    try {
      await supabase.from('user_sessions').upsert({
        'user_id': userId,
        'active_role_id': roleId,
        'active_group_id': groupId,
        'last_switch': AppDateTime.nowIso(),
      });
    } catch (e) {
      AppLogger.e('Error switching active role', 'ROLE_REPO', e);
      rethrow;
    }
  }
}