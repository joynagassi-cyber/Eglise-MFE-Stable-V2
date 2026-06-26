import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/data/local/isar_service.dart';
import '../../../../core/logging/app_logger.dart';
import 'package:isar/isar.dart';
import 'package:lumina/features/bible/core/models/bible_models.dart';
import 'package:lumina/features/bible/data/services/bible_service.dart';

part 'bible_download_service.g.dart';

class BibleDownloadState {
  final bool isDownloading;
  final double progress;
  final String? currentBook;
  final String? error;

  BibleDownloadState({
    this.isDownloading = false,
    this.progress = 0.0,
    this.currentBook,
    this.error,
  });

  BibleDownloadState copyWith({
    bool? isDownloading,
    double? progress,
    String? currentBook,
    String? error,
  }) {
    return BibleDownloadState(
      isDownloading: isDownloading ?? this.isDownloading,
      progress: progress ?? this.progress,
      currentBook: currentBook ?? this.currentBook,
      error: error ?? this.error,
    );
  }
}

const Map<String, int> _chapterCounts = {
  'GEN': 50,
  'EXO': 40,
  'LEV': 27,
  'NUM': 36,
  'DEU': 34,
  'JOS': 24,
  'JDG': 21,
  'RUT': 4,
  '1SA': 31,
  '2SA': 24,
  '1KI': 22,
  '2KI': 25,
  '1CH': 29,
  '2CH': 36,
  'EZR': 10,
  'NEH': 13,
  'EST': 10,
  'JOB': 42,
  'PSA': 150,
  'PRO': 31,
  'ECC': 12,
  'SNG': 8,
  'ISA': 66,
  'JER': 52,
  'LAM': 5,
  'EZK': 48,
  'DAN': 12,
  'HOS': 14,
  'JOL': 3,
  'AMO': 9,
  'OBA': 1,
  'JON': 4,
  'MIC': 7,
  'NAM': 3,
  'HAB': 3,
  'ZEP': 3,
  'HAG': 2,
  'ZEC': 14,
  'MAL': 4,
  'MAT': 28,
  'MRK': 16,
  'LUK': 24,
  'JHN': 21,
  'ACT': 28,
  'ROM': 16,
  '1CO': 16,
  '2CO': 13,
  'GAL': 6,
  'EPH': 6,
  'PHP': 4,
  'COL': 4,
  '1TH': 5,
  '2TH': 3,
  '1TI': 6,
  '2TI': 4,
  'TIT': 3,
  'PHM': 1,
  'HEB': 13,
  'JAS': 5,
  '1PE': 5,
  '2PE': 3,
  '1JN': 5,
  '2JN': 1,
  '3JN': 1,
  'JUD': 1,
  'REV': 22,
};

@Riverpod(keepAlive: true)
class BibleDownloadService extends _$BibleDownloadService {
  late final IsarService _isarService;
  late final BibleService _bibleService;

  @override
  BibleDownloadState build() {
    _isarService = ref.watch(isarServiceProvider);
    _bibleService = ref.watch(bibleServiceProvider.notifier);
    return BibleDownloadState();
  }

  /// Stop current download process if active
  void cancelDownload() {
    state =
        state.copyWith(isDownloading: false, error: 'Téléchargement annulé');
  }

  /// Downloads and caches an entire Bible translation.
  Future<void> downloadEntireBible(String translation) async {
    if (state.isDownloading) return;

    final books = _bibleService.getBooks();
    final totalChapters = _chapterCounts.values.reduce((a, b) => a + b);
    int downloadedCount = 0;

    state = BibleDownloadState(isDownloading: true, progress: 0.0);
    AppLogger.i(
        'Bible: Starting full download for $translation', 'DOWNLOAD_SERVICE');

    for (final book in books) {
      if (!state.isDownloading) break; // Check for cancellation

      final bookId = book['id']!;
      final bookName = book['name']!;
      final chapters = _chapterCounts[bookId] ?? 1;

      state = state.copyWith(currentBook: bookName);

      for (int i = 1; i <= chapters; i++) {
        if (!state.isDownloading) break;

        try {
          final chapter = await _bibleService.getChapter(
            translation: translation,
            book: bookId,
            chapter: i,
          );

          if (chapter != null) {
            downloadedCount++;
            state = state.copyWith(progress: downloadedCount / totalChapters);
            AppLogger.d('Bible: Downloaded $bookId $i', 'DOWNLOAD_SERVICE');
          }
        } catch (e) {
          AppLogger.e(
              'Bible: Failed to download $bookId $i', 'DOWNLOAD_SERVICE', e);
          state = state.copyWith(
              error: 'Erreur: Impossible de télécharger $bookName $i');
          // We continue to next chapter even if one fails to not block all
        }
      }
    }

    if (state.isDownloading) {
      AppLogger.i(
          'Bible: Full download complete for $translation', 'DOWNLOAD_SERVICE');
      state = BibleDownloadState(isDownloading: false, progress: 1.0);
    }
  }

  /// Delete all cached Bible chapters for all translations
  Future<void> clearAllTranslations() async {
    try {
      await _isarService.db.writeTxn(() async {
        await _isarService.bibleChapterModels.clear();
      });
      AppLogger.i('All Bible cache cleared.', 'DOWNLOAD_SERVICE');
      state = BibleDownloadState();
    } catch (e) {
      AppLogger.e('Failed to clear all bible cache', 'DOWNLOAD_SERVICE', e);
    }
  }

  /// Delete all cached Bible chapters for a specific translation
  Future<void> clearCache(String translationId) async {
    try {
      await _isarService.db.writeTxn(() async {
        final chaptersToDelete = await _isarService.bibleChapterModels
            .filter()
            .translationIdEqualTo(translationId)
            .build()
            .findAll();
        final idsToDelete = chaptersToDelete.map((e) => e.id).toList();
        await _isarService.bibleChapterModels.deleteAll(idsToDelete);
      });
      AppLogger.i(
          'Bible cache cleared for $translationId.', 'DOWNLOAD_SERVICE');
      state = BibleDownloadState(); // Reset
    } catch (e) {
      AppLogger.e('Failed to clear bible cache', 'DOWNLOAD_SERVICE', e);
    }
  }

  /// Check how many chapters are downloaded for a translation
  Future<int> getDownloadedChaptersCount(String translation) async {
    try {
      return await _isarService.bibleChapterModels
          .filter()
          .translationIdEqualTo(translation)
          .build()
          .count();
    } catch (e) {
      return 0;
    }
  }
}
