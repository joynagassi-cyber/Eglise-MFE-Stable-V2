import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumina/core/widgets/widgets.dart';
import 'package:lumina/features/profile/presentation/providers/profile_provider.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import '../widgets/group_dashboard_view.dart';
import '../widgets/member_dashboard_view.dart';
import '../widgets/superadmin_dashboard_view.dart';
import '../providers/dashboard_nav_provider.dart';
import '../providers/member_view_mode_provider.dart';
import '../widgets/main_drawer.dart';
import 'package:lumina/core/widgets/radial_fire_menu.dart';
import 'package:lumina/core/router/app_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:lumina/core/providers/user_context_provider.dart';
import 'package:lumina/core/auth/domain/entities/enums/role_level.dart';

import 'package:lumina/features/membres/presentation/screens/member_list_screen.dart';
import 'package:lumina/features/finance/presentation/screens/finance_dashboard_screen.dart';
import 'package:lumina/features/messaging/presentation/screens/inbox_screen.dart';
import 'package:lumina/features/bible/reader/widgets/bible_view.dart';
import '../screens/communaute_screen.dart';

class HomeSwitcher extends ConsumerWidget {
  const HomeSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileStateProvider);
    final userContextAsync = ref.watch(userContextNotifierProvider);
    final currentIndex = ref.watch(dashboardNavIndexProvider);

    return profileAsync.when(
      data: (profile) {
        // Profile null (nouvel utilisateur, pas encore de row dans profiles)
        // → On continue quand même avec un profil par défaut plutôt que
        //   de bloquer l'utilisateur sur un message d'erreur.
        if (profile == null) {
          final roleLevel = userContextAsync.valueOrNull?.role.level ??
              RoleLevel.membre;
          final hasLeaderAccess = roleLevel.hierarchyLevel >= 40;
          final isMemberViewMode = ref.watch(memberViewModeProvider);
          final isProfessionalArea = hasLeaderAccess && !isMemberViewMode;
          final navItems = _getNavItems(isProfessionalArea, roleLevel);

          return Scaffold(
            drawer: const MainDrawer(),
            body: Column(
              children: [
                _buildHomeHeader(context, ref, firstName: null),
                Expanded(
                  child: IndexedStack(
                    index: currentIndex,
                    children: navItems.map((item) => item.view).toList(),
                  ),
                ),
              ],
            ),
            bottomNavigationBar: PremiumBottomBar(
              currentIndex: currentIndex,
              onTap: (index) =>
                  ref.read(dashboardNavIndexProvider.notifier).state = index,
              middleAction: RadialFireMenu(
                items: _getRadialItems(context, hasLeaderAccess),
              ),
              items: navItems.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                return BottomNavigationBarItem(
                  icon: DuoToneIcon(
                    icon: item.icon,
                    size: 24,
                    backgroundOpacity: currentIndex == index ? 0.3 : 0.1,
                    isFlamboyant: currentIndex == index,
                  ),
                  label: item.label,
                );
              }).toList(),
            ),
          );
        }

        // FIX: Utiliser la hiérarchie RoleLevel (RBAC source de vérité complète)
        final userContext = userContextAsync.valueOrNull;
        final roleLevel = userContext?.role.level ?? RoleLevel.membre;

        // Accès leader pour tous ceux ayant un niveau hiérarchique >= 40
        final hasLeaderAccess = roleLevel.hierarchyLevel >= 40;

        // Mode Vue Membre forcé ?
        final isMemberViewMode = ref.watch(memberViewModeProvider);

        // Dashboard pro seulement si on a l'accès ET qu'on n'est pas en mode membre
        final isProfessionalArea = hasLeaderAccess && !isMemberViewMode;

        // 1. Définition des modules selon le niveau de rôle
        final List<_NavigationItem> navItems =
            _getNavItems(isProfessionalArea, roleLevel);

        return Scaffold(
          drawer: const MainDrawer(),
          body: Column(
            children: [
              _buildHomeHeader(
                context,
                ref,
                firstName: profile.firstName,
                roleLabel: userContext?.role.label,
              ),
              Expanded(
                child: IndexedStack(
                  index: currentIndex,
                  children: navItems.map((item) => item.view).toList(),
                ),
              ),
            ],
          ),
          bottomNavigationBar: PremiumBottomBar(
            currentIndex: currentIndex,
            onTap: (index) =>
                ref.read(dashboardNavIndexProvider.notifier).state = index,
            middleAction: RadialFireMenu(
              items: _getRadialItems(context, hasLeaderAccess),
            ),
            items: navItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return BottomNavigationBarItem(
                icon: DuoToneIcon(
                  icon: item.icon,
                  size: 24,
                  backgroundOpacity: currentIndex == index ? 0.3 : 0.1,
                  isFlamboyant: currentIndex == index,
                ),
                label: item.label,
              );
            }).toList(),
          ),
        );
      },
      loading: () => Scaffold(
        body: _buildLoadingScaffold(context),
      ),
      error: (e, st) => Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48),
                SizedBox(height: 16),
                Text(
                  'Erreur d\'aiguillage : $e',
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.invalidate(profileStateProvider),
                  child: Text('Réessayer'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ═══════════════════════════════════════════════════════════
  /// Header premium avec gradient brand + logo + nom complet église
  /// ═══════════════════════════════════════════════════════════
  Widget _buildHomeHeader(
    BuildContext context,
    WidgetRef ref, {
    String? firstName,
    String? roleLabel,
  }) {
    final displayName = firstName?.trim().isNotEmpty == true
        ? firstName!.trim().split(' ').first
        : 'Disciple';

    return Container(
      constraints: const BoxConstraints(minHeight: 150),
      decoration: BoxDecoration(
        gradient: context.colors.brandGradient,
      ),
      child: Stack(
        children: [
          // Effet de lueur "fire" subtil en haut à droite
          Positioned(
            top: -30,
            right: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: context.colors.brandPrimary.withValues(alpha: 0.35),
                    blurRadius: 40,
                    spreadRadius: 10,
                  ),
                  BoxShadow(
                    color: context.colors.brandSecondary.withValues(alpha: 0.2),
                    blurRadius: 60,
                    spreadRadius: 20,
                  ),
                ],
              ),
            ),
          ),
          // Glow subtil en bas à gauche
          Positioned(
            bottom: -20,
            left: -10,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: context.colors.brandPrimary.withValues(alpha: 0.2),
                    blurRadius: 30,
                    spreadRadius: 8,
                  ),
                ],
              ),
            ),
          ),
          // Contenu principal
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
              child: Row(
                children: [
                  // Logo de l'église — cercle avec bordure dorée
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(
                        color: const Color(0xFFD4AF37).withValues(alpha: 0.6),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/icon/church_logo.png',
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Colonne texte : accueil + nom église
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Bonjour,',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withValues(alpha: 0.75),
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          displayName,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 0.2,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 5),
                        // Nom complet de l'église en doré/blanc
                        Text(
                          'Ministère le Feu de l\'Évangile',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFD4AF37).withValues(alpha: 0.9),
                            letterSpacing: 0.4,
                          ),
                        ),
                        Text(
                          'de Jésus-Christ',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withValues(alpha: 0.7),
                            letterSpacing: 0.4,
                          ),
                        ),
                        if (roleLabel != null && roleLabel.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.25),
                                width: 0.5,
                              ),
                            ),
                            child: Text(
                              roleLabel,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Scaffold de chargement : montre la structure du dashboard pendant
  /// que le profil se charge.
  Widget _buildLoadingScaffold(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.home_rounded, size: 48, color: context.colors.textTertiary),
          const SizedBox(height: 16),
          Text(
            'Chargement de votre espace...',
            style: TextStyle(
              color: context.colors.textSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  List<_NavigationItem> _getNavItems(
      bool isProfessionalArea, RoleLevel roleLevel) {
    if (isProfessionalArea) {
      Widget dashboardView;

      if (roleLevel.hierarchyLevel >= 60) {
        dashboardView = const SuperadminDashboardView();
      } else {
        dashboardView = const GroupDashboardView();
      }

      return [
        _NavigationItem(
          label: 'Dashboard',
          icon: Icons.home_rounded,
          view: dashboardView,
        ),
        _NavigationItem(
          label: 'Brebis',
          icon: Icons.people_rounded,
          view: MemberListScreen(),
        ),
        _NavigationItem(
          label: 'Fonds',
          icon: Icons.account_balance_rounded,
          view: FinanceDashboardScreen(),
        ),
        _NavigationItem(
          label: 'Messages',
          icon: Icons.chat_bubble_rounded,
          view: InboxScreen(),
        ),
      ];
    } else {
      return [
        _NavigationItem(
          label: 'Dashboard',
          icon: Icons.home_rounded,
          view: MemberDashboardView(),
        ),
        _NavigationItem(
          label: 'Bible',
          icon: Icons.menu_book_rounded,
          view: BibleView(),
        ),
        _NavigationItem(
          label: 'Communauté',
          icon: Icons.groups_rounded,
          view: CommunauteScreen(),
        ),
        _NavigationItem(
          label: 'Messages',
          icon: Icons.chat_bubble_rounded,
          view: InboxScreen(),
        ),
      ];
    }
  }

  List<RadialMenuItem> _getRadialItems(
      BuildContext context, bool hasLeaderAccess) {
    if (hasLeaderAccess) {
      return [
        RadialMenuItem(
          label: 'Membre',
          icon: Icons.person_add_rounded,
          color: context.colors.brandPrimary,
          onTap: () => context.push(AppRoutes.brebisNouveau),
        ),
        RadialMenuItem(
          label: 'Offrande',
          icon: Icons.payments_rounded,
          color: context.colors.successText,
          onTap: () => context.push(AppRoutes.donorsRecordDonation),
        ),
        RadialMenuItem(
          label: 'Événement',
          icon: Icons.event_available_rounded,
          color: context.colors.warningText,
          onTap: () => context.push(AppRoutes.vieSpirituelleEventsNew),
        ),
      ];
    } else {
      return [
        RadialMenuItem(
          label: 'Témoigner',
          icon: Icons.auto_awesome_rounded,
          color: context.colors.brandSecondary,
          onTap: () => context.push(AppRoutes.communicationSocialCreate),
        ),
        RadialMenuItem(
          label: 'Note Bible',
          icon: Icons.bookmark_add_rounded,
          color: context.colors.brandPrimary,
          onTap: () => context.push(AppRoutes.bibleBookmarks),
        ),
        RadialMenuItem(
          label: 'Donation',
          icon: Icons.favorite_rounded,
          color: context.colors.errorText,
          onTap: () => context.push(AppRoutes.memberDonations),
        ),
      ];
    }
  }
}

class _NavigationItem {
  final String label;
  final IconData icon;
  final Widget view;

  const _NavigationItem({
    required this.label,
    required this.icon,
    required this.view,
  });
}
