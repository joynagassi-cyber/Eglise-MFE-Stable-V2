// lib/core/services/access_control_service.dart
// Service de contrôle d'accès pour les 3 règles de gestion

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:lumina/core/providers/auth_provider.dart';
import '../auth/domain/entities/enums/role_level.dart';
import '../auth/domain/entities/enums/permission.dart';
import '../auth/domain/entities/module.dart';
import 'package:lumina/core/providers/supabase_provider.dart';

part 'access_control_service.g.dart';

/// Service de contrôle d'accès pour implémenter les 3 règles
@riverpod
class AccessControlService extends _$AccessControlService {
  @override
  Future<AccessControlState> build() async {
    final authState = ref.watch(authProvider).valueOrNull;

    if (authState == null) {
      return const AccessControlState(
        userRole: RoleLevel.consultation,
        accessibleModules: [],
        permissions: {},
        isSuperAdmin: false,
      );
    }

    // Déterminer les modules accessibles en fonction des permissions
    final accessibleModules = <String>[];
    final perms = authState.role?.permissions ?? {};
    if (perms.values
        .any((resourcePerms) => resourcePerms.containsKey('members'))) {
      accessibleModules.add('membres');
    }
    if (perms.values
        .any((resourcePerms) => resourcePerms.containsKey('finance'))) {
      accessibleModules.add('finances');
    }
    if (perms.values
        .any((resourcePerms) => resourcePerms.containsKey('events'))) {
      accessibleModules.add('evenements');
    }
    // L'onglet 'eglise' est généralement accessible par défaut pour les infos de base
    accessibleModules.add('eglise');

    return AccessControlState(
      userRole: authState.role?.level ?? RoleLevel.consultation,
      accessibleModules: authState.isSuperAdmin
          ? Module.defaultModules.map((m) => m.id).toList()
          : accessibleModules,
      permissions: Map.fromEntries(
        authState.role?.permissions.entries.expand(
              (entry) => entry.value.entries.map(
                (action) => MapEntry(
                  Permission.values.firstWhere(
                    (p) => p.resource == entry.key && p.action == action.key,
                    orElse: () => Permission.values.first,
                  ),
                  true,
                ),
              ),
            ) ??
            [],
      ),
      isSuperAdmin: authState.isSuperAdmin,
    );
  }

  /// Règle 1 : Vérifier si l'utilisateur est Super Admin
  bool isSuperAdmin() {
    return state.value?.isSuperAdmin ?? false;
  }

  /// Règle 2 : Vérifier si un module est public équipe
  bool isPublicTeamModule(String moduleId) {
    final module = Module.defaultModules.firstWhere(
      (m) => m.id == moduleId,
      orElse: () => Module(
        id: '',
        name: '',
        description: '',
        icon: '',
        category: ModuleCategory.community,
        order: 0,
        visibility: ModuleVisibility.private,
        createdAt: DateTime.now(),
      ),
    );
    return module.isPublicTeam;
  }

  /// Règle 3 : Vérifier l'accès à un module
  bool canAccessModule(String moduleId) {
    final currentState = state.value;
    if (currentState == null) return false;

    // Règle 1 : Super Admin a accès à tout
    if (currentState.isSuperAdmin) {
      return true;
    }

    // Règle 2 : Vérifier si le module est public équipe
    if (isPublicTeamModule(moduleId)) {
      return currentState.userRole.priority <= RoleLevel.groupLeader.priority;
    }

    // Règle 3 : Vérifier si l'utilisateur a une permission explicite
    return currentState.accessibleModules.contains(moduleId);
  }

  /// Règle 4 : Vérifier une permission spécifique
  bool hasPermission(Permission permission) {
    final currentState = state.value;
    if (currentState == null) return false;

    // Super Admin a toutes les permissions
    if (currentState.isSuperAdmin) {
      return true;
    }

    return currentState.permissions[permission] ?? false;
  }

  /// Règle 5 : Compter les Super Admins actuels
  Future<int> getSuperAdminCount() async {
    final supabase = ref.read(supabaseProvider);
    final response =
        await supabase.from('profiles').select('*').eq('role', 'super_admin');

    return (response as List).length;
  }

  /// Règle 6 : Vérifier si on peut ajouter un Super Admin
  Future<bool> canAddSuperAdmin() async {
    final count = await getSuperAdminCount();
    return count < 3;
  }

