// lib/features/admin/presentation/providers/admin_routes_provider.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_animations.dart';
import '../../../audit/presentation/audit_dashboard_screen.dart';
import '../../../audit/presentation/audit_detail_screen.dart';
import '../../../audit/presentation/screens/action_history_screen.dart';
import '../../../approvals/presentation/approval_taskboard_screen.dart';
import '../../../rbac_admin/presentation/rbac_dashboard_screen.dart';
import '../../../rbac_admin/presentation/permission_matrix_screen.dart';
import '../../../bilan/presentation/screens/bilan_screen.dart';
import '../../../auth/presentation/screens/access_denied_screen.dart';
import '../screens/church_list_screen.dart';
import '../screens/admin_settings_screen.dart';
import '../../../auth/presentation/widgets/route_guard.dart';
import '../../../../core/auth/domain/entities/enums/role_level.dart';
import '../../../../core/providers/user_context_provider.dart';

part 'admin_routes_provider.g.dart';

@riverpod
List<RouteBase> adminRoutes(AdminRoutesRef ref) {
  return [
    GoRoute(
      path: AppRoutes.audit,
      pageBuilder: (context, state) => AppAnimations.scalePage(
        key: state.pageKey,
        child: const RouteGuard(
          requiredRoles: [RoleLevel.superadmin, RoleLevel.admin],
          child: AuditDashboardScreen(),
        ),
      ),
    ),
    GoRoute(
      path: AppRoutes.auditDetail,
      pageBuilder: (context, state) => AppAnimations.slideRightPage(
        key: state.pageKey,
        child: RouteGuard(
          requiredRoles: const [RoleLevel.superadmin, RoleLevel.admin],
          child: AuditDetailScreen(logId: state.pathParameters['logId'] ?? ''),
        ),
      ),
    ),
    GoRoute(
      path: AppRoutes.auditHistory,
      pageBuilder: (context, state) => AppAnimations.slideRightPage(
        key: state.pageKey,
        child: const RouteGuard(
          requiredRoles: [RoleLevel.superadmin, RoleLevel.admin],
          child: ActionHistoryScreen(),
        ),
      ),
    ),
    GoRoute(
      path: AppRoutes.approvals,
      pageBuilder: (context, state) => AppAnimations.scalePage(
        key: state.pageKey,
        child: const RouteGuard(
          requiredRoles: [RoleLevel.superadmin, RoleLevel.admin],
          child: ApprovalTaskboardScreen(),
        ),
      ),
    ),
    GoRoute(
      path: AppRoutes.adminRoles,
      pageBuilder: (context, state) => AppAnimations.scalePage(
        key: state.pageKey,
        child: const RouteGuard(
          requiredRoles: [RoleLevel.superadmin],
          child: RbacDashboardScreen(),
        ),
      ),
      routes: [
        GoRoute(
          path: 'matrix',
          pageBuilder: (context, state) => AppAnimations.slideRightPage(
            key: state.pageKey,
            child: const RouteGuard(
              requiredRoles: [RoleLevel.superadmin],
              child: PermissionMatrixScreen(),
            ),
          ),
        ),
      ],
    ),
    GoRoute(
      path: AppRoutes.bilan,
      pageBuilder: (context, state) => AppAnimations.scalePage(
        key: state.pageKey,
        child: Builder(builder: (context) {
          final userContext = ref.read(userContextNotifierProvider).value;
          if (userContext?.role.isSuper != true) {
            return const AccessDeniedScreen();
          }
          return const BilanScreen();
        }),
      ),
    ),
    GoRoute(
      path: AppRoutes.adminSettings,
      pageBuilder: (context, state) => AppAnimations.slideBottomPage(
        key: state.pageKey,
        child: Builder(builder: (context) {
          final userContext = ref.read(userContextNotifierProvider).value;
          if (userContext?.role.isSuper != true) {
            return const AccessDeniedScreen();
          }
          return const AdminSettingsScreen();
        }),
      ),
    ),
    GoRoute(
      path: AppRoutes.churches,
      builder: (context, state) => const RouteGuard(
        requiredRoles: [RoleLevel.superadmin, RoleLevel.admin],
        child: ChurchListScreen(),
      ),
    ),
  ];
}