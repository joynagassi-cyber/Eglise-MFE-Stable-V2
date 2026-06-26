import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumina/core/router/app_routes.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import 'package:lumina/core/utils/haptic_helper.dart';
import 'package:lumina/core/widgets/navigation_hierarchy.dart';
import 'package:lumina/core/widgets/animated_entrance.dart';
import 'package:lumina/core/widgets/app_error_widget.dart';
import 'package:lumina/features/bergers/data/repositories/visites_repository.dart';
import 'package:lumina/features/bergers/domain/entities/visite_pastorale.dart';
import 'package:lumina/core/widgets/skeletons/fire_skeleton_system.dart';

/// ═══════════════════════════════════════════════════════════════════════════════
/// VISITES PASTORALES SCREEN - UI Résiliente SRE
///
/// Architecture:
/// • ConsumerWidget avec AsyncValue (pas de setState)
/// • Skeleton loaders pendant le chargement
/// • Widget ErrorState avec retry explicite
/// • Widget EmptyState avec CTA
/// • Onglets (Historique / À Visiter) avec IndexedStack
/// • 100% Design tokens (AppSpacing, context.colors)
/// • Haptic feedback sur toutes les interactions
/// ═══════════════════════════════════════════════════════════════════════════════

class VisitesPastoralesScreen extends ConsumerStatefulWidget {
  const VisitesPastoralesScreen({super.key});

  @override
  ConsumerState<VisitesPastoralesScreen> createState() =>
      _VisitesPastoralesScreenState();
}

class _VisitesPastoralesScreenState
    extends ConsumerState<VisitesPastoralesScreen>
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
    final visitesAsync = ref.watch(visitesProvider);
    final membresAsync = ref.watch(membresAVisiterProvider);
    final statsAsync = ref.watch(visitesStatsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: BreadcrumbAppBar(
        currentLocation: '/equipe/visites',
        leading: Semantics(
          label: 'Retour',
          button: true,
          child: IconButton(
            icon: Icon(Icons.arrow_back, size: AppSpacing.iconLg),
            onPressed: () {
              HapticHelper.light();
              context.go(AppRoutes.equipe);
            },
          ),
        ),
        actions: [
          Semantics(
            label: 'Rafraîchir',
            button: true,
            child: IconButton(
              icon: Icon(Icons.refresh, size: AppSpacing.iconLg),
              onPressed: () {
                HapticHelper.medium();
                ref.invalidate(visitesProvider);
              },
              tooltip: 'Rafraîchir',
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats header avec animation
          AnimatedEntrance.fromBottom(
            delay: const Duration(milliseconds: 100),
            child: statsAsync.when(
              data: (stats) => _StatsHeader(stats: stats),
              loading: () => const _StatsHeaderSkeleton(),
              error: (_, __) => const SizedBox.shrink(),
            ),
          ),

          // TabBar avec animation
          AnimatedEntrance.fromBottom(
            delay: const Duration(milliseconds: 150),
            child: Container(
              margin: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenHorizontalPadding,
              ),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: AppSpacing.borderRadiusMd,
              ),
              child: TabBar(
                controller: _tabController,
                onTap: (_) => HapticHelper.selection(),
                tabs: const [
                  Tab(text: 'Historique', icon: Icon(Icons.history_rounded)),
                  Tab(
                    text: 'À Visiter',
                    icon: Icon(Icons.people_outline_rounded),
                  ),
                ],
              ),
            ),
          ),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Onglet Historique
                visitesAsync.when(
                  data: (visites) => _HistoriqueTab(
                    visites: visites,
                    onRefresh: () => ref.invalidate(visitesProvider),
                  ),
                  loading: () => const _VisitesSkeletonLoader(),
                  error: (error, _) => AppErrorWidget(
                    message: 'Impossible de charger les visites',
                    technicalDetails: error.toString(),
                    onRetry: () {
                      HapticHelper.light();
                      ref.invalidate(visitesProvider);
                    },
                  ),
                ),

                // Onglet À Visiter
                membresAsync.when(
                  data: (membres) => _AVisiterTab(
                    membres: membres,
                    onRefresh: () => ref.invalidate(membresAVisiterProvider),
                  ),
                  loading: () => const _MembresSkeletonLoader(),
                  error: (error, _) => AppErrorWidget(
                    message: 'Impossible de charger les membres',
                    technicalDetails: error.toString(),
                    onRetry: () {
                      HapticHelper.light();
                      ref.invalidate(membresAVisiterProvider);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Semantics(
        label: 'Planifier une nouvelle visite',
        button: true,
        child: FloatingActionButton.extended(
          onPressed: () {
            HapticHelper.light();
            _showPlanifierDialog(context, ref);
          },
          icon: Icon(Icons.add_location_rounded, size: AppSpacing.iconLg),
          label: Text('Planifier'),
          backgroundColor: context.colors.brandPrimary,
          foregroundColor: context.colors.textOnBrand,
        ),
      ),
    );
  }

  void _showPlanifierDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusCard,
        ),
        title: Text('Planifier une Visite'),
        content: Text(
          'Fonctionnalité à implémenter. Utilisez Supabase Dashboard pour créer des visites.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              HapticHelper.light();
              Navigator.pop(context);
            },
            child: Text('Fermer'),
          ),
        ],
      ),
    );
  }
}