  /// Attribuer un rôle à un utilisateur (seulement Super Admin)
  Future<void> assignRole({
    required String userId,
    required RoleLevel newRole,
  }) async {
    // Vérification : seul un Super Admin peut attribuer des rôles
    if (!isSuperAdmin()) {
      throw const AccessDeniedException(
        'Seuls les Super Administrateurs peuvent attribuer des rôles.',
      );
    }

    // Vérification : limite des Super Admins
    if (newRole == RoleLevel.adminTotal) {
      final canAdd = await canAddSuperAdmin();
      if (!canAdd) {
        throw const AccessDeniedException(
          'Limite de 3 Super Administrateurs atteinte.',
        );
      }
    }

    // Enregistrer dans Supabase via RPC ou mise à jour directe (sous réserve de RLS)
    final supabase = ref.read(supabaseProvider);
    await supabase.from('profiles').update({
      'role_level': newRole.name,
    }).eq('id', userId);

    // Recharger l'état
    ref.invalidateSelf();
  }

  /// Attribuer l'accès à un module (seulement Super Admin)
  Future<void> grantModuleAccess({
    required String userId,
    required String moduleId,
  }) async {
    if (!isSuperAdmin()) {
      throw const AccessDeniedException(
        'Seuls les Super Administrateurs peuvent attribuer des accès modules.',
      );
    }

    // Enregistrer dans Supabase (table user_modules ou similaire dans RBAC v3)
    final supabase = ref.read(supabaseProvider);
    await supabase.from('user_churches').update({
      'role_id': moduleId, // À adapter selon le schéma exact des permissions
    }).eq('user_id', userId);

    ref.invalidateSelf();
  }

  /// Définir les modules publics équipe (seulement Super Admin)
  Future<void> setPublicTeamModules(List<String> moduleIds) async {
    if (!isSuperAdmin()) {
      throw const AccessDeniedException(
        'Seuls les Super Administrateurs peuvent définir les modules publics.',
      );
    }

    // Enregistrer dans la configuration (table app_settings ou churches)
    final supabase = ref.read(supabaseProvider);
    final churchId = ref.read(authProvider).valueOrNull?.activeChurchId;
    if (churchId == null) return;

    await supabase.from('churches').update({
      'settings': {
        'public_team_modules': moduleIds,
      }
    }).eq('id', churchId);

    ref.invalidateSelf();
  }

  /// Recharger les permissions depuis le backend
  Future<void> refreshPermissions() async {
    ref.invalidateSelf();
  }
}

/// État du contrôle d'accès
class AccessControlState {
  final RoleLevel userRole;
  final List<String> accessibleModules;
  final Map<Permission, bool> permissions;
  final bool isSuperAdmin;

  const AccessControlState({
    required this.userRole,
    required this.accessibleModules,
    required this.permissions,
    required this.isSuperAdmin,
  });

  /// Créer un état pour Super Admin
  factory AccessControlState.superAdmin() {
    return AccessControlState(
      userRole: RoleLevel.adminTotal,
      accessibleModules: Module.defaultModules.map((m) => m.id).toList(),
      permissions: {for (var p in Permission.values) p: true},
      isSuperAdmin: true,
    );
  }

  /// Vérifier l'accès à un module
  bool canAccessModule(String moduleId) {
    // Super Admin a accès à tout
    if (isSuperAdmin) {
      return true;
    }

    // Vérifier si l'utilisateur a une permission explicite
    return accessibleModules.contains(moduleId);
  }

  /// Vérifier une permission spécifique
  bool hasPermission(Permission permission) {
    // Super Admin a toutes les permissions
    if (isSuperAdmin) {
      return true;
    }

    return permissions[permission] ?? false;
  }
}

/// Exception personnalisée pour les accès refusés
class AccessDeniedException implements Exception {
  final String message;

  const AccessDeniedException(this.message);

  @override
  String toString() => 'AccessDeniedException: $message';
}

/// Provider pour vérifier l'accès à un module
@riverpod
bool canAccessModule(CanAccessModuleRef ref, String moduleId) {
  final service = ref.watch(accessControlServiceProvider);
  return service.value?.canAccessModule(moduleId) ?? false;
}

/// Provider pour vérifier une permission
@riverpod
bool hasPermissionAccess(HasPermissionAccessRef ref, Permission permission) {
  final service = ref.watch(accessControlServiceProvider);
  return service.value?.hasPermission(permission) ?? false;
}

/// Widget pour conditionner l'affichage selon l'accès
class AccessGuard extends ConsumerWidget {
  final String moduleId;
  final Widget child;
  final Widget? fallback;

  const AccessGuard({
    super.key,
    required this.moduleId,
    required this.child,
    this.fallback,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasAccess = ref.watch(canAccessModuleProvider(moduleId));

    if (!hasAccess) {
      return fallback ?? const SizedBox.shrink();
    }

    return child;
  }
}

/// Widget pour conditionner l'affichage selon une permission
class PermissionGuard extends ConsumerWidget {
  final Permission permission;
  final Widget child;
  final Widget? fallback;

  const PermissionGuard({
    super.key,
    required this.permission,
    required this.child,
    this.fallback,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasAccess = ref.watch(hasPermissionAccessProvider(permission));

    if (!hasAccess) {
      return fallback ?? const SizedBox.shrink();
    }

    return child;
  }
}
