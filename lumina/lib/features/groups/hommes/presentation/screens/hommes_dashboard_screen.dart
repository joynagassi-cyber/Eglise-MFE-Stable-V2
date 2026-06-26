import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumina/core/router/app_routes.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lumina/features/groups/hommes/domain/entities/group_project.dart';
import 'package:lumina/features/groups/hommes/domain/entities/mentorship_pair.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import 'package:lumina/core/utils/haptic_helper.dart';
import 'package:lumina/core/widgets/widgets.dart';
import '../providers/hommes_providers.dart';
import 'package:lumina/features/groups/presentation/providers/group_providers.dart';
import 'package:lumina/features/auth/presentation/widgets/permission_guard.dart';
import 'package:lumina/core/auth/domain/entities/enums/permission.dart';

class HommesDashboardScreen extends ConsumerStatefulWidget {
  final String groupId;

  const HommesDashboardScreen({super.key, required this.groupId});

  @override
  ConsumerState<HommesDashboardScreen> createState() =>
      _HommesDashboardScreenState();
}

class _HommesDashboardScreenState extends ConsumerState<HommesDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final groupAsync = ref.watch(groupsProvider).whenData(
          (groups) => groups.firstWhere((g) => g.id == widget.groupId),
        );

    final dashboardKpiAsync =
        ref.watch(hommesDashboardProvider(widget.groupId));

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          _buildAppBar(context, groupAsync),
          SliverToBoxAdapter(
            child: _buildKpiSection(context, dashboardKpiAsync),
          ),
            SliverPersistentHeader(
            pinned: true,
            delegate: _SliverTabDelegate(
              TabBar(
                controller: _tabController,
                indicatorColor: context.colors.hommesColor,
                labelColor: context.colors.hommesColor,
                unselectedLabelColor: context.colors.textSecondary,
                indicatorWeight: 3,
                labelStyle: const TextStyle(
                  fontFamily: LuminaFont.body,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                tabs: const [
                  Tab(text: 'PROJETS'),
                  Tab(text: 'MENTORAT'),
                ],
              ),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _ProjectsTab(groupId: widget.groupId, accentColor: context.colors.hommesColor),
            _MentorshipTab(groupId: widget.groupId, accentColor: context.colors.hommesColor),
          ],
        ),
      ),
      floatingActionButton: PermissionGuard(
        permission: Permission.groupsEdit,
        child: FloatingActionButton(
          onPressed: () {
            HapticHelper.light();
            // Logic to add project or mentorship pair
          },
          backgroundColor: context.colors.hommesColor,
          elevation: 4,
          child: Icon(Icons.add, color: context.colors.textInverse),
        ).animate().scale(delay: 400.ms, curve: Curves.easeOutBack),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, AsyncValue groupAsync) {
    return SliverAppBar(
      expandedHeight: 220,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: context.colors.hommesGradient,
              ),
            ),
            Positioned(
              right: -30,
              bottom: -30,
              child: Icon(
                Icons.directions_run_rounded,
                size: 240,
                color: context.colors.textInverse.withValues(alpha: 0.1),
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
                        'GROUPE DES HOMMES',
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

  Widget _buildKpiSection(BuildContext context, AsyncValue dashboardKpi) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: dashboardKpi.when(
        data: (kpi) => Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _KpiCard(
                    title: 'Projets Actifs',
                    value:
                        '${kpi['total_projects'] - kpi['completed_projects']}',
                    subtitle: '${kpi['completed_projects']} terminés',
                    icon: Icons.assignment_rounded,
                    color: context.colors.hommesColor,
                  ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.1),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _KpiCard(
                    title: 'Mentorats',
                    value: '${kpi['active_mentorships']}',
                    subtitle: 'Total: ${kpi['total_mentorships']}',
                    icon: Icons.handshake_rounded,
                    color: context.colors.successText,
                  )
                      .animate()
                      .fadeIn(duration: 400.ms, delay: 100.ms)
                      .slideX(begin: 0.1),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            _BudgetOverviewCard(
              target: kpi['total_budget_target'],
              spent: kpi['total_spent'],
              execution: kpi['budget_execution'],
              color: context.colors.hommesColor,
            )
                .animate()
                .fadeIn(duration: 400.ms, delay: 200.ms)
                .slideY(begin: 0.1),
          ],
        ),
        loading: () => const _KpisLoading(),
        error: (e, _) => AppErrorWidget(message: e.toString()),
      ),
    );
  }
}

