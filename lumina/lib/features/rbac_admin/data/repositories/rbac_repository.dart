import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/mixins/auditable_mixin.dart';
import '../../../../core/domain/entities/enums/audit_action.dart';
import '../models/rbac_models.dart';

class RbacRepository with AuditableMixin {
  final SupabaseClient _supabase;
  final Ref _ref;

  RbacRepository(this._supabase, this._ref);

  Future<List<Permission>> getAllPermissions() async {
    final data = await _supabase.from('permissions').select().order('module');
    return (data as List).map((e) => Permission.fromJson(e)).toList();
  }

  Future<List<Role>> getAllRoles() async {
    final data = await _supabase
        .from('roles')
        .select()
        .order('priority_level', ascending: false);
    return (data as List).map((e) => Role.fromJson(e)).toList();
  }

  Future<List<String>> getPermissionsForRole(String roleId) async {
    final data = await _supabase
        .from('role_permissions')
        .select('permissions(code)')
        .eq('role_id', roleId);

    return (data as List)
        .map((e) => (e['permissions'] as Map)['code'] as String)
        .toList();
  }

  Future<void> grantPermission(String roleId, String permissionId) async {
    await _supabase.from('role_permissions').insert({
      'role_id': roleId,
      'permission_id': permissionId,
      'granted_by': _supabase.auth.currentUser?.id,
    });

    // Audit Log: Grant Permission
    await logAuditAction(
      _ref,
      action: AuditAction.insert,
      entityType: 'role_permissions',
      entityId: '$roleId|$permissionId',
      newData: {
        'role_id': roleId,
        'permission_id': permissionId,
      },
    );
  }

  Future<void> revokePermission(String roleId, String permissionId) async {
    await _supabase.from('role_permissions').delete().match({
      'role_id': roleId,
      'permission_id': permissionId,
    });

    // Audit Log: Revoke Permission
    await logAuditAction(
      _ref,
      action: AuditAction.delete,
      entityType: 'role_permissions',
      entityId: '$roleId|$permissionId',
      oldData: {
        'role_id': roleId,
        'permission_id': permissionId,
      },
    );
  }

  Future<List<String>> getUserPermissions(String userId) async {
    final res = await _supabase.rpc(
      'get_user_permissions',
      params: {'p_user_id': userId},
    );
    return (res as List).map((e) => e['code'] as String).toList();
  }

  Future<void> toggleUserRole({required String userId, required String roleId, required bool assign}) async {
    if (assign) {
      await _supabase.from('user_roles').insert({
        'user_id': userId,
        'role_id': roleId,
      });
      // Audit Log
      await logAuditAction(
        _ref,
        action: AuditAction.insert,
        entityType: 'user_roles',
        entityId: '$userId|$roleId',
        newData: {
          'user_id': userId,
          'role_id': roleId,
        },
      );
    } else {
      await _supabase.from('user_roles').delete().match({
        'user_id': userId,
        'role_id': roleId,
      });
      // Audit Log
      await logAuditAction(
        _ref,
        action: AuditAction.delete,
        entityType: 'user_roles',
        entityId: '$userId|$roleId',
        oldData: {
          'user_id': userId,
          'role_id': roleId,
        },
      );
    }
  }
}