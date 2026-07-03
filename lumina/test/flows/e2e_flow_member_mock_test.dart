// test/flows/e2e_flow_member_mock_test.dart
//
// Test E2E complet du parcours Membre Simple avec providers mockés.
// N'initialise PAS Supabase réel — utilise FakeAuth pour simuler l'auth.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

import 'package:lumina/core/auth/domain/entities/auth_state.dart' as app_auth;
import 'package:lumina/core/auth/domain/entities/church_role.dart';
import 'package:lumina/core/auth/domain/entities/enums/role_level.dart';
import 'package:lumina/core/auth/domain/entities/user_session.dart';
import 'package:lumina/core/providers/auth_provider.dart';
import 'package:lumina/core/providers/shared_preferences_provider.dart';
import 'package:lumina/core/router/app_router.dart';
import 'package:lumina/core/theme/app_theme.dart';
import 'package:lumina/features/profile/presentation/providers/profile_provider.dart';
import 'package:lumina/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:lumina/features/onboarding/data/repositories/onboarding_repository.dart';

/// Délai standard pour pumpAndSettle
const _kPumpTimeout = Duration(seconds: 5);

// ─── HELPERS ───────────────────────────────────────────────────────────────

app_auth.UserSession _makeSession({bool needsOnboarding = true}) {
  return app_auth.UserSession(
    userId: 'test-user-123',
    email: 'test@lumina.app',
    name: 'Test Member',
    activeChurchId: 'church-abc',
    accessibleChurchIds: const ['church-abc'],
    role: ChurchRole.membre(churchId: 'church-abc'),
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
      initialRoute: '/dashboard',
    ),
    permissions: const {},
    needsOnboarding: needsOnboarding,
    generatedAt: DateTime(2026, 1, 1),
  );
}

// ─── FAKE AUTH (étend Auth pour accéder à state via le mixin généré) ───────

