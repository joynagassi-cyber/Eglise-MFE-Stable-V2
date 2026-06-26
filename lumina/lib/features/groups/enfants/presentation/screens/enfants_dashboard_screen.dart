import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';
import 'package:lumina/core/router/app_routes.dart';
import 'package:lumina/core/widgets/widgets.dart';
import '../providers/enfants_providers.dart';
import 'package:lumina/features/groups/presentation/providers/group_providers.dart';
import '../widgets/medical_alerts_widget.dart';
import '../widgets/programs_grid.dart';
import '../widgets/attendance_bar_chart.dart';
import '../widgets/resource_vault.dart';
import 'package:lumina/core/utils/haptic_helper.dart';

class EnfantsDashboardScreen extends ConsumerStatefulWidget {
  const EnfantsDashboardScreen({super.key});

  @override
  ConsumerState<EnfantsDashboardScreen> createState() =>
      _EnfantsDashboardScreenState();
}

class _EnfantsDashboardScreenState extends ConsumerState<EnfantsDashboardScreen>
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
    final kpisAsync = ref.watch(enfantsKpisNotifierProvider);

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
                  SizedBox(height: 24),
                  const AttendanceBarChart(),
                  SizedBox(height: 24),
                  const MedicalAlertsWidget(),
                  SizedBox(height: 24),
                  Text(
                    'Programmes par Âge',
                    style: TextStyle(
                      fontFamily: LuminaFont.display,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: context.colors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 12),
                  const ProgramsGrid(),
                  SizedBox(height: 24),
                  Text(
                    'Coffre à Ressources',
                    style: TextStyle(
                      fontFamily: LuminaFont.display,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: context.colors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 12),
                  const ResourceVault(),
                  SizedBox(height: 100), // Space for bottom
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'Enfants Dashboard',
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
                gradient: context.colors.enfantsGradient,
              ),
            ),
            Positioned(
              right: -50,
              top: -50,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  color: context.colors.textInverse.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
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
          onPressed: () async {
            final groupId = _resolveEnfantsGroupId(ref);
            if (groupId == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Groupe enfants introuvable')),
              );
              return;
            }
            await context.push(AppRoutes.groupDashboardJoinRequestsWithId(groupId));
          },
        ),
        IconButton(
          icon: Icon(Icons.notifications_active_outlined),
          onPressed: () async {
            final messenger = ScaffoldMessenger.of(context);
            await HapticHelper.medium();
            messenger.showSnackBar(
              SnackBar(content: Text('Notifications : Bientôt disponible')),
            );
          },
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
              title: 'Total Enfants',
              value: '${kpis['totalKids'] ?? 0}',
              icon: Icons.child_care,
              color: context.colors.brandPrimary,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: _KpiCard(
              title: 'Présence',
              value: '${((kpis['attendanceRate'] ?? 0) * 100).toInt()}%',
              icon: Icons.event_available,
              color: context.colors.successText,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: _KpiCard(
              title: 'Alertes',
              value: '${kpis['pendingAlerts'] ?? 0}',
              icon: Icons.warning_amber_rounded,
              color: context.colors.enfantsColor,
            ),
          ),
        ],
      ),
      loading: () => const AppProgressBar(),
      error: (e, _) => Text('Error: $e'),
    );
  }

  String? _resolveEnfantsGroupId(WidgetRef ref) {
    final groups = ref.read(groupsProvider).valueOrNull;
    if (groups == null) return null;

    for (final group in groups) {
      if (group.type.name == 'enfants' ||
          group.name.toLowerCase().contains('enfant')) {
        return group.id;
      }
    }
    return null;
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
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.colors.bgCard.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: color.withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: LuminaIcon.md),
              SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  fontFamily: LuminaFont.display,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                title,
                style: TextStyle(
                  fontFamily: LuminaFont.body,
                  fontSize: 11,
                  color: context.colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1);
  }
}
