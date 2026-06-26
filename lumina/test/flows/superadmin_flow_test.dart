import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lumina/core/auth/domain/entities/auth_state.dart' as app_auth;
import 'package:lumina/core/auth/domain/entities/enums/role_level.dart';
import 'package:lumina/core/providers/auth_provider.dart';
import 'package:lumina/core/providers/shared_preferences_provider.dart';
import 'package:lumina/core/router/app_routes.dart';
import 'package:lumina/core/router/router_policy.dart';
import 'package:lumina/features/onboarding/domain/entities/onboarding_step.dart';
import 'package:lumina/features/onboarding/presentation/providers/onboarding_progress_provider.dart';

app_auth.UserSession _makeSession({bool needsOnboarding = true, String roleCode = 'super_admin'}) {
  return app_auth.UserSession(
    userId: 'test-user-superadmin',
    email: 'superadmin-test@lumina.app',
    name: 'Super Admin Test',
    activeChurchId: 'church-abc',
    accessibleChurchIds: const ['church-abc'],
    role: app_auth.ChurchRole.superadmin(),
    accessToken: 'fake-access-token',
    refreshToken: 'fake-refresh-token',
    tokenExpiresAt: DateTime.now().add(const Duration(hours: 1)),
    lastLoginAt: DateTime.now(),
    needsOnboarding: needsOnboarding,
  );
}

app_auth.UserContext _makeContext({
  bool needsOnboarding = true,
  String roleCode = 'super_admin',
  String initialRoute = '/dashboard',
  bool isSuper = true,
  RoleLevel level = RoleLevel.superadmin,
}) {
  return app_auth.UserContext(
    user: const app_auth.UserInfo(
      id: 'test-user-superadmin',
      email: 'superadmin-test@lumina.app',
      name: 'Super Admin Test',
    ),
    role: app_auth.RoleInfo(
      code: roleCode,
      label: 'Super Admin',
      isSuper: isSuper,
      level: level,
      initialRoute: initialRoute,
    ),
    permissions: const {},
    needsOnboarding: needsOnboarding,
    generatedAt: DateTime.now(),
  );
}

class FakeAuthForSuperAdmin extends Auth {
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
    final session = _makeSession(needsOnboarding: true, roleCode: 'super_admin');
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
  group('SUPERADMIN FLOW — Inscription → Code → Onboarding → Dashboard', () {
    late ProviderContainer container;
    late FakeAuthForSuperAdmin fakeAuth;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final sharedPrefs = await SharedPreferences.getInstance();
      fakeAuth = FakeAuthForSuperAdmin();
      container = ProviderContainer(
        overrides: [
          authProvider.overrideWith(() => fakeAuth),
          sharedPreferencesProvider.overrideWithValue(sharedPrefs),
        ],
      );
    });

    tearDown(() => container.dispose());