class FakeAuth extends Auth {
  @override
  Future<app_auth.AuthState> build() async {
    return const app_auth.AuthUnauthenticated();
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

  @override Future<void> logout() async {
    state = const AsyncData(app_auth.AuthUnauthenticated());
  }

  @override Future<void> login({required String email, required String password}) async {
    state = const AsyncLoading();
    await Future.delayed(const Duration(milliseconds: 10));
    final session = _makeSession(needsOnboarding: true);
    final context = _makeContext(needsOnboarding: true);
    state = AsyncData(
      app_auth.AuthOnboardingRequired(session: session, context: context),
    );
  }

  @override Future<void> signInWithGoogle() async {
    state = const AsyncLoading();
    await Future.delayed(const Duration(milliseconds: 10));
    final session = _makeSession(needsOnboarding: true);
    final context = _makeContext(needsOnboarding: true);
    state = AsyncData(
      app_auth.AuthOnboardingRequired(session: session, context: context),
    );
  }

  @override Future<void> requestPasswordReset({required String email}) async {}
  @override Future<void> changePassword({required String userId, required String currentPassword, required String newPassword}) async {}
  @override Future<void> switchChurch(String churchId) async {}
  @override Future<bool> verifyAdminCode(String code) async => false;
}

// ─── FAKE ONBOARDING REPO ──────────────────────────────────────────────────

class FakeOnboardingRepo extends Fake implements OnboardingRepository {
  @override
  Future<void> completeSimpleOnboarding(String userId) async {}
}

// ─── TESTS ──────────────────────────────────────────────────────────────────

void main() {
  group('E2E Member Flow (Mock Supabase)', () {
    late ProviderContainer container;
    late GoRouter router;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final fakeAuth = FakeAuth();
      container = ProviderContainer(
        overrides: [
          authProvider.overrideWith(() => fakeAuth),
          sharedPreferencesProvider.overrideWithValue(prefs),
          onboardingRepositoryProvider.overrideWithValue(
            FakeOnboardingRepo(),
          ),
        ],
      );
      router = container.read(appRouterProvider);
    });

    tearDown(() {
      container.dispose();
    });

    test('Auth initial state = AuthUnauthenticated', () async {
      final state = await container.read(authProvider.future);
      expect(state, isA<app_auth.AuthUnauthenticated>());
    });

    test('register() → AuthOnboardingRequired', () async {
      await container.read(authProvider.future);
      await container.read(authProvider.notifier).register(
        email: 'test@lumina.app',
        password: 'Test123!',
        name: 'Test Membre',
      );
      final state = container.read(authProvider).valueOrNull;
      expect(state, isA<app_auth.AuthOnboardingRequired>());
      expect(state!.needsOnboarding, isTrue);
    });

    test('completeOnboarding() → AuthAuthenticated', () async {
      await container.read(authProvider.future);
      await container.read(authProvider.notifier).register(
        email: 'test@lumina.app',
        password: 'Test123!',
        name: 'Test Membre',
      );
      await container.read(authProvider.notifier).completeOnboarding();
      final state = container.read(authProvider).valueOrNull;
      expect(state, isA<app_auth.AuthAuthenticated>());
      expect(state!.needsOnboarding, isFalse);
      expect(state.isAuthenticated, isTrue);
    });

    testWidgets('Full UI flow: Register → Onboarding → Dashboard',
        (tester) async {
      // ─── AFFICHER L'APP AVEC LE ROUTER MOCKÉ ────────────────────
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            title: 'Lumina',
            theme: AppTheme.lightTheme,
            routerConfig: router,
          ),
        ),
      );
      // pump() au lieu de pumpAndSettle car animations continues (particules, shimmer)
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));

      // ─── 1. SUR LA PAGE D'ACCUEIL (NON CONNECTÉ) ──────────────
      // authHome (HomePage) affiche "COMMENCER" et "SE CONNECTER"
      expect(find.text('COMMENCER'), findsOneWidget);
      expect(find.text('LUMINA'), findsOneWidget);

      // Naviguer vers la page d'inscription via le bouton "COMMENCER"
      await tester.tap(find.text('COMMENCER'));
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));

      // ─── 2. VÉRIFIER LA PAGE D'INSCRIPTION ─────────────────────
      // SignUpPage: 5 TextFormFields (Prénom, Nom, Email, Password, Confirmer)
      final fields = find.byType(TextFormField);
      expect(fields.evaluate().length, greaterThanOrEqualTo(5),
          reason: 'Le formulaire d\'inscription doit avoir 5 champs');
      expect(find.text('Créer un Compte'), findsOneWidget);

      // ─── 3. DÉCLENCHER L'INSCRIPTION VIA LE NOTIFIER ───────────
      // Le bouton submit est un SwipeAuthButton (nécessite un swipe)
      // On utilise le notifier pour éviter la complexité du geste
      await container.read(authProvider.notifier).register(
        email: 'test@lumina.app',
        password: 'Test123!',
        name: 'Test Membre',
      );
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));

      // ─── 4. ONBOARDING — SÉLECTION RÔLE ─────────────────────────
      // AuthOnboardingRequired → router redirige vers /onboarding
      final roleMembre = find.text('Membre');
      expect(roleMembre.evaluate().isNotEmpty, isTrue,
          reason: 'La sélection de rôle doit être visible après register');

      await tester.tap(roleMembre);
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));

      // ─── 5. ONBOARDING — ÉTAPES SIMPLIFIÉES ─────────────────────
      final terminBtn = find.text('TERMINER');
      if (terminBtn.evaluate().isNotEmpty) {
        await tester.tap(terminBtn);
        await tester.pump(const Duration(seconds: 1));
        await tester.pump(const Duration(seconds: 1));
      }

      // ─── 6. COMPLÉTER L'ONBOARDING VIA LE NOTIFIER ─────────────
      await container.read(authProvider.notifier).completeOnboarding();
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));

      // ─── 7. VÉRIFICATION DASHBOARD ──────────────────────────────
      await tester.pump(const Duration(seconds: 2));

      // AuthAuthenticated → router redirige vers /dashboard → HomeSwitcher
      final isOnDashboard = find.text('Bonjour,').evaluate().isNotEmpty ||
          find.byIcon(Icons.home_rounded).evaluate().isNotEmpty ||
          find.text('Dashboard').evaluate().isNotEmpty;
      expect(isOnDashboard, isTrue,
          reason: 'Le dashboard doit être visible après onboarding complet');
    });
  });
}
