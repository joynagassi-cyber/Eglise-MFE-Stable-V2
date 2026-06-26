import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../router/app_routes.dart';
import '../providers/auth_provider.dart';

class MainDrawer extends ConsumerWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roleState = ref.watch(authProvider);
    final user = roleState.valueOrNull;
    final role =
        (user?.role is String ? user?.role as String? : user?.role?.toString())
                ?.toUpperCase() ??
            'MEMBRE';

    return Drawer(
      backgroundColor: Colors.transparent,
      elevation: 0,
      width: MediaQuery.of(context).size.width * 0.8,
      child: Container(
        decoration: BoxDecoration(
          color: context.colors.surfaceObsidian.withOpacity(0.95),
          border: const Border(
            right: BorderSide(color: Colors.white10),
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(context, user?.name ?? 'Utilisateur', role),
              Divider(color: Colors.white10),
              Expanded(
                child: ListView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  children: [
                    _buildSection('NAVIGATION'),
                    _buildMenuItem(
                      context,
                      icon: Icons.dashboard_rounded,
                      title: 'Tableau de Bord',
                      onTap: () => context.go(AppRoutes.dashboard),
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.auto_stories_rounded,
                      title: 'Ma Bible',
                      onTap: () => context.push(AppRoutes.bible),
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.chat_bubble_outline_rounded,
                      title: 'Messages',
                      onTap: () =>
                          context.push(AppRoutes.communicationMessaging),
                    ),
                    if (role == 'SUPERADMIN' ||
                        role == 'ADMIN' ||
                        role == 'BERGER') ...[
                      SizedBox(height: AppSpacing.lg),
                      _buildSection('GESTION'),
                      _buildMenuItem(
                        context,
                        icon: Icons.people_rounded,
                        title: 'Annuaire Membres',
                        onTap: () => context.push(AppRoutes.brebis),
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.payments_rounded,
                        title: 'Finances & Dons',
                        onTap: () => context.push(AppRoutes.finance),
                      ),
                    ],
                    if (role == 'SUPERADMIN') ...[
                      SizedBox(height: AppSpacing.lg),
                      _buildSection('ADMINISTRATION'),
                      _buildMenuItem(
                        context,
                        icon: Icons.security_rounded,
                        title: 'Rôles & Permissions (RBAC)',
                        onTap: () => context.push(AppRoutes.adminRoles),
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.history_edu_rounded,
                        title: 'Audit Logs',
                        onTap: () => context.push(AppRoutes.audit),
                      ),
                    ],
                    SizedBox(height: AppSpacing.lg),
                    _buildSection('COMPTE'),
                    _buildMenuItem(
                      context,
                      icon: Icons.person_outline_rounded,
                      title: 'Mon Profil',
                      onTap: () => context.push(AppRoutes.settings),
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.settings_rounded,
                      title: 'Paramètres',
                      onTap: () => context.push(AppRoutes.settings),
                    ),
                  ],
                ),
              ),
              _buildLogoutButton(context, ref),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String name, String role) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: context.colors.fireFusionGradient,
              boxShadow: [
                BoxShadow(
                  color: context.colors.brandPrimary.withOpacity(0.3),
                  blurRadius: 12.0,
                ),
              ],
            ),
            child:
                Icon(Icons.person_rounded, color: Colors.white, size: 30),
          ),
          SizedBox(height: AppSpacing.lg),
          Text(name, style: AppTypography.h2.copyWith(color: Colors.white)),
          Text(
            role,
            style: AppTypography.editorialSection.copyWith(
              color: context.colors.brandSecondary,
              fontSize: 10,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, bottom: 8),
      child: Text(
        title,
        style: AppTypography.editorialSection.copyWith(
          color: Colors.white38,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        margin: const EdgeInsets.only(bottom: 4),
        child: Row(
          children: [
            Icon(icon, color: context.colors.brandPrimary.withOpacity(0.7), size: 22),
            SizedBox(width: AppSpacing.md),
            Text(
              title,
              style: AppTypography.bodySmallStyle.copyWith(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: OutlinedButton.icon(
        onPressed: () async {
          Navigator.pop(context); // Close drawer first
          await ref.read(authProvider.notifier).logout();
          if (context.mounted) {
            context.go(AppRoutes.login);
          }
        },
        icon: Icon(Icons.logout_rounded, size: 18),
        label: Text('DÉCONNEXION'),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.redAccent,
          side: const BorderSide(color: Colors.redAccent, width: 0.5),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: AppTypography.editorialSection.copyWith(fontSize: 10),
        ),
      ),
    );
  }
}
