import "package:lumina/core/widgets/widgets.dart";
import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumina/core/router/app_routes.dart';
import 'package:lumina/l10n/app_localizations.dart';
import '../../../../core/widgets/loading_state.dart';
import '../../../../core/auth/domain/entities/user_context.dart';
import '../../common/widgets/events_section.dart';
import '../../common/widgets/finance_section.dart';
import '../../common/widgets/members_section.dart';
import '../../presentation/widgets/group_dashboard_scaffold.dart';
import 'package:lumina/core/providers/user_context_provider.dart';
import '../../common/providers/group_dashboard_controller.dart';
import 'package:lumina/features/groups/presentation/providers/group_providers.dart';
import 'package:lumina/features/groups/domain/entities/group.dart';
import 'package:lumina/features/dashboard/presentation/widgets/quick_action_button.dart';
import 'package:lumina/core/theme/app_typography.dart';
import 'package:lumina/core/utils/haptic_helper.dart';

class GenericGroupDashboardScreen extends ConsumerWidget {
  final String dashboardType;

  const GenericGroupDashboardScreen({
    super.key,
    this.dashboardType = 'generic',
  });

  void _showComingSoon(BuildContext context) async {
    await HapticHelper.light();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Fonctionnalité bientôt disponible',
            style: AppTypography.bodyMedium.copyWith(color: context.colors.textOnBrand),
          ),
          backgroundColor: context.colors.brandPrimary,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userContext = ref.watch(userContextNotifierProvider).value;
    final groupsAsync = ref.watch(groupsProvider);
    final groupId = _resolveGroupId(
      groupsAsync: groupsAsync,
      userContext: userContext,
      dashboardType: dashboardType,
    );
    if (userContext == null || groupId == null) {
      return Scaffold(body: LoadingState());
    }

    final dashboardData = ref.watch(groupDashboardControllerProvider(groupId));
    final config = _getDashboardConfig(context, dashboardType);

    final List<QuickActionButton> activeActions = List.from(config.actions);

