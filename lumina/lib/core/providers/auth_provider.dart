// lib/core/providers/auth_provider.dart
//
// Notifier d'authentification — RBAC v3
// Responsabilité unique : mapper l'état Supabase en AuthState.
// Aucune logique onboarding, aucun side-effect métier, aucun bypass.
//
// CHANGELOG :
//   - FIX : _sub listener + register() — getUserContext() est maintenant
//     ignoré quand session.needsOnboarding=true ou light_session=true.
//     Avant ce fix, le listener appelait getUserContext() pour tout nouvel
//     utilisateur (Google OAuth ou email), attendait 3 retries × 1.5s = ~4.5s,
//     puis utilisait quand même le fallback. Résultat : l'utilisateur restait
//     bloqué sur le splash ~5s avant d'arriver sur /onboarding.
//     Désormais on va directement au fallback si la session indique déjà
//     que l'onboarding est requis — getUserContext() n'apporterait rien.

import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:lumina/core/mixins/auditable_mixin.dart';
import 'package:lumina/core/domain/entities/enums/audit_action.dart';
import 'package:lumina/core/auth/domain/entities/auth_state.dart'
    as app_auth;
import 'package:lumina/core/auth/domain/entities/user_session.dart';
import 'package:lumina/core/auth/domain/entities/enums/role_level.dart';
import 'package:lumina/core/logging/app_logger.dart';
import 'repository_providers.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
class Auth extends _$Auth with AuditableMixin {
  StreamSubscription<UserSession?>? _sub;
  bool _isInitialized = false;
  UserSession? _lastSession;
  bool _manualAuthInProgress = false;
  DateTime? _lastManualAuthAt;

  /// Durée de cooldown après une action manuelle (login/register/Google)
  /// pendant laquelle les événements du stream sont ignorés pour éviter
  /// les overrides intempestifs (race condition avec getUserContext()).
  static const Duration _manualAuthCooldown = Duration(seconds: 3);

  @override
  Future<app_auth.AuthState> build() async {
    ref.onDispose(() {
      _sub?.cancel();
      _isInitialized = false;
      _lastSession = null;
      _manualAuthInProgress = false;
    });

    // 1. Lecture initiale avant d'abonner le stream pour éviter les doubles
    //    transitions pendant le bootstrap du provider.
    final initialState = await _loadInitialSession();

    // 2. Abonnement réactif à l'état d'authentification.
    _sub = ref
        .read(authRepositoryProvider)
        .watchAuthState()
        .listen((session) async {
      if (_manualAuthInProgress) {
        AppLogger.d(
          'Event auth ignoré pendant un flux manuel',
          'AUTH_PROVIDER',
        );
        return;
      }

      // Éviter le double déclenchement en gardant trace de la dernière session
      if (_lastSession?.userId == session?.userId &&
          _lastSession?.accessToken == session?.accessToken) {
        AppLogger.d(
          'Session identique à la précédente, pas de mise à jour',
          'AUTH_PROVIDER',
        );
        return;
      }

      // Cooldown post-auth manuelle : ignorer les événements stream
      // qui arrivent juste après une action manuelle, pour éviter que
      // getUserContext() (appelé par loadSavedSession()) ne retourne
      // null ou une session différente et override l'état correct.
      if (_lastManualAuthAt != null &&
          DateTime.now().difference(_lastManualAuthAt!) < _manualAuthCooldown) {
        AppLogger.d(
          'Event auth ignoré (cooldown ${_manualAuthCooldown.inSeconds}s après action manuelle)',
          'AUTH_PROVIDER',
        );
        return;
      }

      _lastSession = session;
      await _handleSessionChange(session);
    });

    return initialState;
  }