    group('Étape 0 — Non authentifié', () {
      test('État initial = AuthUnauthenticated', () async {
        final state = await container.read(authProvider.future);
        expect(state, isA<app_auth.AuthUnauthenticated>());
      });

      test('RouteStatus = unauthenticated', () async {
        final state = await container.read(authProvider.future);
        final status = RouterPolicy.resolveStatus(
          AsyncData(state), const AsyncData(null),
        );
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
    });

    group('Étape 1 — Inscription', () {
      test('Register → AuthOnboardingRequired', () async {
        await container.read(authProvider.future);
        await container.read(authProvider.notifier).register(
          email: 'new-superadmin@lumina.app', password: 'Pass123!', name: 'New Super',
        );
        final state = container.read(authProvider).valueOrNull;
        expect(state, isA<app_auth.AuthOnboardingRequired>());
        expect(state!.needsOnboarding, isTrue);
      });

      test('Register → RouteStatus = onboarding', () async {
        await container.read(authProvider.future);
        await container.read(authProvider.notifier).register(
          email: 'new-superadmin@lumina.app', password: 'Pass123!', name: 'New Super',
        );
        final status = RouterPolicy.resolveStatus(
          container.read(authProvider), const AsyncData(null),
        );
        expect(status, RouteStatus.onboarding);
      });

      test('Register → needsOnboarding = true', () async {
        await container.read(authProvider.future);
        await container.read(authProvider.notifier).register(
          email: 'new-superadmin@lumina.app', password: 'Pass123!', name: 'New Super',
        );
        expect(container.read(needsOnboardingProvider), isTrue);
      });

      test('isAuthenticated = false', () async {
        await container.read(authProvider.future);
        await container.read(authProvider.notifier).register(
          email: 'new-superadmin@lumina.app', password: 'Pass123!', name: 'New Super',
        );
        expect(container.read(isAuthenticatedProvider), isFalse);
      });
    });

    group('Étape 2 — RoleSelection → identitySetup', () {
      test('advance vers identitySetup', () {
        container.read(onboardingProgressNotifierProvider.notifier)
          .advance(OnboardingStep.identitySetup);
        final progress = container.read(onboardingProgressNotifierProvider);
        expect(progress.currentStep, OnboardingStep.identitySetup);
        expect(progress.history, [OnboardingStep.roleSelection]);
      });

      test('setRole enregistre super_admin + route', () {
        container.read(onboardingProgressNotifierProvider.notifier)
          .setRole('super_admin', route: '/onboarding/superadmin');
        final progress = container.read(onboardingProgressNotifierProvider);
        expect(progress.selectedRole, 'super_admin');
        expect(progress.roleRoute, '/onboarding/superadmin');
      });

      test('advance completed est terminal', () {
        container.read(onboardingProgressNotifierProvider.notifier)
          .advance(OnboardingStep.completed);
        expect(
          container.read(onboardingProgressNotifierProvider).currentStep.isTerminal,
          isTrue,
        );
      });

      test('reset repart à roleSelection', () {
        final notifier = container.read(onboardingProgressNotifierProvider.notifier);
        notifier.advance(OnboardingStep.identitySetup);
        notifier.reset();
        expect(
          container.read(onboardingProgressNotifierProvider).currentStep,
          OnboardingStep.roleSelection,
        );
      });
    });

    group('Étape 3 — CompleteOnboarding → Dashboard', () {
      test('Register + completeOnboarding → AuthAuthenticated', () async {
        await container.read(authProvider.future);
        await container.read(authProvider.notifier).register(
          email: 'super@lumina.app', password: 'Pass123!', name: 'Super',
        );

        await container.read(authProvider.notifier).completeOnboarding();

        final state = container.read(authProvider).valueOrNull;
        expect(state, isA<app_auth.AuthAuthenticated>());
        expect(state!.needsOnboarding, isFalse);
        expect(state.isAuthenticated, isTrue);
      });

      test('Après completeOnboarding → RouteStatus = authenticated', () async {
        await container.read(authProvider.future);
        await container.read(authProvider.notifier).register(
          email: 'super@lumina.app', password: 'Pass123!', name: 'Super',
        );
        await container.read(authProvider.notifier).completeOnboarding();

        final status = RouterPolicy.resolveStatus(
          container.read(authProvider), const AsyncData(null),
        );
        expect(status, RouteStatus.authenticated);
      });

      test('needsOnboarding = false, isAuthenticated = true', () async {
        await container.read(authProvider.future);
        await container.read(authProvider.notifier).register(
          email: 'super@lumina.app', password: 'Pass123!', name: 'Super',
        );
        await container.read(authProvider.notifier).completeOnboarding();

        expect(container.read(needsOnboardingProvider), isFalse);
        expect(container.read(isAuthenticatedProvider), isTrue);
      });

      test('completeOnboarding sans onboarding → pas de crash', () async {
        await container.read(authProvider.future);
        expect(
          () => container.read(authProvider.notifier).completeOnboarding(),
          returnsNormally,
        );
      });
    });

    group('Étape 4 — Redirect Dashboard', () {
      test('AuthAuthenticated + splash → redirect /dashboard', () async {
        await container.read(authProvider.future);
        await container.read(authProvider.notifier).register(
          email: 'super@lumina.app', password: 'Pass123!', name: 'Super',
        );
        await container.read(authProvider.notifier).completeOnboarding();

        final result = RouterPolicy.redirectWithLocation(
          status: RouteStatus.authenticated,
          location: AppRoutes.splash,
          initialRoute: '/dashboard',
        );
        expect(result, '/dashboard');
      });

      test('AuthAuthenticated + /onboarding → redirect /dashboard', () async {
        await container.read(authProvider.future);
        await container.read(authProvider.notifier).register(
          email: 'super@lumina.app', password: 'Pass123!', name: 'Super',
        );
        await container.read(authProvider.notifier).completeOnboarding();

        final result = RouterPolicy.redirectWithLocation(
          status: RouteStatus.authenticated,
          location: '/onboarding/superadmin',
          initialRoute: '/dashboard',
        );
        expect(result, '/dashboard');
      });

      test('AuthAuthenticated + /dashboard → null', () async {
        await container.read(authProvider.future);
        await container.read(authProvider.notifier).register(
          email: 'super@lumina.app', password: 'Pass123!', name: 'Super',
        );
        await container.read(authProvider.notifier).completeOnboarding();

        final result = RouterPolicy.redirectWithLocation(
          status: RouteStatus.authenticated,
          location: '/dashboard',
          initialRoute: '/dashboard',
        );
        expect(result, isNull);
      });
    });

    group('Étape 5 : Permissions SuperAdmin', () {
      test('isSuperAdmin = true', () async {
        await container.read(authProvider.future);
        await container.read(authProvider.notifier).register(
          email: 'super@lumina.app', password: 'Pass123!', name: 'Super',
        );
        await container.read(authProvider.notifier).completeOnboarding();

        expect(container.read(isSuperAdminProvider), isTrue);
        expect(container.read(isFullAdminProvider), isTrue);
      });

      test('isStaff = true, isGroupLeader = true (admin bypass)', () async {
        await container.read(authProvider.future);
        await container.read(authProvider.notifier).register(
          email: 'super@lumina.app', password: 'Pass123!', name: 'Super',
        );
        await container.read(authProvider.notifier).completeOnboarding();

        expect(container.read(isStaffProvider), isTrue);
        expect(container.read(isGroupLeaderProvider), isTrue);
      });

      test('isMember = false (pas consultation)', () async {
        await container.read(authProvider.future);
        await container.read(authProvider.notifier).register(
          email: 'super@lumina.app', password: 'Pass123!', name: 'Super',
        );
        await container.read(authProvider.notifier).completeOnboarding();

        expect(container.read(isMemberProvider), isFalse);
        expect(container.read(isConsultantProvider), isFalse);
      });

      test('currentRoleLevel = superadmin', () async {
        await container.read(authProvider.future);
        await container.read(authProvider.notifier).register(
          email: 'super@lumina.app', password: 'Pass123!', name: 'Super',
        );
        await container.read(authProvider.notifier).completeOnboarding();

        expect(container.read(currentRoleLevelProvider), RoleLevel.superadmin);
      });

      test('currentInitialRoute = /dashboard', () async {
        await container.read(authProvider.future);
        await container.read(authProvider.notifier).register(
          email: 'super@lumina.app', password: 'Pass123!', name: 'Super',
        );
        await container.read(authProvider.notifier).completeOnboarding();

        expect(container.read(currentInitialRouteProvider), '/dashboard');
      });
    });

    group('Anti-régression', () {
      test('Login direct → AuthAuthenticated sans onboarding', () async {
        await container.read(authProvider.future);
        await container.read(authProvider.notifier).login(
          email: 'existing-super@lumina.app', password: 'Pass123!',
        );
        final state = container.read(authProvider).valueOrNull;
        expect(state, isA<app_auth.AuthAuthenticated>());
        expect(state!.needsOnboarding, isFalse);
      });

      test('Logout → AuthUnauthenticated', () async {
        await container.read(authProvider.future);
        await container.read(authProvider.notifier).login(
          email: 'existing-super@lumina.app', password: 'Pass123!',
        );
        await container.read(authProvider.notifier).logout();
        expect(container.read(isAuthenticatedProvider), isFalse);
      });

      test('RouteStatus loading → splash', () {
        final result = RouterPolicy.redirectWithLocation(
          status: RouteStatus.loading,
          location: AppRoutes.dashboard,
        );
        expect(result, AppRoutes.splash);
      });

      test('RouteStatus onboarding → pas d\'accès dashboard', () {
        final result = RouterPolicy.redirectWithLocation(
          status: RouteStatus.onboarding,
          location: AppRoutes.dashboard,
        );
        expect(result, isNotNull);
        expect(result, isNot('/dashboard'));
      });
    });
  });
}
