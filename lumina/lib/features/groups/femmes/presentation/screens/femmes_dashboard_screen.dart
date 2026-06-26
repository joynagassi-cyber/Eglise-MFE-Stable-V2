import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumina/core/router/app_routes.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import 'package:lumina/core/widgets/widgets.dart';
import 'package:lumina/core/utils/haptic_helper.dart';
import '../providers/femmes_providers.dart';
import 'package:lumina/features/groups/presentation/providers/group_providers.dart';

// Modular Widgets
import '../widgets/kpi_card.dart';
import '../widgets/activities_tab.dart';
import '../widgets/trainings_tab.dart';
import '../widgets/mutual_aid_tab.dart';
import '../widgets/celebrations_tab.dart';

class FemmesDashboardScreen extends ConsumerStatefulWidget {
  final String groupId;

  const FemmesDashboardScreen({super.key, required this.groupId});

  @override
  ConsumerState<FemmesDashboardScreen> createState() => _FemmesDashboardScreenState();
}

class _FemmesDashboardScreenState extends ConsumerState<FemmesDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final groupAsync = ref.watch(groupsProvider).whenData(
          (groups) => groups.firstWhere((g) => g.id == widget.groupId),
        );

    final dashboardKpiAsync =
        ref.watch(femmesDashboardProvider(widget.groupId));

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: context.colors.bgPage,
        ),
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            buildAppBar(context, groupAsync),
            SliverToBoxAdapter(
              child: buildQuickActions(context),
            ),
            SliverToBoxAdapter(
              child: buildKpiSection(context, dashboardKpiAsync),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverTabDelegate(
                TabBar(
                  controller: tabController,
                  isScrollable: true,
                  indicatorColor: context.colors.femmesColor,
                  labelColor: context.colors.femmesColor,
                  unselectedLabelColor: context.colors.textSecondary,
                  indicatorWeight: 3,
                  labelStyle: const TextStyle(
                    fontFamily: LuminaFont.body,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  tabs: const [
                    Tab(text: 'ACTIVITÉS'),
                    Tab(text: 'FORMATIONS'),
                    Tab(text: 'ENTRAIDE'),
                    Tab(text: 'CÉLÉBRATIONS'),
                  ],
                ),
              ),
            ),
          ],
          body: TabBarView(
            controller: tabController,
            children: [
              ActivitiesTab(groupId: widget.groupId, accentColor: context.colors.femmesColor),
              TrainingsTab(
                  groupId: widget.groupId, accentColor: context.colors.brandPrimary),
              MutualAidTab(groupId: widget.groupId, accentColor: context.colors.enfantsColor),
              CelebrationsTab(
                  groupId: widget.groupId, accentColor: context.colors.femmesColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAppBar(BuildContext context, AsyncValue groupAsync) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: context.colors.femmesGradient,
              ),
            ),
            Positioned(
              right: -20,
              bottom: -20,
              child: Icon(
                Icons.auto_awesome_rounded,
                size: 180,
                color: context.colors.textInverse.withValues(alpha: 0.15),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: context.colors.textInverse.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'MINISTÈRE DES FEMMES',
                        style: TextStyle(
                          fontFamily: LuminaFont.display,
                          fontSize: 10,
                          color: context.colors.textInverse,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    groupAsync.when(
                      data: (group) => Text(
                        group.name,
                        style: TextStyle(
                          fontFamily: LuminaFont.display,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: context.colors.textInverse,
                        ),
                      ),
                      loading: () => const ShimmerText(width: 150, height: 30),
                      error: (_, __) => Text('...',
                          style: TextStyle(color: context.colors.textInverse, fontFamily: LuminaFont.body)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: context.colors.textInverse.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.arrow_back_ios_new_rounded,
              color: context.colors.textInverse, size: LuminaIcon.sm),
        ),
        onPressed: () => context.pop(),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.person_add_alt_1_rounded, color: context.colors.textInverse),
          tooltip: 'Demandes',
          onPressed: () => context.push(
            AppRoutes.groupDashboardJoinRequestsWithId(widget.groupId),
          ),
        ),
      ],
    );
  }

  Widget buildQuickActions(BuildContext context) {
    final actions = [
      {
        'icon': Icons.fact_check_rounded,
        'label': 'Présences',
        'color': context.colors.infoText
      },
      {
        'icon': Icons.event_rounded,
        'label': 'Événement',
        'color': context.colors.brandPrimary
      },
      {'icon': Icons.group_rounded, 'label': 'Contacter', 'color': context.colors.successText},
      {
        'icon': Icons.bar_chart_rounded,
        'label': 'Rapport',
        'color': context.colors.enfantsColor
      },
      {
        'icon': Icons.celebration_rounded,
        'label': 'Célébration',
        'color': context.colors.femmesColor
      },
      {
        'icon': Icons.school_rounded,
        'label': 'Formation',
        'color': context.colors.brandSecondary
      },
      {
        'icon': Icons.handshake_rounded,
        'label': 'Entraide',
        'color': context.colors.successText
      },
    ];

    return Container(
      height: 110,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        itemCount: actions.length,
        itemBuilder: (context, index) {
          final action = actions[index];
          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.md),
            child: Column(
              children: [
                InkWell(
                  onTap: () async {
                    await HapticHelper.light();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Fonctionnalité en cours de développement')),
                      );
                    }
                  },
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: (action['color'] as Color).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: (action['color'] as Color)
                              .withValues(alpha: 0.2)),
                    ),
                    child: Icon(action['icon'] as IconData,
                        color: action['color'] as Color),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  action['label'] as String,
                  style: TextStyle(
                    fontFamily: LuminaFont.body,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
            )
                .animate()
                .fadeIn(delay: (50 * index).ms)
                .scale(delay: (50 * index).ms),
          );
        },
      ),
    );
  }

  Widget buildKpiSection(BuildContext context, AsyncValue dashboardKpi) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: dashboardKpi.when(
        data: (kpi) => Row(
          children: [
            Expanded(
              child: KpiCard(
                title: 'Demandes Actives',
                value: '${kpi['active_requests']}',
                subtitle: '${kpi['responses_this_month']} ce mois',
                icon: Icons.volunteer_activism_rounded,
                color: context.colors.femmesColor,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: KpiCard(
                title: 'Anniversaires',
                value: '${kpi['birthdays_count']}',
                subtitle: 'Membres ce mois',
                icon: Icons.cake_rounded,
                color: context.colors.enfantsColor,
              ),
            ),
          ],
        ),
        loading: () => const ShimmerBox(height: 120),
        error: (e, _) => AppErrorWidget(message: e.toString()),
      ),
    );
  }
}

class _SliverTabDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  _SliverTabDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: context.colors.bgPage.withValues(alpha: 0.95),
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabDelegate oldDelegate) => false;
}
