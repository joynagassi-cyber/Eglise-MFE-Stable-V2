import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lumina/core/auth/domain/entities/auth_state.dart' as app_auth;
import 'package:lumina/core/auth/domain/entities/enums/role_level.dart';
import 'package:lumina/core/providers/auth_provider.dart';
import 'package:lumina/core/providers/shared_preferences_provider.dart';
import 'package:lumina/core/router/app_routes.dart';
import 'package:lumina/core/router/router_policy.dart';
import 'package:lumina/features/onboarding/presentation/providers/onboarding_provider.dart';

app_auth.UserSession _makeSession({bool needsOnboarding = true}) {
  return app_auth.UserSession(
    userId: 'test-user-member',
    email: 'member-test@lumina.app',
    name: 'Jean Membre',
    activeChurchId: 'church-abc',
    accessibleChurchIds: const ['church-abc'],
    role: app_auth.ChurchRole.membre(churchId: 'church-abc'),
    accessToken: 'fake-access-token',
    refreshToken: 'fake-refresh-token',
    tokenExpiresAt: DateTime.now().add(const Duration(hours: 1)),
    lastLoginAt: DateTime.now(),
    needsOnboarding: needsOnboarding,
  );
}

app_auth.UserContext _makeContext({
  bool needsOnboarding = true,
  String roleCode = 'membre',
  String initialRoute = '/dashboard',
}) {
  return app_auth.UserContext(
    user: const app_auth.UserInfo(
      id: 'test-user-member',
      email: 'member-test@lumina.app',
      name: 'Jean Membre',
    ),
    role: app_auth.RoleInfo(
      code: roleCode,
      label: 'Membre',
      isSuper: false,
      level: app_auth.RoleLevel.consultation,
      initialRoute: initialRoute,
    ),
    permissions: const {},
    needsOnboarding: needsOnboarding,
    generatedAt: DateTime.now(),
  );
}

class FakeAuthForMember extends Auth {
  @override
  Future<app_auth.AuthState> build() async {
    return const app_auth.AuthUnauthenticated();
  }

  @override
  Future<void> login({required String email, required String password}) async {
    state = const AsyncLoading();
    await Future.delayed(const Duration(milliseconds: 10));
    final session = _makeSession(needsOnboarding: false);
    final context = _makeContext(needsOnboarding: false);
    state = AsyncData(app_auth.AuthAuthenticated(session: session, context: context));
  }

  @override
  Future<void> register({
    required String email,
    required String password,
    required String name,
  }) async {
    state = const AsyncLoading();
    await Future.delayed(const Duration(milliseconds: 10));
    final session = _makeSession(needsOnboarding: true);
    final context = _makeContext(needsOnboarding: true);
    state = AsyncData(app_auth.AuthOnboardingRequired(session: session, context: context));
  }

  @override
  Future<void> completeOnboarding() async {
    final current = state.valueOrNull;
    if (current is! app_auth.AuthOnboardingRequired) return;
    final session = current.session.copyWith(needsOnboarding: false);
    final context = _makeContext(needsOnboarding: false, initialRoute: '/dashboard');
    state = AsyncData(app_auth.AuthAuthenticated(session: session, context: context));
  }

  @override
  Future<void> signInWithGoogle() async {}
  @override
  Future<void> logout() async {
    state = const AsyncData(app_auth.AuthUnauthenticated());
  }
  @override
  Future<void> requestPasswordReset({required String email}) async {}
  @override
  Future<void> changePassword({required String currentPassword, required String newPassword, required String userId}) async {}
  @override
  Future<void> switchChurch(String churchId) async {}
}

