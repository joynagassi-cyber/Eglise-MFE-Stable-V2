// import 'package:lumina/core/theme/lumina_colors_extension.dart';
import 'package:lumina/core/extensions/context_extension.dart';
// lib/features/groups/presentation/screens/group_detail_screen.dart
// Détail d'un groupe - Deep Purple Theme - MIGRATED TO DESIGN SYSTEM

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumina/core/theme/app_typography.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import 'package:lumina/core/utils/haptic_helper.dart';
import 'package:lumina/core/presentation/widgets/app_loading_indicator.dart';
import 'package:lumina/core/widgets/widgets.dart';
import 'package:lumina/core/router/app_routes.dart';
import 'package:lumina/features/groups/domain/entities/group.dart';
import 'package:lumina/features/groups/domain/entities/group_membership.dart';
import 'package:lumina/features/groups/presentation/providers/group_providers.dart';
import 'package:lumina/core/auth/domain/entities/enums/permission.dart';
import 'package:lumina/features/auth/presentation/widgets/permission_guard.dart';
import 'package:lumina/features/groups/presentation/widgets/group_assignment_dialog.dart';
import 'package:lumina/features/membres/presentation/providers/member_detail_provider.dart';
import 'package:lumina/features/messaging/presentation/providers/messaging_providers.dart';
import 'package:lumina/core/widgets/app_error_widget.dart' as core_error;
// import 'package:lumina/core/extensions/build_context_extensions.dart';

class GroupDetailScreen extends ConsumerWidget {
  final String groupId;

