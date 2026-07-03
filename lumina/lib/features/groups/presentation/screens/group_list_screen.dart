// import 'package:lumina/core/theme/lumina_colors_extension.dart';
import 'package:lumina/core/extensions/context_extension.dart';
// lib/features/groups/presentation/screens/group_list_screen.dart
// Liste des groupes - Fire Theme - MIGRATED TO DESIGN SYSTEM

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lumina/core/router/app_routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumina/core/theme/app_typography.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import 'package:lumina/core/widgets/widgets.dart';
import 'package:lumina/core/utils/haptic_helper.dart';
import 'package:lumina/features/groups/domain/entities/group.dart';
import 'package:lumina/features/groups/presentation/providers/group_providers.dart';

class GroupListScreen extends ConsumerWidget {
  const GroupListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupsAsync = ref.watch(groupsProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Communautés',
          style: AppTypography.h3.copyWith(
            fontWeight: FontWeight.bold,
            color: context.colors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search_rounded),
            tooltip: 'Rechercher',
            onPressed: () async {
              await HapticHelper.medium();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Recherche : Bientôt disponible')),
                );
              }
            },
          ),
          SizedBox(width: 8),
        ],
      ),
      body: groupsAsync.when(
        data: (groups) {
          if (groups.isEmpty) {
            return AnimatedEntrance.fromBottom(
              delay: const Duration(milliseconds: 200),
              child: _buildEmptyState(context, isDark),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg, vertical: AppSpacing.md),
            itemCount: groups.length,
            separatorBuilder: (_, __) => SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) {
              final group = groups[index];
              return AnimatedEntrance.fromBottom(
                delay: Duration(milliseconds: 100 + (index * 50)),
                child: _GroupCard(group: group),
              );
            },
          );
        },
        loading: () => const LoadingState(skeleton: FireSkeletonMemberList()),
        error: (err, stack) =>
            const AppErrorWidget(message: 'Impossible de charger les groupes'),
      ),
      floatingActionButton: AnimatedEntrance.fromBottom(
        delay: const Duration(milliseconds: 300),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            gradient: context.colors.fireFusionGradient,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: context.colors.brandPrimary.withValues(alpha: 0.3),
                blurRadius: 12.0,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => context.push(AppRoutes.groupsNouveau),
              borderRadius: BorderRadius.circular(30),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add_rounded, color: context.colors.textInverse, size: LuminaIcon.md),
                    SizedBox(width: 12),
                    Text(
                      'CRÉER UN GROUPE',
                      style: AppTypography.labelLarge.copyWith(
                          color: context.colors.textInverse,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isDark) {
    return EmptyState(
      icon: Icons.groups_outlined,
      title: 'Aucune communauté',
      subtitle: 'Créez votre premier groupe ou cellule',
      actionLabel: 'CRÉER UN GROUPE',
      onAction: () async {
        await HapticHelper.light();
        if (context.mounted) unawaited(context.push(AppRoutes.groupsNouveau));
      },
    );
  }
}

class _GroupCard extends StatelessWidget {
  final Group group;

  const _GroupCard({required this.group});

  @override
  Widget build(BuildContext context) {
    final color = _getColorForType(context, group.type);

    return GlassCard(
      onTap: () => context.push(AppRoutes.groupDetailsWithId(group.id)),
      borderRadius: 24,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Hero(
            tag: 'group_icon_${group.id}',
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                _getIconForType(group.type),
                color: color,
                size: LuminaIcon.md,
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  group.name,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w800,
                    color: context.colors.textPrimary,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  _getLabelForType(group.type).toUpperCase(),
                  style: AppTypography.labelSmall.copyWith(
                    color: context.colors.textSecondary,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: context.colors.brandPrimary.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.arrow_forward_ios_rounded,
              color: context.colors.brandPrimary,
              size: LuminaIcon.xxs,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForType(GroupType type) {
    switch (type) {
      case GroupType.cellule:
        return Icons.home_work_rounded;
      case GroupType.ministere:
        return Icons.account_balance_rounded;
      case GroupType.equipe:
        return Icons.flag_rounded;
      case GroupType.chorale:
        return Icons.music_note_rounded;
      default:
        return Icons.group_rounded;
    }
  }

  Color _getColorForType(BuildContext context, GroupType type) {
    switch (type) {
      case GroupType.cellule:
        return context.colors.successText;
      case GroupType.ministere:
        return context.colors.infoText;
      case GroupType.equipe:
        return context.colors.brandSecondary;
      case GroupType.chorale:
        return context.colors.infoText;
      default:
        return context.colors.brandPrimary;
    }
  }

  String _getLabelForType(GroupType type) {
    switch (type) {
      case GroupType.cellule:
        return 'Cellule';
      case GroupType.ministere:
        return 'Département';
      case GroupType.equipe:
        return 'Équipe';
      case GroupType.chorale:
        return 'Chorale';
      default:
        return 'Groupe';
    }
  }
}
