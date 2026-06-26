import "package:lumina/core/widgets/widgets.dart";
// lib/features/annonces/presentation/screens/annonce_detail_screen.dart
// Détail Annonce - Fire Theme - Premium Design

import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lumina/core/theme/app_spacing.dart';

import 'package:lumina/core/utils/haptic_helper.dart';



import 'package:lumina/core/providers/repository_providers_content.dart';
import 'package:lumina/features/annonces/domain/entities/annonce.dart';
import 'package:lumina/features/annonces/domain/entities/annonce_type.dart';

class AnnonceDetailScreen extends ConsumerWidget {
  final String annonceId;

  const AnnonceDetailScreen({super.key, required this.annonceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final annonceAsync = ref.watch(_annonceDetailProvider(annonceId));
    final theme = Theme.of(context);

    return annonceAsync.when(
      data: (annonce) {
        if (annonce == null) {
          return Scaffold(
            appBar: AppBar(),
            body: AppErrorWidget.notFound(
              message: 'Annonce non trouvée',
              onRetry: () => ref.invalidate(_annonceDetailProvider(annonceId)),
            ),
          );
        }
        return _buildContent(context, ref, annonce, theme);
      },
      loading: () => Scaffold(
        appBar: AppBar(),
        body: const LoadingState(message: 'Chargement de l\'annonce...'),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(),
        body: AppErrorWidget.server(
          technicalDetails: e.toString(),
          onRetry: () => ref.invalidate(_annonceDetailProvider(annonceId)),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    Annonce annonce,
    ThemeData theme,
  ) {
    final type = AnnonceType.fromString(annonce.type);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // HERO HEADER
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: context.colors.brandPrimary,
            leading: Semantics(
              label: 'Retour',
              button: true,
              child: IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Colors.white,
                    size: AppSpacing.iconSm,
                  ),
                ),
                onPressed: () async {
                  await HapticHelper.light();
                  if (context.mounted) context.pop();
                },
              ),
            ),
            actions: [
              if (annonce.isPinned)
                Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.push_pin_rounded,
                          color: Colors.white, size: 14),
                      SizedBox(width: 4),
                      Text(
                        'Épinglée',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: SyncStatusIndicator(isSynced: annonce.isSynced, compact: true),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Gradient background
                  Container(
                    decoration: BoxDecoration(gradient: context.colors.brandPrimaryGradient,
                    ),
                  ),
                  // Decorative icon
                  Positioned(
                    right: -30,
                    bottom: -30,
                    child: Icon(
                      Icons.campaign_rounded,
                      size: 200,
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                  // Content
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        bottom: 20,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Type badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  type.icon,
                                  style: const TextStyle(fontSize: 14),
                                ),
                                SizedBox(width: 6),
                                Text(
                                  type.label,
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 12),
                          // Title
                          Text(
                            annonce.title,
                            style: theme.textTheme.headlineMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // BODY
          SliverToBoxAdapter(
            child: Padding(
              padding: AppSpacing.screenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // META INFO ROW
                  AnimatedEntrance.fromBottom(
                    delay: const Duration(milliseconds: 100),
                    child: _buildMetaRow(context, annonce, theme, isDark),
                  ),

                  SizedBox(height: AppSpacing.lg),

                  // SUMMARY (if present)
                  if (annonce.summary != null &&
                      annonce.summary!.isNotEmpty) ...[
                    AnimatedEntrance.fromBottom(
                      delay: const Duration(milliseconds: 200),
                      child: Container(
                        width: double.infinity,
                        padding: AppSpacing.cardPadding,
                        decoration: BoxDecoration(
                          color: context.colors.brandPrimary.withValues(alpha: 0.06),
                          borderRadius: AppSpacing.borderRadiusCard,
                          border: Border.all(
                            color: context.colors.brandPrimary.withValues(alpha: 0.15),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.format_quote_rounded,
                              color: context.colors.brandPrimary.withValues(alpha: 0.5),
                              size: 24,
                            ),
                            SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Text(
                                annonce.summary!,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: context.colors.textPrimary,
                                  fontStyle: FontStyle.italic,
                                  height: 1.6,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: AppSpacing.lg),
                  ],

                  // CONTENT
                  if (annonce.content != null &&
                      annonce.content!.isNotEmpty) ...[
                    AnimatedEntrance.fromBottom(
                      delay: const Duration(milliseconds: 300),
                      child: Text(
                        'Contenu',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.colors.textPrimary,
                        ),
                      ),
                    ),
                    SizedBox(height: AppSpacing.smd),
                    AnimatedEntrance.fromBottom(
                      delay: const Duration(milliseconds: 400),
                      child: Container(
                        width: double.infinity,
                        padding: AppSpacing.cardPadding,
                        decoration: BoxDecoration(
                          color: context.colors.bgCard,
                          borderRadius: AppSpacing.borderRadiusCard,
                          border: Border.all(
                            color: context.colors.borderSubtle,
                          ),
                        ),
                        child: Text(
                          annonce.content!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: context.colors.textPrimary,
                            height: 1.7,
                          ),
                        ),
                      ),
                    ),
                  ],

                  // IMAGE
                  if (annonce.hasImage) ...[
                    SizedBox(height: AppSpacing.lg),
                    AnimatedEntrance.fromBottom(
                      delay: const Duration(milliseconds: 500),
                      child: ClipRRect(
                        borderRadius: AppSpacing.borderRadiusCard,
                        child: Image.network(
                          annonce.imageUrl!,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            height: 200,
                            decoration: BoxDecoration(
                              color: context.colors.bgCard,
                              borderRadius: AppSpacing.borderRadiusCard,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.broken_image_outlined,
                                color: context.colors.textSecondary,
                                size: 48,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],

                  // TAGS
                  if (annonce.tagsList.isNotEmpty) ...[
                    SizedBox(height: AppSpacing.lg),
                    AnimatedEntrance.fromBottom(
                      delay: const Duration(milliseconds: 600),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: annonce.tagsList.map((tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: context.colors.brandPrimary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: context.colors.brandPrimary.withValues(alpha: 0.2),
                              ),
                            ),
                            child: Text(
                              '#$tag',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: context.colors.brandPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],

                  // STATS ROW
                  SizedBox(height: AppSpacing.xl),
                  AnimatedEntrance.fromBottom(
                    delay: const Duration(milliseconds: 700),
                    child: _buildStatsRow(context, annonce, theme, isDark),
                  ),

                  SizedBox(height: AppSpacing.xxl * 2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaRow(
    BuildContext context,
    Annonce annonce,
    ThemeData theme,
    bool isDark,
  ) {
    final formattedDate =
        DateFormat('d MMMM yyyy', 'fr_FR').format(annonce.date);

    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: context.colors.bgCard,
        borderRadius: AppSpacing.borderRadiusMd,
        border: Border.all(color: context.colors.borderSubtle),
      ),
      child: Row(
        children: [
          // Date
          _buildMetaItem(
            context,
            theme,
            Icons.calendar_today_rounded,
            formattedDate,
          ),
          SizedBox(width: AppSpacing.lg),
          // Author
          if (annonce.authorName != null && annonce.authorName!.isNotEmpty)
            _buildMetaItem(
              context,
              theme,
              Icons.person_rounded,
              annonce.authorName!,
            ),
        ],
      ),
    );
  }

  Widget _buildMetaItem(
    BuildContext context,
    ThemeData theme,
    IconData icon,
    String text,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: context.colors.brandPrimary.withValues(alpha: 0.1),
            borderRadius: AppSpacing.borderRadiusSm,
          ),
          child: Icon(icon, color: context.colors.brandPrimary, size: 16),
        ),
        SizedBox(width: 8),
        Flexible(
          child: Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              color: context.colors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow(
    BuildContext context,
    Annonce annonce,
    ThemeData theme,
    bool isDark,
  ) {
    return Row(
      children: [
        // Views
        _buildStatChip(
          context,
          theme,
          Icons.visibility_outlined,
          '${annonce.viewsCount ?? 0}',
          'vues',
        ),
        SizedBox(width: AppSpacing.md),
        // Likes
        _buildStatChip(
          context,
          theme,
          Icons.favorite_border_rounded,
          '${annonce.likesCount ?? 0}',
          'j\'aime',
        ),
      ],
    );
  }

  Widget _buildStatChip(
    BuildContext context,
    ThemeData theme,
    IconData icon,
    String count,
    String label,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: context.colors.bgCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.colors.borderSubtle),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: context.colors.textSecondary, size: 16),
          SizedBox(width: 6),
          Text(
            '$count $label',
            style: theme.textTheme.labelSmall?.copyWith(
              color: context.colors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

final _annonceDetailProvider =
    FutureProvider.family.autoDispose<Annonce?, String>((ref, id) {
  final repo = ref.watch(annonceRepositoryProvider);
  return repo.getAnnonceById(id);
});
