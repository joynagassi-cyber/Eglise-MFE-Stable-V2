// lib/features/social/presentation/screens/post_detail_screen.dart
// Écran de détail d'une publication — avec badges IA et panel de modération admin

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumina/core/theme/lumina_design_system.dart';
import 'package:lumina/core/widgets/lumina_page.dart';
import 'package:lumina/features/social/domain/entities/social_post.dart';
import 'package:lumina/features/social/presentation/providers/social_providers.dart';
import 'package:lumina/features/social/presentation/widgets/ai_post_badge.dart';
import 'package:lumina/features/social/presentation/widgets/flagged_post_banner.dart';
import 'package:lumina/features/social/presentation/widgets/admin_moderation_panel.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:intl/intl.dart';

class PostDetailScreen extends ConsumerWidget {
  final SocialPost post;

  const PostDetailScreen({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LuminaPage(
      title: "Publication",
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(LuminaDesign.paddingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: LuminaDesign.primary.withOpacity(0.1),
                  backgroundImage: post.authorAvatarUrl != null
                      ? NetworkImage(post.authorAvatarUrl!)
                      : null,
                  child: post.authorAvatarUrl == null
                      ? Text(post.authorName[0])
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.authorName,
                        style: LuminaDesign.bodyLargeOf(context).copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _formatDate(post.createdAt),
                        style: LuminaDesign.labelOf(context),
                      ),
                    ],
                  ),
                ),

                // Badge IA si c'est un post généré
                if (post.isAiGenerated)
                  AiPostBadge(
                    bibleVerse: post.aiBibleVerse,
                    bibleText: post.aiBibleText,
                  ),
              ],
            ),

            const SizedBox(height: 20),

            // Texte du verset biblique (si post IA)
            if (post.isAiGenerated && post.aiBibleText != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: LuminaDesign.primary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(LuminaDesign.radiusMd),
                  border: Border.all(
                    color: LuminaDesign.primary.withOpacity(0.15),
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      color: LuminaDesign.secondary,
                      size: 20,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${post.aiBibleText}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                        color: context.colors.textPrimary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '— ${post.aiBibleVerse ?? ''}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: LuminaDesign.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Contenu
            Text(
              post.content,
              style: LuminaDesign.bodyLargeOf(context).copyWith(
                height: 1.6,
                fontSize: 16,
              ),
            ),

            // Image
            if (post.imageUrls.isNotEmpty) ...[
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(LuminaDesign.radiusMd),
                child: Image.network(
                  post.imageUrls.first,
                  height: 280,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Stats
            Row(
              children: [
                _buildStatChip(context, Icons.favorite_rounded,
                    '${post.likesCount} prières'),
                const SizedBox(width: 12),
                _buildStatChip(context, Icons.chat_bubble_outline_rounded,
                    '${post.commentsCount} amen'),
              ],
            ),

            const SizedBox(height: 16),

            // Bannière de modération (si le post est signalé)
            if (post.status == 'flagged' && post.moderationReason != null)
              FlaggedPostBanner(
                reason: post.moderationReason!,
                severity: post.moderationScore ?? 0,
              ),

            // Panel admin (visible uniquement pour les admins)
            if (post.status == 'flagged')
              AdminModerationPanel(post: post),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(BuildContext context, IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: context.colors.bgPage,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.colors.borderDefault),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: context.colors.textSecondary),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: context.colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays > 7) return DateFormat('dd MMM yyyy').format(date);
    if (diff.inDays > 0) return 'Il y a ${diff.inDays}j';
    if (diff.inHours > 0) return 'Il y a ${diff.inHours}h';
    if (diff.inMinutes > 0) return 'Il y a ${diff.inMinutes}min';
    return "À l'instant";
  }
}
