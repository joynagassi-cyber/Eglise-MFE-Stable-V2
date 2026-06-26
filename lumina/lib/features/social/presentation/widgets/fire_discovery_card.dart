import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../core/utils/haptic_helper.dart';
import '../../domain/entities/social_post.dart';
import 'package:intl/intl.dart';

/// Carte immersive "Discovery" pour le flux social horizontal.
/// Design raffiné, épuré et hautement professionnel.
class FireDiscoveryCard extends StatelessWidget {
  final SocialPost post;
  final VoidCallback? onTap;
  final VoidCallback? onPray;
  final VoidCallback? onAmen;
  final VoidCallback? onShare;

  const FireDiscoveryCard({
    super.key,
    required this.post,
    this.onTap,
    this.onPray,
    this.onAmen,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Hero(
      tag: 'post_${post.id}',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: context.colors.textPrimary.withValues(alpha: 0.2),
                blurRadius: 12.0,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Background (Image ou Gradient)
                _buildBackground(context, isDark),

                // Gradient de lisibilité (bas vers haut)
                _buildOverlayGradient(context),

                // Infos & Actions
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: _buildInfoOverlay(context, isDark),
                ),

                // Badge "Corps du Christ" (Optionnel - Type de post)
                Positioned(
                  top: 20,
                  right: 20,
                  child: _buildTypeBadge(context, isDark),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackground(BuildContext context, bool isDark) {
    if (post.imageUrls.isNotEmpty) {
      return CachedImageWidget(
        imageUrl: post.imageUrls.first,
        fit: BoxFit.cover,
      );
    }

    // Fallback sur un gradient "Fire Fusion" discret et simple
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [context.colors.bgPageDark, context.colors.bgCardDark]
              : [
                  context.colors.brandPrimary.withOpacity(0.05),
                  context.colors.bgPageLight
                ],
        ),
      ),
      child: Center(
        child: Opacity(
          opacity: 0.05,
          child: FaIcon(
            FontAwesomeIcons.church,
            size: 150,
            color: isDark ? context.colors.textPrimaryLight : context.colors.brandPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildOverlayGradient(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.5, 1.0],
          colors: [
            Colors.transparent,
            context.colors.glassDark
                .withValues(alpha: 0.6), // Réduit légèrement pour mieux respirer
          ],
        ),
      ),
    );
  }

  Widget _buildInfoOverlay(BuildContext context, bool isDark) {
    final theme = Theme.of(context);
    final contentColor = context.colors.textOnBrand;

    return GlassCard(
      blur: 8.0,
      padding: const EdgeInsets.all(AppSpacing.lg),
      borderRadius: 24.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              AvatarWidget(
                imageUrl: post.authorAvatarUrl,
                fallbackName: post.authorName,
                size: 40,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.authorName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: contentColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Outfit',
                      ),
                    ),
                    Text(
                      _formatDate(post.createdAt),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: contentColor.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            post.content,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: contentColor,
              height: 1.4,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSacredAction(
                icon: FontAwesomeIcons.fire,
                label: 'PRIER',
                count: post.likesCount,
                onTap: onPray,
                color: contentColor,
              ),
              _buildSacredAction(
                icon: FontAwesomeIcons.dove,
                label: 'AMEN',
                count: post.commentsCount,
                onTap: onAmen,
                color: contentColor,
              ),
              _buildSacredAction(
                icon: FontAwesomeIcons.handHoldingHeart,
                label: 'PARTAGER',
                onTap: onShare,
                color: contentColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSacredAction({
    required FaIconData icon,
    required String label,
    int? count,
    VoidCallback? onTap,
    required Color color,
  }) {
    return InkWell(
      onTap: () async {
        await HapticHelper.light();
        onTap?.call();
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(icon, color: color, size: 22),
          const SizedBox(height: 4),
          Text(
            count != null && count > 0 ? '$count $label' : label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
              fontFamily: 'Outfit',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeBadge(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: context.colors.brandPrimary.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.colors.brandPrimary.withOpacity(0.5), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(FontAwesomeIcons.cross, size: 10, color: context.colors.brandPrimary),
          const SizedBox(width: 6),
          Text(
            'FOI',
            style: TextStyle(
              color: context.colors.brandPrimary,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    if (difference.inDays > 0) return DateFormat('dd MMM').format(date);
    if (difference.inHours > 0) return '${difference.inHours}h';
    return 'Maintenant';
  }
}
