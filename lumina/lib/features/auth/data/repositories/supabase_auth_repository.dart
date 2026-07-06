// lib/features/auth/data/repositories/supabase_auth_repository.dart
//
// Implémentation du repository d'authentification - RBAC v3.
// Délègue TOUT stockage de session au SDK Supabase (flutter_secure_storage intégré).
// Aucun double-stockage Isar / SecureStorage manuel.
//
// CHANGELOG :
//   - FIX 1 : _buildSession() — try/catch sur getUserContext() + fallback
//             _buildLightSession() pour les nouveaux utilisateurs Google OAuth
//             dont le profil RBAC n'existe pas encore en DB.
//   - FIX 2 : register() — suppression du paramètre emailRedirectTo qui causait
//             une AuthException systématique même avec la confirmation email
//             désactivée dans Supabase (validation whitelist côté serveur).
//   - FIX 3 : _handleError() — message timeout sans durée en dur.

import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dartz/dartz.dart';
import 'package:lumina/core/logging/app_logger.dart';
import 'package:lumina/core/error/failures.dart';
import 'package:lumina/core/auth/domain/entities/user_session.dart';
import 'package:lumina/core/auth/domain/entities/church_role.dart';
import 'package:lumina/core/auth/domain/entities/user_context.dart';
import 'package:lumina/core/utils/app_date_time.dart';
import 'package:lumina/core/utils/auth_error_translator.dart';
import 'package:lumina/features/auth/domain/models/auth_user.dart';
import 'package:lumina/features/auth/domain/repositories/auth_repository.dart';
import 'package:lumina/features/auth/domain/repositories/role_repository.dart';
import 'package:lumina/features/auth/domain/repositories/user_context_repository.dart';

class SupabaseAuthRepository implements AuthRepository {
  final SupabaseClient supabase;
  final UserContextRepository userContextRepository;
  final RoleRepository roleRepository;

  SupabaseAuthRepository({
    required this.supabase,
    required this.userContextRepository,
    required this.roleRepository,
  });

  // ─── Helpers ───────────────────────────────────────────────────────────────

  Failure _handleError(dynamic e, String context) {
    AppLogger.e('$context: $e', 'AUTH_REPO', e);

    // FIX 3 : message sans durée en dur pour éviter la confusion avec le
    // timeout réel (15s sur login/register vs 10s sur l'Edge Function).
    if (e is TimeoutException) {
      return const ServerFailure(
        'Délai d\'attente dépassé. Veuillez vérifier votre connexion.',
      );
    }

    if (e is AuthException) {
      return AuthFailure(AuthErrorTranslator.translate(e));
    }
    if (e is PostgrestException) {
      return ServerFailure(
        AuthErrorTranslator.translate(e),
        statusCode: int.tryParse(e.code ?? ''),
      );
    }
    return UnexpectedFailure('$context: $e');
  }

String? _firstNonEmptyString(Iterable<Object?> values) {
  for (final value in values) {
    if (value == null) continue;
    final text = value.toString().trim();
    if (text.isNotEmpty) return text;
  }
  return null;
}

  static const String _fallbackChurchId = 'default_church';

