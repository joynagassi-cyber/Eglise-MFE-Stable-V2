// lib/features/bible/presentation/providers/bible_notifier.dart
// Provider principal de l'état Bible — remplace le BibleService God Object.
// Orchestre IBibleRepository + IBibleTtsService via Riverpod.

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:lumina/features/bible/core/repositories/bible_repository_impl.dart';
import 'package:lumina/features/bible/core/services/bible_tts_service.dart';
import 'package:lumina/features/bible/domain/entities/bible_entities.dart';
import 'package:lumina/features/bible/core/repositories/i_bible_repository.dart';
import 'package:lumina/features/bible/domain/services/i_bible_tts_service.dart';
import 'package:lumina/features/bible/core/providers/bible_settings_provider.dart';
import 'package:lumina/features/bible/reader/providers/bible_stats_notifier.dart';

part 'bible_notifier.freezed.dart';
part 'bible_notifier.g.dart';

// ─────────────────────────────────────────────────────────
// STATE
// ─────────────────────────────────────────────────────────

@freezed
class BibleState with _$BibleState {
  const factory BibleState({
    // Navigation
    @Default('GEN') String currentBook,
    @Default(1) int currentChapter,
    @Default('ls1910') String currentTranslation,

    // Données
    BibleChapter? chapter,
    @Default([]) List<BibleBook> books,
    @Default([]) List<BibleBookmark> bookmarks,
    @Default([]) List<BibleAnnotation> annotations,
    @Default([]) List<BibleVerse> searchResults,
    @Default([]) List<BibleChapter> recentReadings,

    // Sélection de versets
    @Default({}) Set<int> selectedVerses,
    @Default(false) bool isSelectionMode,

    // Recherche
    @Default('') String searchQuery,
    @Default(false) bool isSearching,

    // Chargement
    @Default(false) bool isLoadingChapter,
    @Default(false) bool isSearchingVerses,
    String? errorMessage,

    // TTS
    @Default(TtsPlaybackState.idle) TtsPlaybackState ttsState,
    @Default(-1) int speakingVerseIndex,
    @Default(false) bool ttsLoopMode,
  }) = _BibleState;
}

// ─────────────────────────────────────────────────────────
// NOTIFIER
// ─────────────────────────────────────────────────────────

@Riverpod(keepAlive: true)
class BibleNotifier extends _$BibleNotifier {
  late IBibleRepository _repo;
  late IBibleTtsService _tts;
  StreamSubscription<TtsPlaybackState>? _ttsStateSub;
  StreamSubscription<int>? _ttsVerseSub;

  @override
  BibleState build() {
    _repo = ref.watch(bibleRepositoryProvider);
    _tts = ref.watch(bibleTtsServiceProvider);

    _ttsStateSub?.cancel();
    _ttsVerseSub?.cancel();

    _ttsStateSub = _tts.playbackStateStream.listen((s) {
      state = state.copyWith(ttsState: s);
    });

    _ttsVerseSub = _tts.currentVerseIndexStream.listen((idx) {
      state = state.copyWith(speakingVerseIndex: idx);
    });

    ref.onDispose(() {
      _ttsStateSub?.cancel();
      _ttsVerseSub?.cancel();
    });

    // Chargement initial
    final translation = ref.read(bibleTranslationProvider);
    final books = _repo.getAllBooks();

    Future.microtask(() async {
      state = state.copyWith(
        currentTranslation: translation,
        books: books,
      );
      await _initTts();
      await loadChapter(book: 'GEN', chapter: 1);
      await _loadRecentReadings();
      await _loadBookmarks();
    });

    return BibleState(books: books, currentTranslation: translation);
  }

  // ── TTS ─────────────────────────────────────────────────

  Future<void> _initTts() async {
    final settings = ref.read(bibleTtsSettingsProvider);
    await _tts.initialize(settings);
  }

  Future<void> speakVerse(int verseIndex) async {
    final verses = state.chapter?.verses;
    if (verses == null || verseIndex >= verses.length) return;

    if (state.ttsState == TtsPlaybackState.playing &&
        state.speakingVerseIndex == verseIndex) {
      await _tts.pause();
    } else {
      await _tts.speakVerse(
        text: verses[verseIndex],
        verseNumber: verseIndex,
      );
    }
  }

