import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/auth/domain/entities/user_role.dart';
import '../../../../core/providers/auth_provider.dart';
import 'package:lumina/core/providers/user_context_provider.dart';
import 'package:lumina/core/providers/repository_providers_auth.dart';

part 'available_roles_provider.g.dart';

@riverpod
Future<List<UserRole>> availableRoles(AvailableRolesRef ref) async {
  final user = ref.watch(authProvider).valueOrNull;
  if (user == null) return [];

  final repository = ref.watch(roleRepositoryProvider);
  return await repository.getAvailableRolesForUser(user.userId!);
}

@riverpod
class RoleController extends _$RoleController {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<void> switchRole(UserRole role) async {
    final user = ref.read(authProvider).valueOrNull;
    if (user == null) return;

    state = const AsyncValue.loading();
    try {
      final repository = ref.read(roleRepositoryProvider);

      // 1. Update user_sessions in DB
      await repository.switchActiveRole(
        userId: user.userId!,
        roleId: role
            .roleCode, // On utilise le code comme ID dans cette architecture simplifiée
      );

      // 2. Refresh the UserContext
      await ref.read(userContextNotifierProvider.notifier).refresh();

      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
