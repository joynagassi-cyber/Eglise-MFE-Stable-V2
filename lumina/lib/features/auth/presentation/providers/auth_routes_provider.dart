// lib/features/auth/presentation/providers/auth_routes_provider.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/skeletons/fire_skeleton_system.dart';
import '../pages/sign_up_page.dart';
import '../pages/sign_in_page.dart';
import '../screens/password_recovery_screen.dart';
import '../screens/role_selection_screen.dart';
import '../screens/role_code_verification_screen.dart';
import '../../../onboarding/presentation/screens/onboarding_screen.dart';

import '../../../onboarding/presentation/screens/member_onboarding_screen.dart';
import '../pages/home_page.dart';

part 'auth_routes_provider.g.dart';



@riverpod
List<RouteBase> authRoutes(AuthRoutesRef ref) {
  return [
    GoRoute(
      path: '/login-callback',
      builder: (context, state) => const Scaffold(body: _AuthSkeleton()),
    ),
    GoRoute(
      path: AppRoutes.authHome,
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const SignInPage(),
    ),
    GoRoute(
      path: AppRoutes.register,
      builder: (context, state) => const SignUpPage(),
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      builder: (context, state) => const PasswordRecoveryScreen(),
    ),
    GoRoute(
      path: AppRoutes.welcomeTour,
      builder: (context, state) => const OnboardingScreen(),
    ),

    // ─── Routes onboarding avec :role dynamique ───
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (context, state) => const RoleSelectionScreen(),
    ),
    GoRoute(
      path: '/onboarding/admin-code',
      builder: (context, state) => const RoleCodeVerificationScreen(),
    ),
    GoRoute(
      path: '/onboarding/member',
      builder: (context, state) => const MemberOnboardingScreen(),
    ),

  ];
}

class _AuthSkeleton extends StatelessWidget {
  const _AuthSkeleton();

  @override
  Widget build(BuildContext context) {
    final baseColor = Theme.of(context).brightness == Brightness.dark
        ? context.colors.bgCardElevated.withValues(alpha: 0.3)
        : context.colors.borderSubtle.withValues(alpha: 0.3);

    return Center(
      child: FireShimmer(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100, height: 100,
                decoration: BoxDecoration(color: baseColor, shape: BoxShape.circle),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Container(
                width: double.infinity, height: 56,
                decoration: BoxDecoration(color: baseColor, borderRadius: BorderRadius.circular(12)),
              ),
              const SizedBox(height: AppSpacing.lg),
              Container(
                width: double.infinity, height: 56,
                decoration: BoxDecoration(color: baseColor, borderRadius: BorderRadius.circular(12)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}