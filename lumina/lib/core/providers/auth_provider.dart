// lib/core/providers/auth_provider.dart
//
// Notifier d'authentification â€” RBAC v3
// ResponsabilitÃ© unique : mapper l'Ã©tat Supabase en AuthState.
// Aucune logique onboarding, aucun side-effect mÃ©tier, aucun bypass.
//
// CHANGELOG :
//   - FIX : _sub listener + register() â€” getUserContext() est maintenant
//     ignorÃ© quand session.needsOnboarding=true ou light_session=true.
//     Avant ce fix, le listener appelait getUserContext() pour tout nouvel
//     utilisateur (Google OAuth ou email), attendait 3 retries Ã— 1.5s = ~4.5s,
//     puis utilisait quand mÃªme le fallback. RÃ©sultat : l'utilisateur restait
//     bloquÃ© sur le splash ~5s avant d'arriver sur /onboarding.
//     DÃ©sormais on va directement au fallback si la session indique dÃ©jÃ 
//     que l'onboarding est requis â€” getUserContext() n'apporterait rien.

import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:lumina/core/mixins/auditable_mixin.dart';
import 'package:lumina/core/domain/entities/enums/audit_action.dart';
import 'package:lumina/core/auth/domain/entities/auth_state.dart'
    as app_auth;
import 'package:lumina/core/auth/domain/entities/user_session.dart';
import 'package:lumina/core/auth/domain/entities/enums/role_level.dart';
import 'package:lumina/core/logging/app_logger.dart';
import 'package:lumina/core/data/models/local_session_model.dart';
import 'package:lumina/core/data/models/local_user_context_model.dart';
import 'package:lumina/core/providers/local_persistence_provider.dart';
import 'repository_providers.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
class Auth extends _$Auth with AuditableMixin {
  StreamSubscription<UserSession?>? _sub;
  bool _isInitialized = false;
  UserSession? _lastSession;
  bool _manualAuthInProgress = false;
  DateTime? _lastManualAuthAt;

  /// DurÃ©e de cooldown aprÃ¨s une action manuelle (login/register/Google)
  /// pendant laquelle les Ã©vÃ©nements du stream sont ignorÃ©s pour Ã©viter
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

    // 1. Lecture initiale avant d'abonner le stream pour Ã©viter les doubles
    //    transitions pendant le bootstrap du provider.
    final initialState = await _loadInitialSession();

    // 2. Abonnement rÃ©actif Ã  l'Ã©tat d'authentification.
    _sub = ref
        .read(authRepositoryProvider)
        .watchAuthState()
        .listen((session) async {
      if (_manualAuthInProgress) {
        AppLogger.d(
          'Event auth ignorÃ© pendant un flux manuel',
          'AUTH_PROVIDER',
        );
        return;
      }

      // Ã‰viter le double dÃ©clenchement en gardant trace de la derniÃ¨re session
      if (_lastSession?.userId == session?.userId &&
          _lastSession?.accessToken == session?.accessToken) {
        AppLogger.d(
          'Session identique Ã  la prÃ©cÃ©dente, pas de mise Ã  jour',
          'AUTH_PROVIDER',
        );
        return;
      }

      // Cooldown post-auth manuelle : ignorer les Ã©vÃ©nements stream
      // qui arrivent juste aprÃ¨s une action manuelle, pour Ã©viter que
      // getUserContext() (appelÃ© par loadSavedSession()) ne retourne
      // null ou une session diffÃ©rente et override l'Ã©tat correct.
      if (_lastManualAuthAt != null &&
          DateTime.now().difference(_lastManualAuthAt!) < _manualAuthCooldown) {
        AppLogger.d(
          'Event auth ignorÃ© (cooldown ${_manualAuthCooldown.inSeconds}s aprÃ¨s action manuelle)',
          'AUTH_PROVIDER',
        );
        return;
      }

      _lastSession = session;
      await _handleSessionChange(session);
    });

