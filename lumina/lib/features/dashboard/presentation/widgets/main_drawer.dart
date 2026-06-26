import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import '../../../../core/router/app_routes.dart';
import 'package:lumina/core/widgets/widgets.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../providers/dashboard_nav_provider.dart';
import '../../../../core/auth/domain/entities/enums/role_level.dart';
import '../../../../core/providers/legacy_compatibility_providers.dart';
import '../../../../core/providers/auth_provider.dart';
import '../providers/member_view_mode_provider.dart';

class MainDrawer extends ConsumerWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileStateProvider);
    final currentIndex = ref.watch(dashboardNavIndexProvider);
    final userContext = ref.watch(userContextNotifierProvider).valueOrNull;
    final roleLevel = userContext?.role.level ?? RoleLevel.consultation;
    final isSuperAdmin = userContext?.isSuperAdmin ?? false;
    final hasLeaderAccess = roleLevel.hierarchyLevel >= 40;
    final isMemberViewMode = ref.watch(memberViewModeProvider);

    return Drawer(
      backgroundColor: context.colors.bgPageLight,
      child: Column(
        children: [
          // Header
          profileAsync.when(
            data: (profile) => _buildHeader(context, profile),
            loading: () => const DrawerHeader(
                child: Center(child: LoadingDots())),
            error: (_, __) =>
                const DrawerHeader(child: Center(child: Text('Erreur'))),
          ),

          // Switch Vue Pro / Vue Membre (visible uniquement pour les leaders)
          if (hasLeaderAccess)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.xs,
              ),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  color: isMemberViewMode
                      ? context.colors.brandPrimary.withOpacity(0.08)
                      : context.colors.successText.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isMemberViewMode
                        ? context.colors.brandPrimary.withOpacity(0.3)
                        : context.colors.successText.withOpacity(0.3),
                  ),
                ),
                child: SwitchListTile(
                  dense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  title: Text(
                    isMemberViewMode ? 'Vue Membre' : 'Vue Professionnelle',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isMemberViewMode
                          ? context.colors.brandPrimary
                          : context.colors.successText,
                    ),
                  ),
                  subtitle: Text(
                    isMemberViewMode
                        ? 'Voir comme un membre'
                        : 'Dashboard de gestion',
                    style: TextStyle(
                      fontSize: 11,
                      color: context.colors.textSecondary,
                    ),
                  ),
                  secondary: Icon(
                    isMemberViewMode
                        ? Icons.person_rounded
                        : Icons.admin_panel_settings_rounded,
                    color: isMemberViewMode
                        ? context.colors.brandPrimary
                        : context.colors.successText,
                    size: 22,
                  ),
                  value: isMemberViewMode,
                  activeColor: context.colors.brandPrimary,
                  onChanged: (value) {
                    ref.read(memberViewModeProvider.notifier).state = value;
                    ref.read(dashboardNavIndexProvider.notifier).state = 0;
                    Navigator.pop(context);
                  },
                ),
              ),
            ),

          // Navigation List
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildSectionTitle('NAVIGATION PRINCIPALE'),
                _buildMenuItem(
                  context,
                  label: 'Dashboard',
                  icon: Icons.home_rounded,
                  isSelected: currentIndex == 0,
                  onTap: () {
                    ref.read(dashboardNavIndexProvider.notifier).state = 0;
                    context.pop(); // Close drawer
                  },
                ),
                if (isSuperAdmin ||
                    roleLevel.isSeniorOrEqualTo(RoleLevel.staff))
                  _buildMenuItem(
                    context,
                    label: 'Brebis (Membres)',
                    icon: Icons.people_rounded,
                    isSelected: currentIndex == 1,
                    onTap: () {
                      ref.read(dashboardNavIndexProvider.notifier).state = 1;
                      context.pop();
                    },
                  ),
                if (isSuperAdmin ||
                    roleLevel.isSeniorOrEqualTo(RoleLevel.finance))
                  _buildMenuItem(
                    context,
                    label: 'Fonds (Finances)',
                    icon: Icons.account_balance_rounded,
                    isSelected: currentIndex == 2,
                    onTap: () {
                      ref.read(dashboardNavIndexProvider.notifier).state = 2;
                      context.pop();
                    },
                  ),
                _buildMenuItem(
                  context,
                  label: 'Messages',
                  icon: Icons.chat_bubble_rounded,
                  isSelected: currentIndex == 3,
                  onTap: () {
                    ref.read(dashboardNavIndexProvider.notifier).state = 3;
                    context.pop();
                  },
                ),
                Divider(height: AppSpacing.xl),
                _buildSectionTitle('AUTRES MODULES'),
                _buildMenuItem(
                  context,
                  label: 'Bible',
                  icon: Icons.menu_book_rounded,
                  onTap: () => context.push(AppRoutes.bible),
                ),
                _buildMenuItem(
                  context,
                  label: 'Communauté',
                  icon: Icons.groups_rounded,
                  onTap: () => context.push(AppRoutes.communaute),
                ),
                if (isSuperAdmin ||
                    roleLevel.isSeniorOrEqualTo(RoleLevel.groupLeader))
                  _buildMenuItem(
                    context,
                    label: 'Programmes & Tâches',
                    icon: Icons.task_alt_rounded,
                    onTap: () => context.push(AppRoutes.communicationTasks),
                  ),
                _buildMenuItem(
                  context,
                  label: 'Événements',
                  icon: Icons.event_rounded,
                  onTap: () => context.push(AppRoutes.vieSpirituelleEvents),
                ),
                Divider(height: AppSpacing.xl),
                _buildMenuItem(
                  context,
                  label: 'Paramètres',
                  icon: Icons.settings_rounded,
                  onTap: () => context.push(AppRoutes.settings),
                ),
                _buildMenuItem(
                  context,
                  label: 'Se Déconnecter',
                  icon: Icons.logout_rounded,
                  color: context.colors.errorText,
                  onTap: () => _handleLogout(context, ref),
                ),
              ],
            ),
          ),

          // Footer
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Text(
              'Lumina v1.0.0',
              style: TextStyle(
                color: context.colors.textSecondary,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, dynamic profile) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg, 60, AppSpacing.lg, AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: context.colors.brandPrimaryGradient,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor:
                Theme.of(context).colorScheme.onPrimary.withOpacity(0.2),
            child: Icon(Icons.person_rounded,
                color: Theme.of(context).colorScheme.onPrimary, size: 30),
          ),
          SizedBox(height: AppSpacing.md),
          Text(
            profile?.name ?? 'Utilisateur',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Outfit',
            ),
          ),
          Text(
            profile?.roleLevel?.toUpperCase() ?? 'MEMBRE',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.8),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.xs),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback onTap,
    bool isSelected = false,
    Color? color,
  }) {
    final activeColor = color ?? context.colors.brandPrimary;

    return ListTile(
      leading: DuoToneIcon(
        icon: icon,
        size: 24,
        color: isSelected ? activeColor : context.colors.textSecondary,
        backgroundOpacity: isSelected ? 0.25 : 0.15,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: isSelected ? activeColor : context.colors.textPrimary,
          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
          fontSize: 14,
        ),
      ),
      selected: isSelected,
      dense: true,
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
    );
  }

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    Navigator.pop(context); // Close drawer first
    await ref.read(authProvider.notifier).logout();
    if (context.mounted) {
      context.go(AppRoutes.login);
    }
  }
}