  /// Construit un [UserSession] depuis la session Supabase courante.
  /// Utilise l'Edge Function get-user-context (RBAC v3) comme source de vérité.
  ///
  /// FIX 1 : Si l'Edge Function échoue (ex : nouvel utilisateur Google OAuth
  /// dont le profil RBAC n'existe pas encore en DB), on tombe sur
  /// [_buildLightSession] au lieu de propager l'exception. Cela produit un état
  /// [AuthOnboardingRequired] → RouterNotifier redirige vers /onboarding
  /// au lieu de /auth-home.
  Future<UserSession> _buildSession(User user, Session session) async {
    UserContext? context;

    try {
      context = await userContextRepository.getUserContext();
    } catch (e) {
      AppLogger.d(
        'getUserContext() échoué — nouvel utilisateur probable, pas encore de '
            'profil RBAC en DB. Fallback vers light session. Erreur: $e',
        'AUTH_REPO',
      );
      // needsOnboarding=true dans _buildLightSession → AuthOnboardingRequired
      // → RouterNotifier → /onboarding 
      return _buildLightSession(user, session);
    }

    final activeChurchId = _firstNonEmptyString([
          context.churchId,
          user.userMetadata?['church_id'],
          user.userMetadata?['active_church_id'],
          _fallbackChurchId,
        ]) ??
        _fallbackChurchId;

    final role = ChurchRole.fromLabel(
      churchId: activeChurchId,
      label: context.role.label,
    );

    return UserSession(
      userId: user.id,
      email: user.email ?? '',
      name: user.userMetadata?['name'] as String? ??
          ('${user.userMetadata?['first_name'] ?? ''} ${user.userMetadata?['last_name'] ?? ''}'
                  .trim()
                  .isNotEmpty
              ? '${user.userMetadata?['first_name'] ?? ''} ${user.userMetadata?['last_name'] ?? ''}'
                  .trim()
              : user.email ?? 'Membre'),
      avatar: user.userMetadata?['avatar_url'] as String?,
      activeChurchId: activeChurchId,
      accessibleChurchIds: [activeChurchId],
      role: role,
      needsOnboarding: context.needsOnboarding,
      accessToken: session.accessToken,
      refreshToken: session.refreshToken ?? '',
      tokenExpiresAt: DateTime.fromMillisecondsSinceEpoch(
        (session.expiresAt ?? 0) * 1000,
      ),
      lastLoginAt: AppDateTime.nowUtc(),
      isActive: true,
      metadata: {
        'rbac_v3': true,
        'generated_at': context.generatedAt.toIso8601String(),
      },
    );
  }

  /// Construit un [UserSession] léger sans appeler l'Edge Function.
  /// Utilisé après l'inscription (email ou Google) pour éviter le blocage
  /// quand le contexte RBAC n'existe pas encore pour un nouvel utilisateur.
  UserSession _buildLightSession(User user, Session session) {
    final name = user.userMetadata?['name'] as String? ??
        ('${user.userMetadata?['first_name'] ?? ''} ${user.userMetadata?['last_name'] ?? ''}'
                .trim()
                .isNotEmpty
            ? '${user.userMetadata?['first_name'] ?? ''} ${user.userMetadata?['last_name'] ?? ''}'
                .trim()
            : user.email ?? 'Membre');

    final defaultRole = ChurchRole.membre(churchId: _fallbackChurchId);

    return UserSession(
      userId: user.id,
      email: user.email ?? '',
      name: name,
      avatar: user.userMetadata?['avatar_url'] as String?,
      activeChurchId: _fallbackChurchId,
      accessibleChurchIds: const [_fallbackChurchId],
      role: defaultRole,
      needsOnboarding: true,
      accessToken: session.accessToken,
      refreshToken: session.refreshToken ?? '',
      tokenExpiresAt: DateTime.fromMillisecondsSinceEpoch(
        (session.expiresAt ?? 0) * 1000,
      ),
      lastLoginAt: AppDateTime.nowUtc(),
      isActive: true,
      metadata: const {'rbac_v3': false, 'light_session': true},
    );
  }

  // ─── Authentification ──────────────────────────────────────────────────────

  @override
  Future<Either<Failure, UserSession>> login({
    required String email,
    required String password,
    String? captchaToken,
  }) async {
    AppLogger.d('Tentative de login email: $email', 'AUTH_REPO');

    // Validation des entrées
    if (email.isEmpty || !email.contains('@')) {
      return const Left(AuthFailure('Email invalide'));
    }

    if (password.isEmpty) {
      return const Left(AuthFailure('Mot de passe requis'));
    }

    try {
      final response = await supabase.auth
          .signInWithPassword(
            email: email,
            password: password,
            captchaToken: captchaToken,
          )
          .timeout(const Duration(seconds: 15));

      final user = response.user;
      final session = response.session;

      // Validation stricte de la réponse
      if (user == null || session == null) {
        AppLogger.e('Réponse login sans user ou session', 'AUTH_REPO');
        return const Left(
          AuthFailure('Authentification échouée : données manquantes'),
        );
      }

      // Validation des tokens de session
      if (session.accessToken.isEmpty) {
        AppLogger.e('Session sans access token valide', 'AUTH_REPO');
        return const Left(
          AuthFailure('Session invalide : access token manquant'),
        );
      }

      AppLogger.d('Login email réussi pour: ${user.email}', 'AUTH_REPO');
      return Right(await _buildSession(user, session));
    } on AuthException catch (e) {
      AppLogger.e('Erreur login email', 'AUTH_REPO', e);
      return Left(AuthFailure(e.message));
    } catch (e) {
      AppLogger.e('Erreur inattendue login email', 'AUTH_REPO', e);
      return Left(_handleError(e, 'Login'));
    }
  }

