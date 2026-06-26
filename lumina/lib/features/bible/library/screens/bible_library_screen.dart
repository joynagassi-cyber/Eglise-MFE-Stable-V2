import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import 'package:lumina/core/widgets/widgets.dart';
import '../../../../core/router/app_routes.dart';
import 'package:lumina/features/bible/domain/entities/bible_entities.dart';
import 'package:lumina/features/bible/library/providers/bible_library_notifier.dart';
// import 'package:lumina/core/extensions/build_context_extensions.dart';

class BibleLibraryScreen extends ConsumerWidget {
  const BibleLibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(bibleLibraryNotifierProvider);
    final notifier = ref.read(bibleLibraryNotifierProvider.notifier);
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.bgPrimary,
      appBar: AppBar(
        title: const Text('MA BIBLIOTHÈQUE'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: colors.iconPrimary, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: state.isLoading
          ? const Center(child: LoadingState())
          : Column(
              children: [
                if (state.collections.length > 1) _buildCollectionChips(context, state, notifier),
                Expanded(
                  child: state.bookmarks.isEmpty ? _buildEmpty(context, state.activeCollection) : _buildList(context, state),
                ),
              ],
            ),
    );
  }

  Widget _buildCollectionChips(BuildContext context, BibleLibraryState state, BibleLibraryNotifier notifier) {
//     final colors = context.colors;
    return SizedBox(
      height: 52,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          _buildChip(context, 'Tous', state.activeCollection == null, () {
            notifier.setActiveCollection(null);
          }),
          ...state.collections.map((c) => Padding(
                padding: const EdgeInsets.only(left: 8),
                child: _buildChip(context, c, state.activeCollection == c, () {
                  notifier.setActiveCollection(state.activeCollection == c ? null : c);
                }),
              )),
        ],
      ),
    );
  }

  Widget _buildChip(BuildContext context, String label, bool isActive, VoidCallback onTap) {
    final colors = context.colors;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: isActive ? colors.brandGradient : null,
          color: isActive ? null : colors.bgSecondary,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? Colors.transparent : colors.borderSubtle,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? colors.textOnBrand : colors.textTertiary,
            fontSize: 12,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context, String? activeCollection) {
    final colors = context.colors;
    return FadeInUp(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colors.accent.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.favorite_border_rounded,
                color: colors.accent,
                size: 56,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              activeCollection != null
                  ? 'Aucun favori dans "$activeCollection"'
                  : 'Aucun favori',
              style: AppTypography.h3.copyWith(
                color: colors.textSecondary,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: Text(
                'Ouvrez le lecteur biblique et sélectionnez des versets pour les ajouter à votre bibliothèque.',
                textAlign: TextAlign.center,
                style: AppTypography.bodySmallStyle.copyWith(
                  color: colors.textDisabled,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context, BibleLibraryState state) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: state.bookmarks.length,
      itemBuilder: (context, index) {
        return FadeInLeft(
          duration: Duration(milliseconds: 300 + (index * 50)),
          child: _BibleBookmarkTile(bookmark: state.bookmarks[index]),
        );
      },
    );
  }
}

class _BibleBookmarkTile extends ConsumerWidget {
  final BibleBookmark bookmark;

  const _BibleBookmarkTile({required this.bookmark});

  String _formatDate(DateTime dt) {
    final months = ['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Jun', 'Jul', 'Aoû', 'Sep', 'Oct', 'Nov', 'Déc'];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final bm = bookmark;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Dismissible(
        key: ValueKey('${bm.bookIdentifier}-${bm.chapter}-${bm.verse}'),
        direction: DismissDirection.endToStart,
        confirmDismiss: (_) async {
          return await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              backgroundColor: colors.bibleReaderBackground,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Text('Supprimer ce favori ?', style: TextStyle(color: colors.textPrimary)),
              content: Text(
                bm.reference ?? '${bm.bookIdentifier} ${bm.chapter}:${bm.verse}',
                style: TextStyle(color: colors.textTertiary),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: Text('Annuler', style: TextStyle(color: colors.textDisabled)),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  child: Text('Supprimer', style: TextStyle(color: colors.errorBorder)),
                ),
              ],
            ),
          );
        },
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: AppSpacing.xl),
          decoration: BoxDecoration(
            color: colors.errorBg,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.delete_rounded, color: colors.errorIcon, size: 22),
              const SizedBox(height: 4),
              Text('Supprimer', style: TextStyle(color: colors.errorIcon, fontSize: 10)),
            ],
          ),
        ),
        onDismissed: (_) {
          ref.read(bibleLibraryNotifierProvider.notifier).deleteBookmark(
            bm.bookIdentifier,
            bm.chapter,
            bm.verse,
          );
        },
        child: GlassCard(
          padding: const EdgeInsets.all(AppSpacing.lg),
          backgroundColor: colors.bgCard,
          borderRadius: 16,
          onTap: () {
            context.push(
              AppRoutes.bibleReader
                  .replaceFirst(':book', bm.bookIdentifier)
                  .replaceFirst(':chapter', '${bm.chapter}'),
            );
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: colors.accentGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.bookmark_rounded, color: colors.iconOnBrand, size: 18),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          bm.reference ?? '${bm.bookIdentifier} ${bm.chapter}:${bm.verse}',
                          style: AppTypography.editorialSection.copyWith(
                            color: colors.accent,
                            fontSize: 13,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        if (bm.collectionName != 'Général')
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: colors.accent.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              bm.collectionName,
                              style: TextStyle(
                                color: colors.accent.withOpacity(0.8),
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      bm.verseText,
                      style: AppTypography.editorialDisplay.copyWith(
                        color: colors.textSecondary,
                        fontSize: 13,
                        height: 1.5,
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.access_time_rounded, size: 12, color: colors.textDisabled),
                        const SizedBox(width: 4),
                        Text(
                          _formatDate(bm.createdAt),
                          style: TextStyle(color: colors.textDisabled, fontSize: 10),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          bm.translationId.toUpperCase(),
                          style: TextStyle(
                            color: colors.accent.withOpacity(0.4),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