  /// Gère les changements de session de manière centralisée
  Future<void> _handleSessionChange(UserSession? session) async {
    if (session == null) {
      // ⚠️ FIX: Ne pas override un état AuthAuthenticated valide avec
      // AuthUnauthenticated à cause d'une erreur transitoire de
      // loadSavedSession() / getUserContext() dans le stream listener.
      // L'utilisateur reste connecté jusqu'à la prochaine mise à jour valide.
      final currentState = state.valueOrNull;
      if (currentState is app_auth.AuthAuthenticated &&
          _lastSession != null) {
        AppLogger.d(
          'Session null ignorée — état AuthAuthenticated préservé '
          '(erreur transitoire loadSavedSession)',
          'AUTH_PROVIDER',
        );
        return;
      }
      AppLogger.d('Session null - utilisateur déconnecté', 'AUTH_PROVIDER');
      _lastSession = null;
      state = const AsyncData(app_auth.AuthUnauthenticated());
      return;
    }

    final currentState = state.valueOrNull;
    AppLogger.d(
      'Changement de session détecté pour: ${session.userId}',
      'AUTH_PROVIDER',
    );

    // FIX : si la session indique déjà que l'onboarding est requis
    // (light_session = nouvel utilisateur sans profil RBAC, ou needsOnboarding=true),
    // on n'appelle PAS getUserContext() — ça échouerait après 3 retries × 1.5s
    // pour rien, et on utiliserait de toute façon le fallback.
    final bool skipContextFetch = session.needsOnboarding ||
        (session.metadata ?? {})['light_session'] == true;

    app_auth.UserContext context;
    if (skipContextFetch) {
      context = _buildFallbackContext(session, needsOnboarding: session.needsOnboarding);
      AppLogger.d(
        'Utilisation du contexte fallback (onboarding requis ou session légère)',
        'AUTH_PROVIDER',
      );
    } else {
      try {
        context =
            await ref.read(userContextRepositoryProvider).getUserContext()
              .timeout(const Duration(seconds: 4));
        AppLogger.d(
          'Contexte utilisateur chargé avec succès',
          'AUTH_PROVIDER',
        );
      } catch (e) {
        AppLogger.d(
          'getUserContext() échoué dans _sub listener. Fallback. Erreur: $e',
          'AUTH_PROVIDER',
        );
        context = _buildFallbackContext(session, needsOnboarding: session.needsOnboarding);
      }
    }

    final shouldOnboard = session.needsOnboarding || context.needsOnboarding;
    final newState = AsyncData(
      shouldOnboard
          ? app_auth.AuthOnboardingRequired(session: session, context: context)
          : app_auth.AuthAuthenticated(session: session, context: context),
    );

    // Audit Log: Login (seulement si authentifié et l'état change vers connecté)
    if (newState.valueOrNull is app_auth.AuthAuthenticated &&
        currentState is! app_auth.AuthAuthenticated) {
      unawaited(logAuditAction(
        ref,
        action: AuditAction.login,
        entityType: 'auth',
        entityId: session.userId,
        metadata: {
          'method': session.metadata?['provider'] ?? 'unknown',
          'email': session.email,
        },
      ));
    }

    state = newState;
  }