  @override
  Future<Either<Failure, UserSession?>> register({
    required String email,
    required String password,
    required String name,
    String? churchId,
    String? captchaToken,
  }) async {
    try {
      final trimmedName = name.trim().isEmpty ? 'Nouveau Membre' : name.trim();
      final parts = trimmedName.split(RegExp(r'\s+'));
      final firstName = parts.first;
      final lastName = parts.length > 1 ? parts.sublist(1).join(' ') : ' ';

      final response = await supabase.auth
          .signUp(
            email: email,
            password: password,
            // FIX 2 : emailRedirectTo retiré.
            // Même avec la confirmation email désactivée dans Supabase,
            // ce paramètre est validé contre la whitelist des Redirect URLs
            // côté serveur — ce qui provoquait une AuthException systématique.
            // À remettre uniquement si la confirmation email est réactivée
            // ET que le scheme io.supabase.gtfe:// est whitelisté.
            data: {
              'name': name,
              'first_name': firstName,
              'last_name': lastName,
            },
            captchaToken: captchaToken,
          )
          .timeout(const Duration(seconds: 15));

      final user = response.user;
      final session = response.session;

      if (user == null) return const Left(AuthFailure('Inscription échouée'));

      // Pas de session = confirmation email requise (config dashboard).
      // On retourne null pour que l'AuthProvider affiche le message approprié.
      if (session == null) return const Right(null);

      // Session légère sans appel Edge Function — le contexte RBAC
      // sera chargé lors du prochain loadSavedSession / watchAuthState.
      return Right(_buildLightSession(user, session));
    } catch (e) {
      return Left(_handleError(e, 'Register'));
    }
  }

