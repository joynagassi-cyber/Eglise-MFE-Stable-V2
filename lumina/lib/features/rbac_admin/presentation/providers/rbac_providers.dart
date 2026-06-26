import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/repositories/rbac_repository.dart';
import '../../data/models/rbac_models.dart';

// Providers
final rbacRepositoryProvider = Provider<RbacRepository>((ref) {
  return RbacRepository(Supabase.instance.client, ref);
});

final userPermissionsProvider = FutureProvider.autoDispose<List<String>>((
  ref,
) async {
  final userId = Supabase.instance.client.auth.currentUser?.id;
  if (userId == null) return [];
  final repo = ref.watch(rbacRepositoryProvider);
  return repo.getUserPermissions(userId);
});

final allPermissionsProvider = FutureProvider.autoDispose<List<Permission>>((
  ref,
) async {
  final repo = ref.watch(rbacRepositoryProvider);
  return repo.getAllPermissions();
});

final allRolesProvider = FutureProvider.autoDispose<List<Role>>((ref) async {
  final repo = ref.watch(rbacRepositoryProvider);
  return repo.getAllRoles();
});

final rolePermissionsProvider =
    FutureProvider.autoDispose.family<List<String>, String>((ref, roleId) {
  final repo = ref.watch(rbacRepositoryProvider);
  return repo.getPermissionsForRole(roleId);
});

// Guard Widget
class PermissionGuard extends ConsumerWidget {
  final String permission;
  final Widget child;
  final Widget fallback;

  const PermissionGuard({
    required this.permission,
    required this.child,
    this.fallback = const SizedBox.shrink(),
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final permissionsAsync = ref.watch(userPermissionsProvider);

    return permissionsAsync.when(
      data: (perms) {
        if (perms.contains(permission)) return child;
        return fallback;
      },
      loading: () => const SizedBox.shrink(), // Or loading indicator?
      error: (_, __) => fallback,
    );
  }
}