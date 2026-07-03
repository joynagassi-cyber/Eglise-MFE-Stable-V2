// lib/features/bible/presentation/widgets/bible_search_overlay.dart
// Overlay de recherche plein-écran pour chercher dans toute la Bible locale.

import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_typography.dart';
import 'package:lumina/core/widgets/widgets.dart';
import 'package:lumina/features/bible/domain/entities/bible_entities.dart';
import 'package:lumina/features/bible/reader/providers/bible_notifier.dart';
// import 'package:lumina/core/extensions/build_context_extensions.dart';

class BibleSearchOverlay extends ConsumerStatefulWidget {
  final VoidCallback onClose;

  const BibleSearchOverlay({super.key, required this.onClose});

  @override
  ConsumerState<BibleSearchOverlay> createState() => _BibleSearchOverlayState();
}

class _BibleSearchOverlayState extends ConsumerState<BibleSearchOverlay> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bibleNotifierProvider);
    final notifier = ref.read(bibleNotifierProvider.notifier);

    return Material(
      color: context.colors.bgPrimary,
      child: SafeArea(
        child: Column(
          children: [
            // ── Barre de recherche ──────────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    tooltip: 'Fermer la recherche',
                    onPressed: () {
                      notifier.clearSearch();
                      widget.onClose();
                    },
                  ),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      decoration: InputDecoration(
                        hintText: 'Rechercher dans la Bible…',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor:
                            context.colors.bgSecondary,
                        prefixIcon: Icon(Icons.search),
                        suffixIcon: state.searchQuery.isNotEmpty
                            ? IconButton(
                                icon: Icon(Icons.clear),
                                tooltip: 'Effacer la recherche',
                                onPressed: () {
                                  _controller.clear();
                                  notifier.clearSearch();
                                },
                              )
                            : null,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 10),
                      ),
                      textInputAction: TextInputAction.search,
                      onChanged: notifier.onSearchQueryChanged,
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1),

            // ── Résultats ───────────────────────────────
            Expanded(
              child: _buildBody(state, notifier),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BibleState state, BibleNotifier notifier) {
    if (state.isSearchingVerses) {
      return Center(child: LoadingState());
    }

    if (state.searchQuery.length < 3) {
      return _SearchHint(
        recentReadings: state.recentReadings,
        onTapReading: (chapter) async {
          await notifier.loadChapter(
            book: chapter.bookIdentifier,
            chapter: chapter.chapterNumber,
          );
          widget.onClose();
        },
      );
    }

    if (state.searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off,
                size: 56, color: context.colors.iconDisabled),
            SizedBox(height: 12),
            Text(
              'Aucun résultat pour\n"${state.searchQuery}"',
              style: AppTypography.bodyMedium.copyWith(
                color: context.colors.textTertiary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Text(
            '${state.searchResults.length} résultat(s) pour '
            '"${state.searchQuery}"',
            style: AppTypography.labelSmall.copyWith(
              color: context.colors.textTertiary,
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            itemCount: state.searchResults.length,
            separatorBuilder: (_, __) =>
                Divider(height: 1, indent: 16),
            itemBuilder: (_, i) {
              final verse = state.searchResults[i];
              return _SearchResultTile(
                verse: verse,
                query: state.searchQuery,
                onTap: () async {
                  await notifier.loadChapter(
                    book: verse.bookIdentifier,
                    chapter: verse.chapter,
                  );
                  widget.onClose();
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────
// SOUS-WIDGETS
// ─────────────────────────────────────────────────────────

class _SearchHint extends StatelessWidget {
  final List<BibleChapter> recentReadings;
  final Function(BibleChapter) onTapReading;

  const _SearchHint({
    required this.recentReadings,
    required this.onTapReading,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (recentReadings.isNotEmpty) ...[
            Text('Récemment lu', style: AppTypography.labelMedium),
            SizedBox(height: 8),
            ...recentReadings.map((r) => ListTile(
                  leading: Icon(Icons.history,
                      color: context.colors.accent, size: 20),
                  title: Text(
                    '${r.bookIdentifier} ${r.chapterNumber}',
                    style: AppTypography.bodyMedium,
                  ),
                  subtitle: Text(r.translationId.toUpperCase(),
                      style: AppTypography.labelSmall),
                  onTap: () => onTapReading(r),
                  dense: true,
                )),
            Divider(),
          ],
          SizedBox(height: 8),
          Center(
            child: Column(
              children: [
                Icon(Icons.search,
                    size: 48, color: context.colors.iconDisabled),
                SizedBox(height: 8),
                Text(
                  'Tapez au moins 3 caractères\npour lancer la recherche',
                  style: AppTypography.bodySmall
                      .copyWith(color: context.colors.textTertiary),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchResultTile extends StatelessWidget {
  final BibleVerse verse;
  final String query;
  final VoidCallback onTap;

  const _SearchResultTile({
    required this.verse,
    required this.query,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(
        verse.reference,
        style: AppTypography.labelMedium.copyWith(
          color: context.colors.accent,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: _HighlightedText(text: verse.text, query: query),
    );
  }
}

class _HighlightedText extends StatelessWidget {
  final String text;
  final String query;

  const _HighlightedText({required this.text, required this.query});

  @override
  Widget build(BuildContext context) {
    if (query.isEmpty) return Text(text);

    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final spans = <TextSpan>[];
    int start = 0;

    while (true) {
      final idx = lowerText.indexOf(lowerQuery, start);
      if (idx == -1) {
        spans.add(TextSpan(text: text.substring(start)));
        break;
      }
      if (idx > start) {
        spans.add(TextSpan(text: text.substring(start, idx)));
      }
      spans.add(TextSpan(
        text: text.substring(idx, idx + query.length),
        style: TextStyle(
          backgroundColor: context.colors.accent.withOpacity(0.25),
          color: context.colors.accent,
          fontWeight: FontWeight.w700,
        ),
      ));
      start = idx + query.length;
    }

    return RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style.copyWith(fontSize: 13),
        children: spans,
      ),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }
}

