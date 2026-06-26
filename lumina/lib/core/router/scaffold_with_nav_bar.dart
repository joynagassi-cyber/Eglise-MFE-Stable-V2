// lib/core/router/scaffold_with_nav_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/profile/presentation/providers/profile_provider.dart';
import '../widgets/navigation/fire_floating_nav_bar.dart';
import 'package:lumina/core/widgets/skeletons/fire_skeleton_system.dart';

class ScaffoldWithNavBar extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;
  const ScaffoldWithNavBar({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileStateProvider);

    return profileAsync.when(
      data: (profile) {
        if (profile == null) {
          return const Scaffold(body: FireSkeletonDashboard());
        }

        final role = profile.roleLevel.toLowerCase();
        final isSuperAdmin = role == 'superadmin' || role == 'admin_general';
        final isChef = role == 'berger' || role == 'responsable';
        final isMembre = role == 'membre';

        final destinations = <FireNavItem>[];
        final visibility = <bool>[];

        // Branch 0: Dashboard (Always visible, but label changes)
        destinations.add(FireNavItem(
          icon: isMembre ? Icons.home_outlined : Icons.dashboard_outlined,
          selectedIcon: isMembre ? Icons.home : Icons.dashboard,
          label: isMembre ? 'Accueil' : 'Dashboard',
        ));
        visibility.add(true);

        // Branch 1: Membres / Mon Groupe
        if (isSuperAdmin || isChef) {
          destinations.add(FireNavItem(
            icon: isChef ? Icons.group_outlined : Icons.people_outline,
            selectedIcon: isChef ? Icons.group : Icons.people,
            label: isChef ? 'Mon Groupe' : 'Brebis',
          ));
          visibility.add(true);
        } else {
          visibility.add(false);
        }

        // Branch 2: Sacrements / Événements
        if (isSuperAdmin) {
          destinations.add(const FireNavItem(
            icon: Icons.church_outlined,
            selectedIcon: Icons.church,
            label: 'Sacrements',
          ));
          visibility.add(true);
        } else if (isChef || isMembre) {
          destinations.add(FireNavItem(
            icon: isChef ? Icons.event_outlined : Icons.campaign_outlined,
            selectedIcon: isChef ? Icons.event : Icons.campaign,
            label: isChef ? 'Événements' : 'Annonces',
          ));
          visibility.add(true);
        } else {
          visibility.add(false);
        }

        // Branch 3: Bergers / Social
        if (isSuperAdmin) {
          destinations.add(const FireNavItem(
            icon: Icons.shield_outlined,
            selectedIcon: Icons.shield,
            label: 'Bergers',
          ));
          visibility.add(true);
        } else {
          destinations.add(const FireNavItem(
            icon: Icons.share_outlined,
            selectedIcon: Icons.share,
            label: 'Social',
          ));
          visibility.add(true);
        }

        // Branch 4: Finance / Profil
        if (isSuperAdmin) {
          destinations.add(const FireNavItem(
            icon: Icons.account_balance_wallet_outlined,
            selectedIcon: Icons.account_balance_wallet,
            label: 'Finance',
          ));
          visibility.add(true);
        } else {
          destinations.add(const FireNavItem(
            icon: Icons.person_outline,
            selectedIcon: Icons.person,
            label: 'Profil',
          ));
          visibility.add(true);
        }

        final int visibleIndex =
            _calculateSelectedIndex(navigationShell.currentIndex, visibility);

        return FireFloatingNavScaffold(
          body: navigationShell,
          navBar: FireFloatingNavBar(
            currentIndex: visibleIndex,
            onTap: (index) => _onItemTapped(index, navigationShell, visibility),
            items: destinations,
          ),
        );
      },
      loading: () =>
          const Scaffold(body: FireSkeletonDashboard()),
      error: (e, s) => const Scaffold(body: Center(child: Text('Impossible de charger la navigation'))),
    );
  }

  static int _calculateSelectedIndex(
      int currentBranchIndex, List<bool> visibility) {
    int visibleIndex = 0;
    for (int i = 0; i < currentBranchIndex; i++) {
      if (visibility[i]) visibleIndex++;
    }
    return visibleIndex;
  }

  void _onItemTapped(
      int visibleIndex, StatefulNavigationShell shell, List<bool> visibility) {
    int targetBranchIndex = -1;
    int count = 0;
    for (int i = 0; i < visibility.length; i++) {
      if (visibility[i]) {
        if (count == visibleIndex) {
          targetBranchIndex = i;
          break;
        }
        count++;
      }
    }

    if (targetBranchIndex != -1) {
      shell.goBranch(
        targetBranchIndex,
        initialLocation: targetBranchIndex == shell.currentIndex,
      );
    }
  }
}