  Future<void> startChapterReading({bool loop = false}) async {
    final verses = state.chapter?.verses;
    if (verses == null || verses.isEmpty) return;
    state = state.copyWith(ttsLoopMode: loop);

    await _tts.speakChapter(
      verses: verses,
      loop: loop,
      startFromVerse: state.speakingVerseIndex > 0
          ? state.speakingVerseIndex
          : 0,
    );
  }

  Future<void> pauseTts() => _tts.pause();
  Future<void> resumeTts() => _tts.resume();
  Future<void> stopTts() async {
    await _tts.stop();
    state = state.copyWith(speakingVerseIndex: -1, ttsLoopMode: false);
  }

  Future<void> toggleLoopMode() async {
    final newLoop = !state.ttsLoopMode;
    if (state.ttsState == TtsPlaybackState.playing) {
      await startChapterReading(loop: newLoop);
    } else {
      state = state.copyWith(ttsLoopMode: newLoop);
    }
  }

  Future<void> updateTtsSettings(BibleTtsSettings settings) async {
    await _tts.updateSettings(settings);
    await ref.read(bibleTtsSettingsNotifierProvider.notifier).update(settings);
  }

  // ── NAVIGATION ──────────────────────────────────────────

  Future<void> loadChapter({String? book, int? chapter}) async {
    final bookId = book ?? state.currentBook;
    final chapterNum = chapter ?? state.currentChapter;
    final translation = state.currentTranslation;

    state = state.copyWith(
      currentBook: bookId,
      currentChapter: chapterNum,
      isLoadingChapter: true,
      errorMessage: null,
      selectedVerses: {},
      isSelectionMode: false,
    );

    // Stop TTS if playing a different chapter
    if (state.ttsState == TtsPlaybackState.playing) {
      await _tts.stop();
    }

    final result = await _repo.getChapter(
      translationId: translation,
      bookIdentifier: bookId,
      chapterNumber: chapterNum,
    );

    await result.fold(
      (failure) {
        state = state.copyWith(
          isLoadingChapter: false,
          errorMessage: failure.message,
        );
      },
      (chapterData) async {
        state = state.copyWith(
          chapter: chapterData,
          isLoadingChapter: false,
          speakingVerseIndex: -1,
        );
        // Reload annotations for this chapter
        await _loadAnnotations(bookId: bookId, chapter: chapterNum);
        // Track stats
        unawaited(ref.read(bibleStatsNotifierProvider.notifier).onChapterRead());
      },
    );
  }

  Future<void> navigateToPassage({
    required String book,
    required int chapter,
    int? verse,
  }) async {
    await loadChapter(book: book, chapter: chapter);
    if (verse != null) {
      state = state.copyWith(
        selectedVerses: {verse - 1},
        isSelectionMode: true,
      );
    }
  }


  Future<void> nextChapter() async {
    final book = _repo.getBookByIdentifier(state.currentBook);
    if (book == null) return;
    if (state.currentChapter < book.chapterCount) {
      await loadChapter(chapter: state.currentChapter + 1);
    }
  }

  Future<void> prevChapter() async {
    if (state.currentChapter > 1) {
      await loadChapter(chapter: state.currentChapter - 1);
    }
  }

  Future<void> changeTranslation(String translationId) async {
    await ref
        .read(bibleTranslationProvider.notifier)
        .setTranslation(translationId);
    state = state.copyWith(currentTranslation: translationId);
    await loadChapter();
  }

  // ── SÉLECTION DE VERSETS ────────────────────────────────

  void toggleVerseSelection(int verseIndex) {
    final selected = Set<int>.from(state.selectedVerses);
    if (selected.contains(verseIndex)) {
      selected.remove(verseIndex);
    } else {
      selected.add(verseIndex);
    }
    state = state.copyWith(
      selectedVerses: selected,
      isSelectionMode: selected.isNotEmpty,
    );
  }

  void clearSelection() {
    state = state.copyWith(selectedVerses: {}, isSelectionMode: false);
  }

  // ── SIGNETS ─────────────────────────────────────────────

  Future<void> _loadBookmarks() async {
    final result = await _repo.getBookmarks();
    result.fold((_) {}, (bookmarks) {
      state = state.copyWith(bookmarks: bookmarks);
    });
  }