    return GroupDashboardScaffold(
      title: config.title,
      subtitle: config.subtitle,
      dashboardData: dashboardData,
      onRefresh: () {
        ref.invalidate(groupDashboardControllerProvider(groupId));
      },
      quickActions: activeActions,
      extraContent: dashboardData.maybeWhen(
        data: (data) => Column(
          children: [
            if (data['transactions'] != null)
              FinanceSection(
                recentTransactions: data['transactions'],
                onCreateExpense: () =>
                    context.push(AppRoutes.groupDashboardFinanceWithType(dashboardType)),
              ),
            SizedBox(height: 24),
            if (data['events'] != null)
              EventsSection(
                upcomingEvents: data['events'],
                onAddEvent: () =>
                    context.push(AppRoutes.groupDashboardNewEventWithType(dashboardType)),
              ),
            SizedBox(height: 24),
            if (data['members'] != null)
              MembersSection(groupMembers: data['members'] ?? []),
          ],
        ),
        orElse: () => const SizedBox.shrink(),
      ),
    );
  }

  String? _resolveGroupId({
    required AsyncValue<List<Group>> groupsAsync,
    required UserContext? userContext,
    required String dashboardType,
  }) {
    final groups = groupsAsync.valueOrNull;
    final candidates = <String?>[
      dashboardType,
      userContext?.group?.code,
      userContext?.group?.label,
    ];

    if (groups != null) {
      for (final candidate in candidates) {
        if (candidate == null || candidate.isEmpty) continue;

        for (final group in groups) {
          if (group.id == candidate ||
              group.type.name == candidate ||
              group.name.toLowerCase() == candidate.toLowerCase()) {
            return group.id;
          }
        }
      }
    }

    if (dashboardType.isNotEmpty && dashboardType != 'generic') {
      return dashboardType;
    }

    return null;
  }

  _DashboardConfig _getDashboardConfig(BuildContext context, String type) {
    final l10n = AppLocalizations.of(context)!;

    switch (type) {
      case 'chorale':
        return _DashboardConfig(
          title: 'Dashboard Chorale',
          subtitle: 'Louange et Adoration',
          actions: [
            QuickActionButton(
              label: 'Répétition',
              icon: Icons.music_note,
              color: context.colors.brandPrimary,
              onTap: () => context.push(AppRoutes.groupDashboardEventsWithType('chorale')),
            ),
            QuickActionButton(
              label: 'Dépense',
              icon: Icons.add_shopping_cart,
              color: context.colors.brandSecondary,
              onTap: () => context.push(AppRoutes.groupDashboardFinanceWithType('chorale')),
            ),
            QuickActionButton(
              label: 'Rapport',
              icon: Icons.assessment,
              color: context.colors.brandSecondary,
              onTap: () => context.push(AppRoutes.groupDashboardFinanceWithType('chorale')),
            ),
          ],
        );
      case 'jeunesse':
        return _DashboardConfig(
          title: 'Dashboard Jeunesse',
          subtitle: 'Génération de Feu',
          actions: [
            QuickActionButton(
              label: 'Activité',
              icon: Icons.local_activity,
              color: context.colors.brandPrimary,
              onTap: () => context.push(AppRoutes.groupDashboardEventsWithType('jeunesse')),
            ),
            QuickActionButton(
              label: 'Budget',
              icon: Icons.attach_money,
              color: context.colors.brandSecondary,
              onTap: () => context.push(AppRoutes.groupDashboardFinanceWithType('jeunesse')),
            ),
            QuickActionButton(
              label: 'Membres',
              icon: Icons.group,
              color: context.colors.brandSecondary,
              onTap: () => context.push(AppRoutes.groupDashboardMembersWithType('jeunesse')),
            ),
          ],
        );
      case 'femmes':
        return _DashboardConfig(
          title: 'Dashboard Femmes',
          subtitle: 'Dames de Valeur',
          actions: [
            QuickActionButton(
              label: 'Réunion',
              icon: Icons.group_work,
              color: context.colors.brandPrimary,
              onTap: () => context.push(AppRoutes.groupDashboardEventsWithType('femmes')),
            ),
            QuickActionButton(
              label: 'Caisse',
              icon: Icons.savings,
              color: context.colors.brandSecondary,
              onTap: () => context.push(AppRoutes.groupDashboardFinanceWithType('femmes')),
            ),
            QuickActionButton(
              label: 'Entraide',
              icon: Icons.volunteer_activism,
              color: context.colors.brandSecondary,
              onTap: () => context.push(AppRoutes.groupDashboardMembersWithType('femmes')),
            ),
          ],
        );
      case 'hommes':
        return _DashboardConfig(
          title: 'Dashboard Hommes',
          subtitle: 'Hommes d\'Honneur',
          actions: [
            QuickActionButton(
              label: 'Réunion',
              icon: Icons.handshake,
              color: context.colors.brandPrimary,
              onTap: () => context.push(AppRoutes.groupDashboardEventsWithType('hommes')),
            ),
            QuickActionButton(
              label: 'Projets',
              icon: Icons.construction,
              color: context.colors.brandSecondary,
              onTap: () => context.push(AppRoutes.groupDashboardFinanceWithType('hommes')),
            ),
            QuickActionButton(
              label: 'Membres',
              icon: Icons.group,
              color: context.colors.brandSecondary,
              onTap: () => context.push(AppRoutes.groupDashboardMembersWithType('hommes')),
            ),
          ],
        );
      case 'enfants':
        return _DashboardConfig(
          title: 'Ecodim',
          subtitle: 'Education Chrétienne',
          actions: [
            QuickActionButton(
              label: 'Leçon',
              icon: Icons.book,
              color: context.colors.brandPrimary,
              onTap: () => context.push(AppRoutes.groupDashboardEventsWithType('enfants')),
            ),
            QuickActionButton(
              label: 'Goûter',
              icon: Icons.fastfood,
              color: context.colors.brandSecondary,
              onTap: () => context.push(AppRoutes.groupDashboardFinanceWithType('enfants')),
            ),
            QuickActionButton(
              label: 'Présence',
              icon: Icons.checklist,
              color: context.colors.brandSecondary,
              onTap: () => context.push(AppRoutes.groupDashboardEventsWithType('enfants')),
            ),
          ],
        );
      case 'intercession':
        return _DashboardConfig(
          title: 'Dashboard Intercession',
          subtitle: 'Prière et Intercession',
          actions: [
            QuickActionButton(
              label: 'Sujet de prière',
              icon: Icons.front_hand,
              color: context.colors.brandPrimary,
              onTap: () => context.push(AppRoutes.groupDashboardEventsWithType('intercession')),
            ),
            QuickActionButton(
              label: 'Veillée',
              icon: Icons.nightlight_round,
              color: context.colors.brandSecondary,
              onTap: () => context.push(AppRoutes.groupDashboardEventsWithType('intercession')),
            ),
            QuickActionButton(
              label: 'Rapport',
              icon: Icons.assessment,
              color: context.colors.brandSecondary,
              onTap: () => context.push(AppRoutes.groupDashboardFinanceWithType('intercession')),
            ),
          ],
        );
      case 'organisation':
        return _DashboardConfig(
          title: 'Dashboard Organisation',
          subtitle: 'Logistique et Organisation',
          actions: [
            QuickActionButton(
              label: 'Nouvel Événement',
              icon: Icons.event,
              color: context.colors.brandPrimary,
              onTap: () => _showComingSoon(context),
            ),
            QuickActionButton(
              label: 'Budget Événement',
              icon: Icons.account_balance,
              color: context.colors.brandSecondary,
              onTap: () => _showComingSoon(context),
            ),
            QuickActionButton(
              label: 'Rapport',
              icon: Icons.assessment,
              color: context.colors.brandSecondary,
              onTap: () => _showComingSoon(context),
            ),
          ],
        );
      case 'missions':
        return _DashboardConfig(
          title: 'Dashboard Missions',
          subtitle: 'Évangélisation et Missions',
          actions: [
            QuickActionButton(
              label: 'Nouvelle Mission',
              icon: Icons.public,
              color: context.colors.brandPrimary,
              onTap: () => _showComingSoon(context),
            ),
            QuickActionButton(
              label: 'Évangélisation',
              icon: Icons.record_voice_over,
              color: context.colors.brandSecondary,
              onTap: () => _showComingSoon(context),
            ),
            QuickActionButton(
              label: 'Rapport',
              icon: Icons.assessment,
              color: context.colors.brandSecondary,
              onTap: () => _showComingSoon(context),
            ),
          ],
        );
      case 'budget_event':
        return _DashboardConfig(
          title: 'Budget Événement',
          subtitle: 'Comité Budget & Événementiel',
          actions: [
            QuickActionButton(
              label: 'Budget Prévisionnel',
              icon: Icons.calculate,
              color: context.colors.brandPrimary,
              onTap: () => _showComingSoon(context),
            ),
            QuickActionButton(
              label: 'Dépense Spéciale',
              icon: Icons.monetization_on,
              color: context.colors.brandSecondary,
              onTap: () => _showComingSoon(context),
            ),
            QuickActionButton(
              label: 'Rapport',
              icon: Icons.assessment,
              color: context.colors.brandSecondary,
              onTap: () => _showComingSoon(context),
            ),
          ],
        );
      default:
        return _DashboardConfig(
          title: l10n.groupDashboard,
          subtitle: l10n.membersArea,
          actions: [
            QuickActionButton(
              label: l10n.activities,
              icon: Icons.bolt,
              color: context.colors.brandPrimary,
              onTap: () => context.push(AppRoutes.groupDashboardEventsWithType(type)),
            ),
            QuickActionButton(
              label: l10n.expenses,
              icon: Icons.payments,
              color: context.colors.brandSecondary,
              onTap: () => context.push(AppRoutes.groupDashboardFinanceWithType(type)),
            ),
            QuickActionButton(
              label: l10n.reports,
              icon: Icons.assessment,
              color: context.colors.brandSecondary,
              onTap: () => context.push(AppRoutes.groupDashboardDocumentsWithType(type)),
            ),
          ],
        );
    }
  }
}

class _DashboardConfig {
  final String title;
  final String subtitle;
  final List<QuickActionButton> actions;

  _DashboardConfig({
    required this.title,
    required this.subtitle,
    required this.actions,
  });
}
