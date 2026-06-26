// lib/features/bible/presentation/screens/bible_reader_screen.dart
// Écran lecteur Bible refactorisé — <80 lignes de logique UI.
// Orchestre les widgets atomiques: ReaderAppBar, VerseList,
// ChapterNavBar, TtsControlBar, BibleSearchOverlay.

import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumina/features/bible/core/repositories/bible_repository_impl.dart';
import 'package:lumina/features/bible/reader/providers/bible_notifier.dart';
import 'package:lumina/features/bible/reader/widgets/bible_search_overlay.dart';
import 'package:lumina/features/bible/presentation/widgets/book_picker_sheet.dart';
import 'package:lumina/features/bible/reader/widgets/chapter_nav_bar.dart';
import 'package:lumina/features/bible/presentation/widgets/reader_app_bar.dart';
import 'package:lumina/core/widgets/widgets.dart';
import 'package:flutter/services.dart';
import 'package:lumina/features/bible/presentation/widgets/tts_control_bar.dart';
import 'package:lumina/features/bible/reader/widgets/verse_action_bar.dart';
import 'package:lumina/features/bible/reader/widgets/verse_list.dart';
// import 'package:lumina/core/extensions/build_context_extensions.dart';

class BibleReaderScreen extends ConsumerStatefulWidget {
  final String book;
  final int chapter;

  const BibleReaderScreen({
    super.key,
    required this.book,
    required this.chapter,
  });

  @override
  ConsumerState<BibleReaderScreen> createState() => _BibleReaderScreenState();
}

class _BibleReaderScreenState extends ConsumerState<BibleReaderScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref
        .read(bibleNotifierProvider.notifier)
        .loadChapter(book: widget.book, chapter: widget.chapter));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bibleNotifierProvider);
    final notifier = ref.read(bibleNotifierProvider.notifier);

    final currentBook =
        ref.watch(bibleRepositoryProvider).getBookByIdentifier(state.currentBook);
    final bookName = currentBook?.name ?? state.currentBook;
    final totalChapters = currentBook?.chapterCount ?? 1;

    return Scaffold(
      appBar: ReaderAppBar(
        bookName: bookName,
        chapter: state.currentChapter,
        totalChapters: totalChapters,
        onBookTap: () => _showBookPicker(context),
        onToggleSearch: notifier.toggleSearchMode,
      ),
      body: Stack(
        children: [
          // ── Contenu principal ───────────────────────
          Column(
            children: [
              Expanded(child: _buildContent(state, notifier)),
              ChapterNavBar(
                chapter: state.currentChapter,
                totalChapters: totalChapters,
                bookName: bookName,
              ),
            ],
          ),

          // ── Search overlay ──────────────────────────
          if (state.isSearching)
            BibleSearchOverlay(
              onClose: notifier.toggleSearchMode,
            ),

          // ── TTS Control bar (flottante bas) ─────────
          Positioned(
            left: 0,
            right: 0,
            bottom: 68, // au-dessus de la ChapterNavBar
            child: TtsControlBar(),
          ),

          // ── Verse Action Bar (flottante) ────────────
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: VerseActionBar(
              selectedVerses: state.selectedVerses,
              onClear: notifier.clearSelection,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BibleState state, BibleNotifier notifier) {
    if (state.isLoadingChapter) {
      return Center(child: LoadingState());
    }

    if (state.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off, size: 56, color: context.colors.textTertiary),
            SizedBox(height: 12),
            Text(state.errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(color: context.colors.textTertiary)),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: notifier.loadChapter,
              icon: Icon(Icons.refresh),
              label: Text('Réessayer'),
            ),
          ],
        ),
      );
    }

    final verses = state.chapter?.verses ?? [];

    return VerseList(
      verses: verses,
      annotations: state.annotations,
      onVerseTap: (index, text) {
        // Tap simple en mode sélection → toggle sélection
        if (state.isSelectionMode) {
          notifier.toggleVerseSelection(index);
        } else {
          // Tap simple hors mode → lecture TTS du verset
          notifier.speakVerse(index);
        }
      },
      onVerseLongPress: (index, text) {
        // Toggle selection on long press
        notifier.toggleVerseSelection(index);
        HapticFeedback.heavyImpact();
      },
    );
  }

  void _showBookPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => BookPickerSheet(
        onSelect: (bookId, chapterNum) {
          ref
              .read(bibleNotifierProvider.notifier)
              .loadChapter(book: bookId, chapter: chapterNum);
        },
      ),
    );
  }
}

