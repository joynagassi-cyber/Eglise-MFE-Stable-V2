import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/auth/domain/entities/enums/permission.dart';
import '../../../../core/providers/legacy_compatibility_providers.dart';

/// Widget qui affiche son enfant uniquement si l'utilisateur a les permissions requises.
///
/// Si l'accès est refusé, affiche [fallback] ou rien (SizedBox.shrink).
///
/// Exemple :
/// ```dart
/// PermissionGuard(
///   permission: Permission.financeCreate,
///   child: FloatingActionButton(...),
/// )
/// ```
class PermissionGuard extends ConsumerWidget {
  /// Enfant à afficher si autorisé
  final Widget child;

  /// Permission unique requise
  final Permission? permission;

  /// Liste de permissions requises
  final Set<Permission>? permissions;

  /// Si true, toutes les permissions sont requises (AND)
  /// Si false, au moins une permission est requise (OR)
  /// Par défaut : true
  final bool requireAll;

  /// Widget affiché si non autorisé (optionnel)
  /// Par défaut : SizedBox.shrink()
  final Widget? fallback;

  const PermissionGuard({
    super.key,
    required this.child,
    this.permission,
    this.permissions,
    this.requireAll = true,
    this.fallback,
  }) : assert(
          permission != null || permissions != null,
          'Permission or permissions must be provided',
        );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Super Admin Check (Optimisation)
    final isSuper = ref.watch(isSuperAdminProvider);
    if (isSuper) {
      return child;
    }

    // 2. Vérification des permissions
    bool isAuthorized = false;

    if (permission != null) {
      // Cas simple : une seule permission
      isAuthorized = ref.watch(hasPermissionProvider(permission!));
    } else if (permissions != null && permissions!.isNotEmpty) {
      // Cas complexe : multiples permissions
      if (requireAll) {
        isAuthorized = ref.watch(hasAllPermissionsProvider(permissions!));
      } else {
        isAuthorized = ref.watch(hasAnyPermissionProvider(permissions!));
      }
    }

    // 3. Rendu
    return isAuthorized ? child : (fallback ?? const SizedBox.shrink());
  }
}