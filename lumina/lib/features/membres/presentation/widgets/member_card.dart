import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:lumina/core/router/app_routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/services/offline_sync_manager.dart';
import '../../../../core/utils/haptic_helper.dart';
import 'package:lumina/core/widgets/widgets.dart';
import '../../domain/entities/member.dart';
import '../../domain/entities/enums/enums.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import '../../../groups/presentation/providers/engagement_provider.dart';
import '../../../../core/widgets/role_badge.dart';

import 'member_attendance_history_dialog.dart';

/// Carte de membre pour la liste
class MemberCard extends ConsumerWidget {
  final Member member;
  final VoidCallback? onTap;
  final bool showActions;
  final MemberEngagement? engagement;

  const MemberCard({
    super.key,
    required this.member,
    this.onTap,
    this.showActions = false,
    this.engagement,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    // Watch for sync pending status
    final isPending =
        ref.watch(isRecordPendingProvider(member.id)).value ?? false;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(32.0),
        border: Border.all(
          color: context.colors.borderSubtle.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: _getBorderColor(context, member).withValues(alpha: 0.05),
            blurRadius: 12.0,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap ??
            () {
              HapticHelper.selection();
              context.push(AppRoutes.brebisDetailsWithId(member.id));
            },
        borderRadius: BorderRadius.circular(32.0),
        child: Row(
          children: [
            // Avatar avec Hero Animation
            Hero(
              tag: 'avatar_${member.id}',
              child: Stack(
                children: [
                    AvatarWidget(
                      imageUrl: member.photoUrl,
                      fallbackName: member.fullName,
                      size: 60,
                      borderColor: _getBorderColor(context, member),
                      borderWidth: member.isLeader ? 2 : 0,
                      showOnlineIndicator: true,
                      isOnline: member.status == MemberStatus.active,
                    ),
                  if (isPending)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: context.colors.warningText,
                          shape: BoxShape.circle,
                          border: Border.all(color: theme.cardColor, width: 2),
                        ),
                        child: Icon(
                          Icons.sync,
                          size: 8,
                          color: context.colors.textOnBrand,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(width: AppSpacing.md),

            // Infos principales
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nom
                  Text(
                    member.displayName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.4,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 2),

                  // Rôle / Profession via le nouveau composant universel
                  RoleBadge(
                    roleCode: member.primaryRoleType ?? 'membre_simple',
                    customLabel: member.primaryRoleTitle ??
                        member.profession ??
                        member.primaryRole.label,
                  ),

                  const SizedBox(height: 10),

                  // Badges
                  _buildPillBadges(context, member),
                ],
              ),
            ),

            // Actions ou chevron
            if (showActions)
              _buildActions(context)
            else
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: context.colors.textSecondaryLight.withValues(alpha: 0.05),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.chevron_right_rounded,
                  size: 18,
                  color: context.colors.textTertiary,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPillBadges(BuildContext context, Member member) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: _buildBadges(context, member),
    );
  }

  Color _getBorderColor(BuildContext context, Member member) {
    if (member.primaryRole.level <= 3) {
      return context.colors.warningText; // Pasteur
    }
    if (member.primaryRole.level <= 5) {
      return context.colors.textSecondary; // Ancien/Diacre
    }
    if (member.isLeader) {
      return context.colors.brandSecondary;
    }
    return context.colors.brandPrimary;
  }

  List<Widget> _buildBadges(BuildContext context, Member member) {
    final badges = <Widget>[];

    // Statut
    badges.add(
      StatusBadge.custom(
        label: member.status.label,
        colorValue: member.status.colorValue,
        icon: member.status.icon,
      ),
    );

    // Baptisé
    if (member.isBaptized) {
      badges.add(StatusBadge.baptized());
    }

    // Leader
    if (member.isLeader) {
      badges.add(
        StatusBadge.custom(
          label: member.primaryRole.label,
          colorValue: member.primaryRole.colorValue,
          icon: member.primaryRole.icon,
        ),
      );
    }

    // Engagé (Fidélité)
    if (engagement != null) {
      badges.add(
        StatusBadge.custom(
          label: engagement!.level == EngagementLevel.high
              ? 'Très Actif'
              : 'Actif',
          colorValue: engagement!.level == EngagementLevel.high
              ? context.colors.successText.toARGB32()
              : context.colors.brandPrimary.toARGB32(),
          icon: engagement!.level == EngagementLevel.high
              ? ''
              : (engagement!.isTrendingUp ? '📈' : '📉'),
        ),
      );
    }

    return badges;
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (member.phone != null)
          IconButton(
            icon: Icon(Icons.phone, color: context.colors.successText, size: 20),
            onPressed: () async {
              final url = Uri.parse('tel:${member.phone}');
              if (await canLaunchUrl(url)) {
                await launchUrl(url);
              }
            },
            tooltip: 'Appeler',
          ),
        if (member.whatsapp != null || member.acceptsWhatsApp)
          IconButton(
            icon: Icon(Icons.chat, color: context.colors.successText, size: 20),
            onPressed: () async {
              final phone = member.whatsapp ?? member.phone;
              if (phone != null) {
                final url = Uri.parse('https://wa.me/$phone');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                }
              }
            },
            tooltip: 'WhatsApp',
          ),
        IconButton(
          icon: Icon(Icons.analytics_outlined,
              color: context.colors.brandPrimary, size: 20),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) =>
                  MemberAttendanceHistoryDialog(member: member),
            );
          },
          tooltip: 'Historique Assiduité 360',
        ),
      ],
    );
  }
}

/// Carte de membre compacte (pour les listes denses)
class MemberCardCompact extends StatelessWidget {
  final Member member;
  final VoidCallback? onTap;

  const MemberCardCompact({super.key, required this.member, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      onTap: onTap ?? () => context.push(AppRoutes.brebisDetailsWithId(member.id)),
      leading: AvatarWidget(
        imageUrl: member.photoUrl,
        fallbackName: member.fullName,
        size: 44,
        showOnlineIndicator: true,
        isOnline: member.status == MemberStatus.active,
      ),
      title: Text(
        member.displayName,
        style: theme.textTheme.titleSmall,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: RoleBadge(
          roleCode: member.primaryRoleType ?? 'membre_simple',
          customLabel: member.primaryRoleTitle ?? member.primaryRole.label,
        ),
      ),
      trailing: member.isBaptized
          ? const Text('✝️', style: TextStyle(fontSize: 16))
          : null,
    );
  }
}
