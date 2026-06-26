import 'package:flutter/material.dart';
import 'package:lumina/core/theme/lumina_design_system.dart';

import 'package:lumina/core/widgets/lumina_glow_button.dart';
import '../../domain/entities/social_post.dart';
import 'package:intl/intl.dart';
import '../../../../core/extensions/context_extension.dart';

class SocialPostCard extends StatelessWidget {
  final SocialPost post;
  final VoidCallback? onLike;
  final VoidCallback? onComment;

  const SocialPostCard({
    super.key,
    required this.post,
    this.onLike,
    this.onComment,
  });

  @override
  Widget build(BuildContext context) {
    // Logique de détection de type (simplifiée pour le UI)
    final isPrayerRequest = post.content.toLowerCase().contains('prière') ||
        post.content.toLowerCase().contains('requête') ||
        post.content.toLowerCase().contains('priez');

    return LuminaCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: LuminaDesign.primary.withOpacity(0.1),
                backgroundImage: post.authorAvatarUrl != null ? NetworkImage(post.authorAvatarUrl!) : null,
                child: post.authorAvatarUrl == null ? Text(post.authorName[0]) : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(post.authorName, style: LuminaDesign.bodyLargeOf(context).copyWith(fontWeight: FontWeight.bold)),
                    Text(_formatDate(post.createdAt), style: LuminaDesign.labelOf(context)),
                  ],
                ),
              ),
              if (isPrayerRequest)
                const Icon(Icons.auto_awesome, color: LuminaDesign.secondary, size: 16),
            ],
          ),
          const SizedBox(height: 16),
          // Content
          Text(
            post.content,
            style: LuminaDesign.bodyLargeOf(context),
          ),
          if (post.imageUrls.isNotEmpty) ...[
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(LuminaDesign.radiusSm),
              child: Image.network(
                post.imageUrls.first,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
              ),
            ),
          ],
          const SizedBox(height: 20),
          // Actions Premium
          Row(
            children: [
              LuminaGlowButton(
                label: post.likesCount == 0 ? "PRIER" : "${post.likesCount} PRIÈRES",
                icon: Icons.auto_awesome_rounded,
                isActive: post.likesCount > 0,
                onTap: onLike ?? () {},
              ),
              const SizedBox(width: 12),
              LuminaGlowButton(
                label: post.commentsCount == 0 ? "AMEN" : "${post.commentsCount} AMEN",
                icon: Icons.chat_bubble_outline_rounded,
                isActive: post.commentsCount > 0,
                activeColor: LuminaDesign.accent,
                onTap: onComment ?? () {},
              ),
              const Spacer(),
              Icon(Icons.share_outlined, color: context.colors.textTertiary, size: 20),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays > 0) return DateFormat('dd MMM').format(date);
    if (diff.inHours > 0) return "Il y a ${diff.inHours}h";
    return "À l'instant";
  }
}
