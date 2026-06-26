import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';
import 'package:go_router/go_router.dart';
import 'package:lumina/core/router/app_routes.dart';
import 'package:lumina/core/widgets/widgets.dart';
import '../providers/intercession_providers.dart';
import '../widgets/prayer_vigils_list.dart';
import '../widgets/prayer_subjects_list.dart';
import '../widgets/intercession_stats_chart.dart';

class IntercessionDashboardScreen extends ConsumerStatefulWidget {
  final String groupId;
  const IntercessionDashboardScreen({super.key, required this.groupId});

  @override
  ConsumerState<IntercessionDashboardScreen> createState() =>
      _IntercessionDashboardScreenState();
}

class _IntercessionDashboardScreenState
    extends ConsumerState<IntercessionDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final kpisAsync =
        ref.watch(intercessionKpisNotifierProvider(widget.groupId));

    return Scaffold(
      backgroundColor: context.colors.bgPage,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildKpiHeader(kpisAsync),
                  const SizedBox(height: 24),
                  TabBar(
                    controller: _tabController,
                    labelColor: context.colors.intercessionColor,
                    unselectedLabelColor: context.colors.textSecondary,
                    indicatorColor: context.colors.intercessionColor,
                    dividerColor: Colors.transparent,
                    tabs: const [
                      Tab(text: 'Veillées', icon: Icon(Icons.nightlight_round)),
                      Tab(text: 'Sujets', icon: Icon(Icons.list_alt_rounded)),
                      Tab(text: 'Stats', icon: Icon(Icons.analytics_rounded)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 600,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        PrayerVigilsList(groupId: widget.groupId),
                        PrayerSubjectsList(groupId: widget.groupId),
                        IntercessionStatsChart(groupId: widget.groupId),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddAction(context),
        backgroundColor: context.colors.intercessionColor,
        icon: Icon(Icons.add_task, color: context.colors.textInverse),
        label: Text('Nouvelle Action', style: TextStyle(color: context.colors.textInverse, fontFamily: LuminaFont.body)),
      ).animate().scale(delay: 500.ms),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'Intercession',
          style: TextStyle(
            fontFamily: LuminaFont.display,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: context.colors.textInverse,
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: context.colors.intercessionGradient,
              ),
            ),
            Positioned(
              right: -30,
              top: -30,
              child: Icon(
                Icons.volunteer_activism_rounded,
                size: 200,
                color: context.colors.textInverse.withValues(alpha: 0.1),
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.person_add_alt_1_rounded,
              color: context.colors.textInverse),
          tooltip: 'Demandes',
          onPressed: () => context.push(
            AppRoutes.groupDashboardJoinRequestsWithId(widget.groupId),
          ),
        ),
      ],
    );
  }

  Widget _buildKpiHeader(AsyncValue<Map<String, dynamic>> kpisAsync) {
    return kpisAsync.when(
      data: (kpis) => Row(
        children: [
          Expanded(
            child: _KpiCard(
              title: 'Veillées',
              value: '${kpis['totalVigils']}',
              icon: Icons.nightlight_outlined,
              color: context.colors.intercessionColor,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _KpiCard(
              title: 'Sujets Actifs',
              value: '${kpis['activeSubjects']}',
              icon: Icons.auto_stories_outlined,
              color: context.colors.brandPrimary,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _KpiCard(
              title: 'Participants',
              value: '${kpis['totalParticipants']}',
              icon: Icons.groups_rounded,
              color: context.colors.hommesColor,
            ),
          ),
        ],
      ),
      loading: () => const AppProgressBar(),
      error: (e, _) => Text('Error: $e'),
    );
  }

  void _showAddAction(BuildContext context) {
    // Show bottom sheet to choose between Vigil or Subject
  }
}

class _KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _KpiCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          decoration: BoxDecoration(
            color: context.colors.bgCard,
            border: Border.all(color: color.withValues(alpha: 0.2)),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: LuminaIcon.md),
              const SizedBox(height: 8),
              Text(value, style: TextStyle(fontFamily: LuminaFont.display, fontSize: 18, color: color, fontWeight: FontWeight.bold)),
              Text(
                title,
                style: TextStyle(fontFamily: LuminaFont.body, fontSize: 10, color: context.colors.textSecondary),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn().slideY(begin: 0.2);
  }
}
