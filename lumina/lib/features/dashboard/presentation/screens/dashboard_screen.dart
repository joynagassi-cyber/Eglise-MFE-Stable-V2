import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumina/core/widgets/lumina_page.dart';
import 'package:lumina/core/widgets/main_drawer.dart';
import 'package:lumina/core/providers/user_context_provider.dart';
import '../widgets/group_dashboard_view.dart';
import '../widgets/member_dashboard_view.dart';
import '../widgets/superadmin_dashboard_view.dart';
import '../../../../core/auth/domain/entities/enums/role_level.dart';
import '../../../../core/auth/domain/entities/user_context.dart';
import '../providers/dashboard_kpi_provider.dart';
import '../providers/dashboard_modules_provider.dart';
import 'package:lumina/core/widgets/widgets.dart';
import 'package:lumina/core/widgets/lumina_coach_mark.dart';
import 'package:lumina/core/services/tutorial_service.dart';
import '../../../../core/extensions/context_extension.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  final GlobalKey _kpiCardsKey = GlobalKey();

  final GlobalKey _notificationsKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initTutorialIfNeeded();
    });
  }

  Future<void> _initTutorialIfNeeded() async {
    final tutorialServiceAsync = await ref.read(tutorialServiceProvider.future);
    if (!tutorialServiceAsync.hasSeenTutorial()) {
      _showDashboardTutorial();
    }
  }

  void _showDashboardTutorial() {
    LuminaCoachMark.show(
      context,
      targets: [
        LuminaCoachMark.target(
          key: _kpiCardsKey,
          identify: "stats",
          title: "Indicateurs",
          description: "Retrouvez vos chiffres clés en un clin d'œil.",
          step: 1,
          total: 3,
        ),
      ],
      onFinish: () async {
        final service = await ref.read(tutorialServiceProvider.future);
        await service.markTutorialAsSeen();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userContextAsync = ref.watch(userContextNotifierProvider);

    return userContextAsync.when(
      data: (userContext) {
        if (userContext == null) return const LuminaPage(body: Center(child: Text('Non connecté')));
        final type = _getDashboardType(userContext);
        return LuminaPage(
          title: "Lumina",
          drawer: const MainDrawer(),
          showBackButton: false,
          actions: [
            Semantics(
              label: 'Notifications',
              button: true,
              child: Tooltip(
                message: 'Notifications',
                child: IconButton(
                  key: _notificationsKey,
                  icon: Icon(Icons.notifications_none_rounded, color: context.colors.textSecondary),
                  onPressed: () {},
                ),
              ),
            ),
          ],
          onRefresh: () async {
            ref.invalidate(dashboardKpiProvider);
            ref.invalidate(dashboardModulesProvider);
          },
          body: _buildContent(type),
        );
      },
      loading: () => const LuminaPage(body: DashboardSkeleton()),
      error: (e, st) => LuminaPage(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline_rounded, size: 64, color: context.colors.errorText.withValues(alpha: 0.6)),
                SizedBox(height: 16),
                Text(
                  'Impossible de charger votre espace',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: context.colors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'Veuillez vérifier votre connexion et réessayer.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: context.colors.textTertiary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => ref.invalidate(userContextNotifierProvider),
                  icon: Icon(Icons.refresh_rounded),
                  label: Text('Réessayer'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  DashboardType _getDashboardType(UserContext userContext) {
    if (userContext.isSuperAdmin) return DashboardType.superadmin;
    if (userContext.role.level == RoleLevel.groupLeader || userContext.role.level == RoleLevel.staff) {
      return DashboardType.group;
    }
    return DashboardType.member;
  }

  Widget _buildContent(DashboardType type) {
    return switch (type) {
      DashboardType.superadmin => const SuperadminDashboardView(),
      DashboardType.group => const GroupDashboardView(),
      DashboardType.member => const MemberDashboardView(),
    };
  }
}

enum DashboardType { member, group, superadmin }
