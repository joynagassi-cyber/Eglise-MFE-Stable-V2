import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:lumina/core/providers/repository_providers_auth.dart';
import 'package:lumina/features/auth/domain/repositories/auth_repository.dart';

part 'auth_controller.g.dart';

/// Controller pour gérer les actions d'authentification avancées
/// (réinitialisation de mot de passe, changement de mot de passe, etc.)
@riverpod
class AuthController extends _$AuthController {
  late AuthRepository _repository;

  @override
  Future<void> build() async {
    _repository = ref.watch(authRepositoryProvider);
    return;
  }

  /// Demande la réinitialisation du mot de passe
  Future<void> requestPasswordReset(String email) async {
    state = const AsyncValue.loading();
    try {
      await _repository.requestPasswordReset(email: email);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  /// Confirme la réinitialisation du mot de passe
  Future<void> confirmPasswordReset(String token, String newPassword) async {
    state = const AsyncValue.loading();
    try {
      await _repository.resetPassword(
        resetToken: token,
        newPassword: newPassword,
      );
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  /// Change le mot de passe
  Future<void> changePassword({
    required String userId,
    required String currentPassword,
    required String newPassword,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _repository.changePassword(
        userId: userId,
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  /// Vérifie un code administrateur
  Future<bool> verifyAdminCode(String code) async {
    state = const AsyncValue.loading();
    try {
      final result = await _repository.verifyAdminCode(code);
      state = const AsyncValue.data(null);
      return result.getOrElse(() => false);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      // On retourne false en cas d'erreur
      return false;
    }
  }
}
