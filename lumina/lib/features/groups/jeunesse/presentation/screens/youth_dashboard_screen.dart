import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:lumina/core/router/app_routes.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import 'package:lumina/core/utils/haptic_helper.dart';
import 'package:lumina/core/widgets/widgets.dart';
import '../providers/youth_providers.dart';
import 'package:lumina/features/groups/presentation/providers/group_providers.dart';
import 'package:lumina/features/auth/presentation/widgets/permission_guard.dart';
import 'package:lumina/core/auth/domain/entities/enums/permission.dart';

class YouthDashboardScreen extends ConsumerStatefulWidget {
  final String groupId;

  const YouthDashboardScreen({super.key, required this.groupId});

  @override
  ConsumerState<YouthDashboardScreen> createState() =>
      _YouthDashboardScreenState();
}

class _YouthDashboardScreenState extends ConsumerState<YouthDashboardScreen> {
  late final Color _primaryColor;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _primaryColor = context.colors.jeunesseColor;
  }

  @override
  Widget build(BuildContext context) {
    final groupAsync = ref.watch(groupsProvider).whenData(
          (groups) => groups.firstWhere((g) => g.id == widget.groupId),
        );

    final dashboardKpiAsync = ref.watch(youthDashboardProvider(widget.groupId));

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(youthDashboardProvider(widget.groupId));
          ref.invalidate(campsProvider(widget.groupId));
          ref.invalidate(discipleshipProgramsProvider(widget.groupId));
        },
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildAppBar(context, groupAsync),
            SliverToBoxAdapter(
              child: _buildKpiSection(context, dashboardKpiAsync),
            ),
            SliverToBoxAdapter(
              child: _buildChartsSection(context, dashboardKpiAsync),
            ),
            SliverToBoxAdapter(
              child: _buildQuickActionsSection(context),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
      floatingActionButton: PermissionGuard(
        permission: Permission.groupsEdit,
        child: FloatingActionButton.extended(
          onPressed: () {
            HapticHelper.light();
            // Action to create camp or discipleship
          },
          backgroundColor: _primaryColor,
          icon: Icon(Icons.add_rounded, color: context.colors.iconOnBrand),
          label: Text('NOUVEL ÉVÉNEMENT',
              style:
                  TextStyle(color: context.colors.textOnBrand, fontWeight: FontWeight.bold)),
        ).animate().scale(delay: 500.ms, curve: Curves.easeOutBack),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, AsyncValue groupAsync) {
    return SliverAppBar(
      expandedHeight: 240,
      pinned: true,
      stretch: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [
          StretchMode.zoomBackground,
          StretchMode.blurBackground
        ],
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: context.colors.jeunesseGradient,
              ),
            ),
            Positioned(
              right: -50,
              top: -20,
              child: Icon(
                Icons.rocket_launch_rounded,
                size: 280,
                color: context.colors.textInverse.withValues(alpha: 0.1),
              )
                  .animate(onPlay: (c) => c.repeat())
                  .shimmer(duration: 3.seconds, color: context.colors.textInverse.withValues(alpha: 0.24)),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: context.colors.textOnBrand.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: context.colors.textOnBrand.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.flash_on_rounded,
                              color: context.colors.brandSecondary, size: 14),
                          const SizedBox(width: 6),
                          Text(
                            'DASHBOARD JEUNESSE',
                            style: TextStyle(
                              fontFamily: LuminaFont.display,
                              fontSize: 10,
                              color: context.colors.textInverse,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    groupAsync.when(
                      data: (group) => Text(
                        group.name,
                        style: TextStyle(
                          fontFamily: LuminaFont.display,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: context.colors.textInverse,
                        ),
                      ),
                      loading: () => const ShimmerBox(width: 200, height: 40),
                      error: (_, __) => Text('Vague de Jeunesse',
                          style: TextStyle(color: context.colors.textOnBrand)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Prêt à impacter cette génération ?',
                      style: TextStyle(
                        fontFamily: LuminaFont.body,
                        fontSize: 14,
                        color: context.colors.textInverse.withValues(alpha: 0.7),
                      ),
                    ).animate().fadeIn(delay: 200.ms),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: context.colors.textOnBrand.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.arrow_back_ios_new_rounded,
              color: context.colors.textInverse, size: LuminaIcon.sm),
        ),
        onPressed: () => context.pop(),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.person_add_alt_1_rounded,
              color: context.colors.iconOnBrand),
          tooltip: 'Demandes',
          onPressed: () => context.push(
            AppRoutes.groupDashboardJoinRequestsWithId(widget.groupId),
          ),
        ),
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: context.colors.textOnBrand.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.notifications_none_rounded,
                color: context.colors.iconOnBrand),
          ),
          onPressed: () async {
            await HapticHelper.medium();
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notifications : Bientôt disponible')),
              );
            }
          },
        ),
        const SizedBox(width: 8),
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
                    title: 'Membre Actifs',
                    value: '124', // Idéalement viendrait du groupAsync
                    subtitle: '+12% ce mois',
                    icon: Icons.people_alt_rounded,
                    color: _primaryColor,
                  ).animate().fadeIn(duration: 400.ms).scale(),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _KpiCard(
                    title: 'Camps Prévus',
                    value: '${kpi['planned_camps']}',
                    subtitle: 'Total: ${kpi['total_camps']}',
                    icon: Icons.terrain_rounded,
                    color: context.colors.successText,
                  ).animate().fadeIn(duration: 400.ms, delay: 100.ms).scale(),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: _KpiCard(
                    title: 'Discipulat',
                    value: '${kpi['active_discipleships']}',
                    subtitle:
                        'Progression: ${(kpi['average_discipleship_progress'] as double).toStringAsFixed(0)}%',
                    icon: Icons.auto_graph_rounded,
                    color: context.colors.brandPrimary,
                  ).animate().fadeIn(duration: 400.ms, delay: 200.ms).scale(),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _KpiCard(
                    title: 'Budget Camp',
                    value:
                        '${(kpi['total_budget_actual'] / 1000).toStringAsFixed(0)}k',
                    subtitle:
                        'Objectif: ${(kpi['total_budget_target'] / 1000).toStringAsFixed(0)}k',
                    icon: Icons.account_balance_wallet_rounded,
                    color: context.colors.enfantsColor,
                  ).animate().fadeIn(duration: 400.ms, delay: 300.ms).scale(),
                ),
              ],
            ),
          ],
        ),
        loading: () => const _KpisLoading(),
        error: (e, _) => AppErrorWidget(message: e.toString()),
      ),
    );
  }

  Widget _buildChartsSection(BuildContext context, AsyncValue dashboardKpi) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ANALYTIQUES D\'IMPACT',
            style: TextStyle(
              fontFamily: LuminaFont.display,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: context.colors.textSecondary,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          dashboardKpi.when(
            data: (kpi) => Row(
              children: [
                Expanded(
                  child: GlassCard(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      children: [
                        Text('Engagement Mensuel',
                            style: TextStyle(fontFamily: LuminaFont.body, fontSize: 10, color: context.colors.textSecondary)),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 120,
                          child: LineChart(
                            LineChartData(
                              gridData: const FlGridData(show: false),
                              titlesData: const FlTitlesData(show: false),
                              borderData: FlBorderData(show: false),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: const [
                                    FlSpot(0, 3),
                                    FlSpot(1, 4),
                                    FlSpot(2, 3.5),
                                    FlSpot(3, 5),
                                    FlSpot(4, 4.5),
                                    FlSpot(5, 6),
                                  ],
                                  isCurved: true,
                                  color: context.colors.brandPrimary,
                                  barWidth: 3,
                                  isStrokeCapRound: true,
                                  dotData: const FlDotData(show: false),
                                  belowBarData: BarAreaData(
                                    show: true,
                                    color: context.colors.brandPrimary.withValues(alpha: 0.1),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: GlassCard(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      children: [
                        Text('Croissance Spirituelle',
                            style: TextStyle(fontFamily: LuminaFont.body, fontSize: 10, color: context.colors.textSecondary)),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 120,
                          child: BarChart(
                            BarChartData(
                              gridData: const FlGridData(show: false),
                              titlesData: const FlTitlesData(show: false),
                              borderData: FlBorderData(show: false),
                              barGroups: [
                                BarChartGroupData(x: 0, barRods: [
                                  BarChartRodData(
                                      toY: 8, color: context.colors.brandPrimary)
                                ]),
                                BarChartGroupData(x: 1, barRods: [
                                  BarChartRodData(
                                      toY: 10, color: context.colors.brandPrimary)
                                ]),
                                BarChartGroupData(x: 2, barRods: [
                                  BarChartRodData(
                                      toY: 14, color: context.colors.brandPrimary)
                                ]),
                                BarChartGroupData(x: 3, barRods: [
                                  BarChartRodData(
                                      toY: 15, color: context.colors.brandPrimary)
                                ]),
                                BarChartGroupData(x: 4, barRods: [
                                  BarChartRodData(
                                      toY: 13, color: context.colors.brandPrimary)
                                ]),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ).animate().slideY(begin: 0.1, duration: 600.ms),
            loading: () => const ShimmerBox(height: 160),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ACTIONS RAPIDES',
            style: TextStyle(
              fontFamily: LuminaFont.display,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: context.colors.textSecondary,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _QuickActionItem(
            title: 'Camps & Événements',
            subtitle: 'Gérer les retraites et sorties',
            icon: Icons.terrain_rounded,
            color: context.colors.successText,
            onTap: () async {
              await HapticHelper.medium();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Camps & Événements : Bientôt disponible')),
                );
              }
            },
          ),
          _QuickActionItem(
            title: 'Mentorat & Discipulat',
            subtitle: 'Suivi de la croissance spirituelle',
            icon: Icons.auto_graph_rounded,
            color: context.colors.brandPrimary,
            onTap: () async {
              await HapticHelper.medium();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Mentorat & Discipulat : Bientôt disponible')),
                );
              }
            },
          ),
          _QuickActionItem(
            title: 'Ressources Jeunesse',
            subtitle: 'Matériel d\'étude et guides',
            icon: Icons.library_books_rounded,
            color: context.colors.infoText,
            onTap: () async {
              await HapticHelper.medium();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Ressources Jeunesse : Bientôt disponible')),
                );
              }
            },
          ),
          _QuickActionItem(
            title: 'Messagerie Groupe',
            subtitle: 'Communiquer avec les jeunes',
            icon: Icons.chat_bubble_rounded,
            color: _primaryColor,
            onTap: () async {
              await HapticHelper.medium();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Messagerie : Bientôt disponible')),
                );
              }
            },
          ),
        ],
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
            color: context.colors.borderSubtle.withValues(alpha: 0.05)),
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
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
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

class _QuickActionItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticHelper.selection();
            onTap();
          },
          borderRadius: BorderRadius.circular(20),
          child: GlassCard(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: TextStyle(
                            fontFamily: LuminaFont.body,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: context.colors.textPrimary,
                          )),
                      Text(subtitle,
                          style: TextStyle(
                            fontFamily: LuminaFont.body,
                            fontSize: 10,
                            color: context.colors.textSecondary,
                          )),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded,
                    color: context.colors.textSecondary),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn().slideX(begin: 0.05);
  }
}

class _KpisLoading extends StatelessWidget {
  const _KpisLoading();
  @override
  Widget build(BuildContext context) => const ShimmerBox(height: 250);
}
