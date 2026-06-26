// test/app_flow_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lumina/core/auth/domain/entities/auth_state.dart'
    as app_auth;
import 'package:lumina/core/providers/auth_provider.dart';
import 'package:lumina/core/router/router_policy.dart';
import 'package:lumina/features/onboarding/data/repositories/onboarding_repository.dart';
import 'package:lumina/features/onboarding/domain/entities/onboarding_step.dart';
import 'package:lumina/features/onboarding/domain/entities/onboarding_progress.dart';
import 'package:lumina/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lumina/features/onboarding/presentation/screens/member_onboarding_screen.dart';

import 'package:lumina/core/providers/shared_preferences_provider.dart';
import 'package:lumina/core/theme/app_theme.dart';

app_auth.UserSession _makeSession({bool needsOnboarding = true}) {
  return app_auth.UserSession(
    userId: 'test-user-123',
    email: 'test@lumina.app',
    name: 'Test Member',
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
}) {
  return app_auth.UserContext(
    user: const app_auth.UserInfo(
      id: 'test-user-123',
      email: 'test@lumina.app',
      name: 'Test Member',
    ),
    role: app_auth.RoleInfo(
      code: roleCode,
      label: roleCode,
      isSuper: false,
      level: app_auth.RoleLevel.consultation,
    ),
    permissions: const {},
    needsOnboarding: needsOnboarding,
    generatedAt: DateTime(2026, 1, 1),
  );
}

class FakeAuth extends Auth {
  @override
  Future<app_auth.AuthState> build() async {
    return const app_auth.AuthUnauthenticated();
  }

  @override
  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();
    await Future.delayed(const Duration(milliseconds: 10));
    final session = _makeSession(needsOnboarding: true);
    final context = _makeContext(needsOnboarding: true);
    state = AsyncData(
      app_auth.AuthOnboardingRequired(session: session, context: context),
    );
  }

  @override
  Future<void> completeOnboarding() async {
    final current = state.valueOrNull;
    if (current is! app_auth.AuthOnboardingRequired) return;
    final session = current.session.copyWith(needsOnboarding: false);
    final context = app_auth.UserContext(
      user: const app_auth.UserInfo(
        id: 'test-user-123',
        email: 'test@lumina.app',
        name: 'Test Member',
      ),
      role: const app_auth.RoleInfo(
        code: 'membre',
        label: 'Membre',
        isSuper: false,
        level: app_auth.RoleLevel.consultation,
        initialRoute: '/dashboard',
      ),
      permissions: const {},
      needsOnboarding: false,
      generatedAt: DateTime(2026, 1, 1),
    );
    state = AsyncData(
      app_auth.AuthAuthenticated(session: session, context: context),
    );
  }

  @override Future<void> logout() async {}
  @override Future<void> login({required String email, required String password}) async {}
  @override Future<void> register({required String email, required String password, required String name}) async {}
  @override Future<void> requestPasswordReset({required String email}) async {}
  @override Future<void> changePassword({required String userId, required String currentPassword, required String newPassword}) async {}
  @override Future<void> switchChurch(String churchId) async {}
}

class FakeOnboardingRepo extends Fake implements OnboardingRepository {
  bool simpleCalled = false;

  @override
  Future<void> completeSimpleOnboarding(String userId) async {
    simpleCalled = true;
  }
}

