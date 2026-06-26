// lib/features/bergers/presentation/widgets/team_card.dart
// Carte pour afficher un membre de l'équipe pastorale

import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/haptic_helper.dart';
import 'package:lumina/core/widgets/widgets.dart';
import '../../../membres/domain/entities/entities.dart';

class TeamCard extends StatelessWidget {
  final Member member;

  const TeamCard({super.key, required this.member});

  void _showComingSoon(BuildContext context) async {
    await HapticHelper.light();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Action bientôt disponible',
            style: AppTypography.bodyMedium.copyWith(color: Colors.white),
          ),
          backgroundColor: context.colors.brandPrimary,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GlassCard(
      onTap: () => context.push(
        AppRoutes.brebisDetailsWithId(member.id),
      ), // Redirige vers le profil complet
      padding: EdgeInsets.zero,
      child: Stack(
        children: [
          // Fond décoratif pour le rôle (en haut)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 60,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(member.primaryRole.colorValue).withValues(alpha: 0.2),
                    Colors.transparent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Avatar avec bordure de rôle
                AvatarWidget(
                  imageUrl: member.photoUrl,
                  fallbackName: member.fullName,
                  size: 80,
                  borderColor: Color(member.primaryRole.colorValue),
                  borderWidth: 2,
                ),

                const SizedBox(height: 12),

                // Nom
                Text(
                  member.displayName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 4),

                // Rôle (Badge)
                StatusBadge.custom(
                  label: member.primaryRoleTitle ?? member.primaryRole.label,
                  colorValue: member.primaryRole.colorValue,
                  icon: member.primaryRole.icon,
                ),

                const SizedBox(height: 12),

                // Département / Ministère (simulé si pas dispo)
                if (member.ministries.isNotEmpty)
                  Text(
                    member.ministries.first.role ?? 'Membre', // Null-safe
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: context.colors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                else
                  Text(
                    'Leadership',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: context.colors.textSecondary,
                    ),
                  ),

                const Spacer(),

                // Actions (Appel / Message)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _SmallActionButton(
                      icon: Icons.phone,
                      color: context.colors.successText,
                      onTap: () => _showComingSoon(context),
                    ),
                    const SizedBox(width: 12),
                    _SmallActionButton(
                      icon: Icons.message,
                      color: context.colors.brandPrimary,
                      onTap: () => _showComingSoon(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _SmallActionButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18, color: color),
      ),
    );
  }
}
