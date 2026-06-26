import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/auth/domain/entities/church_role.dart';
import '../../../../core/auth/domain/entities/enums/permission.dart';
import 'package:lumina/core/providers/repository_providers_auth.dart';

part 'role_provider.g.dart';

// ============================================
// PROVIDERS DE LECTURE
// ============================================

/// Provider pour récupérer tous les rôles d'une église
@riverpod
Future<List<ChurchRole>> allRoles(
  AllRolesRef ref, {
  required String churchId,
  bool includeInactive = false,
}) async {
  final repository = ref.watch(roleRepositoryProvider);
  return repository.getAllRoles(
    churchId: churchId,
    includeInactive: includeInactive,
  );
}

/// Provider pour récupérer les rôles système
@riverpod
Future<List<ChurchRole>> systemRoles(
  SystemRolesRef ref, {
  required String churchId,
}) async {
  final repository = ref.watch(roleRepositoryProvider);
  return repository.getSystemRoles(churchId: churchId);
}

/// Provider pour récupérer les rôles personnalisés
@riverpod
Future<List<ChurchRole>> customRoles(
  CustomRolesRef ref, {
  required String churchId,
  bool includeInactive = false,
}) async {
  final repository = ref.watch(roleRepositoryProvider);
  return repository.getCustomRoles(
    churchId: churchId,
    includeInactive: includeInactive,
  );
}

/// Provider pour récupérer un rôle par ID
@riverpod
Future<ChurchRole?> roleById(RoleByIdRef ref, String roleId) async {
  final repository = ref.watch(roleRepositoryProvider);
  return repository.getRoleById(roleId);
}

/// Provider pour récupérer le rôle d'un utilisateur
@riverpod
Future<ChurchRole?> userRole(
  UserRoleRef ref, {
  required String userId,
  required String churchId,
}) async {
  final repository = ref.watch(roleRepositoryProvider);
  return repository.getUserRole(userId: userId, churchId: churchId);
}

/// Provider pour récupérer toutes les permissions
@riverpod
List<Permission> allPermissions(AllPermissionsRef ref) {
  // Pas besoin de watch repository ici car c'est une enum statique
  return Permission.values;
}

/// Provider pour récupérer les permissions groupées par module
@riverpod
Map<String, List<Permission>> permissionsByModule(PermissionsByModuleRef ref) {
  final grouped = <String, List<Permission>>{};

  for (final permission in Permission.values) {
    final module = permission.module;
    grouped.putIfAbsent(module, () => []);
    grouped[module]!.add(permission);
  }

  return grouped;
}

// ============================================
// STREAMING
// ============================================

/// Stream de tous les rôles d'une église
@riverpod
Stream<List<ChurchRole>> watchRoles(
  WatchRolesRef ref, {
  required String churchId,
}) async* {
  final repository = ref.watch(roleRepositoryProvider);
  yield* repository.watchRoles(churchId: churchId);
}

/// Stream d'un rôle spécifique
@riverpod
Stream<ChurchRole?> watchRole(WatchRoleRef ref, String roleId) async* {
  final repository = ref.watch(roleRepositoryProvider);
  yield* repository.watchRole(roleId);
}

// ============================================
// ACTIONS
// ============================================

/// Helper class pour les actions sur les rôles
class RoleActions {
  final Ref ref;

  RoleActions(this.ref);

  /// Crée un nouveau rôle
  Future<ChurchRole> createRole(ChurchRole role) async {
    final repository = ref.read(roleRepositoryProvider);
    final createdRole = await repository.createRole(role);

    // Invalider le cache
    ref.invalidate(allRolesProvider);
    ref.invalidate(customRolesProvider);

    return createdRole;
  }

  /// Met à jour un rôle
  Future<ChurchRole> updateRole(ChurchRole role) async {
    final repository = ref.read(roleRepositoryProvider);
    final updatedRole = await repository.updateRole(role);

    // Invalider le cache
    ref.invalidate(allRolesProvider);
    ref.invalidate(customRolesProvider);
    ref.invalidate(roleByIdProvider(role.id));

    return updatedRole;
  }

  /// Supprime un rôle
  Future<void> deleteRole(String roleId) async {
    final repository = ref.read(roleRepositoryProvider);
    await repository.deleteRole(roleId);

    // Invalider le cache
    ref.invalidate(allRolesProvider);
    ref.invalidate(customRolesProvider);
    ref.invalidate(roleByIdProvider(roleId));
  }

  /// Ajoute des permissions à un rôle
  Future<ChurchRole> addPermissions({
    required String roleId,
    required Set<Permission> permissions,
  }) async {
    final repository = ref.read(roleRepositoryProvider);
    final updatedRole = await repository.addPermissionsToRole(
      roleId: roleId,
      permissions: permissions,
    );

    // Invalider le cache
    ref.invalidate(roleByIdProvider(roleId));

    return updatedRole;
  }

  /// Retire des permissions d'un rôle
  Future<ChurchRole> removePermissions({
    required String roleId,
    required Set<Permission> permissions,
  }) async {
    final repository = ref.read(roleRepositoryProvider);
    final updatedRole = await repository.removePermissionsFromRole(
      roleId: roleId,
      permissions: permissions,
    );

    // Invalider le cache
    ref.invalidate(roleByIdProvider(roleId));

    return updatedRole;
  }

  /// Assigne un rôle à un utilisateur
  Future<void> assignRoleToUser({
    required String userId,
    required String churchId,
    required String roleId,
    String? groupId,
  }) async {
    final repository = ref.read(roleRepositoryProvider);
    await repository.assignRoleToUser(
      userId: userId,
      churchId: churchId,
      roleId: roleId,
      groupId: groupId,
    );

    // Invalider le cache
    ref.invalidate(userRoleProvider(userId: userId, churchId: churchId));
  }

  /// Change le rôle d'un utilisateur
  Future<void> changeUserRole({
    required String userId,
    required String churchId,
    required String newRoleId,
  }) async {
    final repository = ref.read(roleRepositoryProvider);
    await repository.assignRoleToUser(
      userId: userId,
      churchId: churchId,
      roleId: newRoleId,
    );

    // Invalider le cache
    ref.invalidate(userRoleProvider(userId: userId, churchId: churchId));
  }

  /// Assigne le rôle par défaut (membre) à un utilisateur
  Future<ChurchRole?> assignDefaultRole({
    required String userId,
    String? churchId,
  }) async {
    final repository = ref.read(roleRepositoryProvider);
    final role = await repository.assignDefaultRole(
      userId: userId,
      churchId: churchId,
    );

    // Invalider le cache si un churchId a été utilisé / trouvé
    if (churchId != null) {
      ref.invalidate(userRoleProvider(userId: userId, churchId: churchId));
    }
    return role;
  }

  /// Synchronise les rôles avec Supabase
  Future<void> syncRoles({required String churchId}) async {
    final repository = ref.read(roleRepositoryProvider);
    await repository.syncRoles(churchId: churchId);

    // Invalider le cache
    ref.invalidate(allRolesProvider);
  }

  /// Initialise les rôles système pour une nouvelle église
  Future<void> seedSystemRoles({required String churchId}) async {
    final repository = ref.read(roleRepositoryProvider);
    await repository.seedSystemRoles(churchId: churchId);

    // Invalider le cache
    ref.invalidate(systemRolesProvider);
    ref.invalidate(allRolesProvider);
  }
}

/// Provider pour accéder aux actions sur les rôles
@riverpod
RoleActions roleActions(RoleActionsRef ref) {
  return RoleActions(ref);
}
