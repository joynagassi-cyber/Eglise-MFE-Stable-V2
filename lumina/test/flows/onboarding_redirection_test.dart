import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lumina/core/auth/domain/entities/auth_state.dart' as app_auth;
import 'package:lumina/core/auth/domain/entities/church_role.dart';
import 'package:lumina/core/auth/domain/entities/enums/role_level.dart';
import 'package:lumina/core/providers/auth_provider.dart';
import 'package:lumina/core/providers/shared_preferences_provider.dart';

import 'package:lumina/core/router/router_policy.dart';

app_auth.UserSession _makeSession({
  bool needsOnboarding = true,
  required String roleCode,
  required String initialRoute,
  required RoleLevel level,
  bool isSuper = false,
}) {
  return app_auth.UserSession(
    userId: 'test-user-$roleCode',
    email: '$roleCode-test@lumina.app',
    name: 'Test ${roleCode}_${initialRoute.replaceAll('/', '_')}',
    activeChurchId: 'church-abc',
    accessibleChurchIds: const ['church-abc'],
    role: ChurchRole.fromLabel(churchId: 'church-abc', label: roleCode),
    accessToken: 'fake-access-token',
    refreshToken: 'fake-refresh-token',
    tokenExpiresAt: DateTime.now().add(const Duration(hours: 1)),
    lastLoginAt: DateTime.now(),
    needsOnboarding: needsOnboarding,
  );
}

app_auth.UserContext _makeContext({
  bool needsOnboarding = true,
  required String roleCode,
  required String initialRoute,
  required RoleLevel level,
  bool isSuper = false,
}) {
  return app_auth.UserContext(
    user: app_auth.UserInfo(
      id: 'test-user-$roleCode',
      email: '$roleCode-test@lumina.app',
      name: 'Test $roleCode',
    ),
    role: app_auth.RoleInfo(
      code: roleCode,
      label: roleCode,
      isSuper: isSuper,
      level: level,
      initialRoute: initialRoute,
    ),
    permissions: const {},
    needsOnboarding: needsOnboarding,
    generatedAt: DateTime.now(),
  );
}

class FakeAuthForRole extends Auth {
  final String roleCode;
  final String initialRoute;
  final RoleLevel level;
  final bool isSuper;

  FakeAuthForRole({
    required this.roleCode,
    required this.initialRoute,
    required this.level,
    this.isSuper = false,
  });

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
    await Future.delayed(const Duration(milliseconds: 5));
    final session = _makeSession(
      needsOnboarding: true,
      roleCode: roleCode,
      initialRoute: initialRoute,
      level: level,
      isSuper: isSuper,
    );
    final context = _makeContext(
      needsOnboarding: true,
      roleCode: roleCode,
      initialRoute: initialRoute,
      level: level,
      isSuper: isSuper,
    );
    state = AsyncData(app_auth.AuthOnboardingRequired(session: session, context: context));
  }

  @override
  Future<void> completeOnboarding() async {
    final current = state.valueOrNull;
    if (current is! app_auth.AuthOnboardingRequired) return;

    // Simule le comportement réel : ChurchRole.fromLabel + sync
    final syncedRole = ChurchRole.fromLabel(
      churchId: current.session.activeChurchId,
      label: roleCode,
    );
    final session = current.session.copyWith(
      needsOnboarding: false,
      role: syncedRole,
    );
    final context = _makeContext(
      needsOnboarding: false,
      roleCode: roleCode,
      initialRoute: initialRoute,
      level: level,
      isSuper: isSuper,
    );
    state = AsyncData(app_auth.AuthAuthenticated(session: session, context: context));
  }

  @override
  Future<void> signInWithGoogle() async {}
  @override
  Future<void> logout() async {
    state = const AsyncData(app_auth.AuthUnauthenticated());
  }
  @override
  Future<void> login({required String email, required String password}) async {}
  @override
  Future<void> requestPasswordReset({required String email}) async {}
  @override
  Future<void> changePassword({required String currentPassword, required String newPassword, required String userId}) async {}
  @override
  Future<void> switchChurch(String churchId) async {}
}