  const GroupDetailScreen({super.key, required this.groupId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final groupAsync = ref
        .watch(groupsProvider)
        .whenData((groups) => groups.where((g) => g.id == groupId).firstOrNull);
    final membersAsync = ref.watch(groupMembersProvider(groupId));

    return groupAsync.when(
      data: (group) {
        if (group == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const core_error.AppErrorWidget(
              message: 'Groupe introuvable',
            ),
          );
        }
        return Scaffold(
          body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              expandedHeight: 220,
              pinned: true,
              backgroundColor: Colors.transparent,
              leading: Center(
                child: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: context.colors.textInverse.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.arrow_back_ios_rounded,
                        color: context.colors.textInverse, size: LuminaIcon.sm),
                  ),
                  onPressed: () => context.pop(),
                ),
              ),
              actions: [
                PermissionGuard(
                  permission: Permission.groupsEdit,
                  child: Center(
                    child: IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: context.colors.textInverse.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.edit_rounded,
                            color: context.colors.textInverse, size: LuminaIcon.sm),
                      ),
                      onPressed: () =>
                          context.push(AppRoutes.groupModifierWithId(group.id)),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                        decoration: BoxDecoration(
                            gradient: context.colors.fireFusionGradient)),
                    Positioned(
                      right: -30,
                      top: -30,
                      child: Icon(
                        _getIconForType(group.type),
                        size: LuminaIcon.mega * 3, // Custom scale for large background icon
                        color: context.colors.textInverse.withValues(alpha: 0.1),
                      ),
                    ),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.xl),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: context.colors.textInverse.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                                child: Text(
                                  _getLabelForType(group.type).toUpperCase(),
                                  style: AppTypography.labelSmall.copyWith(
                                      color: context.colors.textInverse,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1),
                                ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              group.name,
                              style: AppTypography.h3.copyWith(
                                color: context.colors.textInverse,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          body: Container(
            decoration: BoxDecoration(
              color: context.colors.bgPage,
            ),
            child: Builder(
              builder: (context) {
                return Column(
                  children: [
                    _buildGroupInfo(context, group),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg, vertical: AppSpacing.md),
                      child: Row(
                        children: [
                          Text(
                            'MEMBRES ACTUELS',
                            style: AppTypography.labelSmall.copyWith(
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                              color: context.colors.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          membersAsync.maybeWhen(
                            data: (members) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: context.colors.brandPrimary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${members.length}',
                                style: AppTypography.labelSmall.copyWith(
                                    color: context.colors.brandPrimary,
                                    fontWeight: FontWeight.w900),
                              ),
                            ),
                            orElse: () => const SizedBox.shrink(),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: membersAsync.when(
                        data: (members) =>
                            _buildMembersList(context, ref, group, members, theme),
                        loading: () => const AppLoadingIndicator(),
                        error: (err, stack) => core_error.AppErrorWidget(message: err.toString()),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        floatingActionButton: Builder(
          builder: (context) {
//             final theme = Theme.of(context);
            return Semantics(
              label: 'Ajouter un membre au groupe',
              button: true,
              child: PermissionGuard(
                permission: Permission.groupsAssignMembers,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: context.colors.brandPrimaryGradient,
                    borderRadius: AppSpacing.borderRadiusLg,
                    boxShadow: AppSpacing.shadowPrimary(context.colors.brandPrimary),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () async {
                        await HapticHelper.light();
                        if (context.mounted) {
                          _showAddMemberDialog(context, ref, group);
                        }
                      },
                      borderRadius: AppSpacing.borderRadiusLg,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                              Icon(
                                Icons.person_add_rounded,
                                color: context.colors.textInverse,
                                size: LuminaIcon.md,
                              ),
            const SizedBox(width: 8),
                              Text(
                                'Ajouter',
                                style: AppTypography.bodySmall.copyWith(
                                  color: context.colors.textInverse,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    },
    loading: () => const Scaffold(body: Center(child: AppLoadingIndicator())),
    error: (err, stack) => Scaffold(
      body: Center(child: core_error.AppErrorWidget(message: err.toString())),
    ),
  );
  }

  Widget _buildGroupInfo(
    BuildContext context,
    Group group,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (group.description != null && group.description!.isNotEmpty) ...[
            Text(
              group.description!,
              style: AppTypography.bodyMedium.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: context.colors.bgCard,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                  color: context.colors.borderSubtle.withValues(alpha: 0.5)),
            ),
            child: Row(
              children: [
                if (group.location != null) ...[
                  Expanded(
                    child: Row(
                      children: [
                        Icon(Icons.location_on_rounded,
                            size: LuminaIcon.sm, color: context.colors.brandPrimary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            group.location!,
                            style: AppTypography.labelSmall.copyWith(
                              fontWeight: FontWeight.w600,
                              color: context.colors.textPrimary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                if (group.scheduleDescription != null) ...[
                  const SizedBox(width: 16),
                  Expanded(
                    child: Row(
                      children: [
                        Icon(Icons.schedule_rounded,
                            size: LuminaIcon.sm, color: context.colors.brandPrimary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            group.scheduleDescription!,
                            style: AppTypography.labelSmall.copyWith(
                              fontWeight: FontWeight.w600,
                              color: context.colors.textPrimary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (group.type == GroupType.chorale ||
              (group.name.toLowerCase().contains('chorale'))) ...[
            const SizedBox(height: AppSpacing.lg),
            _buildDashboardButton(
              context,
              'TABLEAU DE BORD CHORALE',
              context.colors.fireFusionGradient,
              () => context.push(AppRoutes.groupsChoraleWithId(group.id)),
            ),
          ],
          if (group.type == GroupType.hommes ||
              (group.name.toLowerCase().contains('hommes'))) ...[
            const SizedBox(height: AppSpacing.lg),
            _buildDashboardButton(
              context,
              'TABLEAU DE BORD HOMMES',
              context.colors.hommesGradient,
              () => context.push(AppRoutes.groupsHommesWithId(group.id)),
            ),
          ],
          if (group.type == GroupType.femmes ||
             (group.name.toLowerCase().contains('femmes'))) ...[
            const SizedBox(height: AppSpacing.lg),
            _buildDashboardButton(
              context,
              'TABLEAU DE BORD FEMMES',
              context.colors.femmesGradient,
              () => context.push(AppRoutes.groupsFemmesWithId(group.id)),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          _ChatAccessButton(groupId: groupId),
        ],
      ),
    );
  }

  Widget _buildDashboardButton(
    BuildContext context,
    String label,
    Gradient gradient,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: context.colors.brandPrimary.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton.icon(
          onPressed: () {
            HapticHelper.medium();
            onPressed();
          },
          icon: Icon(Icons.dashboard_rounded, color: context.colors.textInverse),
          label: Text(
            label,
            style: AppTypography.labelLarge.copyWith(
              color: context.colors.textInverse,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMembersList(
    BuildContext context,
    WidgetRef ref,
    Group group,
    List<GroupMembership> memberships,
    ThemeData theme,
  ) {
    if (memberships.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: context.colors.brandPrimary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.group_off_outlined,
                size: LuminaIcon.xxl,
                color: context.colors.brandPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Aucun membre dans ce groupe',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: context.colors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xs,),
      itemCount: memberships.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.smd),
      itemBuilder: (context, index) {
        final membership = memberships[index];
        return AnimatedEntrance.fromBottom(
          delay: Duration(milliseconds: 50 * index),
          child: _MemberRow(groupId: group.id, membership: membership),
        );
      },
    );
  }

  void _showAddMemberDialog(BuildContext context, WidgetRef ref, Group group) {
    unawaited(showDialog(
      context: context,
      builder: (context) => GroupAssignmentDialog(initialGroup: group),
    ));
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
      case GroupType.hommes:
        return Icons.directions_run_rounded;
      case GroupType.femmes:
        return Icons.auto_awesome_rounded;
      default:
        return Icons.group_rounded;
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
      case GroupType.hommes:
        return 'Hommes';
      case GroupType.femmes:
        return 'Femmes';
      default:
        return 'Groupe';
    }
  }
}

class _MemberRow extends ConsumerWidget {
  final String groupId;
  final GroupMembership membership;

  const _MemberRow({required this.groupId, required this.membership});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memberAsync = ref.watch(memberDetailProvider(membership.memberId));
    final theme = Theme.of(context);

    return memberAsync.when(
      data: (member) => Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(32),
          border:
              Border.all(color: context.colors.borderSubtle.withValues(alpha: 0.2)),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 4,
          ),
          leading: AvatarWidget(
            imageUrl: member?.photoUrl,
            fallbackName: member?.fullName ?? 'Membre inconnu',
            size: 44,
          ),
          title: Text(
            member?.fullName ?? 'Membre inconnu',
            style: AppTypography.labelLarge.copyWith(
              fontWeight: FontWeight.w800,
              color: context.colors.textPrimary,
            ),
          ),
          subtitle: Row(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: _getRoleColor(context, membership.role)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _getRoleLabel(membership.role).toUpperCase(),
                  style: AppTypography.labelSmall.copyWith(
                    fontWeight: FontWeight.w900,
                    color: _getRoleColor(context, membership.role),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          trailing: PermissionGuard(
            permission: Permission.groupsAssignMembers,
            child: PopupMenuButton<String>(
              icon: Icon(
                Icons.more_vert_rounded,
                color: context.colors.textSecondary,
                size: 20,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              onSelected: (value) async {
                await HapticHelper.light();
                if (value == 'remove') {
                  if (context.mounted) {
                    _confirmRemove(context, ref, member?.fullName, theme);
                  }
                } else {
                  final role = GroupRole.values.firstWhere(
                    (r) => r.name == value,
                  );
                  await ref
                      .read(groupControllerProvider.notifier)
                      .updateMemberRole(groupId, membership.id, role);
                  await HapticHelper.success();
                }
              },
              itemBuilder: (context) => [
                ...GroupRole.values.map(
                  (role) => PopupMenuItem(
                    value: role.name,
                    child: Row(
                      children: [
                        Icon(
                          _getRoleIcon(role),
                          size: AppSpacing.iconSm,
                          color: _getRoleColor(context, role),
                        ),
                        const SizedBox(width: 8),
                        Text(_getRoleLabel(role)),
                      ],
                    ),
                  ),
                ),
                const PopupMenuDivider(),
                PopupMenuItem(
                  value: 'remove',
                  child: Row(
                    children: [
                      Icon(
                        Icons.delete_outline_rounded,
                        size: AppSpacing.iconSm,
          color: context.colors.errorText,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Retirer',
                        style: AppTypography.bodySmall.copyWith(
                          color: context.colors.errorText,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      loading: () => Container(
        decoration: BoxDecoration(
          color: context.colors.bgCard,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const ListTile(title: AppProgressBar()),
      ),
      error: (err, _) => ListTile(
        title: Text(
          'Impossible de supprimer le membre',
          style: AppTypography.bodySmall.copyWith(
            color: context.colors.errorText,
          ),
        ),
      ),
    );
  }

  Color _getRoleColor(BuildContext context, GroupRole role) {
    switch (role) {
      case GroupRole.leader:
        return context.colors.brandPrimary;
      case GroupRole.coLeader:
        return context.colors.infoText;
      case GroupRole.member:
        return context.colors.textSecondary;
    }
  }

  IconData _getRoleIcon(GroupRole role) {
    switch (role) {
      case GroupRole.leader:
        return Icons.star_rounded;
      case GroupRole.coLeader:
        return Icons.star_half_rounded;
      case GroupRole.member:
        return Icons.person_rounded;
    }
  }

  String _getRoleLabel(GroupRole role) {
    switch (role) {
      case GroupRole.leader:
        return 'Leader';
      case GroupRole.coLeader:
        return 'Co-Leader';
      case GroupRole.member:
        return 'Membre';
    }
  }

  void _confirmRemove(
    BuildContext context,
    WidgetRef ref,
    String? name,
    ThemeData theme,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.colors.bgCard,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusCard,
        ),
        title: Text(
          'Retirer du groupe',
          style: AppTypography.h3.copyWith(
            color: context.colors.textPrimary,
          ),
        ),
        content: Text(
          'Voulez-vous vraiment retirer ${name ?? 'ce membre'} de ce groupe?',
          style: AppTypography.bodySmall.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await HapticHelper.light();
              if (context.mounted) Navigator.pop(context);
            },
            child: Text('Annuler', style: AppTypography.bodySmall.copyWith(color: context.colors.textPrimary)),
          ),
          TextButton(
            onPressed: () async {
              unawaited(ref
                  .read(groupControllerProvider.notifier)
                  .removeMemberFromGroup(groupId, membership.id));
              await HapticHelper.success();
              if (context.mounted) Navigator.pop(context);
            },
            child: Text(
              'Retirer',
              style: AppTypography.bodySmall.copyWith(
                color: context.colors.errorText,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// _PendingRequestsBadge was causing issues and was marked as unused, removing for now.

class _ChatAccessButton extends ConsumerWidget {
  final String groupId;

  const _ChatAccessButton({required this.groupId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          color: context.colors.bgPage,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: context.colors.brandPrimary.withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: context.colors.brandPrimary.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton.icon(
          onPressed: () async {
            await HapticHelper.medium();
            final getChat = ref.read(groupChatControllerProvider);
            final groupAsync = ref.read(groupsProvider).valueOrNull;
            final group = groupAsync?.where((g) => g.id == groupId).firstOrNull;
            final chatId = await getChat(groupId, group?.name ?? 'Chat du groupe');
            if (chatId != null && context.mounted) {
              unawaited(context.push(AppRoutes.messagingConversationWithId(chatId)));
            } else {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Impossible d\'ouvrir le chat du groupe')),
                );
              }
            }
          },
          icon: Icon(Icons.chat_bubble_rounded, color: context.colors.brandPrimary),
          label: Text(
            'CHAT DU GROUPE',
            style: AppTypography.labelLarge.copyWith(
              color: context.colors.brandPrimary,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
    );
  }
}