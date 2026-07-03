import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumina/core/auth/domain/entities/auth_state.dart'
    as app_auth;
import 'package:lumina/core/auth/domain/entities/church_role.dart';
import 'package:lumina/core/auth/domain/entities/enums/permission.dart';
import 'package:lumina/core/auth/domain/entities/enums/role_level.dart';
import 'package:lumina/core/auth/domain/entities/user_session.dart';
import 'package:lumina/core/router/app_routes.dart';
import 'package:lumina/core/router/router_policy.dart';
import 'package:lumina/features/profile/domain/entities/profile.dart';

void main() {
  group('RouterPolicy.resolveStatus', () {
    test('returns loading while auth is loading', () {
      final status = RouterPolicy.resolveStatus(
        const AsyncLoading<app_auth.AuthState>(),
        const AsyncData<Profile?>(null),
      );

      expect(status, RouteStatus.loading);
    });

    test('returns unauthenticated on auth error', () {
      final status = RouterPolicy.resolveStatus(
        AsyncError<app_auth.AuthState>(
          Exception('auth failed'),
          StackTrace.current,
        ),
        const AsyncData<Profile?>(null),
      );

      expect(status, RouteStatus.unauthenticated);
    });

    test('returns authenticated on offline auth with cached session', () {
      final status = RouterPolicy.resolveStatus(
        AsyncData<app_auth.AuthState>(
          app_auth.AuthOffline(cachedSession: _session()),
        ),
        const AsyncData<Profile?>(null),
      );

      expect(status, RouteStatus.authenticated);
    });

    test('returns unauthenticated on offline auth without cached session', () {
      final status = RouterPolicy.resolveStatus(
        const AsyncData<app_auth.AuthState>(
          app_auth.AuthOffline(),
        ),
        const AsyncData<Profile?>(null),
      );

      expect(status, RouteStatus.unauthenticated);
    });

    test('returns onboarding when auth requires onboarding', () {
      final status = RouterPolicy.resolveStatus(
        AsyncData<app_auth.AuthState>(
          app_auth.AuthOnboardingRequired(
            session: _session(needsOnboarding: true),
            context: _context(needsOnboarding: true),
          ),
        ),
        const AsyncData<Profile?>(null),
      );

      expect(status, RouteStatus.onboarding);
    });

    test('returns authenticated even when profile is loading (FIX: ne pas flash au splash)', () {
      final status = RouterPolicy.resolveStatus(
        AsyncData<app_auth.AuthState>(
          app_auth.AuthAuthenticated(
            session: _session(),
            context: _context(),
          ),
        ),
        const AsyncLoading<Profile?>(),
      );

      expect(status, RouteStatus.authenticated);
    });

    test('returns authenticated when profile load fails', () {
      final status = RouterPolicy.resolveStatus(
        AsyncData<app_auth.AuthState>(
          app_auth.AuthAuthenticated(
            session: _session(),
            context: _context(),
          ),
        ),
        AsyncError<Profile?>(
          Exception('profile failed'),
          StackTrace.current,
        ),
      );

      expect(status, RouteStatus.authenticated);
    });

    test('returns authenticated even when profile needs onboarding (auth est source de vérité)', () {
      final status = RouterPolicy.resolveStatus(
        AsyncData<app_auth.AuthState>(
          app_auth.AuthAuthenticated(
            session: _session(),
            context: _context(),
          ),
        ),
        AsyncData<Profile?>(
            _profile(needsOnboarding: true, roleLevel: 'visitor')),
      );

      expect(status, RouteStatus.authenticated);
    });

    test('returns authenticated for a healthy authenticated user', () {
      final status = RouterPolicy.resolveStatus(
        AsyncData<app_auth.AuthState>(
          app_auth.AuthAuthenticated(
            session: _session(),
            context: _context(),
          ),
        ),
        AsyncData<Profile?>(
            _profile(needsOnboarding: false, roleLevel: 'staff')),
      );

      expect(status, RouteStatus.authenticated);
    });
  });

  group('RouterPolicy.redirect', () {
    test('keeps splash during loading', () {
      expect(
        RouterPolicy.redirectWithLocation(
          status: RouteStatus.loading,
          location: AppRoutes.splash,
        ),
        isNull,
      );

      expect(
        RouterPolicy.redirectWithLocation(
          status: RouteStatus.loading,
          location: AppRoutes.dashboard,
        ),
        AppRoutes.splash,
      );
    });

    test('sends unauthenticated users to auth home', () {
      expect(
        RouterPolicy.redirectWithLocation(
          status: RouteStatus.unauthenticated,
          location: AppRoutes.login,
        ),
        isNull,
      );

      expect(
        RouterPolicy.redirectWithLocation(
          status: RouteStatus.unauthenticated,
          location: AppRoutes.dashboard,
        ),
        AppRoutes.authHome,
      );
    });

    test('keeps onboarding users inside onboarding routes', () {
      expect(
        RouterPolicy.redirectWithLocation(
          status: RouteStatus.onboarding,
          location: AppRoutes.dashboard,
        ),
        AppRoutes.onboarding,
      );
    });

    test('routes authenticated users away from public pages to initial route',
        () {
      expect(
        RouterPolicy.redirectWithLocation(
          status: RouteStatus.authenticated,
          location: AppRoutes.authHome,
          initialRoute: '/finance',
        ),
        '/finance',
      );

      expect(
        RouterPolicy.redirectWithLocation(
          status: RouteStatus.authenticated,
          location: '/finance',
          initialRoute: '/finance',
        ),
        isNull,
      );
    });
  });
}

ChurchRole _role({
  String churchId = 'church-1',
  String name = 'Membre',
  RoleLevel level = RoleLevel.consultation,
  String initialRoute = AppRoutes.dashboard,
  Set<Permission> permissions = const {},
}) {
  return ChurchRole(
    id: 'role-1',
    churchId: churchId,
    level: level,
    name: name,
    permissions: permissions,
    createdAt: DateTime.utc(2026, 1, 1),
    initialRoute: initialRoute,
  );
}

UserSession _session({
  String userId = 'user-1',
  String email = 'user@example.com',
  String name = 'Jean User',
  String churchId = 'church-1',
  bool needsOnboarding = false,
}) {
  return UserSession(
    userId: userId,
    email: email,
    name: name,
    activeChurchId: churchId,
    accessibleChurchIds: [churchId],
    role: _role(churchId: churchId),
    accessToken: 'access-token',
    refreshToken: 'refresh-token',
    tokenExpiresAt: DateTime.now().add(const Duration(hours: 1)),
    lastLoginAt: DateTime.now(),
    needsOnboarding: needsOnboarding,
  );
}

Profile _profile({
  String id = 'profile-1',
  bool needsOnboarding = false,
  String roleLevel = 'staff',
}) {
  return Profile(
    id: id,
    email: 'user@example.com',
    roleLevel: roleLevel,
    needsOnboarding: needsOnboarding,
  );
}

app_auth.UserContext _context({
  bool needsOnboarding = false,
  String churchId = 'church-1',
  String initialRoute = AppRoutes.dashboard,
}) {
  return app_auth.UserContext(
    user: const app_auth.UserInfo(
      id: 'user-1',
      email: 'user@example.com',
      name: 'Jean User',
    ),
    role: app_auth.RoleInfo(
      code: 'role-1',
      label: 'Membre',
      isSuper: false,
      level: RoleLevel.consultation,
      initialRoute: initialRoute,
    ),
    permissions: const {},
    generatedAt: DateTime.utc(2026, 1, 1),
    needsOnboarding: needsOnboarding,
    churchId: churchId,
  );
}
