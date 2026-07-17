import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../auth/domain/entities/user_context.dart';
import 'package:lumina/core/providers/global_providers.dart';
import 'repository_providers_auth.dart';
import 'package:lumina/core/logging/app_logger.dart';
import 'local_persistence_provider.dart';

part 'user_context_provider.g.dart';

@riverpod
class UserContextNotifier extends _$UserContextNotifier {
  @override
  Future<UserContext?> build() async {
    // Listen to auth state changes to refresh context
    ref.listen(authStateProvider, (previous, next) {
      final event = next.value?.event;
      if (event == AuthChangeEvent.signedIn ||
          event == AuthChangeEvent.tokenRefreshed) {
        ref.invalidateSelf();
      }
    });

    final supabase = ref.watch(supabaseClientProvider);
    final user = supabase.auth.currentUser;

    if (user == null) return null;

    return _loadUserContext();
  }

  Future<UserContext?> _loadUserContext() async {
    // OFFLINE-FIRST: Try local cache first
    try {
      final localSvc = ref.read(localPersistenceServiceProvider);
      if (localSvc.isReady) {
        final localCtx = await localSvc.getLocalUserContext(
          ref.read(supabaseClientProvider).auth.currentUser?.id ?? '',
        );
        if (localCtx != null) {
          AppLogger.d('User context loaded from local cache (offline)', 'USER_CONTEXT');
          // Build a basic UserContext from local data
          return UserContext(
            user: UserInfo(
              id: localCtx.userId,
              email: '',
              name: localCtx.roleLabel,
            ),
            role: RoleInfo(
              code: localCtx.roleCode,
              label: localCtx.roleLabel,
              isSuper: localCtx.isSuper,
              level: localCtx.roleHierarchyLevel >= 4
                  ? RoleLevel.superadmin
                  : localCtx.roleHierarchyLevel >= 3
                      ? RoleLevel.adminPartiel
                      : localCtx.roleHierarchyLevel >= 2
                          ? RoleLevel.staff
                          : RoleLevel.consultation,
              initialRoute: localCtx.initialRoute,
            ),
            permissions: const {},
            generatedAt: localCtx.updatedAt,
            needsOnboarding: localCtx.needsOnboarding,
            churchId: localCtx.churchId,
          );
        }
      }
    } catch (e) {
      AppLogger.w('Local context load failed, falling back to network: $e', 'USER_CONTEXT');
    }

    // Fallback to network
    try {
      final repository = ref.read(userContextRepositoryProvider);
      return await (repository.getUserContext() as Future<UserContext?>).timeout(
        const Duration(seconds: 8),
        onTimeout: () {
          AppLogger.w(
            'getUserContext timeout - using fallback',
            'USER_CONTEXT',
          );
          return null;
        },
      );
    } catch (e, stack) {
      AppLogger.e('Failed to load user context: $e', 'USER_CONTEXT', e, stack);
      return null;
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _loadUserContext());
  }

  Future<void> switchRole(String roleId) async {
    try {
      final supabase = ref.read(supabaseClientProvider);
      await supabase.auth.updateUser(
        UserAttributes(data: {'active_role_id': roleId}),
      );
      await refresh();
    } catch (e, stack) {
      AppLogger.e('Failed to switch role', 'USER_CONTEXT', e, stack);
      rethrow;
    }
  }
}

@riverpod
Stream<AuthState> authState(AuthStateRef ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return supabase.auth.onAuthStateChange;
}