Widget _testApp(Widget child, {List<Override> overrides = const []}) {
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp(
      theme: AppTheme.lightTheme,
      localizationsDelegates: const [],
      home: child,
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('RouterPolicy — logique de redirection', () {
    test('état loading → reste sur splash', () {
      final result = RouterPolicy.redirectWithLocation(
        status: RouteStatus.loading,
        location: '/',
      );
      expect(result, isNull);
    });

    test('état loading + route non-splash → redirige vers splash', () {
      final result = RouterPolicy.redirectWithLocation(
        status: RouteStatus.loading,
        location: '/dashboard',
      );
      expect(result, equals('/'));
    });

    test('non-authentifié sur route protégée → redirige vers auth-home', () {
      final result = RouterPolicy.redirectWithLocation(
        status: RouteStatus.unauthenticated,
        location: '/dashboard',
      );
      expect(result, equals('/auth-home'));
    });

    test('non-authentifié sur /login → pas de redirection', () {
      final result = RouterPolicy.redirectWithLocation(
        status: RouteStatus.unauthenticated,
        location: '/login',
      );
      expect(result, isNull);
    });

    test('état onboarding → redirige vers la bonne étape', () {
      final result = RouterPolicy.redirectWithLocation(
        status: RouteStatus.onboarding,
        location: '/dashboard',
      );
      expect(result, isNotNull);
      expect(result, isNot(equals('/dashboard')));
    });

    test('authentifié sur splash → redirige vers dashboard', () {
      final result = RouterPolicy.redirectWithLocation(
        status: RouteStatus.authenticated,
        location: '/',
        initialRoute: '/dashboard',
      );
      expect(result, equals('/dashboard'));
    });

    test('authentifié sur route protégée → pas de redirection', () {
      final result = RouterPolicy.redirectWithLocation(
        status: RouteStatus.authenticated,
        location: '/brebis',
        initialRoute: '/dashboard',
      );
      expect(result, isNull);
    });

    test('redirectWithLocation ne lance jamais d exception', () {
      expect(
        () => RouterPolicy.redirectWithLocation(
          status: RouteStatus.authenticated,
          location: '/route/inconnue',
        ),
        returnsNormally,
      );
    });
  });

  group('OnboardingNotifier — machine à états', () {
    late ProviderContainer container;
    late FakeOnboardingRepo fakeRepo;
    late FakeAuth fakeAuth;
    late SharedPreferences prefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      fakeRepo = FakeOnboardingRepo();
      fakeAuth = FakeAuth();
      container = ProviderContainer(
        overrides: [
          authProvider.overrideWith(() => fakeAuth),
          onboardingRepositoryProvider.overrideWithValue(fakeRepo),
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
      );
    });

    tearDown(() => container.dispose());

    test('état initial vide', () {
      final state = container.read(onboardingProvider);
      expect(state.isSubmitting, isFalse);
      expect(state.error, isNull);
    });

    test('submitOnboarding → termine avec succès', () async {
      await container.read(authProvider.notifier).signInWithGoogle();
      final notifier = container.read(onboardingProvider.notifier);
      await notifier.submitOnboarding();

      final state = container.read(onboardingProvider);
      expect(state.isSubmitting, isFalse);
      expect(fakeRepo.simpleCalled, isTrue);
    });
  });

  group('FakeAuth — transitions d\'état', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer(
        overrides: [authProvider.overrideWith(() => FakeAuth())],
      );
    });

    tearDown(() => container.dispose());

    test('état initial = AuthUnauthenticated', () async {
      final state = await container.read(authProvider.future);
      expect(state, isA<app_auth.AuthUnauthenticated>());
    });

    test('signInWithGoogle() → AuthOnboardingRequired', () async {
      await container.read(authProvider.future);
      await container.read(authProvider.notifier).signInWithGoogle();
      final state = container.read(authProvider).valueOrNull;
      expect(state, isA<app_auth.AuthOnboardingRequired>());
      expect(state!.needsOnboarding, isTrue);
    });

    test('completeOnboarding() → AuthAuthenticated', () async {
      await container.read(authProvider.future);
      await container.read(authProvider.notifier).signInWithGoogle();
      await container.read(authProvider.notifier).completeOnboarding();
      final state = container.read(authProvider).valueOrNull;
      expect(state, isA<app_auth.AuthAuthenticated>());
      expect(state!.needsOnboarding, isFalse);
      expect(state.isAuthenticated, isTrue);
    });

    test('completeOnboarding() sans AuthOnboardingRequired → pas de crash', () async {
      await container.read(authProvider.future);
      expect(
        () => container.read(authProvider.notifier).completeOnboarding(),
        returnsNormally,
      );
    });

    test('userId accessible après connexion', () async {
      await container.read(authProvider.future);
      await container.read(authProvider.notifier).signInWithGoogle();
      expect(container.read(currentUserIdProvider), equals('test-user-123'));
    });

    test('needsOnboarding = true après signIn', () async {
      await container.read(authProvider.future);
      await container.read(authProvider.notifier).signInWithGoogle();
      expect(container.read(needsOnboardingProvider), isTrue);
    });

    test('isAuthenticated = true après completeOnboarding', () async {
      await container.read(authProvider.future);
      await container.read(authProvider.notifier).signInWithGoogle();
      await container.read(authProvider.notifier).completeOnboarding();
      expect(container.read(isAuthenticatedProvider), isTrue);
    });
  });

  group('MemberOnboardingScreen — widgets', () {
    late FakeOnboardingRepo fakeRepo;
    late SharedPreferences prefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      fakeRepo = FakeOnboardingRepo();
    });

    testWidgets('Affiche le message de bienvenue et le bouton TERMINER',
        (tester) async {
      await tester.pumpWidget(_testApp(
        const MemberOnboardingScreen(),
        overrides: [
          authProvider.overrideWith(() => FakeAuth()),
          onboardingRepositoryProvider.overrideWithValue(fakeRepo),
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
      ));
      await tester.pump();

      expect(find.textContaining('Bienvenue', skipOffstage: false), findsWidgets);
      expect(find.text('TERMINER'), findsOneWidget);
      
      final btn = tester.widget<ElevatedButton>(
        find.ancestor(of: find.text('TERMINER'), matching: find.byType(ElevatedButton)),
      );
      expect(btn.onPressed, isNotNull);
    });
  });

  group('OnboardingProgress — navigation entre étapes', () {
    test('step initial = roleSelection', () {
      const progress = OnboardingProgress(
        currentStep: OnboardingStep.roleSelection,
        history: [],
      );
      expect(progress.currentStep, equals(OnboardingStep.roleSelection));
    });
  });
}
