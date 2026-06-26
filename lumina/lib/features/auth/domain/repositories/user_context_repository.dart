import '../../../../core/auth/domain/entities/user_context.dart';

abstract class UserContextRepository {
  /// Récupère le contexte utilisateur courant depuis le backend (Edge Function).
  Future<UserContext> getUserContext();
}