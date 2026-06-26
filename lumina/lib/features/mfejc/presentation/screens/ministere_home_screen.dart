import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:lumina/core/router/app_routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import 'package:lumina/core/animations/staggered_animations.dart';
import 'package:lumina/core/widgets/widgets.dart';
import 'package:lumina/core/widgets/navigation_hierarchy.dart';
import 'package:lumina/features/dashboard/presentation/providers/dashboard_kpi_provider.dart';
import 'package:lumina/features/churches/presentation/providers/church_providers.dart';
import 'package:lumina/features/finance/domain/services/currency_service.dart';
import '../widgets/structure_card.dart';
import '../widgets/ministere_widgets.dart';
import 'package:lumina/core/utils/haptic_helper.dart';

class MinistereHomeScreen extends ConsumerWidget {
  const MinistereHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Real data from providers
    final kpiAsync = ref.watch(dashboardKpiProvider);
    final churchesAsync = ref.watch(allChurchesProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: AppSpacing.screenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Menu de navigation rapide
                  const StaggeredListItem(
                    index: 0,
                    child: SectionQuickMenu(
                      currentRoute: '/ministere',
                      showHeader: true,
                    ),
                  ),

                  SizedBox(height: AppSpacing.xl),

                  // Aperçu Financier
                  StaggeredListItem(
                    index: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SectionHeader(
                          title: 'Aperçu Financier',
                          icon: Icons.account_balance_rounded,
                          iconColor: context.colors.brandPrimary,
                          trailingLabel: 'Détails',
                          onTrailingTap: () => context.go(AppRoutes.ministereFinance),
                        ),
                        SizedBox(height: AppSpacing.md),
                        kpiAsync.when(
                          data: (kpi) => Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: _StatCard(
                                      title: 'Solde Global',
                                      value: CurrencyService.format(
                                          kpi.balance, 'XAF'),
                                      change:
                                          '${kpi.growthRate.toStringAsFixed(1)}%',
                                      isPositive: kpi.growthRate >= 0,
                                      icon: Icons.payments_rounded,
                                      color: context.colors.successText,
                                    ),
                                  ),
                                  SizedBox(width: AppSpacing.md),
                                  Expanded(
                                    child: _StatCard(
                                      title: 'Membres',
                                      value: kpi.membersCount.toString(),
                                      change: 'Total',
                                      icon: Icons.people_rounded,
                                      color: context.colors.infoText,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: AppSpacing.md),
                              Row(
                                children: [
                                  Expanded(
                                    child: _StatCard(
                                      title: 'Événements',
                                      value: kpi.upcomingEvents.toString(),
                                      change: 'À venir',
                                      icon: Icons.event_rounded,
                                      color: context.colors.warningText,
                                    ),
                                  ),
                                  SizedBox(width: AppSpacing.md),
                                  Expanded(
                                    child: _StatCard(
                                      title: 'Croissance',
                                      value:
                                          '${kpi.growthRate.toStringAsFixed(1)}%',
                                      change: '30 jours',
                                      isPositive: kpi.growthRate >= 0,
                                      icon: Icons.trending_up_rounded,
                                      color: context.colors.brandPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          loading: () => const LoadingState(useShimmer: true),
                          error: (err, _) => EmptyState(
                              icon: Icons.error_outline,
                              title: 'Erreur',
                              subtitle: err.toString()),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: AppSpacing.xl),

                  // Églises & Structures
                  StaggeredListItem(
                    index: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SectionHeader(
                          title: 'Églises & Structures',
                          icon: Icons.account_tree_rounded,
                          iconColor: context.colors.brandSecondary,
                          trailingLabel: 'Gérer',
                          onTrailingTap: () =>
                              context.go(AppRoutes.ministereChurches),
                        ),
                        SizedBox(height: AppSpacing.md),
                        churchesAsync.when(
                          data: (churchList) => churchList.isEmpty
                              ? const EmptyState(
                                  icon: Icons.church_rounded,
                                  title: 'Aucune église',
                                  subtitle: 'Configurez vos structures')
                              : GridView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: AppSpacing.md,
                                    crossAxisSpacing: AppSpacing.md,
                                    childAspectRatio: 1.6,
                                  ),
                                  itemCount: churchList.length,
                                  itemBuilder: (context, i) => StructureCard(
                                    title: churchList[i].name,
                                    members:
                                        '${churchList[i].memberCount} membres',
                                    status: 'Actif',
                                    icon: Icons.church_rounded,
                                  ),
                                ),
                          loading: () =>
                              Center(child: LoadingState()),
                          error: (err, _) => Text('Impossible de charger les données'),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: AppSpacing.xl),

                  // Actions rapides
                  const StaggeredListItem(
                    index: 3,
                    child: SectionHeader(
                      title: 'Actions Rapides',
                      icon: Icons.bolt_rounded,
                      iconColor: Colors.amber,
                    ),
                  ),
                  SizedBox(height: AppSpacing.md),
                  StaggeredListItem(
                    index: 4,
                    child: GridView.count(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: AppSpacing.md,
                      crossAxisSpacing: AppSpacing.md,
                      childAspectRatio: 1.6,
                      children: [
                        QuickActionCard(
                          title: 'Nouveau budget',
                          icon: Icons.account_balance_wallet_rounded,
                          color: context.colors.brandPrimary,
                          onTap: () => context.go(AppRoutes.ministereFinance),
                        ),
                        QuickActionCard(
                          title: 'Ajouter une église',
                          icon: Icons.add_business_rounded,
                          color: context.colors.brandSecondary,
                          onTap: () => context.go(AppRoutes.ministereChurches),
                        ),
                        QuickActionCard(
                          title: 'Rapports',
                          icon: Icons.description_rounded,
                          color: context.colors.infoText,
                          onTap: () async {
                            await HapticHelper.medium();
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Rapports : Bientôt disponible')),
                              );
                            }
                          },
                        ),
                        QuickActionCard(
                          title: 'Audit Logs',
                          icon: Icons.security_rounded,
                          color: context.colors.errorText,
                          onTap: () => context.go(AppRoutes.audit),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 140,
      floating: true,
      pinned: true,
      backgroundColor: context.colors.brandPrimary,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'MFE-JC',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
            fontSize: 16,
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(gradient: LinearGradient(
                  colors: [context.colors.textSecondary, context.colors.textSecondaryLight],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            Positioned(
              right: -30,
              bottom: -20,
              child: Icon(
                Icons.work_rounded,
                size: 180,
                color: context.colors.textInverse.withValues(alpha: 0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String change;
  final bool? isPositive;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.change,
    this.isPositive,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      borderColor: color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: LuminaIcon.md),
          SizedBox(height: AppSpacing.md),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 2),
          Row(
            children: [
              if (isPositive != null)
                Icon(
                  isPositive!
                      ? Icons.trending_up_rounded
                      : Icons.trending_down_rounded,
                  size: LuminaIcon.xs,
                  color: isPositive! ? context.colors.successText : context.colors.errorText,
                ),
              SizedBox(width: 4),
              Text(
                change,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: isPositive != null
                      ? (isPositive! ? context.colors.successText : context.colors.errorText)
                      : (context.colors.textTertiary),
                ),
              ),
            ],
          ),
          Spacer(),
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
              color: context.colors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}
