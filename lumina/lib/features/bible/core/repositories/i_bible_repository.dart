// lib/features/bible/domain/repositories/i_bible_repository.dart
// Interface abstraite du repository Bible — contrat pur du domaine.
// La couche data DOIT implémenter cette interface.

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import 'package:lumina/features/bible/domain/entities/bible_entities.dart';

abstract class IBibleRepository {
  // ── Livres ─────────────────────────────────────────────
  List<BibleBook> getAllBooks();
  BibleBook? getBookByIdentifier(String identifier);

  // ── Chapitres ──────────────────────────────────────────
  Future<Either<Failure, BibleChapter>> getChapter({
    required String translationId,
    required String bookIdentifier,
    required int chapterNumber,
  });

  Future<List<BibleChapter>> getRecentReadings({int limit = 3});

  // ── Versets ────────────────────────────────────────────
  /// Recherche globale dans toute la Bible (sur les données importées en local)
  Future<Either<Failure, List<BibleVerse>>> searchVerses({
    required String query,
    String? translationId,
    int limit = 50,
  });

  Map<String, String> getVerseOfTheDay();

  // ── Recherche Histoire ────────────────────────────────
  Future<Either<Failure, List<BibleSearchHistory>>> getSearchHistory();
  Future<Either<Failure, void>> saveSearchHistory(String query, int resultCount);
  Future<Either<Failure, void>> deleteSearchHistory(int id);
  Future<Either<Failure, void>> clearSearchHistory();

  // ── Traductions ────────────────────────────────────────
  List<BibleTranslation> getAvailableTranslations();
  Future<int> getDownloadedChaptersCount(String translationId);

  // ── Signets ────────────────────────────────────────────
  Future<Either<Failure, List<BibleBookmark>>> getBookmarks();
  Future<Either<Failure, List<BibleBookmark>>> getBookmarksByCollection(
      String collection);
  Future<Either<Failure, List<String>>> getCollections();
  Future<Either<Failure, bool>> isBookmarked(
      String book, int chapter, int verse);

  Future<Either<Failure, void>> addBookmark({
    required String bookIdentifier,
    required int chapter,
    required int verse,
    required String verseText,
    required String translationId,
    String collectionName = 'Général',
  });

  Future<Either<Failure, void>> removeBookmark({
    required String bookIdentifier,
    required int chapter,
    required int verse,
  });

  Future<Either<Failure, void>> toggleBookmark({
    required String bookIdentifier,
    required int chapter,
    required int verse,
    required String verseText,
    required String translationId,
    String collectionName = 'Général',
  });

  Future<Either<Failure, void>> syncBookmarksFromCloud();

  // ── Annotations ────────────────────────────────────────
  Future<Either<Failure, List<BibleAnnotation>>> getAnnotations({
    required String bookIdentifier,
    required int chapter,
  });

  Future<Either<Failure, void>> saveHighlight({
    required String bookIdentifier,
    required int chapter,
    required int verse,
    required String translationId,
    required String colorHex,
    String? category,
  });

  Future<Either<Failure, void>> saveNote({
    required String bookIdentifier,
    required int chapter,
    required int verse,
    required String translationId,
    required String content,
  });

  Future<Either<Failure, void>> deleteAnnotation(int localId);

  // ── Plans de lecture ───────────────────────────────────
  Future<Either<Failure, List<BibleReadingPlan>>> getReadingPlans();
  Future<Either<Failure, BibleReadingPlan?>> getActivePlan();

  Future<Either<Failure, BiblePlanProgress?>> getPlanProgress({
    required String planId,
    required String userId,
  });

  Future<Either<Failure, void>> markDayComplete({
    required String planId,
    required String userId,
    required int dayNumber,
  });

  // ── Statistiques & Gamification ─────────────────────────
  Future<Either<Failure, BibleReadingStat>> getReadingStats();
  Future<Either<Failure, void>> updateReadingStreak();
  Future<Either<Failure, void>> incrementChaptersRead();
  Future<Either<Failure, void>> incrementAnnotationsCount();

  // ── Import local ───────────────────────────────────────
  Future<Either<Failure, void>> importLocalBibles();
  Future<bool> isBibleImported(String translationId);

  // ── Téléchargement en ligne ────────────────────────────
  Future<Either<Failure, void>> downloadEntireBible(String translationId);
  Future<Either<Failure, void>> clearCachedTranslation(String translationId);
  Future<Either<Failure, void>> clearAllTranslations();
}
