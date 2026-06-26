// lib/features/communaute/presentation/screens/communaute_home_screen.dart
// Page d'accueil de la section Communauté — wired with real data

import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumina/core/router/app_routes.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import 'package:lumina/core/widgets/navigation_hierarchy.dart';
// import 'package:lumina/core/widgets/animated_entrance.dart';
import 'package:lumina/core/utils/haptic_helper.dart';
import 'package:lumina/core/providers/auth_provider.dart';
import 'package:lumina/features/communaute/presentation/controllers/circle_controller.dart';
import 'package:lumina/features/communaute/presentation/providers/communaute_stats_provider.dart';
import 'package:lumina/core/widgets/widgets.dart';
class CommunauteHomeScreen extends ConsumerWidget {
  const CommunauteHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textColor = context.colors.textPrimary;

    final churchId = ref.watch(activeChurchIdProvider);
    final circlesAsync = ref.watch(
      circleControllerProvider(churchId: churchId),
    );

    // Member count via dedicated provider (Clean Architecture)
    final memberCountAsync = ref.watch(communauteMemberCountProvider);

    return Scaffold(
      appBar: BreadcrumbAppBar(
        currentLocation: '/communaute',
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
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: AppSpacing.md),
            child: SyncStatusIndicator(isSynced: true, compact: true),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(circleControllerProvider(churchId: churchId));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header avec titre
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
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: AppSpacing.borderRadiusSm,
                        ),
                        child: const Icon(
                          Icons.people,
                          color: Colors.white,
                          size: AppSpacing.iconXl,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'Communauté',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Gérez votre troupeau et suivez les personnes',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Menu de navigation rapide
              const AnimatedEntrance.fromBottom(
                delay: Duration(milliseconds: 200),
                child: SectionQuickMenu(
                  currentRoute: '/communaute',
                  showHeader: true,
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Statistiques rapides
              AnimatedEntrance.fromBottom(
                delay: const Duration(milliseconds: 300),
                child: Text(
                  'Aperçu de la communauté',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // — Live stats from CircleController —
              circlesAsync.when(
                loading: () => const Padding(
                  padding: EdgeInsets.all(AppSpacing.lg),
                  child: LoadingState(skeleton: FireSkeletonCommSummary()),
                ),
                error: (e, _) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      children: [
                        Icon(Icons.error_outline, color: context.colors.errorText),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'Erreur de chargement',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: context.colors.errorText,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        TextButton(
                          onPressed: () => ref.invalidate(
                            circleControllerProvider(churchId: churchId),
                          ),
                          child: const Text('Réessayer'),
                        ),
                      ],
                    ),
                  ),
                ),
                data: (circles) {
                  final totalCircles = circles.length;
                  final memberCount = memberCountAsync.valueOrNull ?? 0;

                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _StatCard(
                              title: 'Membres',
                              value: '$memberCount',
                              change: 'Total',
                              icon: Icons.people,
                              color: context.colors.brandPrimary,
                              onTap: () => context.go(AppRoutes.communaute),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: _StatCard(
                              title: 'Cercles',
                              value: '$totalCircles',
                              change: 'Total',
                              icon: Icons.group_work,
                              color: context.colors.brandSecondary,
                              onTap: () async {
                                await HapticHelper.medium();
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Cercles : Bientôt disponible')),
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: AppSpacing.xxl),

              // Actions rapides
              AnimatedEntrance.fromBottom(
                delay: const Duration(milliseconds: 400),
                child: Text(
                  'Actions rapides',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              AnimatedEntrance.fromBottom(
                delay: const Duration(milliseconds: 450),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: AppSpacing.md,
                  crossAxisSpacing: AppSpacing.md,
                  childAspectRatio: 1.6,
                  children: [
                    _QuickActionCard(
                      title: 'Ajouter un membre',
                      icon: Icons.person_add,
                      color: context.colors.brandPrimary,
                      onTap: () => context.go(AppRoutes.communauteNouveau),
                    ),
                    _QuickActionCard(
                      title: 'Voir les anniversaires',
                      icon: Icons.cake,
                      color: context.colors.brandSecondary,
                      onTap: () => context.go(AppRoutes.communauteBirthdays),
                    ),
                    _QuickActionCard(
                      title: 'Statistiques',
                      icon: Icons.bar_chart,
                      color: context.colors.successText,
                      onTap: () => context.go(AppRoutes.communauteStats),
                    ),
                    _QuickActionCard(
                      title: 'Exporter la liste',
                      icon: Icons.file_download,
                      color: context.colors.infoText,
                      onTap: () async {
                        await HapticHelper.medium();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Export lancé',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        }
                      },
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

    return Semantics(
      label: '$title: $value, évolution: $change',
      button: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            await HapticHelper.light();
            onTap?.call();
          },
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
                      padding: const EdgeInsets.all(AppSpacing.xs),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: AppSpacing.borderRadiusSm,
                      ),
                      child: Icon(icon, size: AppSpacing.iconMd, color: color),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs,
                        vertical: AppSpacing.xxs,
                      ),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: AppSpacing.borderRadiusSm,
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
                    color: context.colors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
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
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      label: title,
      button: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            await HapticHelper.medium();
            onTap();
          },
          borderRadius: AppSpacing.borderRadiusMd,
          child: Container(
            decoration: BoxDecoration(
              color: context.colors.bgCard,
              borderRadius: AppSpacing.borderRadiusMd,
              border: Border.all(
                color: context.colors.borderSubtle,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.smd),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: AppSpacing.borderRadiusSm,
                    ),
                    child: Icon(icon, size: AppSpacing.iconLg, color: color),
                  ),
                  const Spacer(),
                  Text(
                    title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: context.colors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