class _KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _KpiCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colors.bgCard,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: context.colors.borderSubtle.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.08),
            blurRadius: 12.0,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: LuminaIcon.sm),
          const SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              fontFamily: LuminaFont.display,
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontFamily: LuminaFont.body,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: context.colors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontFamily: LuminaFont.body,
              fontSize: 10,
              color: context.colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _BudgetOverviewCard extends StatelessWidget {
  final double target;
  final double spent;
  final double execution;
  final Color color;

  const _BudgetOverviewCard({
    required this.target,
    required this.spent,
    required this.execution,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.colors.bgCard,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: context.colors.borderSubtle.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Budget Global',
                    style: TextStyle(
                      fontFamily: LuminaFont.display,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: context.colors.textPrimary,
                    ),
                  ),
                  Text(
                    'Exécution: ${(execution * 100).toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontFamily: LuminaFont.body,
                      fontSize: 10,
                      color: context.colors.textSecondary,
                    ),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${spent.toStringAsFixed(0)} / ${target.toStringAsFixed(0)} FCFA',
                  style: TextStyle(
                    fontFamily: LuminaFont.body,
                    fontSize: 10,
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: AppProgressBar(
              value: execution.clamp(0.0, 1.0),
              backgroundColor: color.withValues(alpha: 0.1),
              color: color,
              height: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProjectsTab extends ConsumerWidget {
  final String groupId;
  final Color accentColor;
  const _ProjectsTab({required this.groupId, required this.accentColor});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsAsync = ref.watch(groupProjectsProvider(groupId));

    return projectsAsync.when(
      data: (projects) => projects.isEmpty
          ? _EmptyState(
              icon: Icons.assignment_outlined,
              message: 'Aucun projet en cours',
              color: accentColor)
          : ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: projects.length,
              itemBuilder: (context, index) {
                final project = projects[index];
                return _ProjectCard(project: project, color: accentColor)
                    .animate()
                    .fadeIn(delay: Duration(milliseconds: 100 * index))
                    .slideY(begin: 0.1);
              },
            ),
      loading: () => const Center(child: LoadingState()),
      error: (e, _) => AppErrorWidget(message: e.toString()),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final GroupProject project;
  final Color color;
  const _ProjectCard({required this.project, required this.color});

  @override
  Widget build(BuildContext context) {
    final progress = project.budgetTarget > 0
        ? (project.budgetSpent / project.budgetTarget)
        : 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colors.bgCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: context.colors.borderSubtle.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: color.withValues(alpha: 0.1),
                child:
                    Icon(Icons.rocket_launch_rounded, color: color, size: LuminaIcon.sm),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(project.title,
                        style: TextStyle(
                          fontFamily: LuminaFont.body,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: context.colors.textPrimary,
                        )),
                    if (project.description != null)
                      Text(
                        project.description!,
                        style: TextStyle(
                          fontFamily: LuminaFont.body,
                          fontSize: 10,
                          color: context.colors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              if (project.status == ProjectStatus.completed)
                Icon(Icons.check_circle_rounded,
                    color: context.colors.successText, size: LuminaIcon.sm),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Progression Budget', style: TextStyle(fontFamily: LuminaFont.body, fontSize: 10, color: context.colors.textSecondary)),
              Text('${(progress * 100).toStringAsFixed(0)}%',
                  style: TextStyle(fontFamily: LuminaFont.body, fontSize: 10, fontWeight: FontWeight.bold, color: context.colors.textPrimary)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: AppProgressBar(
              value: progress.toDouble(),
              backgroundColor: color.withValues(alpha: 0.05),
              color: color,
              height: 6,
            ),
          ),
        ],
      ),
    );
  }
}

class _MentorshipTab extends ConsumerWidget {
  final String groupId;
  final Color accentColor;
  const _MentorshipTab({required this.groupId, required this.accentColor});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pairsAsync = ref.watch(mentorshipPairsProvider(groupId));

    return pairsAsync.when(
      data: (pairs) => pairs.isEmpty
          ? _EmptyState(
              icon: Icons.handshake_outlined,
              message: 'Aucun binôme de mentorat',
              color: accentColor)
          : ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: pairs.length,
              itemBuilder: (context, index) {
                final pair = pairs[index];
                return _MentorshipCard(pair: pair, color: accentColor)
                    .animate()
                    .fadeIn(delay: Duration(milliseconds: 100 * index))
                    .slideY(begin: 0.1);
              },
            ),
      loading: () => const Center(child: LoadingState()),
      error: (e, _) => AppErrorWidget(message: e.toString()),
    );
  }
}

class _MentorshipCard extends StatelessWidget {
  final MentorshipPair pair;
  final Color color;
  const _MentorshipCard({required this.pair, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colors.bgCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: context.colors.borderSubtle.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          _UserAvatar(userId: pair.mentorId, label: 'Mentor'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Icon(Icons.arrow_forward_rounded,
                color: context.colors.textSecondary, size: LuminaIcon.xs),
          ),
          _UserAvatar(userId: pair.menteeId, label: 'Mentoré'),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: (pair.status == MentorshipStatus.active
                          ? context.colors.successText
                          : context.colors.errorText)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  pair.status == MentorshipStatus.active ? 'ACTIF' : 'INACTIF',
                  style: TextStyle(
                    fontFamily: LuminaFont.body,
                    fontSize: 10,
                    color: pair.status == MentorshipStatus.active
                        ? context.colors.successText
                        : context.colors.errorText,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Focus: Général',
                style: TextStyle(
                  fontFamily: LuminaFont.body,
                  fontSize: 10,
                  color: context.colors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  final String userId;
  final String label;
  const _UserAvatar({required this.userId, required this.label});

  @override
  Widget build(BuildContext context) {
    // In a real app we'd fetch the user profile. For now, mock avatar.
    return Column(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: context.colors.brandPrimary.withValues(alpha: 0.1),
          child: Icon(Icons.person_rounded, color: context.colors.brandPrimary),
        ),
        const SizedBox(height: 4),
        Text(label,
            style: TextStyle(fontFamily: LuminaFont.body, fontSize: 10, fontWeight: FontWeight.bold, color: context.colors.textSecondary)),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  final Color color;
  const _EmptyState(
      {required this.icon, required this.message, required this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: LuminaIcon.xl, color: color.withValues(alpha: 0.2)),
          const SizedBox(height: 16),
          Text(message,
              style: TextStyle(fontFamily: LuminaFont.body, fontSize: 14, color: context.colors.textSecondary)),
        ],
      ),
    );
  }
}

class _KpisLoading extends StatelessWidget {
  const _KpisLoading();
  @override
  Widget build(BuildContext context) => const ShimmerBox(height: 250);
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
      color: context.colors.bgPage,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabDelegate oldDelegate) => false;
}
