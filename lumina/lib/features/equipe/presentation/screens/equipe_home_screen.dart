// import 'package:lumina/core/theme/lumina_colors_extension.dart';
import 'package:lumina/core/extensions/context_extension.dart';
// lib/features/equipe/presentation/screens/equipe_home_screen.dart
// Page d'accueil de la section Équipe — wired with real EquipeController data

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumina/core/router/app_routes.dart';
import 'package:intl/intl.dart';
import 'package:lumina/core/widgets/widgets.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import 'package:lumina/core/widgets/navigation_hierarchy.dart';
import 'package:lumina/core/utils/haptic_helper.dart';
import 'package:lumina/core/providers/auth_provider.dart';
import 'package:lumina/features/equipe/presentation/controllers/equipe_controller.dart';
// import 'package:lumina/core/extensions/build_context_extensions.dart';

class EquipeHomeScreen extends ConsumerWidget {
  const EquipeHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cardColor = context.colors.bgCard;
    final churchId = ref.watch(activeChurchIdProvider);

    final equipeAsync = ref.watch(
      equipeControllerProvider(churchId: churchId),
    );

    return Scaffold(
      appBar: BreadcrumbAppBar(
        currentLocation: AppRoutes.equipe,
        leading: Semantics(
          label: 'Retour au tableau de bord',
          button: true,
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              await HapticHelper.light();
              if (context.mounted) context.go(AppRoutes.dashboard);
            },
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(equipeControllerProvider(churchId: churchId));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedEntrance.fromBottom(
                delay: const Duration(milliseconds: 100),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.lg,
                  ),
                  decoration: BoxDecoration(
                    gradient: context.colors.brandPrimaryGradient,
                    borderRadius: AppSpacing.borderRadiusCard,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.smd),
                        decoration: BoxDecoration(
                          color: context.colors.textOnBrand.withValues(alpha: 0.2),
                          borderRadius: AppSpacing.borderRadiusSm,
                        ),
                        child: Icon(Icons.shield,
                          color: context.colors.textOnBrand,
                          size: AppSpacing.iconXl,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'Équipe Pastorale',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: context.colors.textOnBrand,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Coordonnez et équipez vos leaders',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: context.colors.textOnBrand.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              const AnimatedEntrance.fromBottom(
                delay: Duration(milliseconds: 200),
                child: SectionQuickMenu(
                  currentRoute: AppRoutes.equipe,
                  showHeader: true,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              AnimatedEntrance.fromBottom(
                delay: const Duration(milliseconds: 300),
                child: Text(
                  'Aperçu de l\'équipe',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // — Live data from EquipeController —
              equipeAsync.when(
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(AppSpacing.lg),
                    child: LoadingDots(),
                  ),
                ),
                error: (e, _) => _buildErrorState(context, theme, ref, churchId),
                data: (equipeState) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Stat cards
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            title: 'Bergers actifs',
                            value: '${equipeState.activeShepherdCount}',
                            change: 'Total',
                            icon: Icons.person,
                            color: context.colors.brandPrimary,
                            onTap: () => context.go(AppRoutes.equipe),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: _StatCard(
                            title: 'Visites planifiées',
                            value: '${equipeState.pendingVisitCount}',
                            change: 'À venir',
                            icon: Icons.location_on,
                            color: context.colors.brandSecondary,
                            onTap: () => context.go(AppRoutes.equipeVisites),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            title: 'Visites ce mois',
                            value: '${equipeState.totalVisitsThisMonth}',
                            change: 'Ce mois',
                            icon: Icons.calendar_today,
                            color: context.colors.successText,
                            onTap: () => context.go(AppRoutes.equipeVisites),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: _StatCard(
                            title: 'Complétées',
                            value: '${equipeState.completedVisits.length}',
                            change: 'Historique',
                            icon: Icons.check_circle,
                            color: context.colors.infoText,
                            onTap: () => context.go(AppRoutes.equipeVisites),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    // Bergers actifs récents
                    Container(
                      padding: AppSpacing.cardPadding,
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: AppSpacing.borderRadiusCard,
                        border: Border.all(
                          color: context.colors.borderSubtle,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Bergers actifs récents',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextButton(
                                onPressed: () => context.go(AppRoutes.equipe),
                                child: Text(
                                  'Voir tous',
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    color: context.colors.brandPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.md),
                          if (equipeState.shepherds.isEmpty)
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(AppSpacing.md),
                                child: Text(
                                  'Aucun berger disponible',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: context.colors.textSecondary,
                                  ),
                                ),
                              ),
                            )
                          else
                            ...equipeState.shepherds.take(5).map(
                                  (s) => Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: AppSpacing.sm,
                                    ),
                                    child: _buildShepherdPreview(
                                      '${s.firstName ?? ''} ${s.lastName ?? ''}'
                                          .trim(),
                                      s.specialties.isNotEmpty
                                          ? s.specialties.join(', ')
                                          : 'Équipe générale',
                                      s.level,
                                      context,
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    // Visites à planifier
                    Container(
                      padding: AppSpacing.cardPadding,
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: AppSpacing.borderRadiusCard,
                        border: Border.all(
                          color: context.colors.borderSubtle,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Visites à planifier',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.sm,
                                  vertical: AppSpacing.xs,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      context.colors.brandPrimary.withValues(alpha: 0.1),
                                  borderRadius: AppSpacing.borderRadiusMd,
                                ),
                                child: Text(
                                  '${equipeState.plannedVisits.length} à venir',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: context.colors.brandPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.md),
                          if (equipeState.plannedVisits.isEmpty)
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(AppSpacing.md),
                                child: Text(
                                  'Aucune visite à planifier',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: context.colors.textSecondary,
                                  ),
                                ),
                              ),
                            )
                          else
                            ...equipeState.plannedVisits.take(5).map(
                                  (v) => Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: AppSpacing.sm,
                                    ),
                                    child: _buildVisitPreview(
                                      v.notes.isNotEmpty
                                          ? v.notes
                                          : 'Visite pastorale',
                                      DateFormat('dd/MM/yyyy').format(v.date),
                                      'Planifiée',
                                      context,
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, ThemeData theme, WidgetRef ref, String? churchId) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            Icon(Icons.error_outline, color: context.colors.errorText, size: 48),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Erreur de chargement',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: context.colors.errorText,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextButton.icon(
              onPressed: () => ref.invalidate(
                equipeControllerProvider(churchId: churchId),
              ),
              icon: const Icon(Icons.refresh),
              label: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShepherdPreview(
    String name,
    String team,
    String activity,
    BuildContext context,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.go(AppRoutes.equipe),
        borderRadius: AppSpacing.borderRadiusSm,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.smd,
          ),
          decoration: BoxDecoration(
            color: context.colors.bgCard,
            borderRadius: AppSpacing.borderRadiusSm,
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(shape: BoxShape.circle,
                  gradient: context.colors.brandPrimaryGradient,
                ),
                child: Center(child: Icon(
                    Icons.person,
                    color: context.colors.textOnBrand,
                    size: AppSpacing.iconMd,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.smd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      team,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: context.colors.textSecondary,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      activity,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: context.colors.successText,
                          ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: context.colors.brandPrimary.withValues(alpha: 0.1),
                  borderRadius: AppSpacing.borderRadiusMd,
                ),
                child: Text(
                  'Actif',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: context.colors.brandPrimary,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVisitPreview(
    String title,
    String time,
    String status,
    BuildContext context,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.go(AppRoutes.equipeVisites),
        borderRadius: AppSpacing.borderRadiusSm,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.smd,
          ),
          decoration: BoxDecoration(
            color: context.colors.bgCard,
            borderRadius: AppSpacing.borderRadiusSm,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: context.colors.brandSecondary.withValues(alpha: 0.1),
                  borderRadius: AppSpacing.borderRadiusSm,
                ),
                child: Icon(Icons.location_on,
                  size: 18,
                  color: context.colors.brandSecondary,
                ),
              ),
              const SizedBox(width: AppSpacing.smd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          size: AppSpacing.iconXs - 4,
                          color: context.colors.textTertiary,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          time,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: context.colors.textTertiary,
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: context.colors.successText.withValues(alpha: 0.1),
                  borderRadius: AppSpacing.borderRadiusMd,
                ),
                child: Text(
                  status,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: context.colors.successText,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String change;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const _StatCard({
    required this.title,
    required this.value,
    required this.change,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppSpacing.borderRadiusMd,
        child: Container(
          padding: AppSpacing.cardPadding,
          decoration: BoxDecoration(
            color: context.colors.bgCard,
            borderRadius: AppSpacing.borderRadiusMd,
            border: Border.all(
              color: context.colors.borderSubtle,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: AppSpacing.borderRadiusSm,
                    ),
                    child: Icon(icon, size: AppSpacing.iconMd, color: color),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: AppSpacing.borderRadiusMd,
                    ),
                    child: Text(
                      change,
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.smd),
              Text(
                value,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}