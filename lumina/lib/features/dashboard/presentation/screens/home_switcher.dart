import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumina/core/widgets/widgets.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../widgets/group_dashboard_view.dart';
import '../widgets/member_dashboard_view.dart';
import '../widgets/superadmin_dashboard_view.dart';
import '../providers/dashboard_nav_provider.dart';
import '../widgets/main_drawer.dart';
import '../../../../core/widgets/radial_fire_menu.dart';
import '../../../../core/router/app_routes.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers/user_context_provider.dart';
import '../../../../core/auth/domain/entities/enums/role_level.dart';

import '../providers/member_view_mode_provider.dart';

// Import des modules pour la navigation
import '../../../membres/presentation/screens/member_list_screen.dart';
import '../../../finance/presentation/screens/finance_dashboard_screen.dart';
import '../../../messaging/presentation/screens/inbox_screen.dart';
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
          // Tombé ici → l'utilisateur n'a pas de profil mais peut quand
          // même accéder à son dashboard. On construit le Scaffold avec
          // les nav items par défaut (mode membre).
          final roleLevel = userContextAsync.valueOrNull?.role.level ??
              RoleLevel.membre;
          final hasLeaderAccess = roleLevel.hierarchyLevel >= 40;
          final isMemberViewMode = ref.watch(memberViewModeProvider);
          final isProfessionalArea = hasLeaderAccess && !isMemberViewMode;
          final navItems = _getNavItems(isProfessionalArea, roleLevel);

          return Scaffold(
            drawer: const MainDrawer(),
            body: IndexedStack(
              index: currentIndex,
              children: navItems.map((item) => item.view).toList(),
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
        // (Superadmin, Admin, Finance, Staff, GroupLeader)
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
          body: IndexedStack(
            index: currentIndex,
            children: navItems.map((item) => item.view).toList(),
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
        // Au lieu d'un écran noir avec shimmer, on affiche le Scaffold
        // avec une barre de navigation et un contenu de chargement discret.
        // L'utilisateur voit immédiatement la structure de son dashboard.
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

  /// Scaffold de chargement : montre la structure du dashboard pendant
  /// que le profil se charge, au lieu d'un écran noir avec shimmer.
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
      // Choix du Dashboard selon le niveau hiérarchique du rôle
      Widget dashboardView;
      
      if (roleLevel.hierarchyLevel >= 60) {
        // Niveau 60+ : Superadmin, Admin, Finance, Staff -> Dashboard global
        dashboardView = const SuperadminDashboardView();
      } else {
        // Niveau 40 : GroupLeader -> Dashboard de groupe (département, pasteur)
        dashboardView = const GroupDashboardView();
      }

      return [
        _NavigationItem(
          label: 'Dashboard',
          icon: Icons.home_rounded,
          view: dashboardView,
        ),
        const _NavigationItem(
          label: 'Brebis',
          icon: Icons.people_rounded,
          view: MemberListScreen(),
        ),
        const _NavigationItem(
          label: 'Fonds',
          icon: Icons.account_balance_rounded,
          view: FinanceDashboardScreen(),
        ),
        const _NavigationItem(
          label: 'Messages',
          icon: Icons.chat_bubble_rounded,
          view: InboxScreen(),
        ),
      ];
    } else {
      return [
        const _NavigationItem(
          label: 'Dashboard',
          icon: Icons.home_rounded,
          view: MemberDashboardView(),
        ),
        const _NavigationItem(
          label: 'Bible',
          icon: Icons.menu_book_rounded,
          view: BibleView(),
        ),
        const _NavigationItem(
          label: 'Communauté',
          icon: Icons.groups_rounded,
          view: CommunauteScreen(),
        ),
        const _NavigationItem(
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