  /// Charge la session initiale de manière synchrone
  Future<app_auth.AuthState> _loadInitialSession() async {
    if (_isInitialized) {
      AppLogger.d(
        'Session déjà initialisée, retour de l\'état actuel',
        'AUTH_PROVIDER',
      );
      return state.value ?? const app_auth.AuthUnauthenticated();
    }

    try {
      final user = await ref.read(authRepositoryProvider).getCurrentUser();

      if (user == null) {
        AppLogger.d(
          'Aucun utilisateur trouvé, état non-authentifié',
          'AUTH_PROVIDER',
        );
        return const app_auth.AuthUnauthenticated();
      }

      final sessionResult =
          await ref.read(authRepositoryProvider).getCurrentSession();
      final session = sessionResult.getOrElse(() => null);

      if (session == null) {
        AppLogger.d(
          'Aucune session trouvée, état non-authentifié',
          'AUTH_PROVIDER',
        );
        return const app_auth.AuthUnauthenticated();
      }

      // Même logique de skip pour la lecture initiale
      final bool skipContextFetch = session.needsOnboarding ||
          (session.metadata ?? {})['light_session'] == true;

      if (skipContextFetch) {
        AppLogger.d(
          'Session avec onboarding requis ou légère, utilisation du contexte fallback',
          'AUTH_PROVIDER',
        );
        _isInitialized = true;
        _lastSession = session;
        return app_auth.AuthOnboardingRequired(
          session: session,
          context: _buildFallbackContext(session, needsOnboarding: session.needsOnboarding),
        );
      }

      try {
        final context =
            await ref.read(userContextRepositoryProvider).getUserContext()
              .timeout(const Duration(seconds: 4));

        _isInitialized = true;
        _lastSession = session;
        AppLogger.d('Session initiale chargée avec succès', 'AUTH_PROVIDER');
        final shouldOnboard =
            session.needsOnboarding || context.needsOnboarding;
        return shouldOnboard
            ? app_auth.AuthOnboardingRequired(
                session: session, context: context)
            : app_auth.AuthAuthenticated(session: session, context: context);
      } catch (e) {
        // Guard : si le contexte échoue (nouveau compte sans RBAC encore prêt),
        // fallback safe vers AuthOnboardingRequired.
        _isInitialized = true;
        _lastSession = session;
        AppLogger.d(
          'Contexte utilisateur échoué, fallback vers onboarding',
          'AUTH_PROVIDER',
        );
        return app_auth.AuthOnboardingRequired(
          session: session,
          context: _buildFallbackContext(session, needsOnboarding: session.needsOnboarding),
        );
      }
    } catch (e) {
      AppLogger.e('Erreur lors du chargement de la session initiale',
          'AUTH_PROVIDER', e);
      return const app_auth.AuthUnauthenticated();
    }
  }

