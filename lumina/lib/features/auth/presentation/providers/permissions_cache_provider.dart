import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/auth/domain/entities/enums/permission.dart';
import '../../../../core/providers/auth_provider.dart';

part 'permissions_cache_provider.g.dart';

/// Cache des permissions utilisateur pour éviter recalculs
///
/// Recalculé uniquement quand la session change
@riverpod
class PermissionsCache extends _$PermissionsCache {
  @override
  Map<Permission, bool> build() {
    final session = ref.watch(authProvider).valueOrNull;

    if (session == null) {
      return {for (var p in Permission.values) p: false};
    }

    // Calculer une seule fois toutes les permissions
    return {
      for (var p in Permission.values)
        p: session.hasPermission(p.resource, p.action)
    };
  }

  /// Vérifie une permission depuis le cache
  bool has(Permission permission) {
    return state[permission] ?? false;
  }
}

/// Provider simplifié pour vérifier une permission
@riverpod
bool hasPermissionCached(HasPermissionCachedRef ref, Permission permission) {
  return ref.watch(permissionsCacheProvider)[permission] ?? false;
}

/// Provider pour vérifier plusieurs permissions (toutes requises)
@riverpod
bool hasAllPermissionsCached(
  HasAllPermissionsCachedRef ref,
  Set<Permission> permissions,
) {
  final cache = ref.watch(permissionsCacheProvider);
  return permissions.every((p) => cache[p] ?? false);
}

/// Provider pour vérifier plusieurs permissions (au moins une)
@riverpod
bool hasAnyPermissionCached(
  HasAnyPermissionCachedRef ref,
  Set<Permission> permissions,
) {
  final cache = ref.watch(permissionsCacheProvider);
  return permissions.any((p) => cache[p] ?? false);
}