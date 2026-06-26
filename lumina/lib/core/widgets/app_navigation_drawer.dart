import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import '../providers/legacy_compatibility_providers.dart';
import 'package:lumina/core/widgets/skeletons/fire_skeleton_system.dart';
import '../auth/domain/entities/user_context.dart';

class AppNavigationDrawer extends ConsumerWidget {
  const AppNavigationDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userContextAsync = ref.watch(userContextNotifierProvider);

    return Drawer(
      child: userContextAsync.when(
        data: (userContext) {
          if (userContext == null) {
            return const Center(child: Text('Non connecté'));
          }

          final items = _buildFilteredItems(userContext);

          return Column(
            children: [
              _buildHeader(context, userContext.user.email),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: items,
                ),
              ),
              _buildFooter(context),
            ],
          );
        },
        loading: () => const _DrawerSkeleton(),
        error: (e, _) => const Center(child: Text('Impossible de charger le menu')),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String email) {
    return DrawerHeader(
      decoration: BoxDecoration(gradient: LinearGradient(
          colors: [context.colors.brandPrimary, context.colors.brandPrimaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CircleAvatar(radius: 32,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 32, color: context.colors.brandPrimary),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            email,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFilteredItems(UserContext userContext) {
    final allItems = <_DrawerItem>[
      _DrawerItem(
        icon: Icons.dashboard,
        title: 'Dashboard',
        route: '/dashboard',
        resource: null,
      ),
      _DrawerItem(
        icon: Icons.admin_panel_settings,
        title: 'Administration',
        route: '/admin',
        resource: 'admin',
        action: 'view',
      ),
      _DrawerItem(
        icon: Icons.people,
        title: 'Bergers',
        route: '/bergers',
        resource: 'bergers',
        action: 'view',
      ),
      _DrawerItem(
        icon: Icons.assessment,
        title: 'Bilan',
        route: '/bilan',
        resource: 'reports',
        action: 'view',
      ),
      _DrawerItem(
        icon: Icons.church,
        title: 'Églises',
        route: '/churches',
        resource: 'churches',
        action: 'view',
      ),
      _DrawerItem(
        icon: Icons.group,
        title: 'Communauté',
        route: '/communaute',
        resource: 'members',
        action: 'view',
      ),
      _DrawerItem(
        icon: Icons.event,
        title: 'Événements',
        route: '/events',
        resource: 'events',
        action: 'view',
      ),
      _DrawerItem(
        icon: Icons.groups,
        title: 'Équipe',
        route: '/equipe',
        resource: 'team',
        action: 'view',
      ),
      _DrawerItem(
        icon: Icons.account_balance_wallet,
        title: 'Finances',
        route: '/finance',
        resource: 'finance',
        action: 'view',
      ),
      _DrawerItem(
        icon: Icons.volunteer_activism,
        title: 'Donateurs',
        route: '/donors',
        resource: 'donors',
        action: 'view',
      ),
      _DrawerItem(
        icon: Icons.message,
        title: 'Messagerie',
        route: '/messaging',
        resource: 'messaging',
        action: 'view',
      ),
      _DrawerItem(
        icon: Icons.notifications,
        title: 'Notifications',
        route: '/notifications',
        resource: null,
      ),
      _DrawerItem(
        icon: Icons.analytics,
        title: 'Rapports',
        route: '/reports',
        resource: 'reports',
        action: 'view',
      ),
      _DrawerItem(
        icon: Icons.settings,
        title: 'Paramètres',
        route: '/settings',
        resource: null,
      ),
      _DrawerItem(
        icon: Icons.help,
        title: 'Aide',
        route: '/help',
        resource: null,
      ),
    ];

    return allItems
        .where((item) =>
            item.resource == null ||
            userContext.isSuperAdmin ||
            userContext.hasPermission(item.resource!, item.action))
        .map((item) => _buildDrawerTile(item))
        .toList();
  }

  Widget _buildDrawerTile(_DrawerItem item) {
    return Builder(
      builder: (context) => ListTile(
        leading: Icon(item.icon, color: context.colors.brandPrimary),
        title: Text(item.title),
        onTap: () {
          Navigator.pop(context);
          context.go(item.route);
        },
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Text('Lumina v1.0.0',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12,
          color: context.colors.textSecondaryLight,
        ),
      ),
    );
  }
}

class _DrawerItem {
  final IconData icon;
  final String title;
  final String route;
  final String? resource;
  final String action;

  _DrawerItem({
    required this.icon,
    required this.title,
    required this.route,
    this.resource,
    this.action = 'view',
  });
}

class _DrawerSkeleton extends StatelessWidget {
  const _DrawerSkeleton();

  @override
  Widget build(BuildContext context) {
    final baseColor = Theme.of(context).brightness == Brightness.dark
        ? context.colors.bgCardElevated.withValues(alpha: 0.3)
        : context.colors.borderSubtle.withValues(alpha: 0.3);

    return FireShimmer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: baseColor),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: baseColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Container(
                  width: 120,
                  height: 16,
                  decoration: BoxDecoration(
                    color: baseColor,
                    borderRadius: AppSpacing.borderRadiusSm,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 8,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) => ListTile(
                leading: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: baseColor,
                    shape: BoxShape.circle,
                  ),
                ),
                title: Container(
                  height: 16,
                  decoration: BoxDecoration(
                    color: baseColor,
                    borderRadius: AppSpacing.borderRadiusSm,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
