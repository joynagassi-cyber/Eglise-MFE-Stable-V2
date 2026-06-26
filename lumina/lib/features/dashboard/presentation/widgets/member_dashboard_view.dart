import "package:lumina/core/widgets/widgets.dart";
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumina/core/theme/lumina_design_system.dart';
import '../providers/member_dashboard_provider.dart';
import 'package:lumina/features/bible/reader/widgets/daily_bible_card.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_routes.dart';
import 'package:lumina/core/widgets/loading_state.dart';

class MemberDashboardView extends ConsumerWidget {
  const MemberDashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(memberDashboardProvider);

    // Au lieu de bloquer avec du shimmer, on affiche TOUJOURS le dashboard.
    // En loading : on montre la structure avec des placeholders légers.
    // En error : on montre un message d'accueil sans planter.
    // En data : on montre le contenu complet.
    return dashboardState.when(
      data: (state) => _buildContent(context, state),
      loading: () => _buildLoadingContent(context),
      error: (e, st) => _buildContent(context, MemberDashboardState.empty),
    );
  }

  Widget _buildContent(BuildContext context, MemberDashboardState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(LuminaDesign.paddingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcome(context, state),
          SizedBox(height: LuminaDesign.paddingLg),
          _buildKPIGrid(context, state),
          SizedBox(height: LuminaDesign.paddingLg),
          const DailyBibleCard(),
          SizedBox(height: LuminaDesign.paddingLg),
          _buildSectionTitle(context, "Ma Communauté"),
          _buildGroupsList(context, state),
        ],
      ),
    );
  }

  /// Contenu de chargement : skeleton qui mime EXACTEMENT la structure du
  /// dashboard final (recommandation NN/g — jamais de "frame-display" vide).
  /// Chaque ShimmerBox correspond à un élément réel :
  ///   - ligne "Bonjour," (label)
  ///   - prénom (h1)
  ///   - 2 cartes KPI (icône + label + valeur)
  ///   - DailyBibleCard se charge indépendamment (vraie card)
  ///   - titre section + ligne de groupes
  /// Les couleurs proviennent des tokens shimmerBase/shimmerHighlight → visibles
  /// en light ET dark mode (corrige le bug "page noire").
  Widget _buildLoadingContent(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(LuminaDesign.paddingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête de bienvenue — 2 lignes qui miment _buildWelcome
          SkeletonTile(width: 90, height: 14),
          const SizedBox(height: 6),
          SkeletonTile(width: 140, height: 24),
          SizedBox(height: LuminaDesign.paddingLg),
          // 2 KPI cards — miment _buildKPIGrid (icône + label + valeur)
          Row(
            children: [
              Expanded(child: _buildKPISkeleton(context)),
              SizedBox(width: LuminaDesign.paddingMd),
              Expanded(child: _buildKPISkeleton(context)),
            ],
          ),
          SizedBox(height: LuminaDesign.paddingLg),
          // La carte Bible se charge indépendamment (vraie card, pas skeleton)
          const DailyBibleCard(),
          SizedBox(height: LuminaDesign.paddingLg),
          // Titre section Communauté
          _buildSectionTitle(context, "Ma Communauté"),
          const SizedBox(height: 8),
          // Ligne horizontale de 4 avatars-groupes (miment _buildGroupsList)
          SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              children: List.generate(4, (_) {
                return Padding(
                  padding: const EdgeInsets.only(right: LuminaDesign.paddingMd),
                  child: Column(
                    children: [
                      SkeletonTile(
                        width: 60,
                        height: 60,
                        shape: BoxShape.circle,
                      ),
                      const SizedBox(height: 4),
                      SkeletonTile(width: 48, height: 10),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  /// Skeleton d'une carte KPI : icône (cercle) + label + valeur.
  /// Mimes la structure de _buildKPIGrid.
  Widget _buildKPISkeleton(BuildContext context) {
    return SizedBox(
      height: 90,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SkeletonTile(width: 24, height: 24, shape: BoxShape.circle),
          const SizedBox(height: 8),
          SkeletonTile(width: 60, height: 10),
          const SizedBox(height: 4),
          SkeletonTile(width: 40, height: 16),
        ],
      ),
    );
  }

  Widget _buildWelcome(BuildContext context, MemberDashboardState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Bonjour,", style: LuminaDesign.labelOf(context)),
        Text(state.member?.firstName ?? "Disciple", style: LuminaDesign.h1Of(context)),
      ],
    );
  }

  Widget _buildKPIGrid(BuildContext context, MemberDashboardState state) {
    return Row(
      children: [
        Expanded(
          child: LuminaCard(
            color: LuminaDesign.primary.withOpacity(0.05),
            onTap: () => context.push(AppRoutes.memberDonations),
            child: Column(
              children: [
                Icon(Icons.favorite, color: LuminaDesign.primary),
                SizedBox(height: 8),
                Text("Mes Dons", style: LuminaDesign.labelOf(context)),
                Text("${state.totalContributions.toInt()} F", style: LuminaDesign.h2Of(context)),
              ],
            ),
          ),
        ),
        SizedBox(width: LuminaDesign.paddingMd),
        Expanded(
          child: LuminaCard(
            color: LuminaDesign.accent.withOpacity(0.05),
            onTap: () => context.push(AppRoutes.communaute),
            child: Column(
              children: [
                Icon(Icons.groups, color: LuminaDesign.accent),
                SizedBox(height: 8),
                Text("Mes Groupes", style: LuminaDesign.labelOf(context)),
                Text("${state.myGroups.length}", style: LuminaDesign.h2Of(context)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: LuminaDesign.paddingMd),
      child: Text(title.toUpperCase(), style: LuminaDesign.labelOf(context)),
    );
  }

  Widget _buildGroupsList(BuildContext context, MemberDashboardState state) {
    if (state.myGroups.isEmpty) {
      return Text("Vous n'avez pas encore rejoint de groupe.");
    }
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: state.myGroups.length,
        itemBuilder: (ctx, i) => Container(
          width: 80,
          margin: const EdgeInsets.only(right: LuminaDesign.paddingMd),
          child: Column(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: LuminaDesign.primary.withOpacity(0.1),
                child: Text(state.myGroups[i].name[0]),
              ),
              SizedBox(height: 4),
              Text(state.myGroups[i].name, overflow: TextOverflow.ellipsis, style: LuminaDesign.labelOf(context)),
            ],
          ),
        ),
      ),
    );
  }
}