/// ═══════════════════════════════════════════════════════════════════════════════
/// SKELETON LOADERS
/// ═══════════════════════════════════════════════════════════════════════════════

class _VisitesSkeletonLoader extends StatelessWidget {
  const _VisitesSkeletonLoader();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.screenHorizontalPadding),
      itemCount: 4,
      itemBuilder: (context, index) => AnimatedEntrance.fromBottom(
        delay: Duration(milliseconds: 100 * index),
        child: const _SkeletonCard(),
      ),
    );
  }
}

class _MembresSkeletonLoader extends StatelessWidget {
  const _MembresSkeletonLoader();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.screenHorizontalPadding),
      itemCount: 4,
      itemBuilder: (context, index) => AnimatedEntrance.fromBottom(
        delay: Duration(milliseconds: 100 * index),
        child: const _SkeletonCard(),
      ),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark
        ? context.colors.bgCardElevated.withValues(alpha: 0.3)
        : context.colors.borderSubtle.withValues(alpha: 0.3);

    return FireShimmer(
      child: Card(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 60,
                decoration: BoxDecoration(
                  color: baseColor,
                  borderRadius: AppSpacing.borderRadiusSm,
                ),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 16,
                      decoration: BoxDecoration(
                        color: baseColor,
                        borderRadius: AppSpacing.borderRadiusSm,
                      ),
                    ),
                    SizedBox(height: AppSpacing.sm),
                    Container(
                      width: 120,
                      height: 12,
                      decoration: BoxDecoration(
                        color: baseColor,
                        borderRadius: AppSpacing.borderRadiusSm,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatsHeaderSkeleton extends StatelessWidget {
  const _StatsHeaderSkeleton();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return FireShimmer(
      child: Container(
        margin: const EdgeInsets.all(AppSpacing.screenHorizontalPadding),
        padding: const EdgeInsets.all(AppSpacing.lg),
        height: 120,
        decoration: BoxDecoration(
          color: isDark
              ? context.colors.bgCardElevated.withValues(alpha: 0.3)
              : context.colors.borderSubtle.withValues(alpha: 0.3),
          borderRadius: AppSpacing.borderRadiusLg,
        ),
      ),
    );
  }
}

/// ═══════════════════════════════════════════════════════════════════════════════
/// STATS HEADER
/// ═══════════════════════════════════════════════════════════════════════════════

class _StatsHeader extends StatelessWidget {
  final VisitesStats stats;

  const _StatsHeader({required this.stats});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.all(AppSpacing.screenHorizontalPadding),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [context.colors.brandPrimary, context.colors.brandSecondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppSpacing.borderRadiusLg,
        boxShadow: AppSpacing.shadowMd,
      ),
      child: Semantics(
        label: 'Statistiques des visites pastorales',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Visites Pastorales',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: AppSpacing.md),
            Row(
              children: [
                _StatItem(
                  icon: Icons.check_circle_rounded,
                  value: stats.effectuees.toString(),
                  label: 'Effectuées',
                ),
                SizedBox(width: AppSpacing.lg),
                _StatItem(
                  icon: Icons.schedule_rounded,
                  value: stats.planifiees.toString(),
                  label: 'Planifiées',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: AppSpacing.borderRadiusSm,
            ),
            child: Icon(icon, color: Colors.white, size: AppSpacing.iconMd),
          ),
          SizedBox(width: AppSpacing.smd),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// ═══════════════════════════════════════════════════════════════════════════════
/// ONGLET HISTORIQUE
/// ═══════════════════════════════════════════════════════════════════════════════

class _HistoriqueTab extends StatelessWidget {
  final List<VisitePastorale> visites;
  final VoidCallback onRefresh;

  const _HistoriqueTab({required this.visites, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    if (visites.isEmpty) {
      return const _EmptyState(
        icon: Icons.history_rounded,
        title: 'Aucune visite enregistrée',
        subtitle: 'Commencez par planifier votre première visite pastorale',
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await HapticHelper.medium();
        onRefresh();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.screenHorizontalPadding),
        itemCount: visites.length,
        itemBuilder: (context, index) => AnimatedEntrance.fromBottom(
          delay: Duration(milliseconds: 50 * index),
          child: _VisiteCard(visite: visites[index]),
        ),
      ),
    );
  }
}

class _VisiteCard extends StatelessWidget {
  final VisitePastorale visite;

  const _VisiteCard({required this.visite});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      color: theme.cardColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.borderRadiusMd,
        side: BorderSide(
          color: context.colors.borderSubtle,
        ),
      ),
      child: Semantics(
        label:
            'Visite de ${visite.displayMembreNom}, ${visite.statutLabel}, ${visite.displayDate}',
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: visite.statutColor(context).withValues(alpha: 0.1),
                      borderRadius: AppSpacing.borderRadiusSm,
                    ),
                    child: Text(
                      visite.statutLabel,
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: visite.statutColor(context),
                      ),
                    ),
                  ),
                  Spacer(),
                  Text(
                    visite.displayDate,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: context.colors.textSecondary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.smd),
              Text(
                visite.displayMembreNom,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.colors.textPrimary,
                ),
              ),
              if (visite.adresse.isNotEmpty) ...[
                SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      size: AppSpacing.iconSm,
                      color: context.colors.textTertiary,
                    ),
                    SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: Text(
                        visite.displayAdresse,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: context.colors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
              SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Icon(Icons.person_outline_rounded,
                    size: AppSpacing.iconSm,
                    color: context.colors.brandPrimary,
                  ),
                  SizedBox(width: AppSpacing.xs),
                  Text(
                    'Berger: ${visite.displayBergerNom}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: context.colors.brandPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ═══════════════════════════════════════════════════════════════════════════════
/// ONGLET À VISITER
/// ═══════════════════════════════════════════════════════════════════════════════

class _AVisiterTab extends StatelessWidget {
  final List<MembreAVisiter> membres;
  final VoidCallback onRefresh;

  const _AVisiterTab({required this.membres, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    if (membres.isEmpty) {
      return const _EmptyState(
        icon: Icons.check_circle_outline_rounded,
        title: 'Tous les membres sont à jour',
        subtitle: 'Aucun membre ne nécessite de visite prioritaire',
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await HapticHelper.medium();
        onRefresh();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.screenHorizontalPadding),
        itemCount: membres.length,
        itemBuilder: (context, index) => AnimatedEntrance.fromBottom(
          delay: Duration(milliseconds: 50 * index),
          child: _MembreCard(membre: membres[index]),
        ),
      ),
    );
  }
}

class _MembreCard extends StatelessWidget {
  final MembreAVisiter membre;

  const _MembreCard({required this.membre});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      color: theme.cardColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.borderRadiusMd,
        side: BorderSide(
          color: context.colors.borderSubtle,
        ),
      ),
      child: Semantics(
        label:
            'Membre ${membre.displayNom}, priorité ${membre.priorite.name}, ${membre.raison}',
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 60,
                decoration: BoxDecoration(
                  color: membre.prioriteColor(context),
                  borderRadius: AppSpacing.borderRadiusSm,
                ),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            membre.displayNom,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: context.colors.textPrimary,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: AppSpacing.xs,
                          ),
                          decoration: BoxDecoration(
                            color: membre.prioriteColor(context).withValues(alpha: 0.1),
                            borderRadius: AppSpacing.borderRadiusSm,
                          ),
                          child: Text(
                            membre.priorite.name.toUpperCase(),
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: membre.prioriteColor(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.xs),
                    Text(
                      membre.raison,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: context.colors.textSecondary,
                      ),
                    ),
                    SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: AppSpacing.iconSm,
                          color: context.colors.textTertiary,
                        ),
                        SizedBox(width: AppSpacing.xs),
                        Text(
                          membre.displayDerniereVisite,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: context.colors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Semantics(
                label: 'Planifier visite pour ${membre.displayNom}',
                button: true,
                child: IconButton(
                  icon: Icon(Icons.add_circle_outline_rounded,
                    color: context.colors.brandPrimary,
                    size: AppSpacing.iconLg,
                  ),
                  onPressed: () {
                    HapticHelper.light();
                    // TODO: Planifier visite pour ce membre
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ═══════════════════════════════════════════════════════════════════════════════
/// EMPTY STATE GÉNÉRIQUE
/// ═══════════════════════════════════════════════════════════════════════════════

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: AppSpacing.iconFeature + 20,
              color: context.colors.textTertiary,
            ),
            SizedBox(height: AppSpacing.lg),
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: context.colors.textPrimary,
              ),
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
