import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import '../../../../core/utils/haptic_helper.dart';
import '../../../../core/providers/auth_provider.dart';
import 'package:lumina/core/providers/user_context_provider.dart';
import '../../../auth/presentation/widgets/role_switcher.dart';
import '../providers/dashboard_modules_provider.dart';
import '../../../../core/services/tutorial_service.dart';
import '../../../../core/router/app_routes.dart';

class DashboardDrawer extends ConsumerWidget {
  const DashboardDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authProvider).valueOrNull;
    final userContextAsync = ref.watch(userContextNotifierProvider);
    final modulesAsync = ref.watch(dashboardModulesProvider);
    final theme = Theme.of(context);

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: AppSpacing.cardPadding,
              decoration: BoxDecoration(
                gradient: context.colors.brandPrimaryGradient,
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: context.colors.brandPrimaryContainer,
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: context.colors.brandPrimary,
                    ),
                  ),
                  SizedBox(height: AppSpacing.md),
                  Text(
                    session?.name ?? 'Utilisateur',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xs),
                  SizedBox(height: AppSpacing.xs),
                  userContextAsync.when(
                    data: (ctx) => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          ctx?.role.label ?? session?.role?.name ?? 'Membre',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimary
                                .withValues(alpha: 0.9),
                          ),
                        ),
                        if (ctx != null)
                          IconButton(
                            icon: Icon(
                              Icons.sync,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimary
                                  .withValues(alpha: 0.7),
                              size: 16,
                            ),
                            tooltip: 'Changer de rôle',
                            onPressed: () => showRoleSwitcher(context),
                          ),
                      ],
                    ),
                    loading: () => Text(
                      'Chargement...',
                      style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimary
                              .withValues(alpha: 0.7)),
                    ),
                    error: (_, __) => Text(
                      session?.role?.name ?? 'Membre',
                      style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimary
                              .withValues(alpha: 0.7)),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                children: [
                  if (modulesAsync
                      .where((m) => m.priority == ModulePriority.critical)
                      .isNotEmpty) ...[
                    _buildSectionHeader(context, 'Modules Critiques'),
                    ...modulesAsync
                        .where((m) => m.priority == ModulePriority.critical)
                        .map((module) => _buildModuleTile(context, module)),
                    Divider(height: AppSpacing.lg),
                  ],
                  if (modulesAsync
                      .where((m) => m.priority == ModulePriority.frequent)
                      .isNotEmpty) ...[
                    _buildSectionHeader(context, 'Modules Fréquents'),
                    ...modulesAsync
                        .where((m) => m.priority == ModulePriority.frequent)
                        .map((module) => _buildModuleTile(context, module)),
                    Divider(height: AppSpacing.lg),
                  ],
                  if (modulesAsync
                      .where((m) => m.priority == ModulePriority.secondary)
                      .isNotEmpty) ...[
                    _buildSectionHeader(context, 'Modules Secondaires'),
                    ...modulesAsync
                        .where((m) => m.priority == ModulePriority.secondary)
                        .map((module) => _buildModuleTile(context, module)),
                  ],
                ],
              ),
            ),

            // Footer
            Divider(height: 1),
            FutureBuilder<PackageInfo>(
              future: PackageInfo.fromPlatform(),
              builder: (context, snapshot) {
                final version = snapshot.data?.version ?? '1.0.0';
                return Padding(
                  padding: AppSpacing.cardPadding,
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(
                          Icons.help_outline,
                          color: context.colors.infoText,
                        ),
                        title: Text('Revoir le tutoriel'),
                        onTap: () async {
                          await HapticHelper.light();
                          // Reset tutorial et fermer drawer
                          final service = await ref.read(
                            tutorialServiceProvider.future,
                          );
                          await service.resetTutorial();

                          if (context.mounted) {
                            Navigator.pop(context);
                            // Le tutoriel sera relancé au prochain build du dashboard
                            context.go(AppRoutes.dashboard);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Naviguez vers le Dashboard pour voir le tutoriel',
                                ),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.settings_outlined,
                          color: context.colors.brandPrimary,
                        ),
                        title: Text('Paramètres'),
                        onTap: () {
                          HapticHelper.light();
                          Navigator.pop(context);
                          context.go(AppRoutes.settings);
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.logout,
                          color: context.colors.errorText,
                        ),
                        title: Text('Déconnexion'),
                        onTap: () async {
                          await HapticHelper.medium();
                          await ref.read(authProvider.notifier).logout();
                          if (context.mounted) context.go(AppRoutes.login);
                        },
                      ),
                      SizedBox(height: AppSpacing.sm),
                      Text(
                        'Version $version',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: context.colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: context.colors.brandPrimary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildModuleTile(BuildContext context, ModuleData module) {
    return Semantics(
      label: '${module.title}, ${module.subtitle}',
      button: true,
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            gradient: module.gradient,
            borderRadius: AppSpacing.borderRadiusLg,
          ),
          child: Icon(module.icon, color: Colors.white, size: 20),
        ),
        title: Text(module.title),
        subtitle: Text(module.subtitle),
        trailing: module.notificationCount > 0
            ? Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: context.colors.errorText,
                  borderRadius: AppSpacing.borderRadiusLg,
                ),
                child: Text(
                  module.notificationCount > 99
                      ? '99+'
                      : module.notificationCount.toString(),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onError,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              )
            : Icon(Icons.chevron_right),
        onTap: () async {
          await HapticHelper.light();
          if (context.mounted) {
            Navigator.pop(context);
            context.go(module.route);
          }
        },
      ),
    );
  }
}
