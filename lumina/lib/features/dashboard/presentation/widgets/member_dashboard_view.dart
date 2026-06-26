import "package:lumina/core/widgets/widgets.dart";
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumina/core/theme/lumina_design_system.dart';
import '../providers/member_dashboard_provider.dart';
import 'package:lumina/features/bible/reader/widgets/daily_bible_card.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_routes.dart';

class MemberDashboardView extends ConsumerWidget {
  const MemberDashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(memberDashboardProvider);

    return dashboardState.when(
      data: (state) => SingleChildScrollView(
        padding: const EdgeInsets.all(LuminaDesign.paddingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcome(state),
            const SizedBox(height: LuminaDesign.paddingLg),
            _buildKPIGrid(context, state),
            const SizedBox(height: LuminaDesign.paddingLg),
            const DailyBibleCard(),
            const SizedBox(height: LuminaDesign.paddingLg),
            _buildSectionTitle("Ma Communauté"),
            _buildGroupsList(state),
          ],
        ),
      ),
      loading: () => const LoadingState(),
      error: (e, st) => Center(child: Text("Erreur : $e")),
    );
  }

  Widget _buildWelcome(MemberDashboardState state) {
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
                const Icon(Icons.favorite, color: LuminaDesign.primary),
                const SizedBox(height: 8),
                Text("Mes Dons", style: LuminaDesign.labelOf(context)),
                Text("${state.totalContributions.toInt()} F", style: LuminaDesign.h2Of(context)),
              ],
            ),
          ),
        ),
        const SizedBox(width: LuminaDesign.paddingMd),
        Expanded(
          child: LuminaCard(
            color: LuminaDesign.accent.withOpacity(0.05),
            onTap: () => context.push(AppRoutes.communaute),
            child: Column(
              children: [
                const Icon(Icons.groups, color: LuminaDesign.accent),
                const SizedBox(height: 8),
                Text("Mes Groupes", style: LuminaDesign.labelOf(context)),
                Text("${state.myGroups.length}", style: LuminaDesign.h2Of(context)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: LuminaDesign.paddingMd),
      child: Text(title.toUpperCase(), style: LuminaDesign.labelOf(context)),
    );
  }

  Widget _buildGroupsList(MemberDashboardState state) {
    if (state.myGroups.isEmpty) {
      return const Text("Vous n'avez pas encore rejoint de groupe.");
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
              const SizedBox(height: 4),
              Text(state.myGroups[i].name, overflow: TextOverflow.ellipsis, style: LuminaDesign.labelOf(context)),
            ],
          ),
        ),
      ),
    );
  }
}
