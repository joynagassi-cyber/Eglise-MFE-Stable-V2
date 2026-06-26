import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../auth/domain/entities/user_context.dart';
import 'package:lumina/core/providers/global_providers.dart';
import 'repository_providers_auth.dart';
import 'package:lumina/core/logging/app_logger.dart';

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
    try {
      final repository = ref.read(userContextRepositoryProvider);
      // CRITICAL FIX: Add timeout to prevent infinite waiting on getUserContext()
      // Network requests can hang if Supabase is slow or unreachable
      // 8 second timeout ensures we don't block the dashboard indefinitely
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
      // Logic for switching role typically involves calling an RPC or updating user session metadata
      // For RBAC v3, we might need a dedicated switch_role RPC or Edge Function endpoint
      // Assuming for now a reload of context is enough after a metadata update if the backend supports it
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