  @override
  Future<Either<Failure, UserSession?>> signInWithGoogleTokens({
    required String idToken,
    required String accessToken,
  }) async {
    AppLogger.d('Début de signInWithGoogleTokens (Supabase)', 'AUTH_REPO');

    // Validation des tokens entrants
    if (idToken.trim().isEmpty) {
      AppLogger.e('ID token manquant ou vide', 'AUTH_REPO');
      return const Left(AuthFailure('ID token Google invalide ou manquant'));
    }

    if (accessToken.trim().isEmpty) {
      AppLogger.e('Access token manquant ou vide', 'AUTH_REPO');
      return const Left(
          AuthFailure('Access token Google invalide ou manquant'));
    }

    AppLogger.d(
      'Tokens Google validés, tentative de connexion Supabase',
      'AUTH_REPO',
    );

    // P2: Skip full OAuth if valid session already exists
    final existingSession = supabase.auth.currentSession;
    if (existingSession != null && existingSession.accessToken.isNotEmpty) {
      AppLogger.d('Session Supabase existante valide, réutilisation', 'AUTH_REPO');
      return await loadSavedSession();
    }

    try {
      final response = await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      final user = response.user;
      final session = response.session;

      // Validation stricte de la réponse Supabase
      if (user == null) {
        AppLogger.e('Supabase a renvoyé une réponse sans user', 'AUTH_REPO');
        return const Left(
          AuthFailure('Authentification Google échouée : utilisateur non créé'),
        );
      }

      if (session == null) {
        AppLogger.e('Supabase a renvoyé une réponse sans session', 'AUTH_REPO');
        return const Left(
          AuthFailure('Authentification Google échouée : session non générée'),
        );
      }

      // Validation supplémentaire des tokens de session
      if (session.accessToken.isEmpty) {
        AppLogger.e('Session Supabase sans access token valide', 'AUTH_REPO');
        return const Left(
            AuthFailure('Session invalide : access token manquant'));
      }

      AppLogger.d(
        'Réponse Supabase valide – construction de la session locale',
        'AUTH_REPO',
      );

      // Construire la session locale complète ou légère (onboarding)
      final builtSession = await _buildSession(user, session);

      // Validation finale de la session construite
      if (!builtSession.isValid) {
        AppLogger.e('Session construite invalide', 'AUTH_REPO');
        return const Left(AuthFailure('Session construite invalide'));
      }

      AppLogger.d(
        'Google auth OK – session Supabase construite et validée',
        'AUTH_REPO',
      );
      return Right(builtSession);
    } on AuthException catch (e) {
      AppLogger.e('Erreur d\'authentification Supabase', 'AUTH_REPO', e);
      return Left(
          AuthFailure('Erreur d\'authentification Supabase: ${e.message}'));
    } on PostgrestException catch (e) {
      AppLogger.e('Erreur base de données Supabase', 'AUTH_REPO', e);
      return Left(ServerFailure(
        'Erreur serveur lors de l\'authentification: ${e.message}',
        statusCode: int.tryParse(e.code ?? ''),
      ));
    } catch (e) {
      AppLogger.e(
          'Erreur inattendue pendant signInWithGoogleTokens', 'AUTH_REPO', e);
      return Left(_handleError(e, 'Google OAuth Native'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await supabase.auth.signOut();
      return const Right(null);
    } catch (e) {
      return Left(_handleError(e, 'Logout'));
    }
  }

  // ─── Session ───────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, UserSession?>> loadSavedSession() async {
    try {
      // Le SDK Supabase gère nativement la persistance des tokens.
      // On lit directement currentSession — aucun double stockage nécessaire.
      final session = supabase.auth.currentSession;
      final user = supabase.auth.currentUser;
      if (session == null || user == null) return const Right(null);
      return Right(await _buildSession(user, session));
    } catch (e) {
      AppLogger.e('Error loading session', 'AUTH_REPO', e);
      return Left(CacheFailure('Erreur de chargement de session: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> requestPasswordReset({
    required String email,
    String? captchaToken,
  }) async {
    try {
      await supabase.auth.resetPasswordForEmail(
        email,
        captchaToken: captchaToken,
      );
      return const Right(null);
    } catch (e) {
      return Left(_handleError(e, 'Password reset'));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword({
    required String resetToken,
    required String newPassword,
  }) async {
    try {
      await supabase.auth.updateUser(UserAttributes(password: newPassword));
      return const Right(null);
    } catch (e) {
      return Left(_handleError(e, 'Reset password'));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword({
    required String userId,
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final email = supabase.auth.currentUser?.email;
      if (email == null) throw const AuthException('Non authentifié');
      // Vérifie l'ancien mot de passe avant de changer
      await supabase.auth
          .signInWithPassword(email: email, password: currentPassword);
      await supabase.auth.updateUser(UserAttributes(password: newPassword));
      return const Right(null);
    } catch (e) {
      return Left(_handleError(e, 'Change password'));
    }
  }

  @override
  Future<Either<Failure, UserSession>> switchActiveChurch({
    required String userId,
    required String newChurchId,
  }) async {
    try {
      final session = supabase.auth.currentSession;
      final user = supabase.auth.currentUser;
      if (session == null || user == null) {
        return const Left(AuthFailure('Aucune session active'));
      }

      await supabase.auth.updateUser(
        UserAttributes(
          data: {
            'church_id': newChurchId,
            'active_church_id': newChurchId,
          },
        ),
      );

      final refreshedSession = supabase.auth.currentSession;
      final refreshedUser = supabase.auth.currentUser;
      if (refreshedSession == null || refreshedUser == null) {
        return const Left(AuthFailure('Impossible de rafraîchir la session'));
      }

      return Right(await _buildSession(refreshedUser, refreshedSession));
    } catch (e) {
      return Left(_handleError(e, 'Switch church'));
    }
  }

  @override
  Future<Either<Failure, bool>> verifyAdminCode(String code) async {
    // Normalisation côté client : trim + majuscules, tirets conservés.
    // Le serveur fait la même chose avec UPPER(TRIM(input_code)).
    final normalizedCode = code.trim().toUpperCase();
    try {
      final data = await supabase
          .rpc('verify_admin_code', params: {'input_code': normalizedCode});
      if (data is List && data.isNotEmpty) {
        return Right(
          (data.first as Map<String, dynamic>)['is_valid'] == true,
        );
      }
      return const Right(false);
    } catch (e) {
      return Left(_handleError(e, 'Verify admin code'));
    }
  }

  @override
  Future<AppAuthUser?> getCurrentUser() async {
    final user = supabase.auth.currentUser;
    if (user == null) return null;

    return AppAuthUser(
      id: user.id,
      email: user.email ?? '',
      firstName: user.userMetadata?['first_name'] as String?,
      lastName: user.userMetadata?['last_name'] as String?,
    );
  }

  @override
  User? get currentUser => supabase.auth.currentUser;

  @override
  bool get isAuthenticated => supabase.auth.currentSession != null;

  @override
  Stream<UserSession?> watchAuthState() {
    // P3: tokenRefreshed filtered out — no context change, avoids getUserContext() call
    const relevant = {
      AuthChangeEvent.signedIn,
      AuthChangeEvent.signedOut,
      AuthChangeEvent.userUpdated,
    };
    return supabase.auth.onAuthStateChange
        .where((e) => relevant.contains(e.event))
        .asyncMap((e) async {
      try {
        if (e.event == AuthChangeEvent.signedOut) return null;
        final result = await loadSavedSession();
        final session = result.fold<UserSession?>(
          (failure) {
            // ⚠️ FIX: Ne pas retourner null sur erreur transitoire de
            // loadSavedSession() / getUserContext(). À la place, on tente
            // de construire une session légère avec les données disponibles.
            // Sinon le _sub listener dans AuthProvider override l'état
            // AuthAuthenticated avec AuthUnauthenticated.
            AppLogger.e(
              'watchAuthState: loadSavedSession échoué, fallback light session. Erreur: ${failure.message}',
              'AUTH_REPO',
            );
            return _buildLightSessionFromCurrent();
          },
          (s) => s,
        );
        return session;
      } catch (err) {
        AppLogger.e('watchAuthState: erreur fatale, fallback light session. Erreur: $err', 'AUTH_REPO');
        return _buildLightSessionFromCurrent();
      }
    });
  }

  /// Construit une session légère à partir des données Supabase courantes
  /// sans appeler l'Edge Function (getUserContext). Utilisé comme fallback
  /// par watchAuthState() quand loadSavedSession() échoue.
  UserSession? _buildLightSessionFromCurrent() {
    try {
      final session = supabase.auth.currentSession;
      final user = supabase.auth.currentUser;
      if (session == null || user == null) return null;
      return _buildLightSession(user, session);
    } catch (e) {
      AppLogger.e('_buildLightSessionFromCurrent échoué: $e', 'AUTH_REPO');
      return null;
    }
  }

  // ─── Méthodes stub (compatibilité interface) ───────────────────────────────

  @override
  Future<Either<Failure, void>> saveSession(UserSession session) async =>
      const Right(null); // Géré nativement par le SDK

  @override
  Future<Either<Failure, void>> clearSavedSession() async {
    try {
      await supabase.auth.signOut();
      return const Right(null);
    } catch (e) {
      return Left(_handleError(e, 'Clear session'));
    }
  }

  @override
  Future<Either<Failure, UserSession?>> getCurrentSession() =>
      loadSavedSession();

  @override
  Future<Either<Failure, UserSession>> refreshSession({
    required String refreshToken,
  }) async {
    try {
      final response = await supabase.auth.refreshSession();
      final session = response.session;
      final user = response.user;
      if (session == null || user == null) {
        return const Left(
          AuthFailure('Impossible de rafraîchir la session'),
        );
      }
      return Right(await _buildSession(user, session));
    } catch (e) {
      return Left(_handleError(e, 'Refresh session'));
    }
  }

  @override
  Future<Either<Failure, bool>> validateSession(UserSession session) async =>
      Right(session.isValid && supabase.auth.currentSession != null);

  @override
  Future<Either<Failure, void>> invalidateSession(String sessionId) async =>
      clearSavedSession();

  @override
  Future<Either<Failure, List<String>>> getAccessibleChurches({
    required String userId,
  }) async {
    try {
      final context = await userContextRepository.getUserContext();
      final churchId = _firstNonEmptyString([
        context.churchId,
        supabase.auth.currentUser?.userMetadata?['church_id'],
        supabase.auth.currentUser?.userMetadata?['active_church_id'],
        _fallbackChurchId,
      ]);

      return Right(churchId != null ? [churchId] : const [_fallbackChurchId]);
    } catch (e) {
      return const Right([_fallbackChurchId]);
    }
  }

  @override
  Future<Either<Failure, UserSession?>> loginWithToken(String token) async {
    try {
      await supabase.auth.setSession(token);
      return await loadSavedSession();
    } catch (e) {
      return Left(_handleError(e, 'Login with token'));
    }
  }
}
