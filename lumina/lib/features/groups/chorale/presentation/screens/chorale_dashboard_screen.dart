import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumina/core/router/app_routes.dart';
import 'package:lumina/core/widgets/widgets.dart';
import 'package:lumina/core/theme/app_typography.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import 'package:lumina/core/utils/haptic_helper.dart';
import 'package:lumina/features/groups/chorale/presentation/providers/chorale_providers.dart';
import 'package:lumina/features/groups/presentation/providers/group_providers.dart';

class ChoraleDashboardScreen extends ConsumerStatefulWidget {
  final String groupId;

  const ChoraleDashboardScreen({super.key, required this.groupId});

  @override
  ConsumerState<ChoraleDashboardScreen> createState() =>
      _ChoraleDashboardScreenState();
}

class _ChoraleDashboardScreenState extends ConsumerState<ChoraleDashboardScreen>
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

    final membersKpiAsync =
        ref.watch(choraleMembersKpiProvider(widget.groupId));
    final sheetsKpiAsync = ref.watch(sheetMusicKpiProvider(widget.groupId));

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          _buildAppBar(context, groupAsync),
          SliverToBoxAdapter(
            child: _buildKpiSection(context, membersKpiAsync, sheetsKpiAsync),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverTabDelegate(
              TabBar(
                controller: _tabController,
                indicatorColor: context.colors.brandPrimary,
                labelColor: context.colors.brandPrimary,
                unselectedLabelColor: context.colors.textSecondary,
                tabs: const [
                  Tab(text: 'PARTITIONS'),
                  Tab(text: 'RÉPÉTITIONS'),
                ],
                labelStyle: AppTypography.labelSmall.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
                unselectedLabelStyle: AppTypography.labelSmall.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _SheetMusicTab(groupId: widget.groupId),
            _RehearsalsTab(groupId: widget.groupId),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          HapticHelper.light();
          // Logique pour ajouter selon l'onglet actif
        },
        backgroundColor: context.colors.choraleColor,
        child: Icon(Icons.add, color: context.colors.textInverse),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, AsyncValue groupAsync) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
                decoration: BoxDecoration(
                    gradient: context.colors.fireFusionGradient)),
            Positioned(
              right: -20,
              bottom: -20,
              child: Icon(Icons.music_note_rounded,
                  size: 200, color: context.colors.textInverse.withValues(alpha: 0.1)),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('CHORALE',
                        style: AppTypography.labelSmall.copyWith(
                            color: context.colors.textInverse,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2)),
                    groupAsync.when(
                      data: (group) => Text(group.name,
                          style: AppTypography.h3.copyWith(
                            fontWeight: FontWeight.bold,
                            color: context.colors.textInverse,
                          )),
                      loading: () => Text('Chargement...',
                          style: AppTypography.bodySmall.copyWith(color: context.colors.textInverse)),
                      error: (_, __) => Text('Erreur',
                          style: AppTypography.bodySmall.copyWith(color: context.colors.textInverse)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new_rounded, color: context.colors.textInverse),
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

  Widget _buildKpiSection(
      BuildContext context, AsyncValue membersKpi, AsyncValue sheetsKpi) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Expanded(
            child: membersKpi.when(
              data: (kpi) => _KpiCard(
                title: 'Moy. Présences',
                value: kpi['average_attendance'],
                icon: Icons.people_rounded,
                color: context.colors.brandPrimary,
              ),
              loading: () => const _KpiLoadingCard(),
              error: (_, __) => const _KpiErrorCard(),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: sheetsKpi.when(
              data: (kpi) => _KpiCard(
                title: 'Partitions',
                value: kpi['total_sheets'].toString(),
                icon: Icons.library_music_rounded,
                color: context.colors.infoText,
              ),
              loading: () => const _KpiLoadingCard(),
              error: (_, __) => const _KpiErrorCard(),
            ),
          ),
        ],
      ),
    );
  }
}

class _KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _KpiCard(
      {required this.title,
      required this.value,
      required this.icon,
      required this.color});

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
              color: color.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: LuminaIcon.md),
          const SizedBox(height: 12),
          Text(value,
              style: AppTypography.h4.copyWith(
                fontWeight: FontWeight.w900,
                color: context.colors.textPrimary,
              )),
          Text(title,
              style: AppTypography.labelSmall.copyWith(
                color: context.colors.textSecondary,
              )),
        ],
      ),
    );
  }
}

