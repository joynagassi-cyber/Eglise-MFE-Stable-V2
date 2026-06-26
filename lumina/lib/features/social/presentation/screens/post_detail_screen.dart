import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../core/utils/haptic_helper.dart';
import '../../domain/entities/social_post.dart';
import 'package:intl/intl.dart';

class PostDetailScreen extends StatelessWidget {
  final SocialPost post;

  const PostDetailScreen({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: context.colors.bgPage,
      body: CustomScrollView(
        slivers: [
          // AppBar Immersive avec Hero de l'image (si présente)
          SliverAppBar(
            expandedHeight: post.imageUrls.isNotEmpty ? 300 : 120,
            pinned: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: _buildCloseButton(context),
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'post_${post.id}',
                child: _buildHeaderBackground(context, isDark),
              ),
            ),
          ),

          // Contenu du Post
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Auteur & Date
                  Row(
                    children: [
                      AvatarWidget(
                        imageUrl: post.authorAvatarUrl,
                        fallbackName: post.authorName,
                        size: 48,
                      ),
                      SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post.authorName,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Outfit',
                              ),
                            ),
                            Text(
                              _formatFullDate(post.createdAt),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: context.colors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.xl),

                  // Texte de la publication (Focus Lecture)
                  Text(
                    post.content,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      height: 1.6,
                      fontSize: 18,
                      fontFamily: 'Inter',
                      color: context.colors.textPrimary,
                    ),
                  ),

                  SizedBox(height: AppSpacing.xxl),
                  Divider(),
                  SizedBox(height: AppSpacing.xl),

                  // Actions Sacrées
                  _buildActionsRow(theme),

                  SizedBox(height: AppSpacing.xxl),

                  // Espace pour les commentaires (Placeholder)
                  Text(
                    'AMEN (Commentaires)',
                    style: theme.textTheme.titleSmall?.copyWith(
                      letterSpacing: 1.5,
                      fontFamily: 'Outfit',
                      color: context.colors.brandPrimary,
                    ),
                  ),
                  SizedBox(height: AppSpacing.md),
                  _buildCommentsPlaceholder(context, isDark),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderBackground(BuildContext context, bool isDark) {
    if (post.imageUrls.isNotEmpty) {
      return CachedImageWidget(
        imageUrl: post.imageUrls.first,
        fit: BoxFit.cover,
      );
    }
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [context.colors.bgCardDark, context.colors.bgPageDark]
              : [context.colors.bgCardLight, context.colors.bgPageLight],
        ),
      ),
      child: Center(
        child: FaIcon(
          FontAwesomeIcons.church,
          size: 60,
          color: context.colors.brandPrimary.withValues(alpha: 0.1),
        ),
      ),
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CircleAvatar(
        backgroundColor: context.colors.bgScrim,
        child: IconButton(
          icon: Icon(Icons.close, color: context.colors.iconOnBrand, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
    );
  }

  Widget _buildActionsRow(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _SacredDetailAction(
          icon: FontAwesomeIcons.fire,
          label: 'PRIER',
          count: post.likesCount,
        ),
        _SacredDetailAction(
          icon: FontAwesomeIcons.dove,
          label: 'AMEN',
          count: post.commentsCount,
        ),
        const _SacredDetailAction(
          icon: FontAwesomeIcons.handHoldingHeart,
          label: 'PARTAGER',
        ),
      ],
    );
  }

  Widget _buildCommentsPlaceholder(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: context.colors.bgCard,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(
          'Aucun Amen pour le moment. Soyez le premier !',
          textAlign: TextAlign.center,
          style: TextStyle(fontStyle: FontStyle.italic, color: context.colors.textTertiary),
        ),
      ),
    );
  }

  String _formatFullDate(DateTime date) {
    return DateFormat('EEEE d MMMM yyyy, HH:mm', 'fr_FR').format(date);
  }
}

class _SacredDetailAction extends StatelessWidget {
  final FaIconData icon;
  final String label;
  final int? count;

  const _SacredDetailAction({
    required this.icon,
    required this.label,
    this.count,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        IconButton(
          icon: FaIcon(icon, color: context.colors.brandPrimary),
          onPressed: () => HapticHelper.medium(),
        ),
        Text(
          count != null && count! > 0 ? '$count $label' : label,
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.bold,
            fontFamily: 'Outfit',
          ),
        ),
      ],
    );
  }
}