  // ─── Login / Register / Logout ───────────────────────────────────────────

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    _manualAuthInProgress = true;
    try {
      final result = await ref
          .read(authRepositoryProvider)
          .login(email: email, password: password)
          .timeout(const Duration(seconds: 20));

      if (result.isRight()) {
        final session = result.getOrElse(() => throw Exception());
        try {
          final context =
              await ref.read(userContextRepositoryProvider).getUserContext()
              .timeout(const Duration(seconds: 4));
          state = AsyncData(
            (session.needsOnboarding || context.needsOnboarding)
                ? app_auth.AuthOnboardingRequired(
                    session: session, context: context)
                : app_auth.AuthAuthenticated(
                    session: session, context: context),
          );
          _lastSession = session;
          _lastManualAuthAt = DateTime.now();

          // Audit Log: Login
          unawaited(logAuditAction(
            ref,
            action: AuditAction.login,
            entityType: 'auth',
            entityId: session.userId,
            metadata: {
              'method': 'password',
              'email': email,
            },
          ));
        } catch (e) {
          // Fallback déterministe en cas de problème de contexte après login réussi
          state = AsyncData(app_auth.AuthOnboardingRequired(
            session: session,
            context: _buildFallbackContext(session, needsOnboarding: session.needsOnboarding),
          ));
          _lastSession = session;
          _lastManualAuthAt = DateTime.now();
        }
      } else {
        state = result.fold(
          (failure) => AsyncError(failure.message, StackTrace.current),
          (_) => throw Exception(),
        );
      }
    } finally {
      _manualAuthInProgress = false;
    }
  }

  app_auth.UserContext _buildFallbackContext(
    UserSession session, {
    bool? needsOnboarding,
  }) {
    // Convert ChurchRole -> RoleInfo pour le fallback.
    // ChurchRole.name est utilisé comme code et label (comportement历史).
    final isSuper = session.role.level == app_auth.RoleLevel.superadmin ||
        session.role.level == app_auth.RoleLevel.adminTotal;
    return app_auth.UserContext(
      user: app_auth.UserInfo(
        id: session.userId,
        email: session.email,
        name: session.name,
      ),
      role: app_auth.RoleInfo(
        code: session.role.name,
        label: session.role.name,
        isSuper: isSuper,
        level: session.role.level,
        initialRoute: session.role.initialRoute,
      ),
      permissions: const {},
      generatedAt: DateTime.now().toUtc(),
      needsOnboarding: needsOnboarding ?? session.needsOnboarding,
    );
  }

  Future<void> register({
    required String email,
    required String password,
    required String name,
  }) async {
    _manualAuthInProgress = true;
    try {
      final result = await ref
          .read(authRepositoryProvider)
          .register(email: email, password: password, name: name)
          .timeout(const Duration(seconds: 20));

      if (result.isRight()) {
        final session = result.getOrElse(() => null);
        if (session == null) {
          // session=null : confirmation email requise (ne devrait pas arriver
          // avec confirm email désactivé, mais on gère quand même).
          state = const AsyncData(app_auth.AuthUnauthenticated());
          _lastSession = null;
          return;
        }

        // FIX : même logique que le _sub listener — un nouvel utilisateur
        // n'a pas encore de profil RBAC, inutile d'appeler getUserContext().
        // On va directement au fallback → AuthOnboardingRequired → /onboarding.
        state = AsyncData(app_auth.AuthOnboardingRequired(
          session: session,
          context: _buildFallbackContext(session, needsOnboarding: true),
        ));
        _lastSession = session;
        _lastManualAuthAt = DateTime.now();

          // Audit Log: Register
        unawaited(logAuditAction(
          ref,
          action: AuditAction.register,
          entityType: 'auth',
          entityId: session.userId,
          metadata: {
            'method': 'password',
            'email': email,
            'name': name,
          },
        ));
      } else {
        state = result.fold(
          (failure) => AsyncError(failure.message, StackTrace.current),
          (_) => throw Exception(),
        );
      }
    } finally {
      _manualAuthInProgress = false;
    }
  }

  Future<void> signInWithGoogle() async {
    final previousState = state.valueOrNull;
    state = const AsyncLoading();
    _manualAuthInProgress = true;
    try {
      final result = await ref.read(signInWithGoogleUseCaseProvider).call()
          .timeout(const Duration(seconds: 30));

      if (result.isLeft()) {
        state = result.fold(
          (f) => AsyncError(f.message, StackTrace.current),
          (_) => throw Exception(),
        );
        return;
      }

      final session = result.getOrElse(() => null);
      if (session == null) {
        AppLogger.d(
          'Connexion Google annulée par l\'utilisateur',
          'AUTH_PROVIDER',
        );
        final restoredState = switch (previousState) {
          app_auth.AuthAuthenticated() => previousState,
          app_auth.AuthOnboardingRequired() => previousState,
          _ => const app_auth.AuthUnauthenticated(),
        };
        state = AsyncData(restoredState);
        return;
      }

      _lastSession = session;
      await _handleSessionChange(session);
      _lastManualAuthAt = DateTime.now();
      AppLogger.d(
        'Google OAuth natif synchronisé immédiatement',
        'AUTH_PROVIDER',
      );
    } finally {
      _manualAuthInProgress = false;
    }
  }

  Future<void> logout() async {
    final userId = ref.read(currentUserIdProvider);
    if (userId != null) {
      unawaited(logAuditAction(
        ref,
        action: AuditAction.logout,
        entityType: 'auth',
        entityId: userId,
      ));
    }

    await ref.read(authRepositoryProvider).logout();
    _lastSession = null;
    state = const AsyncData(app_auth.AuthUnauthenticated());
  }

  // ─── Password ────────────────────────────────────────────────────────────

  Future<void> requestPasswordReset({required String email}) async {
    await ref.read(authRepositoryProvider).requestPasswordReset(email: email);
  }

  Future<void> changePassword({
    required String userId,
    required String currentPassword,
    required String newPassword,
  }) async {
    await ref.read(authRepositoryProvider).changePassword(
          userId: userId,
          currentPassword: currentPassword,
          newPassword: newPassword,
        );
  }

  // ─── Onboarding ──────────────────────────────────────────────────────────

  Future<void> completeOnboarding() async {
    final current = state.valueOrNull;
    if (current is! app_auth.AuthOnboardingRequired) return;

    // 1. Tenter de récupérer le contexte backend AVANT de transitionner.
    //    Si getUserContext() réussit, on a la source de vérité (rôle, groupe...).
    //    Si l'Edge Function retourne needs_onboarding=true, c'est que le rôle
    //    n'est pas encore visible en DB : on retente 2 fois avant de basculer.
    app_auth.UserContext? backendContext;
    int tries = 0;
    while (tries < 2) {
      try {
        backendContext =
            await ref.read(userContextRepositoryProvider).getUserContext()
              .timeout(const Duration(seconds: 3));
        if (!backendContext.needsOnboarding) break;
        AppLogger.w(
          'getUserContext() après onboarding: needs_onboarding=true (tentative ${tries + 1}/2)',
          'AUTH_PROVIDER',
        );
      } catch (e) {
        AppLogger.w(
          'getUserContext() échec tentative ${tries + 1}/2: $e',
          'AUTH_PROVIDER',
        );
      }
      tries++;
      if (tries < 2) {
        await Future.delayed(const Duration(milliseconds: 600));
      }
    }

    final c = backendContext ?? current.context;
    final syncedRole = app_auth.ChurchRole.fromLabel(
      churchId: current.session.activeChurchId,
      label: c.role.code,
    );
    final syncedRoleInfo = app_auth.RoleInfo(
      code: syncedRole.name,
      label: syncedRole.name,
      isSuper: syncedRole.level == app_auth.RoleLevel.superadmin,
      level: syncedRole.level,
      initialRoute: syncedRole.initialRoute,
    );
    final session = current.session.copyWith(
      needsOnboarding: false,
      role: syncedRole,
    );
    final updatedContext = app_auth.UserContext(
      user: c.user,
      role: syncedRoleInfo,
      group: c.group,
      permissions: c.permissions,
      generatedAt: c.generatedAt,
      needsOnboarding: false,
      churchId: c.churchId,
    );
    state = AsyncData(
        app_auth.AuthAuthenticated(session: session, context: updatedContext));
    _lastSession = session;
  }

  // ─── Church switching ─────────────────────────────────────────────────────

  Future<void> switchChurch(String churchId) async {
    final current = state.valueOrNull;
    if (current is! app_auth.AuthAuthenticated) return;

    final result = await ref.read(authRepositoryProvider).switchActiveChurch(
          userId: current.session.userId,
          newChurchId: churchId,
        );

    if (result.isRight()) {
      final session = result.getOrElse(() => throw Exception());
      final context =
          await ref.read(userContextRepositoryProvider).getUserContext()
              .timeout(const Duration(seconds: 4));
      state = AsyncData(
          app_auth.AuthAuthenticated(session: session, context: context));
      _lastSession = session;
    }
  }

  Future<bool> verifyAdminCode(String code) async {
    final result = await ref.read(authRepositoryProvider).verifyAdminCode(code);
    return result.getOrElse(() => false);
  }
}

