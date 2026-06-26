import 'user_session.dart';
import 'user_context.dart';

export 'user_session.dart';
export 'user_context.dart';
export 'church_role.dart';
export 'enums/role_level.dart';

/// Sealed class représentant tous les états possibles de l'authentification.
///
/// Garantit un traitement exhaustif via `switch` (pattern matching).
/// Les getters de compatibilité sur la classe de base retournent des
/// valeurs par défaut (null/false) pour les états non-authentifiés,
/// permettant aux fichiers consommateurs existants de continuer à
/// fonctionner sans modification.
sealed class AuthState {
  const AuthState();

  // ─── Getters de compatibilité (safe defaults) ───
  // Préférer le pattern matching pour le nouveau code.
  bool get isAuthenticated => false;
  bool get isSuperAdmin => false;
  bool get needsOnboarding => false;
  String? get userId => null;
  String? get id => userId;
  String? get churchId => null;
  String? get activeChurchId => null;
  String? get accessToken => null;
  String? get name => null;
  String? get avatar => null;
  RoleInfo? get role => null;
  UserContext? get context => null;
  UserSession? get session => null;
  // Fallback direct sur l'objet User du context si présent
  dynamic get user => context?.user;

  bool hasPermission(String resource, String action) => false;
}

/// État initial — l'app vient de démarrer, rien n'a encore été chargé.
final class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Chargement en cours (login, register, refresh, build).
final class AuthLoading extends AuthState {
  const AuthLoading();
}

/// L'utilisateur n'est pas authentifié (pas de session).
final class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// L'utilisateur est authentifié et opérationnel.
final class AuthAuthenticated extends AuthState {
  @override
  final UserSession session;
  @override
  final UserContext context;

  const AuthAuthenticated({
    required this.session,
    required this.context,
  });

  // ─── Overrides ───
  @override
  bool get isAuthenticated => session.isValid;
  @override
  bool get isSuperAdmin => context.role.isSuper;
  @override
  String get userId => session.userId;
  @override
  String get churchId => session.activeChurchId;
  @override
  String get activeChurchId => session.activeChurchId;
  @override
  String get accessToken => session.accessToken;
  @override
  String get name => context.user.name;
  @override
  String? get avatar => context.user.avatar;
  @override
  RoleInfo get role => context.role;
  @override
  bool get needsOnboarding => false;

  @override
  bool hasPermission(String resource, String action) {
    if (isSuperAdmin) return true;
    return context.hasPermission(resource, action);
  }
}

/// L'utilisateur est authentifié mais doit compléter l'onboarding.
final class AuthOnboardingRequired extends AuthState {
  @override
  final UserSession session;
  @override
  final UserContext context;

  const AuthOnboardingRequired({
    required this.session,
    required this.context,
  });

  // ─── Overrides ───
  @override
  bool get isAuthenticated => session.isValid;
  @override
  bool get isSuperAdmin => context.role.isSuper;
  @override
  String get userId => session.userId;
  @override
  String get churchId => session.activeChurchId;
  @override
  String get activeChurchId => session.activeChurchId;
  @override
  String get accessToken => session.accessToken;
  @override
  String get name => context.user.name;
  @override
  String? get avatar => context.user.avatar;
  @override
  RoleInfo get role => context.role;
  @override
  bool get needsOnboarding => true;

  @override
  bool hasPermission(String resource, String action) {
    if (isSuperAdmin) return true;
    return context.hasPermission(resource, action);
  }
}

/// Erreur d'authentification (credentials invalides, serveur injoignable sans cache…).
final class AuthError extends AuthState {
  final String message;
  final Object? error;

  const AuthError(this.message, {this.error});
}

/// Hors-ligne mais avec une session cache exploitable.
final class AuthOffline extends AuthState {
  final UserSession? cachedSession;

  const AuthOffline({this.cachedSession});

  @override
  bool get isAuthenticated => cachedSession != null;
  @override
  String? get userId => cachedSession?.userId;
  @override
  String? get churchId => cachedSession?.activeChurchId;
  @override
  String? get activeChurchId => cachedSession?.activeChurchId;
  @override
  UserSession? get session => cachedSession;

  // En mode offline, on autorise les permissions de lecture
  // seulement si la session cache est encore valide (pas expirée).
  @override
  bool hasPermission(String resource, String action) {
    if (cachedSession == null) return false;
    if (!cachedSession!.isValid) return false;
    if (action == 'read' || action == 'view') return true;
    return false;
  }
}
