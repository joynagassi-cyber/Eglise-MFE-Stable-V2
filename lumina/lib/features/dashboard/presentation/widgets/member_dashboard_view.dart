import "package:lumina/core/widgets/widgets.dart";
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumina/core/theme/lumina_design_system.dart';
import '../providers/member_dashboard_provider.dart';
import 'package:lumina/features/bible/reader/widgets/daily_bible_card.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_routes.dart';
import 'package:lumina/core/widgets/loading_state.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:lumina/core/theme/app_spacing.dart';

class MemberDashboardView extends ConsumerWidget {
  const MemberDashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(memberDashboardProvider);

    return dashboardState.when(
      data: (state) => _buildContent(context, state),
      loading: () => _buildLoadingContent(context),
      error: (e, st) => _buildContent(context, MemberDashboardState.empty),
    );
  }

  Widget _buildContent(BuildContext context, MemberDashboardState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: LuminaDesign.paddingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          _buildWelcome(context, state),
          const SizedBox(height: 24),
          _buildKPIGrid(context, state),
          const SizedBox(height: 20),
          const DailyBibleCard(),
          const SizedBox(height: 20),
          _buildSectionTitle(context, "Ma Communauté"),
          const SizedBox(height: 12),
          _buildGroupsList(context, state),
          const SizedBox(height: 100), // espace pour la bottom nav
        ],
      ),
    );
  }

  Widget _buildWelcome(BuildContext context, MemberDashboardState state) {
    final firstName = state.member?.firstName?.trim();
    final greeting = firstName != null && firstName.isNotEmpty ? firstName : 'Disciple';
    
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bonjour,',
                style: LuminaDesign.labelOf(context).copyWith(
                  fontSize: 13,
                  color: context.colors.textSecondary,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                greeting,
                style: LuminaDesign.h1Of(context).copyWith(fontSize: 28),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      context.colors.brandPrimary.withValues(alpha: 0.15),
                      context.colors.brandSecondary.withValues(alpha: 0.1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: context.colors.brandPrimary.withValues(alpha: 0.2),
                    width: 0.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.church_rounded,
                      size: 12,
                      color: context.colors.brandPrimary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'MFE-JC',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: context.colors.brandPrimary,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Avatar décoratif avec glow
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: context.colors.brandGradient,
            boxShadow: [
              BoxShadow(
                color: context.colors.brandPrimary.withValues(alpha: 0.3),
                blurRadius: 16,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Icon(
            Icons.person_rounded,
            color: Colors.white,
            size: 28,
          ),
        ),
      ],
    );
  }

  Widget _buildKPIGrid(BuildContext context, MemberDashboardState state) {
    return Row(
      children: [
        Expanded(
          child: _buildKPICard(
            context,
            icon: Icons.favorite_rounded,
            iconBg: context.colors.errorText.withValues(alpha: 0.12),
            iconColor: context.colors.errorText,
            label: 'Mes Dons',
            value: '${state.totalContributions.toInt()} F',
            route: AppRoutes.memberDonations,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _buildKPICard(
            context,
            icon: Icons.groups_rounded,
            iconBg: context.colors.brandPrimary.withValues(alpha: 0.12),
            iconColor: context.colors.brandPrimary,
            label: 'Mes Groupes',
            value: '${state.myGroups.length}',
            route: AppRoutes.communaute,
          ),
        ),
      ],
    );
  }

  Widget _buildKPICard(
    BuildContext context, {
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String label,
    required String value,
    required String route,
  }) {
    return GestureDetector(
      onTap: () => context.push(route),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              context.colors.bgCard,
              context.colors.bgCard.withValues(alpha: 0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: context.colors.borderSubtle.withValues(alpha: 0.6),
            width: 0.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(height: 14),
            Text(
              label,
              style: LuminaDesign.labelOf(context).copyWith(
                fontSize: 12,
                color: context.colors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: LuminaDesign.h2Of(context).copyWith(fontSize: 22),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4, left: 4),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 16,
            decoration: BoxDecoration(
              gradient: context.colors.brandGradient,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title.toUpperCase(),
            style: LuminaDesign.labelOf(context).copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: context.colors.textSecondary,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupsList(BuildContext context, MemberDashboardState state) {
    if (state.myGroups.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: context.colors.bgCard.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: context.colors.borderSubtle.withValues(alpha: 0.4),
            width: 0.5,
          ),
        ),
        child: Column(
          children: [
            Icon(
              Icons.group_rounded,
              size: 32,
              color: context.colors.textTertiary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 8),
            Text(
              'Vous n\'avez pas encore rejoint de groupe.',
              style: LuminaDesign.labelOf(context),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: state.myGroups.length,
        itemBuilder: (ctx, i) {
          final group = state.myGroups[i];
          return Container(
            width: 88,
            margin: const EdgeInsets.only(right: 12),
            child: Column(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        context.colors.brandPrimary.withValues(alpha: 0.2),
                        context.colors.brandSecondary.withValues(alpha: 0.15),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    border: Border.all(
                      color: context.colors.brandPrimary.withValues(alpha: 0.25),
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      group.name.isNotEmpty ? group.name[0].toUpperCase() : '?',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: context.colors.brandPrimary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  group.name,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: LuminaDesign.labelOf(context).copyWith(fontSize: 11),
                  maxLines: 1,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Skeleton de chargement aligné avec la structure redesignée
  Widget _buildLoadingContent(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: LuminaDesign.paddingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          // Skeleton header
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonTile(width: 80, height: 12),
                    const SizedBox(height: 6),
                    SkeletonTile(width: 120, height: 24),
                  ],
                ),
              ),
              SkeletonTile(width: 52, height: 52, shape: BoxShape.circle),
            ],
          ),
          const SizedBox(height: 28),
          // Skeleton KPI cards
          Row(
            children: [
              Expanded(child: _buildKPISkeleton(context)),
              const SizedBox(width: 14),
              Expanded(child: _buildKPISkeleton(context)),
            ],
          ),
          const SizedBox(height: 20),
          // Bible card skeleton
          SkeletonTile(
            width: double.infinity,
            height: 120,
            borderRadius: 16,
          ),
          const SizedBox(height: 20),
          // Section title
          Row(
            children: [
              SkeletonTile(width: 4, height: 16),
              const SizedBox(width: 8),
              SkeletonTile(width: 100, height: 12),
            ],
          ),
          const SizedBox(height: 12),
          // Groups skeleton
          SizedBox(
            height: 110,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: List.generate(4, (_) => Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Column(
                  children: [
                    SkeletonTile(width: 60, height: 60, shape: BoxShape.circle),
                    const SizedBox(height: 8),
                    SkeletonTile(width: 60, height: 10),
                  ],
                ),
              )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKPISkeleton(BuildContext context) {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.colors.bgCard.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: context.colors.borderSubtle.withValues(alpha: 0.4),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonTile(width: 40, height: 40, shape: BoxShape.circle),
          const SizedBox(height: 14),
          SkeletonTile(width: 60, height: 10),
          const SizedBox(height: 4),
          SkeletonTile(width: 40, height: 20),
        ],
      ),
    );
  }
}