// ─── Providers dérivés ────────────────────────────────────────────────────

@Riverpod(keepAlive: true)
UserSession? currentSession(CurrentSessionRef ref) {
  final authState = ref.watch(authProvider).valueOrNull;
  return switch (authState) {
    app_auth.AuthAuthenticated(session: final s) => s,
    app_auth.AuthOnboardingRequired(session: final s) => s,
    _ => null,
  };
}

@Riverpod(keepAlive: true)
bool isAuthenticated(IsAuthenticatedRef ref) {
  return ref.watch(authProvider).valueOrNull is app_auth.AuthAuthenticated;
}

@Riverpod(keepAlive: true)
bool needsOnboarding(NeedsOnboardingRef ref) {
  return ref.watch(authProvider).valueOrNull is app_auth.AuthOnboardingRequired;
}

@Riverpod(keepAlive: true)
String? currentUserId(CurrentUserIdRef ref) {
  return ref.watch(currentSessionProvider)?.userId;
}

@Riverpod(keepAlive: true)
String activeChurchId(ActiveChurchIdRef ref) {
  return ref.watch(currentSessionProvider)?.activeChurchId ?? 'global';
}

// ─── Providers dérivés additionnels (Architecture V2) ─────────────────

/// Retourne le RoleLevel de l'utilisateur courant
@Riverpod(keepAlive: true)
RoleLevel currentRoleLevel(CurrentRoleLevelRef ref) {
  return ref.watch(currentSessionProvider)?.role.level ??
      RoleLevel.consultation;
}

