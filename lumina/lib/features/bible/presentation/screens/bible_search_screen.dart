import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';

// import '../../../../core/theme/lumina_colors_extension.dart';
import 'package:lumina/core/widgets/widgets.dart';
import 'package:lumina/features/bible/search/providers/bible_search_notifier.dart';
import 'package:lumina/features/bible/reader/providers/bible_notifier.dart';
// import 'package:lumina/core/extensions/build_context_extensions.dart';
import 'package:lumina/features/bible/domain/entities/bible_entities.dart';


class BibleSearchScreen extends ConsumerWidget {
  const BibleSearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(bibleSearchNotifierProvider);
    final searchNotifier = ref.read(bibleSearchNotifierProvider.notifier);
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.bgPrimary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: TextField(
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Rechercher un verset...',
            hintStyle: TextStyle(color: colors.textTertiary),
            border: InputBorder.none,
          ),
          style: TextStyle(color: colors.textPrimary, fontSize: 18),
          onChanged: searchNotifier.onQueryChanged,
          textInputAction: TextInputAction.search,
          onSubmitted: searchNotifier.search,
        ),
        actions: [
          if (searchState.query.isNotEmpty)
            IconButton(
              icon: Icon(Icons.close, color: colors.textSecondary),
              onPressed: searchNotifier.clearSearch,
            ),
        ],
      ),
      body: Column(
        children: [
          if (searchState.history.isNotEmpty && !searchState.isSearching)
            _buildHistory(context, ref),
          
          Expanded(
            child: _buildBody(context, ref, searchState),
          ),
        ],
      ),
    );
  }

  Widget _buildHistory(BuildContext context, WidgetRef ref) {
    final history = ref.watch(bibleSearchNotifierProvider).history;
    final notifier = ref.read(bibleSearchNotifierProvider.notifier);
    final colors = context.colors;

    return FadeInDown(
      duration: const Duration(milliseconds: 300),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'RECHERCHES RÉCENTES',
                    style: TextStyle(
                      color: colors.textTertiary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  TextButton(
                    onPressed: notifier.clearHistory,
                    child: Text(
                      'Tout effacer',
                      style: TextStyle(color: colors.brandPrimary, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: history.map((item) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: InputChip(
                      label: Text(item.query),
                      backgroundColor: colors.surfacePrimary,
                      labelStyle: TextStyle(color: colors.textPrimary, fontSize: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: colors.borderSubtle),
                      ),
                      onPressed: () => notifier.search(item.query),
                      onDeleted: () => notifier.deleteHistoryItem(item.id),
                      deleteIcon: Icon(Icons.close, size: 14, color: colors.textTertiary),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 8),
            Divider(color: colors.borderSubtle, height: 1),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, BibleSearchState state) {
    if (state.isLoading) {
      return const Center(child: LoadingState());
    }

    if (!state.isSearching) {
      return _buildEmptyState(context);
    }

    if (state.results.isEmpty) {
      return _buildNoResults(context, state.query);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.results.length,
      itemBuilder: (context, index) {
        final verse = state.results[index];
        return FadeInUp(
          duration: Duration(milliseconds: 300 + (index * 50)),
          child: _VerseSearchResult(verse: verse),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final colors = context.colors;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 80, color: colors.textTertiary.withOpacity(0.2)),
          const SizedBox(height: 16),
          Text(
            'Explorez la Parole',
            style: TextStyle(
              color: colors.textSecondary,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Saisissez un mot ou un verset...',
            style: TextStyle(color: colors.textTertiary),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResults(BuildContext context, String query) {
    final colors = context.colors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: colors.textTertiary),
            const SizedBox(height: 16),
            Text(
              'Aucun résultat pour "$query"',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colors.textSecondary,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VerseSearchResult extends ConsumerWidget {
  final BibleVerse verse;

  const _VerseSearchResult({required this.verse});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;

    return InkWell(
      onTap: () {
        // Naviguer vers le lecteur au passage spécifique
        ref.read(bibleNotifierProvider.notifier).navigateToPassage(
          book: verse.bookIdentifier,
          chapter: verse.chapter,
          verse: verse.verse,
        );
        context.pop(); // Fermer la recherche
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.surfacePrimary,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.borderSubtle),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: colors.brandPrimary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${verse.bookName} ${verse.chapter}:${verse.verse}',
                    style: TextStyle(
                      color: colors.brandPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  verse.translationId.toUpperCase(),
                  style: TextStyle(
                    color: colors.textTertiary,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              verse.text,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: colors.textPrimary,
                fontSize: 15,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