class _KpiLoadingCard extends StatelessWidget {
  const _KpiLoadingCard();
  @override
  Widget build(BuildContext context) => const FireSkeletonStatCard();
}

class _KpiErrorCard extends StatelessWidget {
  const _KpiErrorCard();
  @override
  Widget build(BuildContext context) => Container(
        height: 100,
        decoration: BoxDecoration(
          color: context.colors.bgCard,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Center(
          child: Icon(Icons.error_outline, color: context.colors.errorText),
        ),
      );
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

class _SheetMusicTab extends ConsumerWidget {
  final String groupId;
  const _SheetMusicTab({required this.groupId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sheetsAsync = ref.watch(sheetMusicProvider(groupId));
    return sheetsAsync.when(
      data: (sheets) => sheets.isEmpty
          ? const Center(child: Text('Aucune partition trouvée'))
          : ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: sheets.length,
              itemBuilder: (context, index) {
                final sheet = sheets[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: AppSpacing.md),
                  decoration: BoxDecoration(
                    color: context.colors.bgCard,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: context.colors.borderSubtle.withValues(alpha: 0.1),
                    ),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: context.colors.brandPrimary.withValues(alpha: 0.1),
                      child: Icon(Icons.description_rounded,
                          color: context.colors.brandPrimary,
                          size: LuminaIcon.sm),
                    ),
                    title: Text(sheet.title,
                        style: AppTypography.bodySmall.copyWith(
                            fontWeight: FontWeight.bold,
                            color: context.colors.textPrimary)),
                    subtitle: Text(sheet.composer ?? 'Compositeur inconnu',
                        style: AppTypography.labelSmall.copyWith(
                            color: context.colors.textSecondary)),
                    trailing: Icon(Icons.download_rounded,
                        color: context.colors.textTertiary,
                        size: LuminaIcon.sm),
                    onTap: () {
                      // Logique de visualisation/téléchargement
                    },
                  ),
                );
              },
            ),
      loading: () => const FireSkeletonMemberList(),
      error: (e, _) => const Center(child: Text('Impossible de charger les données')),
    );
  }
}

class _RehearsalsTab extends ConsumerWidget {
  final String groupId;
  const _RehearsalsTab({required this.groupId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rehearsalsAsync = ref.watch(rehearsalsProvider(groupId));
    return rehearsalsAsync.when(
      data: (rehearsals) => rehearsals.isEmpty
          ? const Center(child: Text('Aucune répétition enregistrée'))
          : ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: rehearsals.length,
              itemBuilder: (context, index) {
                final rehearsal = rehearsals[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: AppSpacing.md),
                  decoration: BoxDecoration(
                    color: context.colors.bgCard,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: context.colors.borderSubtle.withValues(alpha: 0.1),
                    ),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          context.colors.brandSecondary.withValues(alpha: 0.1),
                      child: Icon(Icons.calendar_today_rounded,
                          color: context.colors.brandSecondary,
                          size: LuminaIcon.sm),
                    ),
                    title: Text(
                        '${rehearsal.date.day}/${rehearsal.date.month}/${rehearsal.date.year}',
                        style: AppTypography.bodySmall.copyWith(
                            fontWeight: FontWeight.bold,
                            color: context.colors.textPrimary)),
                    subtitle: Text(rehearsal.location ?? 'Lieu non spécifié',
                        style: AppTypography.labelSmall.copyWith(
                            color: context.colors.textSecondary)),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                          color: context.colors.successText.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12)),
                      child: Text('${rehearsal.attendanceCount} prés.',
                          style: AppTypography.labelSmall.copyWith(
                              color: context.colors.successText,
                              fontWeight: FontWeight.bold)),
                    ),
                    onTap: () {
                      // Logique de détail
                    },
                  ),
                );
              },
            ),
      loading: () => const FireSkeletonMemberList(),
      error: (e, _) => const Center(child: Text('Impossible de charger les données')),
    );
  }
}
