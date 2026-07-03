// lib/features/settings/presentation/providers/settings_routes_provider.dart

import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/router/transition_factory.dart';
import '../screens/settings_screen.dart';
import '../screens/backup_settings_screen.dart';
import '../../../auth/presentation/screens/role_codes_admin_screen.dart';

part 'settings_routes_provider.g.dart';

@riverpod
List<RouteBase> settingsRoutes(SettingsRoutesRef ref) {
  return [
    GoRoute(
      path: AppRoutes.settings,
      pageBuilder: (context, state) => TransitionFactory.buildPage(
        context: context,
        state: state,
        type: PageType.form,
        child: const SettingsScreen(),
      ),
      routes: [
        GoRoute(
          path: 'backup',
          pageBuilder: (context, state) => TransitionFactory.buildPage(
            context: context,
            state: state,
            type: PageType.detail,
            child: const BackupSettingsScreen(),
          ),
        ),
        GoRoute(
          path: 'admin-codes',
          pageBuilder: (context, state) => TransitionFactory.buildPage(
            context: context,
            state: state,
            type: PageType.detail,
            child: const RoleCodesAdminScreen(),
          ),
        ),
      ],
    ),
  ];
}