/// Retourne la route initiale de l'utilisateur courant.
/// Priorité au UserContext.role.initialRoute (rafraîchi après onboarding)
/// puis fallback sur UserSession.role.initialRoute (construit au login).
@Riverpod(keepAlive: true)
String currentInitialRoute(CurrentInitialRouteRef ref) {
  final authState = ref.watch(authProvider).valueOrNull;
  // 1. Priorité au contexte (rafraîchi post-onboarding via getUserContext)
  final contextRoute = switch (authState) {
    app_auth.AuthAuthenticated(context: final c) => c.role.initialRoute,
    app_auth.AuthOnboardingRequired(context: final c) => c.role.initialRoute,
    _ => null,
  };
  if (contextRoute != null && contextRoute.isNotEmpty) return contextRoute;
  // 2. Fallback sur la session (construit au login)
  return ref.watch(currentSessionProvider)?.role.initialRoute ?? '/dashboard';
}

/// Vérifie si l'utilisateur a un accès administratif complet.
/// (Soit SuperAdmin, soit son rôle contient "administrateur").
@Riverpod(keepAlive: true)
bool isFullAdmin(IsFullAdminRef ref) {
  final authState = ref.watch(authProvider).valueOrNull;
  return switch (authState) {
    app_auth.AuthAuthenticated(context: final c) => _checkAdminAccess(c.role),
    app_auth.AuthOnboardingRequired(context: final c) =>
      _checkAdminAccess(c.role),
    _ => false,
  };
}

/// Helper pour vérifier les accès administratifs par nom ou catégorie.
bool _checkAdminAccess(app_auth.RoleInfo role) {
  if (role.isSuper ||
      role.level == RoleLevel.adminTotal ||
      role.level == RoleLevel.superadmin) {
    return true;
  }

  final label = role.label.toLowerCase();
  return label.contains('administrateur') ||
      label.contains('président') ||
      label.contains('superadmin') ||
      label.contains('webmaster');
}

/// Vérifie si l'utilisateur fait partie du Staff (Accès opérationnel complet).
/// Note: Tout le staff (Pasteurs, Secrétaires, Trésoriers) peut s'entraider.
@Riverpod(keepAlive: true)
bool isStaff(IsStaffRef ref) {
  final level = ref.watch(currentRoleLevelProvider);
  return level == RoleLevel.staff ||
      level == RoleLevel.pastoral ||
      level == RoleLevel.finance ||
      ref.watch(isFullAdminProvider);
}

/// Vérifie si l'utilisateur a accès aux finances.
/// Avec la polyvalence opérationnelle, isStaff et isTreasurer deviennent équivalents
/// pour le staff administratif de l'église.
@Riverpod(keepAlive: true)
bool isTreasurer(IsTreasurerRef ref) {
  return ref.watch(isStaffProvider);
}

/// Vérifie si l'utilisateur est admin ou superadmin (Maintenu pour compatibilité UI)
@Riverpod(keepAlive: true)
bool isAdmin(IsAdminRef ref) {
  return ref.watch(isFullAdminProvider);
}

/// Vérifie si l'utilisateur est superadmin
@Riverpod(keepAlive: true)
bool isSuperAdmin(IsSuperAdminRef ref) {
  return ref.watch(currentRoleLevelProvider) == RoleLevel.superadmin;
}

/// Vérifie si l'utilisateur est un leader (responsable de groupe)
@Riverpod(keepAlive: true)
bool isGroupLeader(IsGroupLeaderRef ref) {
  return ref.watch(currentRoleLevelProvider) == RoleLevel.groupLeader ||
      ref.watch(isStaffProvider);
}

/// Vérifie si l'utilisateur est en mode consultation uniquement
@Riverpod(keepAlive: true)
bool isConsultant(IsConsultantRef ref) {
  return ref.watch(currentRoleLevelProvider) == RoleLevel.consultation;
}

/// Vérifie si l'utilisateur est un membre standard
@Riverpod(keepAlive: true)
bool isMember(IsMemberRef ref) {
  return ref.watch(currentRoleLevelProvider) == RoleLevel.consultation;
}