void main() {
  // ═══════════════════════════════════════════════════════════════════
  // MATRICE : Tous les rôles → leur button TERMINER → dashboard dédié
  // ═══════════════════════════════════════════════════════════════════

  final roleMatrix = {
    // ─── Membres ────────────────────────────────────────────────────
    'membre':                               (route: '/dashboard',          level: RoleLevel.consultation,  isSuper: false),
    // ─── Admin Total ────────────────────────────────────────────────
    'super_admin':                          (route: '/dashboard',          level: RoleLevel.adminTotal,    isSuper: true),
    'president':                            (route: '/dashboard',          level: RoleLevel.adminTotal,    isSuper: true),
    'vice_president':                      (route: '/dashboard',          level: RoleLevel.adminTotal,    isSuper: true),
    'administrateur_systeme':              (route: '/dashboard',          level: RoleLevel.adminTotal,    isSuper: true),
    'administrateur_systeme_adjoint':       (route: '/dashboard',          level: RoleLevel.adminTotal,    isSuper: true),
    'webmaster':                            (route: '/dashboard',          level: RoleLevel.adminTotal,    isSuper: true),
    // ─── Staff ─────────────────────────────────────────────────────
    'pasteur':                              (route: '/dashboard',          level: RoleLevel.staff,         isSuper: false),
    'pasteur_adjoint':                     (route: '/dashboard',          level: RoleLevel.staff,         isSuper: false),
    'pasteur_principal':                   (route: '/dashboard',          level: RoleLevel.staff,         isSuper: false),
    'secretaire_general':                   (route: '/brebis',             level: RoleLevel.staff,         isSuper: false),
    'secretaire_general_adjoint':          (route: '/brebis',             level: RoleLevel.staff,         isSuper: false),
    'secretaire_adjoint':                   (route: '/brebis',             level: RoleLevel.staff,         isSuper: false),
    // ─── Finance ────────────────────────────────────────────────────
    'tresorier':                            (route: '/finance',            level: RoleLevel.staff,         isSuper: false),
    'tresorier_adjoint':                   (route: '/finance',            level: RoleLevel.staff,         isSuper: false),
    'comptable':                            (route: '/finance',            level: RoleLevel.staff,         isSuper: false),
    'comptable_adjoint':                   (route: '/finance',            level: RoleLevel.staff,         isSuper: false),
    'validateur_transaction':              (route: '/finance',            level: RoleLevel.staff,         isSuper: false),
    // ─── Group Leaders ─────────────────────────────────────────────
    'chef_chorale':                         (route: '/dashboard/group/chorale', level: RoleLevel.groupLeader, isSuper: false),
    'maitre_chorale':                       (route: '/dashboard/group/chorale', level: RoleLevel.groupLeader, isSuper: false),
    'president_hommes':                     (route: '/dashboard/group/hommes',  level: RoleLevel.groupLeader, isSuper: false),
    'president_hommes_adjoint':            (route: '/dashboard/group/hommes',  level: RoleLevel.groupLeader, isSuper: false),
    'presidente_femmes':                    (route: '/dashboard/group/femmes',  level: RoleLevel.groupLeader, isSuper: false),
    'presidente_femmes_adjointe':           (route: '/dashboard/group/femmes',  level: RoleLevel.groupLeader, isSuper: false),
    'president_jeunesse':                   (route: '/dashboard/group/jeunesse', level: RoleLevel.groupLeader, isSuper: false),
    'president_jeunesse_adjoint':          (route: '/dashboard/group/jeunesse', level: RoleLevel.groupLeader, isSuper: false),
    'responsable_enfants':                  (route: '/dashboard/group/enfants', level: RoleLevel.groupLeader, isSuper: false),
    'moniteur_enfants':                     (route: '/dashboard/group/enfants', level: RoleLevel.groupLeader, isSuper: false),
    'chef_intercession':                    (route: '/dashboard/group/intercession', level: RoleLevel.groupLeader, isSuper: false),
  };

  // ═══════════════════════════════════════════════════════════════════
  // TEST 1 : Chaque bouton TERMINER → currentInitialRoute correct
  // ═══════════════════════════════════════════════════════════════════
  group('Bouton TERMINER → currentInitialRoute = dashboard dédié', () {
    for (final entry in roleMatrix.entries) {
      final roleCode = entry.key;
      final expected = entry.value;

      test('$roleCode → ${expected.route}', () async {
        SharedPreferences.setMockInitialValues({});
        final sharedPrefs = await SharedPreferences.getInstance();
        final fakeAuth = FakeAuthForRole(
          roleCode: roleCode,
          initialRoute: expected.route,
          level: expected.level,
          isSuper: expected.isSuper,
        );
        final container = ProviderContainer(
          overrides: [
            authProvider.overrideWith(() => fakeAuth),
            sharedPreferencesProvider.overrideWithValue(sharedPrefs),
          ],
        );

        try {
          await container.read(authProvider.future);
          await container.read(authProvider.notifier).register(
            email: '$roleCode@test.app',
            password: 'Pass123!',
            name: 'Test $roleCode',
          );

          // Simule le clic sur TERMINER
          await container.read(authProvider.notifier).completeOnboarding();

          // Vérifie currentInitialRoute
          expect(
            container.read(currentInitialRouteProvider),
            expected.route,
            reason: 'Échec pour $roleCode :'
                ' attendu ${expected.route}'
                ' mais obtenu ${container.read(currentInitialRouteProvider)}',
          );
        } finally {
          container.dispose();
        }
      });
    }
  });

  // ═══════════════════════════════════════════════════════════════════
  // TEST 2 : Chaque bouton → status = authenticated → redirect OK
  // ═══════════════════════════════════════════════════════════════════
  group('Bouton TERMINER → RouteStatus.authenticated + redirect OK', () {
    for (final entry in roleMatrix.entries) {
      final roleCode = entry.key;
      final expected = entry.value;

      test('$roleCode → authenticated + redirect ${expected.route}', () async {
        SharedPreferences.setMockInitialValues({});
        final sharedPrefs = await SharedPreferences.getInstance();
        final fakeAuth = FakeAuthForRole(
          roleCode: roleCode,
          initialRoute: expected.route,
          level: expected.level,
          isSuper: expected.isSuper,
        );
        final container = ProviderContainer(
          overrides: [
            authProvider.overrideWith(() => fakeAuth),
            sharedPreferencesProvider.overrideWithValue(sharedPrefs),
          ],
        );

        try {
          await container.read(authProvider.future);
          await container.read(authProvider.notifier).register(
            email: '$roleCode@test.app',
            password: 'Pass123!',
            name: 'Test $roleCode',
          );
          await container.read(authProvider.notifier).completeOnboarding();

          // Vérifie AuthState
          final state = container.read(authProvider).valueOrNull;
          expect(state, isA<app_auth.AuthAuthenticated>(),
              reason: '$roleCode: AuthAuthenticated attendu après TERMINER');
          expect(state!.needsOnboarding, isFalse);

          // Vérifie RouteStatus
          final status = RouterPolicy.resolveStatus(
            container.read(authProvider),
            const AsyncData(null),
          );
          expect(status, RouteStatus.authenticated,
              reason: '$roleCode: authenticated attendu');

          // Vérifie redirect si on est sur le onboarding screen
          final result = RouterPolicy.redirectWithLocation(
            status: RouteStatus.authenticated,
            location: '/onboarding/$roleCode',
            initialRoute: expected.route,
          );
          expect(result, expected.route,
              reason: '$roleCode: redirect vers ${expected.route}');
        } finally {
          container.dispose();
        }
      });
    }
  });

  // ═══════════════════════════════════════════════════════════════════
  // TEST 3 : Permissions post-TERMINER → isSuperAdmin/isStaff/isMember
  // ═══════════════════════════════════════════════════════════════════
  group('Permissions post-TERMINER', () {
    test('super_admin → isFullAdmin=true', () async {
      SharedPreferences.setMockInitialValues({});
      final sharedPrefs = await SharedPreferences.getInstance();
      final fakeAuth = FakeAuthForRole(
        roleCode: 'super_admin',
        initialRoute: '/dashboard',
        level: RoleLevel.adminTotal,
        isSuper: true,
      );
      final container = ProviderContainer(
        overrides: [
          authProvider.overrideWith(() => fakeAuth),
          sharedPreferencesProvider.overrideWithValue(sharedPrefs),
        ],
      );

      try {
        await container.read(authProvider.future);
        await container.read(authProvider.notifier).register(
          email: 'super@test.app', password: 'Pass123!', name: 'Super',
        );
        await container.read(authProvider.notifier).completeOnboarding();

        expect(container.read(isFullAdminProvider), isTrue);
        expect(container.read(currentRoleLevelProvider), RoleLevel.adminTotal);
        expect(container.read(isStaffProvider), isTrue);
        expect(container.read(isGroupLeaderProvider), isTrue);
        expect(container.read(currentRoleLevelProvider), RoleLevel.adminTotal);
      } finally {
        container.dispose();
      }
    });

    test('chef_chorale → isGroupLeader=true, isSuperAdmin=false', () async {
      SharedPreferences.setMockInitialValues({});
      final sharedPrefs = await SharedPreferences.getInstance();
      final fakeAuth = FakeAuthForRole(
        roleCode: 'chef_chorale',
        initialRoute: '/dashboard/group/chorale',
        level: RoleLevel.groupLeader,
      );
      final container = ProviderContainer(
        overrides: [
          authProvider.overrideWith(() => fakeAuth),
          sharedPreferencesProvider.overrideWithValue(sharedPrefs),
        ],
      );

      try {
        await container.read(authProvider.future);
        await container.read(authProvider.notifier).register(
          email: 'chorale@test.app', password: 'Pass123!', name: 'Chef',
        );
        await container.read(authProvider.notifier).completeOnboarding();

        expect(container.read(isGroupLeaderProvider), isTrue);
        expect(container.read(isSuperAdminProvider), isFalse);
        expect(container.read(isFullAdminProvider), isFalse);
        expect(container.read(isMemberProvider), isFalse);
      } finally {
        container.dispose();
      }
    });

    test('membre → isMember=true, isSuperAdmin=false', () async {
      SharedPreferences.setMockInitialValues({});
      final sharedPrefs = await SharedPreferences.getInstance();
      final fakeAuth = FakeAuthForRole(
        roleCode: 'membre',
        initialRoute: '/dashboard',
        level: RoleLevel.consultation,
      );
      final container = ProviderContainer(
        overrides: [
          authProvider.overrideWith(() => fakeAuth),
          sharedPreferencesProvider.overrideWithValue(sharedPrefs),
        ],
      );

      try {
        await container.read(authProvider.future);
        await container.read(authProvider.notifier).register(
          email: 'member@test.app', password: 'Pass123!', name: 'Member',
        );
        await container.read(authProvider.notifier).completeOnboarding();

        expect(container.read(isMemberProvider), isTrue);
        expect(container.read(isConsultantProvider), isTrue);
        expect(container.read(isSuperAdminProvider), isFalse);
        expect(container.read(isFullAdminProvider), isFalse);
        expect(container.read(isStaffProvider), isFalse);
        expect(container.read(isGroupLeaderProvider), isFalse);
      } finally {
        container.dispose();
      }
    });
  });

  // ═══════════════════════════════════════════════════════════════════
  // TEST 4 : Anti-régression — session.role synchronisé avec contexte
  // ═══════════════════════════════════════════════════════════════════
  group('Session.Role synchronisé après TERMINER', () {
    test('session.role.level = context.role.level après completeOnboarding', () async {
      SharedPreferences.setMockInitialValues({});
      final sharedPrefs = await SharedPreferences.getInstance();
      final fakeAuth = FakeAuthForRole(
        roleCode: 'super_admin',
        initialRoute: '/dashboard',
        level: RoleLevel.adminTotal,
        isSuper: true,
      );
      final container = ProviderContainer(
        overrides: [
          authProvider.overrideWith(() => fakeAuth),
          sharedPreferencesProvider.overrideWithValue(sharedPrefs),
        ],
      );

      try {
        await container.read(authProvider.future);
        await container.read(authProvider.notifier).register(
          email: 'super@test.app', password: 'Pass123!', name: 'Super',
        );
        await container.read(authProvider.notifier).completeOnboarding();

        final state = container.read(authProvider).valueOrNull as app_auth.AuthAuthenticated;
        expect(state.session.role.level, state.context.role.level,
            reason: 'session.role.level doit égaler context.role.level');
        expect(state.session.role.level, RoleLevel.adminTotal);
      } finally {
        container.dispose();
      }
    });
  });
}