void main() {
  group('MEMBER FLOW — Inscription → Onboarding (simplifié) → Dashboard', () {
    late ProviderContainer container;
    late FakeAuthForMember fakeAuth;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final sharedPrefs = await SharedPreferences.getInstance();
      fakeAuth = FakeAuthForMember();
      container = ProviderContainer(
        overrides: [
          authProvider.overrideWith(() => fakeAuth),
          sharedPreferencesProvider.overrideWithValue(sharedPrefs),
        ],
      );
    });

    tearDown(() => container.dispose());

    // ─── ÉTAPE 0 : Etat initial ──────────────────────────────────
    group('Étape 0 — Non authentifié', () {
      test('État initial = AuthUnauthenticated', () async {
        final state = await container.read(authProvider.future);
        expect(state, isA<app_auth.AuthUnauthenticated>());
      });

      test('RouteStatus = unauthenticated', () async {
        final state = await container.read(authProvider.future);
        final status = RouterPolicy.resolveStatus(AsyncData(state), const AsyncData(null));
        expect(status, RouteStatus.unauthenticated);
      });

      test('Redirection dashboard → auth-home', () {
        final result = RouterPolicy.redirectWithLocation(
          status: RouteStatus.unauthenticated,
          location: AppRoutes.dashboard,
        );
        expect(result, AppRoutes.authHome);
      });

      test('Routes publiques accessibles', () {
        final result = RouterPolicy.redirectWithLocation(
          status: RouteStatus.unauthenticated,
          location: AppRoutes.login,
        );
        expect(result, isNull);
      });

      test('currentUserId = null', () async {
        await container.read(authProvider.future);
        expect(container.read(currentUserIdProvider), isNull);
      });

      test('isAuthenticated = false', () async {
        await container.read(authProvider.future);
        expect(container.read(isAuthenticatedProvider), isFalse);
      });
    });

    // ─── ÉTAPE 1 : Inscription → AuthOnboardingRequired ────────────
    group('Étape 1 — Inscription', () {
      test('Register → AuthOnboardingRequired', () async {
        await container.read(authProvider.future);
        await container.read(authProvider.notifier).register(
          email: 'new@lumina.app', password: 'Pass123!', name: 'Nouveau',
        );
        final state = container.read(authProvider).valueOrNull;
        expect(state, isA<app_auth.AuthOnboardingRequired>());
        expect(state!.needsOnboarding, isTrue);
      });

      test('Register → fallback rôle membre', () async {
        await container.read(authProvider.future);
        await container.read(authProvider.notifier).register(
          email: 'new@lumina.app', password: 'Pass123!', name: 'Nouveau',
        );
        final state = container.read(authProvider).valueOrNull as app_auth.AuthOnboardingRequired;
        expect(state.context.role.code, 'membre');
        expect(state.context.role.level, app_auth.RoleLevel.consultation);
      });

      test('Register → RouteStatus = onboarding', () async {
        await container.read(authProvider.future);
        await container.read(authProvider.notifier).register(
          email: 'new@lumina.app', password: 'Pass123!', name: 'Nouveau',
        );
        final status = RouterPolicy.resolveStatus(
          container.read(authProvider), const AsyncData(null),
        );
        expect(status, RouteStatus.onboarding);
      });

      test('Register → needsOnboarding = true', () async {
        await container.read(authProvider.future);
        await container.read(authProvider.notifier).register(
          email: 'new@lumina.app', password: 'Pass123!', name: 'Nouveau',
        );
        expect(container.read(needsOnboardingProvider), isTrue);
      });

      test('currentInitialRoute = /dashboard pour membre', () async {
        await container.read(authProvider.future);
        await container.read(authProvider.notifier).register(
          email: 'new@lumina.app', password: 'Pass123!', name: 'Nouveau',
        );
        expect(container.read(currentInitialRouteProvider), '/dashboard');
      });
    });

    // ─── ÉTAPE 2 : Submit onboarding → AuthAuthenticated ──────────
    group('Étape 2 — SubmitOnboarding → Dashboard', () {
      test('submitOnboarding sans register → pas de crash', () async {
        await container.read(authProvider.future);
        expect(
          () => container.read(onboardingProvider.notifier).submitOnboarding(),
          returnsNormally,
        );
      });

      test('Register + submitOnboarding → AuthAuthenticated', () async {
        await container.read(authProvider.future);
        await container.read(authProvider.notifier).register(
          email: 'member@lumina.app', password: 'Pass123!', name: 'Jean Membre',
        );

        await container.read(onboardingProvider.notifier).submitOnboarding();

        final state = container.read(authProvider).valueOrNull;
        expect(state, isA<app_auth.AuthAuthenticated>());
        expect(state!.needsOnboarding, isFalse);
        expect(state.isAuthenticated, isTrue);
      });

      test('Après submit → RouteStatus = authenticated', () async {
        await container.read(authProvider.future);
        await container.read(authProvider.notifier).register(
          email: 'member@lumina.app', password: 'Pass123!', name: 'Jean Membre',
        );
        await container.read(onboardingProvider.notifier).submitOnboarding();

        final status = RouterPolicy.resolveStatus(
          container.read(authProvider), const AsyncData(null),
        );
        expect(status, RouteStatus.authenticated);
      });

      test('Après submit → needsOnboarding = false', () async {
        await container.read(authProvider.future);
        await container.read(authProvider.notifier).register(
          email: 'member@lumina.app', password: 'Pass123!', name: 'Jean Membre',
        );
        await container.read(onboardingProvider.notifier).submitOnboarding();

        expect(container.read(needsOnboardingProvider), isFalse);
      });

      test('Après submit → isAuthenticated = true', () async {
        await container.read(authProvider.future);
        await container.read(authProvider.notifier).register(
          email: 'member@lumina.app', password: 'Pass123!', name: 'Jean Membre',
        );
        await container.read(onboardingProvider.notifier).submitOnboarding();

        expect(container.read(isAuthenticatedProvider), isTrue);
        expect(container.read(isMemberProvider), isTrue);
        expect(container.read(isSuperAdminProvider), isFalse);
      });
    });

    // ─── ÉTAPE 3 : Redirection Dashboard ─────────────────────────
    group('Étape 3 — Redirect Dashboard', () {
      test('AuthAuthenticated + splash → redirect /dashboard', () async {
        await container.read(authProvider.future);
        await container.read(authProvider.notifier).register(
          email: 'member@lumina.app', password: 'Pass123!', name: 'Jean Membre',
        );
        await container.read(onboardingProvider.notifier).submitOnboarding();

        final result = RouterPolicy.redirectWithLocation(
          status: RouteStatus.authenticated,
          location: AppRoutes.splash,
          initialRoute: '/dashboard',
        );
        expect(result, '/dashboard');
      });

      test('AuthAuthenticated + /dashboard → null', () async {
        await container.read(authProvider.future);
        await container.read(authProvider.notifier).register(
          email: 'member@lumina.app', password: 'Pass123!', name: 'Jean Membre',
        );
        await container.read(onboardingProvider.notifier).submitOnboarding();

        final result = RouterPolicy.redirectWithLocation(
          status: RouteStatus.authenticated,
          location: '/dashboard',
          initialRoute: '/dashboard',
        );
        expect(result, isNull);
      });
    });

    // ─── ÉTAPE 4 : Permissions membre ────────────────────────────
    group('Étape 4 — Permissions membre', () {
      test('isMember = true, isConsultant = true', () async {
        await container.read(authProvider.future);
        await container.read(authProvider.notifier).register(
          email: 'member@lumina.app', password: 'Pass123!', name: 'Jean Membre',
        );
        await container.read(onboardingProvider.notifier).submitOnboarding();

        expect(container.read(isMemberProvider), isTrue);
        expect(container.read(isConsultantProvider), isTrue);
        expect(container.read(currentRoleLevelProvider), RoleLevel.consultation);
      });

      test('isSuperAdmin = false, isStaff = false, isGroupLeader = false', () async {
        await container.read(authProvider.future);
        await container.read(authProvider.notifier).register(
          email: 'member@lumina.app', password: 'Pass123!', name: 'Jean Membre',
        );
        await container.read(onboardingProvider.notifier).submitOnboarding();

        expect(container.read(isSuperAdminProvider), isFalse);
        expect(container.read(isStaffProvider), isFalse);
        expect(container.read(isGroupLeaderProvider), isFalse);
        expect(container.read(isFullAdminProvider), isFalse);
      });
    });

    // ─── ANTI-RÉGRESSION ─────────────────────────────────────────
    group('Anti-régression', () {
      test('Login → AuthAuthenticated direct', () async {
        await container.read(authProvider.future);
        await container.read(authProvider.notifier).login(
          email: 'existing@lumina.app', password: 'Pass123!',
        );
        final state = container.read(authProvider).valueOrNull;
        expect(state, isA<app_auth.AuthAuthenticated>());
      });

      test('Logout → AuthUnauthenticated', () async {
        await container.read(authProvider.future);
        await container.read(authProvider.notifier).login(
          email: 'existing@lumina.app', password: 'Pass123!',
        );
        await container.read(authProvider.notifier).logout();
        expect(container.read(isAuthenticatedProvider), isFalse);
      });

      test('isSubmitting = false dans OnboardingState initial', () {
        expect(container.read(onboardingProvider).isSubmitting, isFalse);
        expect(container.read(onboardingProvider).canSubmit, isTrue);
      });
    });
  });
}