  Future<void> toggleBookmark({
    required int verse,
    required String verseText,
    String collectionName = 'Général',
  }) async {
    await _repo.toggleBookmark(
      bookIdentifier: state.currentBook,
      chapter: state.currentChapter,
      verse: verse + 1,
      verseText: verseText,
      translationId: state.currentTranslation,
      collectionName: collectionName,
    );
    await _loadBookmarks();
  }

  bool isBookmarked(int verseIndex) {
    return state.bookmarks.any((b) =>
        b.bookIdentifier == state.currentBook &&
        b.chapter == state.currentChapter &&
        b.verse == verseIndex + 1);
  }

  // ── ANNOTATIONS ─────────────────────────────────────────

  Future<void> _loadAnnotations({
    required String bookId,
    required int chapter,
  }) async {
    final result =
        await _repo.getAnnotations(bookIdentifier: bookId, chapter: chapter);
    result.fold((_) {}, (annotations) {
      state = state.copyWith(annotations: annotations);
    });
  }

  Future<void> saveHighlight({
    required int verse,
    required String colorHex,
    String? category,
  }) async {
    await _repo.saveHighlight(
      bookIdentifier: state.currentBook,
      chapter: state.currentChapter,
      verse: verse + 1,
      translationId: state.currentTranslation,
      colorHex: colorHex,
      category: category,
    );
    await _loadAnnotations(
        bookId: state.currentBook, chapter: state.currentChapter);
  }

  Future<void> saveNote({required int verse, required String content}) async {
    await _repo.saveNote(
      bookIdentifier: state.currentBook,
      chapter: state.currentChapter,
      verse: verse + 1,
      translationId: state.currentTranslation,
      content: content,
    );
    await _loadAnnotations(
        bookId: state.currentBook, chapter: state.currentChapter);
  }

  // ── RECHERCHE ────────────────────────────────────────────

  Timer? _searchDebounce;

  void onSearchQueryChanged(String query) {
    state = state.copyWith(searchQuery: query);
    _searchDebounce?.cancel();
    if (query.length < 3) {
      state = state.copyWith(searchResults: []);
      return;
    }
    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      search(query);
    });
  }

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      state = state.copyWith(searchResults: []);
      return;
    }
    state = state.copyWith(isSearchingVerses: true);

    final result = await _repo.searchVerses(
      query: query,
      translationId: state.currentTranslation,
    );

    result.fold(
      (_) => state = state.copyWith(isSearchingVerses: false),
      (results) => state = state.copyWith(
        searchResults: results,
        isSearchingVerses: false,
      ),
    );
  }

  void clearSearch() {
    _searchDebounce?.cancel();
    state = state.copyWith(
      searchQuery: '',
      searchResults: [],
      isSearchingVerses: false,
      isSearching: false,
    );
  }

  void toggleSearchMode() {
    state = state.copyWith(
      isSearching: !state.isSearching,
      searchQuery: '',
      searchResults: [],
    );
  }

  // ── LECTURE RÉCENTE ─────────────────────────────────────

  Future<void> _loadRecentReadings() async {
    final readings = await _repo.getRecentReadings(limit: 3);
    state = state.copyWith(recentReadings: readings);
  }

  // ── IMPORT LOCAL ─────────────────────────────────────────

  Future<void> importLocalBibles() async {
    final result = await _repo.importLocalBibles();
    result.fold(
      (f) => state = state.copyWith(errorMessage: f.message),
      (_) async => await loadChapter(),
    );
  }
}

// ─────────────────────────────────────────────────────────
// PROVIDERS DÉRIVÉS (sélecteurs performants)
// ─────────────────────────────────────────────────────────

@riverpod
BibleChapter? currentChapter(CurrentChapterRef ref) =>
    ref.watch(bibleNotifierProvider.select((s) => s.chapter));

@riverpod
List<BibleVerse> bibleSearchResults(BibleSearchResultsRef ref) =>
    ref.watch(bibleNotifierProvider.select((s) => s.searchResults));

@riverpod
Set<int> selectedVerses(SelectedVersesRef ref) =>
    ref.watch(bibleNotifierProvider.select((s) => s.selectedVerses));

@riverpod
TtsPlaybackState ttsPlaybackState(TtsPlaybackStateRef ref) =>
    ref.watch(bibleNotifierProvider.select((s) => s.ttsState));