    return initialState;
  }

  // --- Local Persistence Helpers (Offline-First) ---

  /// Sauvegarde la session et le contexte dans Isar pour le mode offline.
  Future<void> _saveSessionLocally(
    UserSession session,
    app_auth.UserContext context,
  ) async {
    try {
      final localSvc = ref.read(localPersistenceServiceProvider);
      if (!localSvc.isReady) return;

      final localSession = LocalSessionModel.fromMap({
        'userId': session.userId,
        'email': session.email,
        'name': session.name,
        'accessToken': session.accessToken,
        'refreshToken': session.refreshToken,
        'activeChurchId': session.activeChurchId,
        'roleCode': context.role.code,
        'roleLabel': context.role.label,
        'roleHierarchyLevel': session.role.level.index,
        'needsOnboarding': session.needsOnboarding,
        'lastLoginAt': DateTime.now().toIso8601String(),
      });
      await localSvc.saveLocalSession(localSession);

      final localCtx = LocalUserContextModel.fromMap({
        'userId': session.userId,
        'roleCode': context.role.code,
        'roleLabel': context.role.label,
        'roleHierarchyLevel': session.role.level.index,
        'isSuper': context.role.isSuper,
        'needsOnboarding': context.needsOnboarding,
        'churchId': context.churchId ?? session.activeChurchId,
        'groupId': context.group?.id,
        'initialRoute': context.role.initialRoute,
      });
      await localSvc.saveLocalUserContext(localCtx);

      AppLogger.d('Session + contexte sauvegardes localement', 'AUTH_PROVIDER');
    } catch (e) {
      AppLogger.w('Erreur sauvegarde locale session: $e', 'AUTH_PROVIDER');
    }
  }

  /// Tente de charger une session depuis Isar (fallback offline).
  Future<app_auth.AuthState?> _loadSessionFromLocal() async {
    try {
      final localSvc = ref.read(localPersistenceServiceProvider);
      if (!localSvc.isReady) return null;

      final localSession = await localSvc.getLocalSession();
      if (localSession == null) return null;

      AppLogger.i(
        'Session locale: ${localSession.email} - mode offline',
        'AUTH_PROVIDER',
      );

      final localCtx = await localSvc.getLocalUserContext(localSession.userId);

      final churchId = localSession.activeChurchId ?? 'global';
      final role = app_auth.ChurchRole.fromLabel(
        churchId: churchId,
        label: localCtx?.roleCode ?? localSession.roleCode ?? 'membre',
      );

      final session = UserSession(
        userId: localSession.userId,
        email: localSession.email,
        name: localSession.name ?? '',
        accessToken: localSession.accessToken ?? '',
        refreshToken: localSession.refreshToken ?? '',
        activeChurchId: churchId,
        accessibleChurchIds: [churchId],
        role: role,
        tokenExpiresAt: DateTime.now().add(const Duration(days: 1)),
        lastLoginAt: DateTime.now(),
        needsOnboarding: localSession.needsOnboarding,
      );

      final context = app_auth.UserContext(
        user: app_auth.UserInfo(
          id: localSession.userId,
          email: localSession.email,
          name: localSession.name ?? '',
        ),
        role: app_auth.RoleInfo(
          code: localCtx?.roleCode ?? localSession.roleCode ?? 'membre',
          label: localCtx?.roleLabel ?? localSession.roleLabel ?? 'Membre',
          isSuper: localCtx?.isSuper ?? false,
          level: role.level,
          initialRoute: localCtx?.initialRoute ?? role.initialRoute,
        ),
        permissions: const {},
        generatedAt: DateTime.now().toUtc(),
        needsOnboarding: localSession.needsOnboarding,
        churchId: localCtx?.churchId ?? churchId,
      );

      _isInitialized = true;
      _lastSession = session;

      return localSession.needsOnboarding
          ? app_auth.AuthOnboardingRequired(session: session, context: context)
          : app_auth.AuthAuthenticated(session: session, context: context);
    } catch (e) {
      AppLogger.w('Erreur chargement session locale: $e', 'AUTH_PROVIDER');
      return null;
    }
  }
  /// GÃ¨re les changements de session de maniÃ¨re centralisÃ©e
  Future<void> _handleSessionChange(UserSession? session) async {
    if (session == null) {
      // âš ï¸ FIX: Ne pas override un Ã©tat AuthAuthenticated valide avec
      // AuthUnauthenticated Ã  cause d'une erreur transitoire de
      // loadSavedSession() / getUserContext() dans le stream listener.
      // L'utilisateur reste connectÃ© jusqu'Ã  la prochaine mise Ã  jour valide.
      final currentState = state.valueOrNull;
      if (currentState is app_auth.AuthAuthenticated &&
          _lastSession != null) {
        AppLogger.d(
          'Session null ignorÃ©e â€” Ã©tat AuthAuthenticated prÃ©servÃ© '
          '(erreur transitoire loadSavedSession)',
          'AUTH_PROVIDER',
        );
        return;
      }
      AppLogger.d('Session null - utilisateur dÃ©connectÃ©', 'AUTH_PROVIDER');
      _lastSession = null;
      state = const AsyncData(app_auth.AuthUnauthenticated());
      return;
    }

    final currentState = state.valueOrNull;
    AppLogger.d(
      'Changement de session dÃ©tectÃ© pour: ${session.userId}',
      'AUTH_PROVIDER',
    );

    // FIX : si la session indique dÃ©jÃ  que l'onboarding est requis
    // (light_session = nouvel utilisateur sans profil RBAC, ou needsOnboarding=true),
    // on n'appelle PAS getUserContext() â€” Ã§a Ã©chouerait aprÃ¨s 3 retries Ã— 1.5s
    // pour rien, et on utiliserait de toute faÃ§on le fallback.
    final bool skipContextFetch = session.needsOnboarding ||
        (session.metadata ?? {})['light_session'] == true;

    app_auth.UserContext context;
    if (skipContextFetch) {
      context = _buildFallbackContext(session, needsOnboarding: session.needsOnboarding);
      AppLogger.d(
        'Utilisation du contexte fallback (onboarding requis ou session lÃ©gÃ¨re)',
        'AUTH_PROVIDER',
      );
    } else {
      try {
        context =
            await ref.read(userContextRepositoryProvider).getUserContext()
              .timeout(const Duration(seconds: 4));
        AppLogger.d(
          'Contexte utilisateur chargÃ© avec succÃ¨s',
          'AUTH_PROVIDER',
        );
      } catch (e) {
        AppLogger.d(
          'getUserContext() Ã©chouÃ© dans _sub listener. Fallback. Erreur: $e',
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

    // Audit Log: Login (seulement si authentifiÃ© et l'Ã©tat change vers connectÃ©)
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

    // OFFLINE-FIRST: Persist when authenticated
    if (newState.valueOrNull is app_auth.AuthAuthenticated) {
      final a = newState.valueOrNull as app_auth.AuthAuthenticated;
      unawaited(_saveSessionLocally(a.session, a.context));
    }
  }

  /// Charge la session initiale de maniÃ¨re synchrone
  Future<app_auth.AuthState> _loadInitialSession() async {
    if (_isInitialized) {
      AppLogger.d(
        'Session dÃ©jÃ  initialisÃ©e, retour de l\'Ã©tat actuel',
        'AUTH_PROVIDER',
      );
      return state.value ?? const app_auth.AuthUnauthenticated();
    }

    try {
      final user = await ref.read(authRepositoryProvider).getCurrentUser();

      if (user == null) {
        AppLogger.d(
          'Aucun utilisateur trouvÃ©, Ã©tat non-authentifiÃ©',
          'AUTH_PROVIDER',
        );
        // OFFLINE FALLBACK
        final localState = await _loadSessionFromLocal();
        if (localState != null) return localState;
        return const app_auth.AuthUnauthenticated();
      }

      final sessionResult =
          await ref.read(authRepositoryProvider).getCurrentSession();
      final session = sessionResult.getOrElse(() => null);

      if (session == null) {
        AppLogger.d(
          'Aucune session trouvÃ©e, Ã©tat non-authentifiÃ©',
          'AUTH_PROVIDER',
        );
        // OFFLINE FALLBACK
        final localState = await _loadSessionFromLocal();
        if (localState != null) return localState;
        return const app_auth.AuthUnauthenticated();
      }
      final bool skipContextFetch = session.needsOnboarding ||
          (session.metadata ?? {})['light_session'] == true;

      if (skipContextFetch) {
        AppLogger.d(
          'Session avec onboarding requis ou lÃ©gÃ¨re, utilisation du contexte fallback',
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
        AppLogger.d('Session initiale chargÃ©e avec succÃ¨s', 'AUTH_PROVIDER');
        final shouldOnboard =
            session.needsOnboarding || context.needsOnboarding;
        return shouldOnboard
            ? app_auth.AuthOnboardingRequired(
                session: session, context: context)
            : app_auth.AuthAuthenticated(session: session, context: context);
      } catch (e) {
        // Guard : si le contexte Ã©choue (nouveau compte sans RBAC encore prÃªt),
        // fallback safe vers AuthOnboardingRequired.
        _isInitialized = true;
        _lastSession = session;
        AppLogger.d(
          'Contexte utilisateur Ã©chouÃ©, fallback vers onboarding',
          'AUTH_PROVIDER',
        );
        return app_auth.AuthOnboardingRequired(
          session: session,
          context: _buildFallbackContext(session, needsOnboarding: session.needsOnboarding),
        );
      }
    } catch (e) {
      AppLogger.w('Erreur chargement session Supabase: `$e. Tentative locale...',
          'AUTH_PROVIDER');
      // OFFLINE FALLBACK: Try loading from Isar
      final localState = await _loadSessionFromLocal();
      if (localState != null) return localState;
      return const app_auth.AuthUnauthenticated();
    }
  }
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

          // OFFLINE-FIRST: Save session locally
          unawaited(_saveSessionLocally(session, context));

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
          // Fallback dÃ©terministe en cas de problÃ¨me de contexte aprÃ¨s login rÃ©ussi
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
    // ChurchRole.name est utilisÃ© comme code et label (comportementåŽ†å²).
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
          // avec confirm email dÃ©sactivÃ©, mais on gÃ¨re quand mÃªme).
          state = const AsyncData(app_auth.AuthUnauthenticated());
          _lastSession = null;
          return;
        }

        // FIX : mÃªme logique que le _sub listener â€” un nouvel utilisateur
        // n'a pas encore de profil RBAC, inutile d'appeler getUserContext().
        // On va directement au fallback â†’ AuthOnboardingRequired â†’ /onboarding.
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
          'Connexion Google annulÃ©e par l\'utilisateur',
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
        'Google OAuth natif synchronisÃ© immÃ©diatement',
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

    // OFFLINE-FIRST: Clear local persistence
    try {
      await ref.read(localPersistenceServiceProvider).clearAll();
    } catch (e) {
      AppLogger.w('Erreur nettoyage session locale: $e', 'AUTH_PROVIDER');
    }
    await ref.read(authRepositoryProvider).logout();
    _lastSession = null;
    state = const AsyncData(app_auth.AuthUnauthenticated());
  }

  // â”€â”€â”€ Password â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

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

  // â”€â”€â”€ Onboarding â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  Future<void> completeOnboarding() async {
    final current = state.valueOrNull;
    if (current is! app_auth.AuthOnboardingRequired) return;

    // 1. Tenter de rÃ©cupÃ©rer le contexte backend AVANT de transitionner.
    //    Si getUserContext() rÃ©ussit, on a la source de vÃ©ritÃ© (rÃ´le, groupe...).
    //    Si l'Edge Function retourne needs_onboarding=true, c'est que le rÃ´le
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
          'getUserContext() aprÃ¨s onboarding: needs_onboarding=true (tentative ${tries + 1}/2)',
          'AUTH_PROVIDER',
        );
      } catch (e) {
        AppLogger.w(
          'getUserContext() Ã©chec tentative ${tries + 1}/2: $e',
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

    // OFFLINE-FIRST: Save the authenticated session locally
    unawaited(_saveSessionLocally(session, updatedContext));
  }
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

// â”€â”€â”€ Providers dÃ©rivÃ©s â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

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

// â”€â”€â”€ Providers dÃ©rivÃ©s additionnels (Architecture V2) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

/// Retourne le RoleLevel de l'utilisateur courant
@Riverpod(keepAlive: true)
RoleLevel currentRoleLevel(CurrentRoleLevelRef ref) {
  return ref.watch(currentSessionProvider)?.role.level ??
      RoleLevel.consultation;
}

/// Retourne la route initiale de l'utilisateur courant.
/// PrioritÃ© au UserContext.role.initialRoute (rafraÃ®chi aprÃ¨s onboarding)
/// puis fallback sur UserSession.role.initialRoute (construit au login).
@Riverpod(keepAlive: true)
String currentInitialRoute(CurrentInitialRouteRef ref) {
  final authState = ref.watch(authProvider).valueOrNull;
  // 1. PrioritÃ© au contexte (rafraÃ®chi post-onboarding via getUserContext)
  final contextRoute = switch (authState) {
    app_auth.AuthAuthenticated(context: final c) => c.role.initialRoute,
    app_auth.AuthOnboardingRequired(context: final c) => c.role.initialRoute,
    _ => null,
  };
  if (contextRoute != null && contextRoute.isNotEmpty) return contextRoute;
  // 2. Fallback sur la session (construit au login)
  return ref.watch(currentSessionProvider)?.role.initialRoute ?? '/dashboard';
}

/// VÃ©rifie si l'utilisateur a un accÃ¨s administratif complet.
/// (Soit SuperAdmin, soit son rÃ´le contient "administrateur").
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

/// Helper pour vÃ©rifier les accÃ¨s administratifs par nom ou catÃ©gorie.
bool _checkAdminAccess(app_auth.RoleInfo role) {
  if (role.isSuper ||
      role.level == RoleLevel.adminTotal ||
      role.level == RoleLevel.superadmin) {
    return true;
  }

  final label = role.label.toLowerCase();
  return label.contains('administrateur') ||
      label.contains('prÃ©sident') ||
      label.contains('superadmin') ||
      label.contains('webmaster');
}

/// VÃ©rifie si l'utilisateur fait partie du Staff (AccÃ¨s opÃ©rationnel complet).
/// Note: Tout le staff (Pasteurs, SecrÃ©taires, TrÃ©soriers) peut s'entraider.
@Riverpod(keepAlive: true)
bool isStaff(IsStaffRef ref) {
  final level = ref.watch(currentRoleLevelProvider);
  return level == RoleLevel.staff ||
      level == RoleLevel.pastoral ||
      level == RoleLevel.finance ||
      ref.watch(isFullAdminProvider);
}

/// VÃ©rifie si l'utilisateur a accÃ¨s aux finances.
/// Avec la polyvalence opÃ©rationnelle, isStaff et isTreasurer deviennent Ã©quivalents
/// pour le staff administratif de l'Ã©glise.
@Riverpod(keepAlive: true)
bool isTreasurer(IsTreasurerRef ref) {
  return ref.watch(isStaffProvider);
}

/// VÃ©rifie si l'utilisateur est admin ou superadmin (Maintenu pour compatibilitÃ© UI)
@Riverpod(keepAlive: true)
bool isAdmin(IsAdminRef ref) {
  return ref.watch(isFullAdminProvider);
}

/// VÃ©rifie si l'utilisateur est superadmin
@Riverpod(keepAlive: true)
bool isSuperAdmin(IsSuperAdminRef ref) {
  return ref.watch(currentRoleLevelProvider) == RoleLevel.superadmin;
}

/// VÃ©rifie si l'utilisateur est un leader (responsable de groupe)
@Riverpod(keepAlive: true)
bool isGroupLeader(IsGroupLeaderRef ref) {
  return ref.watch(currentRoleLevelProvider) == RoleLevel.groupLeader ||
      ref.watch(isStaffProvider);
}

/// VÃ©rifie si l'utilisateur est en mode consultation uniquement
@Riverpod(keepAlive: true)
bool isConsultant(IsConsultantRef ref) {
  return ref.watch(currentRoleLevelProvider) == RoleLevel.consultation;
}

/// VÃ©rifie si l'utilisateur est un membre standard
@Riverpod(keepAlive: true)
bool isMember(IsMemberRef ref) {
  return ref.watch(currentRoleLevelProvider) == RoleLevel.consultation;
}
