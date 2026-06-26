// lib/features/profile/presentation/widgets/member_groups_widget.dart
import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/skeletons/fire_skeleton_system.dart';
import '../../../../core/theme/app_typography.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import '../../../../core/theme/lumina_colors_extension.dart';
import '../../../../features/groups/presentation/providers/group_providers.dart';
import '../../../../features/groups/domain/entities/group.dart';
import '../../../../features/groups/domain/entities/group_membership.dart';

// ─── Helpers ──────────────────────────────────────────────────────────────

extension _GroupTypeExt on GroupType {
  String get emoji {
    switch (this) {
      case GroupType.cellule:      return '';
      case GroupType.ministere:    return '';
      case GroupType.equipe:       return '👥';
      case GroupType.chorale:      return '🎶';
      case GroupType.hommes:       return '🙋';
      case GroupType.femmes:       return '🌸';
      case GroupType.jeunesse:     return '';
      case GroupType.enfants:      return '🧒';
      case GroupType.intercession: return '';
      case GroupType.autre:        return '📌';
    }
  }
}

class MemberGroupsWidget extends ConsumerWidget {
  const MemberGroupsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeGroupsAsync  = ref.watch(myMemberGroupsProvider);
    final pendingGroupsAsync = ref.watch(myPendingGroupRequestsProvider);
    final allGroupsAsync     = ref.watch(groupsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.mlg, vertical: AppSpacing.sm),
          child: Text('Mes Départements & Groupes',
              style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.bold)),
        ),

        // ── Groupes actifs ──────────────────────────────────────────────────
        activeGroupsAsync.when(
          loading: () => const _ShimmerList(),
          error: (e, _) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.mlg),
            child: Text('Impossible de charger les groupes',
                style: AppTypography.bodyMedium.copyWith(color: context.colors.errorText)),
          ),
          data: (memberships) {
            if (memberships.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.mlg, vertical: AppSpacing.sm),
                child: Text('Aucun groupe actif.',
                    style: AppTypography.bodyMedium.copyWith(color: context.colors.textSecondary)),
              );
            }
            return allGroupsAsync.when(
              loading: () => const _ShimmerList(),
              error: (_, __) => const _ShimmerList(),
              data: (groups) {
                final groupMap = {for (final g in groups) g.id: g};
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: memberships.length,
                  itemBuilder: (context, index) {
                    final m = memberships[index];
                    final g = groupMap[m.groupId];
                    return _GroupTile(
                      name:      g?.name    ?? m.groupId,
                      emoji:     g?.type.emoji ?? '📌',
                      isPrimary: m.role == GroupRole.leader,
                      status:    'Actif',
                      color:     context.colors.successText,
                    );
                  },
                );
              },
            );
          },
        ),

        // ── Demandes en attente ──────────────────────────────────────────────
        pendingGroupsAsync.when(
          loading: () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.md),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.mlg, vertical: AppSpacing.xs),
                child: Text('En attente de validation',
                    style: AppTypography.labelLarge.copyWith(
                        color: context.colors.textSecondary,
                        fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: AppSpacing.xs),
              const _ShimmerList(),
            ],
          ),

          error: (e, st) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.mlg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.md),
                Text('En attente de validation',
                    style: AppTypography.labelLarge.copyWith(
                        color: context.colors.textSecondary,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: AppSpacing.sm),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.smd),
                  decoration: BoxDecoration(
                    color: context.colors.errorBg,
                    borderRadius: AppSpacing.borderRadiusSm,
                    border: Border.all(color: context.colors.errorText),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Erreur lors du chargement des demandes.',
                          style: AppTypography.bodyMedium.copyWith(color: context.colors.errorText)),
                      const SizedBox(height: AppSpacing.sm),
                      ElevatedButton.icon(
                        onPressed: () => ref.refresh(myPendingGroupRequestsProvider),
                        icon: const Icon(Icons.refresh, size: LuminaIcon.sm),
                        label: const Text('Réessayer'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.colors.errorBg,
                          foregroundColor: context.colors.errorText,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          data: (requests) {
            if (requests.isEmpty) return const SizedBox();
            return allGroupsAsync.when(
              loading: () => const SizedBox(),
              error: (_, __) => const SizedBox(),
              data: (groups) {
                final groupMap = {for (final g in groups) g.id: g};
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSpacing.md),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.mlg, vertical: AppSpacing.xs),
                      child: Text('En attente de validation',
                          style: AppTypography.labelLarge.copyWith(
                              color: context.colors.textSecondary,
                              fontWeight: FontWeight.bold)),
                    ),
                    ...requests.map((r) {
                      final g = groupMap[r.groupId];
                      return _GroupTile(
                        name:      g?.name    ?? r.groupId,
                        emoji:     g?.type.emoji ?? '📌',
                        isPrimary: false,
                        status:    'En attente',
                        color:     context.colors.warningText,
                      );
                    }),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class _GroupTile extends StatelessWidget {
  final String name;
  final String emoji;
  final bool isPrimary;
  final String status;
  final Color color;

  const _GroupTile({
    required this.name,
    required this.emoji,
    required this.isPrimary,
    required this.status,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.mlg, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: context.colors.bgCard,
        borderRadius: AppSpacing.borderRadiusMd,
        border: Border.all(color: context.colors.borderLight),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: AppSpacing.borderRadiusSm,
          ),
          child: Text(emoji, style: AppTypography.headlineSmall),
        ),
        title: Text(name,
            style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.bold)),
        subtitle: isPrimary
            ? Text('Chef de groupe', style: AppTypography.labelMedium)
            : null,
        trailing: Container(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: AppSpacing.borderRadiusMd,
          ),
          child: Text(status,
              style: AppTypography.labelSmall.copyWith(
                  color: color, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}

class _ShimmerList extends StatelessWidget {
  const _ShimmerList();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        children: List.generate(
            2,
            (i) => const Padding(
                  padding: EdgeInsets.only(bottom: AppSpacing.smd),
                  child: FireSkeletonTransactionItem(),
                )),
      ),
    );
  }
}
