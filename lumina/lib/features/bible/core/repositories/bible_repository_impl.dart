// lib/features/bible/data/repositories/bible_repository_impl.dart
// Implémentation concrète de IBibleRepository.
// Orchestre Isar (local), bible-api.com (remote) et Supabase (sync).

import 'dart:async';
import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/data/local/isar_service.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/logging/app_logger.dart';
import 'package:lumina/features/bible/core/repositories/bible_mappers.dart';
import 'package:lumina/features/bible/core/models/bible_models.dart';
import 'package:lumina/features/bible/core/services/bible_import_service.dart';
import 'package:lumina/features/bible/domain/entities/bible_entities.dart';
import 'package:lumina/features/bible/core/repositories/i_bible_repository.dart';

part 'bible_repository_impl.g.dart';

@Riverpod(keepAlive: true)
IBibleRepository bibleRepository(BibleRepositoryRef ref) {
  return BibleRepositoryImpl(
    isarService: ref.watch(isarServiceProvider),
    importService: ref.watch(bibleImportServiceProvider.notifier),
  );
}

class BibleRepositoryImpl implements IBibleRepository {
  final IsarService _isar;
  final BibleImportService _importService;

  BibleRepositoryImpl({
    required IsarService isarService,
    required BibleImportService importService,
  })  : _isar = isarService,
        _importService = importService;

  String get _userId =>
      Supabase.instance.client.auth.currentUser?.id ?? 'anonymous';

  // ── METADATA ────────────────────────────────────────────

  static const Map<String, int> _chapterCounts = {
    'GEN': 50, 'EXO': 40, 'LEV': 27, 'NUM': 36, 'DEU': 34,
    'JOS': 24, 'JDG': 21, 'RUT': 4, '1SA': 31, '2SA': 24,
    '1KI': 22, '2KI': 25, '1CH': 29, '2CH': 36, 'EZR': 10,
    'NEH': 13, 'EST': 10, 'JOB': 42, 'PSA': 150, 'PRO': 31,
    'ECC': 12, 'SNG': 8, 'ISA': 66, 'JER': 52, 'LAM': 5,
    'EZK': 48, 'DAN': 12, 'HOS': 14, 'JOL': 3, 'AMO': 9,
    'OBA': 1, 'JON': 4, 'MIC': 7, 'NAM': 3, 'HAB': 3,
    'ZEP': 3, 'HAG': 2, 'ZEC': 14, 'MAL': 4, 'MAT': 28,
    'MRK': 16, 'LUK': 24, 'JHN': 21, 'ACT': 28, 'ROM': 16,
    '1CO': 16, '2CO': 13, 'GAL': 6, 'EPH': 6, 'PHP': 4,
    'COL': 4, '1TH': 5, '2TH': 3, '1TI': 6, '2TI': 4,
    'TIT': 3, 'PHM': 1, 'HEB': 13, 'JAS': 5, '1PE': 5,
    '2PE': 3, '1JN': 5, '2JN': 1, '3JN': 1, 'JUD': 1, 'REV': 22,
  };

  static const List<Map<String, String>> _books = [
    {'id': 'GEN', 'name': 'Genèse', 't': 'old'},
    {'id': 'EXO', 'name': 'Exode', 't': 'old'},
    {'id': 'LEV', 'name': 'Lévitique', 't': 'old'},
    {'id': 'NUM', 'name': 'Nombres', 't': 'old'},
    {'id': 'DEU', 'name': 'Deutéronome', 't': 'old'},
    {'id': 'JOS', 'name': 'Josué', 't': 'old'},
    {'id': 'JDG', 'name': 'Juges', 't': 'old'},
    {'id': 'RUT', 'name': 'Ruth', 't': 'old'},
    {'id': '1SA', 'name': '1 Samuel', 't': 'old'},
    {'id': '2SA', 'name': '2 Samuel', 't': 'old'},
    {'id': '1KI', 'name': '1 Rois', 't': 'old'},
    {'id': '2KI', 'name': '2 Rois', 't': 'old'},
    {'id': '1CH', 'name': '1 Chroniques', 't': 'old'},
    {'id': '2CH', 'name': '2 Chroniques', 't': 'old'},
    {'id': 'EZR', 'name': 'Esdras', 't': 'old'},
    {'id': 'NEH', 'name': 'Néhémie', 't': 'old'},
    {'id': 'EST', 'name': 'Esther', 't': 'old'},
    {'id': 'JOB', 'name': 'Job', 't': 'old'},
    {'id': 'PSA', 'name': 'Psaumes', 't': 'old'},
    {'id': 'PRO', 'name': 'Proverbes', 't': 'old'},
    {'id': 'ECC', 'name': 'Ecclésiaste', 't': 'old'},
    {'id': 'SNG', 'name': 'Cantique des Cantiques', 't': 'old'},
    {'id': 'ISA', 'name': 'Ésaïe', 't': 'old'},
    {'id': 'JER', 'name': 'Jérémie', 't': 'old'},
    {'id': 'LAM', 'name': 'Lamentations', 't': 'old'},
    {'id': 'EZK', 'name': 'Ézéchiel', 't': 'old'},
    {'id': 'DAN', 'name': 'Daniel', 't': 'old'},
    {'id': 'HOS', 'name': 'Osée', 't': 'old'},
    {'id': 'JOL', 'name': 'Joël', 't': 'old'},
    {'id': 'AMO', 'name': 'Amos', 't': 'old'},
    {'id': 'OBA', 'name': 'Abdias', 't': 'old'},
    {'id': 'JON', 'name': 'Jonas', 't': 'old'},
    {'id': 'MIC', 'name': 'Michée', 't': 'old'},
    {'id': 'NAM', 'name': 'Nahum', 't': 'old'},
    {'id': 'HAB', 'name': 'Habacuc', 't': 'old'},
    {'id': 'ZEP', 'name': 'Sophonie', 't': 'old'},
    {'id': 'HAG', 'name': 'Aggée', 't': 'old'},
    {'id': 'ZEC', 'name': 'Zacharie', 't': 'old'},
    {'id': 'MAL', 'name': 'Malachie', 't': 'old'},
    {'id': 'MAT', 'name': 'Matthieu', 't': 'new'},
    {'id': 'MRK', 'name': 'Marc', 't': 'new'},
    {'id': 'LUK', 'name': 'Luc', 't': 'new'},
    {'id': 'JHN', 'name': 'Jean', 't': 'new'},
    {'id': 'ACT', 'name': 'Actes', 't': 'new'},
    {'id': 'ROM', 'name': 'Romains', 't': 'new'},
    {'id': '1CO', 'name': '1 Corinthiens', 't': 'new'},
    {'id': '2CO', 'name': '2 Corinthiens', 't': 'new'},
    {'id': 'GAL', 'name': 'Galates', 't': 'new'},
    {'id': 'EPH', 'name': 'Éphésiens', 't': 'new'},
    {'id': 'PHP', 'name': 'Philippiens', 't': 'new'},
    {'id': 'COL', 'name': 'Colossiens', 't': 'new'},
    {'id': '1TH', 'name': '1 Thessaloniciens', 't': 'new'},
    {'id': '2TH', 'name': '2 Thessaloniciens', 't': 'new'},
    {'id': '1TI', 'name': '1 Timothée', 't': 'new'},
    {'id': '2TI', 'name': '2 Timothée', 't': 'new'},
    {'id': 'TIT', 'name': 'Tite', 't': 'new'},
    {'id': 'PHM', 'name': 'Philémon', 't': 'new'},
    {'id': 'HEB', 'name': 'Hébreux', 't': 'new'},
    {'id': 'JAS', 'name': 'Jacques', 't': 'new'},
    {'id': '1PE', 'name': '1 Pierre', 't': 'new'},
    {'id': '2PE', 'name': '2 Pierre', 't': 'new'},
    {'id': '1JN', 'name': '1 Jean', 't': 'new'},
    {'id': '2JN', 'name': '2 Jean', 't': 'new'},
    {'id': '3JN', 'name': '3 Jean', 't': 'new'},
    {'id': 'JUD', 'name': 'Jude', 't': 'new'},
    {'id': 'REV', 'name': 'Apocalypse', 't': 'new'},
  ];

  // ── LIVRES ──────────────────────────────────────────────

  @override
  List<BibleBook> getAllBooks() {
    return _books.map((b) {
      return BibleBook(
        identifier: b['id']!,
        name: b['name']!,
        chapterCount: _chapterCounts[b['id']] ?? 1,
        testament: b['t'] == 'old'
            ? BibleTestament.old
            : BibleTestament.newTestament,
      );
    }).toList();
  }

  @override
  BibleBook? getBookByIdentifier(String identifier) {
    try {
      final b = _books.firstWhere((b) => b['id'] == identifier.toUpperCase());
      return BibleBook(
        identifier: b['id']!,
        name: b['name']!,
        chapterCount: _chapterCounts[b['id']] ?? 1,
        testament: b['t'] == 'old'
            ? BibleTestament.old
            : BibleTestament.newTestament,
      );
    } catch (_) {
      return null;
    }
  }

  String _getBookName(String bookId) {
    try {
      return _books.firstWhere((b) => b['id'] == bookId)['name'] ?? bookId;
    } catch (_) {
      return bookId;
    }
  }

  // ── CHAPITRES ───────────────────────────────────────────

  @override
  Future<Either<Failure, BibleChapter>> getChapter({
    required String translationId,
    required String bookIdentifier,
    required int chapterNumber,
  }) async {
    final bookId = bookIdentifier.toUpperCase();

    // 1. Cache local Isar
    try {
      final cached = await _isar.bibleChapterModels
          .filter()
          .translationIdEqualTo(translationId)
          .bookIdentifierEqualTo(bookId)
          .chapterNumberEqualTo(chapterNumber)
          .findFirst();

      if (cached != null) {
        await _isar.db.writeTxn(() async {
          cached.lastReadAt = DateTime.now();
          await _isar.bibleChapterModels.put(cached);
        });
        return Right(BibleMappers.chapterFromModel(cached));
      }
    } catch (e) {
      AppLogger.w('Bible: cache miss: $e', 'BIBLE_REPO');
    }

    // 2. Fetch distant
    try {
      final url =
          'https://bible-api.com/$bookId+$chapterNumber?translation=$translationId';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final versesData = data['verses'] as List?;
        if (versesData == null) {
          return Left(ServerFailure('Aucun verset trouvé pour $bookId $chapterNumber'));
        }

        final verses = versesData
            .map((v) => (v['text'] as String?) ?? '')
            .toList();

        final model = BibleChapterModel()
          ..bookIdentifier = bookId
          ..chapterNumber = chapterNumber
          ..translationId = translationId
          ..verses = verses
          ..lastReadAt = DateTime.now();

        await _isar.db.writeTxn(() async {
          await _isar.bibleChapterModels.put(model);
        });

        return Right(BibleMappers.chapterFromModel(model));
      }
      return Left(ServerFailure(
          'Erreur API Bible: ${response.statusCode}',
          statusCode: response.statusCode));
    } catch (e, st) {
      return Left(NetworkFailure('Impossible de charger $bookId $chapterNumber',
          stackTrace: st));
    }
  }

  @override
  Future<List<BibleChapter>> getRecentReadings({int limit = 3}) async {
    final models = await _isar.bibleChapterModels
        .where()
        .anyId()
        .sortByLastReadAtDesc()
        .limit(limit)
        .findAll();
    return models.map(BibleMappers.chapterFromModel).toList();
  }

  // ── VERSETS & RECHERCHE ─────────────────────────────────

  @override
  Future<Either<Failure, List<BibleVerse>>> searchVerses({
    required String query,
    String? translationId,
    int limit = 50,
  }) async {
    if (query.trim().isEmpty) return const Right([]);

    try {
      final queryLower = query.toLowerCase();
      
      // We prioritize searching in BibleVerseModel which is indexed
      var verseQuery = _isar.bibleVerseModels
          .filter()
          .textContains(queryLower, caseSensitive: false);

      if (translationId != null) {
        verseQuery = verseQuery.translationIdEqualTo(translationId);
      }

      final models = await verseQuery.limit(limit).findAll();
      
      if (models.isNotEmpty) {
        return Right(models.map((m) => BibleVerse(
          bookIdentifier: m.bookIdentifier,
          bookName: _getBookName(m.bookIdentifier),
          chapter: m.chapter,
          verse: m.verse,
          text: m.text,
          translationId: m.translationId,
        )).toList());
      }

      // Fallback to chapter search if BibleVerseModel is empty (not yet imported/fully indexed)
      final chaptersQuery = translationId != null
          ? _isar.bibleChapterModels
              .filter()
              .translationIdEqualTo(translationId)
          : _isar.bibleChapterModels.where();

      final chapters = await chaptersQuery.findAll();
      final results = <BibleVerse>[];

      for (final chapter in chapters) {
        for (int i = 0; i < chapter.verses.length; i++) {
          if (chapter.verses[i].toLowerCase().contains(queryLower)) {
            results.add(BibleVerse(
              bookIdentifier: chapter.bookIdentifier,
              bookName: _getBookName(chapter.bookIdentifier),
              chapter: chapter.chapterNumber,
              verse: i + 1,
              text: chapter.verses[i],
              translationId: chapter.translationId,
            ));
            if (results.length >= limit) return Right(results);
          }
        }
      }
      return Right(results);
    } catch (e, st) {
      return Left(CacheFailure('Erreur de recherche: $e', stackTrace: st));
    }
  }

  @override
  Future<Either<Failure, List<BibleSearchHistory>>> getSearchHistory() async {
    try {
      final models = await _isar.bibleSearchHistoryModels
          .filter()
          .userIdEqualTo(_userId)
          .sortByCreatedAtDesc()
          .limit(10)
          .findAll();
      return Right(models.map(BibleMappers.searchHistoryFromModel).toList());
    } catch (e, st) {
      return Left(CacheFailure('Erreur histoire recherche', stackTrace: st));
    }
  }

  @override
  Future<Either<Failure, void>> saveSearchHistory(String query, int resultCount) async {
    try {
      final existing = await _isar.bibleSearchHistoryModels
          .filter()
          .userIdEqualTo(_userId)
          .queryEqualTo(query, caseSensitive: false)
          .findFirst();

      await _isar.db.writeTxn(() async {
        if (existing != null) {
          existing.createdAt = DateTime.now();
          existing.resultCount = resultCount;
          await _isar.bibleSearchHistoryModels.put(existing);
        } else {
          final model = BibleSearchHistoryModel()
            ..query = query
            ..resultCount = resultCount
            ..userId = _userId
            ..churchId = 'default' // Should be injected via church provider ideally
            ..createdAt = DateTime.now();
          await _isar.bibleSearchHistoryModels.put(model);
        }
      });
      return const Right(null);
    } catch (e, st) {
      return Left(CacheFailure('Erreur sauvegarde histoire', stackTrace: st));
    }
  }

  @override
  Future<Either<Failure, void>> deleteSearchHistory(int id) async {
    try {
      await _isar.db.writeTxn(() async {
        await _isar.bibleSearchHistoryModels.delete(id);
      });
      return const Right(null);
    } catch (e, st) {
      return Left(CacheFailure('Erreur suppression histoire', stackTrace: st));
    }
  }

  @override
  Future<Either<Failure, void>> clearSearchHistory() async {
    try {
      await _isar.db.writeTxn(() async {
        await _isar.bibleSearchHistoryModels
            .filter()
            .userIdEqualTo(_userId)
            .deleteAll();
      });
      return const Right(null);
    } catch (e, st) {
      return Left(CacheFailure('Erreur vide histoire', stackTrace: st));
    }
  }

  @override
  Map<String, String> getVerseOfTheDay() {
    final day = DateTime.now().day;
    final verses = [
      {'book': 'JHN', 'chapter': '3', 'ref': 'Jean 3:16',
       'text': 'Car Dieu a tant aimé le monde qu\'il a donné son Fils unique...'},
      {'book': 'PSA', 'chapter': '23', 'ref': 'Psaume 23:1',
       'text': 'L\'Éternel est mon berger: je ne manquerai de rien.'},
      {'book': 'PHP', 'chapter': '4', 'ref': 'Philippiens 4:13',
       'text': 'Je puis tout par celui qui me fortifie.'},
      {'book': 'ROM', 'chapter': '8', 'ref': 'Romains 8:28',
       'text': 'Toutes choses concourent au bien de ceux qui aiment Dieu.'},
      {'book': 'JER', 'chapter': '29', 'ref': 'Jérémie 29:11',
       'text': 'Car je connais les projets que j\'ai formés sur vous...'},
      {'book': 'MAT', 'chapter': '6', 'ref': 'Matthieu 6:33',
       'text': 'Cherchez premièrement le royaume et la justice de Dieu.'},
      {'book': 'ISA', 'chapter': '41', 'ref': 'Ésaïe 41:10',
       'text': 'Ne crains rien, car je suis avec toi.'},
    ];
    return verses[(day - 1) % verses.length];
  }

  // ── TRADUCTIONS ─────────────────────────────────────────

  @override
  List<BibleTranslation> getAvailableTranslations() {
    return [
      const BibleTranslation(
          id: 'ls1910', name: 'Louis Segond 1910', shortName: 'LSG',
          language: 'fr'),
      const BibleTranslation(
          id: 'kjv', name: 'King James Version', shortName: 'KJV',
          language: 'en'),
      const BibleTranslation(
          id: 'darby', name: 'Darby (Français)', shortName: 'DARBY',
          language: 'fr'),
      const BibleTranslation(
          id: 'bds', name: 'Bible du Semeur', shortName: 'BDS',
          language: 'fr'),
    ];
  }

  @override
  Future<int> getDownloadedChaptersCount(String translationId) async {
    try {
      return await _isar.bibleChapterModels
          .filter()
          .translationIdEqualTo(translationId)
          .count();
    } catch (_) {
      return 0;
    }
  }

  // ── SIGNETS ─────────────────────────────────────────────

  @override
  Future<Either<Failure, List<BibleBookmark>>> getBookmarks() async {
    try {
      final models = await _isar.bibleBookmarkModels
          .filter()
          .userIdEqualTo(_userId)
          .sortByCreatedAtDesc()
          .findAll();
      final entities = models
          .map((m) =>
              BibleMappers.bookmarkFromModel(m, bookName: _getBookName(m.bookIdentifier)))
          .toList();
      return Right(entities);
    } catch (e, st) {
      return Left(CacheFailure('Erreur chargement signets', stackTrace: st));
    }
  }

  @override
  Future<Either<Failure, List<BibleBookmark>>> getBookmarksByCollection(
      String collection) async {
    try {
      final models = await _isar.bibleBookmarkModels
          .filter()
          .userIdEqualTo(_userId)
          .collectionNameEqualTo(collection)
          .sortByCreatedAtDesc()
          .findAll();
      return Right(models
          .map((m) =>
              BibleMappers.bookmarkFromModel(m, bookName: _getBookName(m.bookIdentifier)))
          .toList());
    } catch (e, st) {
      return Left(CacheFailure('Erreur chargement collection', stackTrace: st));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getCollections() async {
    try {
      final markers = await _isar.bibleBookmarkModels
          .filter()
          .userIdEqualTo(_userId)
          .findAll();
      final collections =
          markers.map((b) => b.collectionName).toSet().toList()..sort();
      return Right(collections);
    } catch (e, st) {
      return Left(CacheFailure('Erreur chargement collections', stackTrace: st));
    }
  }

  @override
  Future<Either<Failure, bool>> isBookmarked(
      String book, int chapter, int verse) async {
    try {
      final existing = await _isar.bibleBookmarkModels
          .filter()
          .bookIdentifierEqualTo(book)
          .chapterEqualTo(chapter)
          .verseEqualTo(verse)
          .userIdEqualTo(_userId)
          .findFirst();
      return Right(existing != null);
    } catch (e, st) {
      return Left(CacheFailure('Erreur vérification signet', stackTrace: st));
    }
  }

  @override
  Future<Either<Failure, void>> addBookmark({
    required String bookIdentifier,
    required int chapter,
    required int verse,
    required String verseText,
    required String translationId,
    String collectionName = 'Général',
  }) async {
    try {
      final existing = await _isar.bibleBookmarkModels
          .filter()
          .bookIdentifierEqualTo(bookIdentifier)
          .chapterEqualTo(chapter)
          .verseEqualTo(verse)
          .userIdEqualTo(_userId)
          .findFirst();
      if (existing != null) return const Right(null);

      final reference = '${_getBookName(bookIdentifier)} $chapter:$verse';
      final model = BibleBookmarkModel()
        ..bookIdentifier = bookIdentifier
        ..chapter = chapter
        ..verse = verse
        ..verseText = verseText
        ..translationId = translationId
        ..userId = _userId
        ..reference = reference
        ..collectionName = collectionName;

      await _isar.db.writeTxn(() async {
        await _isar.bibleBookmarkModels.put(model);
      });
      unawaited(_upsertBookmarkToSupabase(model));
      return const Right(null);
    } catch (e, st) {
      return Left(CacheFailure('Erreur ajout signet', stackTrace: st));
    }
  }

  @override
  Future<Either<Failure, void>> removeBookmark({
    required String bookIdentifier,
    required int chapter,
    required int verse,
  }) async {
    try {
      final existing = await _isar.bibleBookmarkModels
          .filter()
          .bookIdentifierEqualTo(bookIdentifier)
          .chapterEqualTo(chapter)
          .verseEqualTo(verse)
          .userIdEqualTo(_userId)
          .findFirst();
      if (existing == null) return const Right(null);

      await _isar.db.writeTxn(() async {
        await _isar.bibleBookmarkModels.delete(existing.id);
      });
      unawaited(_deleteBookmarkFromSupabase(existing.supabaseId));
      return const Right(null);
    } catch (e, st) {
      return Left(CacheFailure('Erreur suppression signet', stackTrace: st));
    }
  }

  @override
  Future<Either<Failure, void>> toggleBookmark({
    required String bookIdentifier,
    required int chapter,
    required int verse,
    required String verseText,
    required String translationId,
    String collectionName = 'Général',
  }) async {
    final checkResult = await isBookmarked(bookIdentifier, chapter, verse);
    return checkResult.fold(Left.new, (exists) {
      if (exists) {
        return removeBookmark(
            bookIdentifier: bookIdentifier, chapter: chapter, verse: verse);
      } else {
        return addBookmark(
          bookIdentifier: bookIdentifier,
          chapter: chapter,
          verse: verse,
          verseText: verseText,
          translationId: translationId,
          collectionName: collectionName,
        );
      }
    });
  }

  @override
  Future<Either<Failure, void>> syncBookmarksFromCloud() async {
    if (_userId == 'anonymous') return const Right(null);
    try {
      final remote = await Supabase.instance.client
          .from('bible_bookmarks')
          .select()
          .eq('user_id', _userId);

      await _isar.db.writeTxn(() async {
        for (final r in remote) {
          final exists = await _isar.bibleBookmarkModels
              .filter()
              .bookIdentifierEqualTo(r['book_id'] as String)
              .chapterEqualTo(r['chapter'] as int)
              .verseEqualTo(r['verse'] as int)
              .userIdEqualTo(_userId)
              .findFirst();
          if (exists == null) {
            final m = BibleBookmarkModel()
              ..bookIdentifier = r['book_id'] as String
              ..chapter = r['chapter'] as int
              ..verse = r['verse'] as int
              ..verseText = r['verse_text'] as String
              ..translationId = r['version'] as String
              ..userId = _userId
              ..reference = r['reference'] as String?
              ..collectionName = (r['collection_name'] as String?) ?? 'Général'
              ..supabaseId = r['id'] as String
              ..createdAt =
                  DateTime.parse(r['created_at'] as String);
            await _isar.bibleBookmarkModels.put(m);
          }
        }
      });
      return const Right(null);
    } catch (e, st) {
      return Left(SyncFailure('Échec sync signets', stackTrace: st));
    }
  }

  // ── ANNOTATIONS ─────────────────────────────────────────

  @override
  Future<Either<Failure, List<BibleAnnotation>>> getAnnotations({
    required String bookIdentifier,
    required int chapter,
  }) async {
    try {
      final models = await _isar.bibleAnnotationModels
          .filter()
          .bookIdentifierEqualTo(bookIdentifier)
          .chapterEqualTo(chapter)
          .findAll();
      return Right(models.map(BibleMappers.annotationFromModel).toList());
    } catch (e, st) {
      return Left(CacheFailure('Erreur annotations', stackTrace: st));
    }
  }

  @override
  Future<Either<Failure, void>> saveHighlight({
    required String bookIdentifier,
    required int chapter,
    required int verse,
    required String translationId,
    required String colorHex,
    String? category,
  }) async {
    try {
      final existing = await _isar.bibleAnnotationModels
          .filter()
          .bookIdentifierEqualTo(bookIdentifier)
          .chapterEqualTo(chapter)
          .verseEqualTo(verse)
          .typeEqualTo('highlight')
          .findFirst();

      await _isar.db.writeTxn(() async {
        if (existing != null) {
          existing.color = colorHex;
          existing.category = category;
          existing.updatedAt = DateTime.now();
          await _isar.bibleAnnotationModels.put(existing);
        } else {
          final model = BibleAnnotationModel()
            ..bookIdentifier = bookIdentifier
            ..chapter = chapter
            ..verse = verse
            ..translationId = translationId
            ..type = 'highlight'
            ..color = colorHex
            ..category = category
            ..createdAt = DateTime.now()
            ..updatedAt = DateTime.now();
          await _isar.bibleAnnotationModels.put(model);
        }
      });
      return const Right(null);
    } catch (e, st) {
      return Left(CacheFailure('Erreur sauvegarde surlignage', stackTrace: st));
    }
  }

  @override
  Future<Either<Failure, void>> saveNote({
    required String bookIdentifier,
    required int chapter,
    required int verse,
    required String translationId,
    required String content,
  }) async {
    if (content.isEmpty) return const Right(null);
    try {
      final existing = await _isar.bibleAnnotationModels
          .filter()
          .bookIdentifierEqualTo(bookIdentifier)
          .chapterEqualTo(chapter)
          .verseEqualTo(verse)
          .typeEqualTo('note')
          .findFirst();

      await _isar.db.writeTxn(() async {
        if (existing != null) {
          existing.content = content;
          existing.updatedAt = DateTime.now();
          await _isar.bibleAnnotationModels.put(existing);
        } else {
          final model = BibleAnnotationModel()
            ..bookIdentifier = bookIdentifier
            ..chapter = chapter
            ..verse = verse
            ..translationId = translationId
            ..type = 'note'
            ..content = content
            ..createdAt = DateTime.now()
            ..updatedAt = DateTime.now();
          await _isar.bibleAnnotationModels.put(model);
        }
      });
      return const Right(null);
    } catch (e, st) {
      return Left(CacheFailure('Erreur sauvegarde note', stackTrace: st));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAnnotation(int localId) async {
    try {
      final annotation = await _isar.bibleAnnotationModels.get(localId);
      await _isar.db.writeTxn(() async {
        await _isar.bibleAnnotationModels.delete(localId);
      });
      if (annotation?.supabaseId != null) {
        unawaited(_deleteAnnotationFromSupabase(annotation!.supabaseId!));
      }
      return const Right(null);
    } catch (e, st) {
      return Left(CacheFailure('Erreur suppression annotation', stackTrace: st));
    }
  }

  // ── PLANS DE LECTURE ────────────────────────────────────

  @override
  Future<Either<Failure, List<BibleReadingPlan>>> getReadingPlans() async {
    try {
      final models = await _isar.bibleReadingPlanModels.where().findAll();
      return Right(models.map(BibleMappers.planFromModel).toList());
    } catch (e, st) {
      return Left(CacheFailure('Erreur chargement plans', stackTrace: st));
    }
  }

  @override
  Future<Either<Failure, BibleReadingPlan?>> getActivePlan() async {
    try {
      final model = await _isar.bibleReadingPlanModels.where().findFirst();
      return Right(model != null ? BibleMappers.planFromModel(model) : null);
    } catch (e, st) {
      return Left(CacheFailure('Erreur plan actif', stackTrace: st));
    }
  }

  @override
  Future<Either<Failure, BiblePlanProgress?>> getPlanProgress({
    required String planId,
    required String userId,
  }) async {
    try {
      final model = await _isar.biblePlanProgressModels
          .filter()
          .planIdEqualTo(planId)
          .userIdEqualTo(userId)
          .findFirst();
      return Right(model != null ? BibleMappers.progressFromModel(model) : null);
    } catch (e, st) {
      return Left(CacheFailure('Erreur progression plan', stackTrace: st));
    }
  }

  @override
  Future<Either<Failure, void>> markDayComplete({
    required String planId,
    required String userId,
    required int dayNumber,
  }) async {
    try {
      var progress = await _isar.biblePlanProgressModels
          .filter()
          .planIdEqualTo(planId)
          .userIdEqualTo(userId)
          .findFirst();

      await _isar.db.writeTxn(() async {
        if (progress == null) {
          progress = BiblePlanProgressModel()
            ..planId = planId
            ..userId = userId
            ..startDate = DateTime.now()
            ..completedDays = [dayNumber]
            ..lastReadAt = DateTime.now();
        } else if (!progress!.completedDays.contains(dayNumber)) {
          progress!.completedDays = [...progress!.completedDays, dayNumber];
          progress!.lastReadAt = DateTime.now();
        }
        await _isar.biblePlanProgressModels.put(progress!);
      });
      return const Right(null);
    } catch (e, st) {
      return Left(
          CacheFailure('Erreur mise à jour progression', stackTrace: st));
    }
  }

  // ── STATISTIQUES & GAMIFICATION ──────────────────────────

  @override
  Future<Either<Failure, BibleReadingStat>> getReadingStats() async {
    try {
      var model = await _isar.bibleReadingStatModels
          .filter()
          .userIdEqualTo(_userId)
          .findFirst();

      if (model == null) {
        model = BibleReadingStatModel()
          ..userId = _userId
          ..churchId = 'default';
        await _isar.db.writeTxn(() async {
          await _isar.bibleReadingStatModels.put(model!);
        });
      }
      return Right(BibleMappers.statFromModel(model));
    } catch (e, st) {
      return Left(CacheFailure('Erreur stats lecture', stackTrace: st));
    }
  }

  @override
  Future<Either<Failure, void>> updateReadingStreak() async {
    try {
      var model = await _isar.bibleReadingStatModels
          .filter()
          .userIdEqualTo(_userId)
          .findFirst();

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      await _isar.db.writeTxn(() async {
        if (model == null) {
          model = BibleReadingStatModel()
            ..userId = _userId
            ..churchId = 'default'
            ..currentStreak = 1
            ..maxStreak = 1
            ..lastReadDate = today
            ..updatedAt = now;
          await _isar.bibleReadingStatModels.put(model!);
        } else {
          final lastRead = model!.lastReadDate;
          if (lastRead != null) {
            final lastDay = DateTime(lastRead.year, lastRead.month, lastRead.day);
            final diff = today.difference(lastDay).inDays;

            if (diff == 1) {
              // Consecutive day → increment streak
              model!.currentStreak += 1;
            } else if (diff > 1) {
              // Streak broken → reset to 1
              model!.currentStreak = 1;
            }
            // diff == 0 → same day, no change
          } else {
            model!.currentStreak = 1;
          }

          if (model!.currentStreak > model!.maxStreak) {
            model!.maxStreak = model!.currentStreak;
          }
          model!.lastReadDate = today;
          model!.updatedAt = now;
          await _isar.bibleReadingStatModels.put(model!);
        }
      });
      return const Right(null);
    } catch (e, st) {
      return Left(CacheFailure('Erreur mise à jour streak', stackTrace: st));
    }
  }

  @override
  Future<Either<Failure, void>> incrementChaptersRead() async {
    try {
      var model = await _isar.bibleReadingStatModels
          .filter()
          .userIdEqualTo(_userId)
          .findFirst();

      await _isar.db.writeTxn(() async {
        if (model == null) {
          model = BibleReadingStatModel()
            ..userId = _userId
            ..churchId = 'default'
            ..totalChaptersRead = 1;
          await _isar.bibleReadingStatModels.put(model!);
        } else {
          model!.totalChaptersRead += 1;
          model!.updatedAt = DateTime.now();
          await _isar.bibleReadingStatModels.put(model!);
        }
      });
      return const Right(null);
    } catch (e, st) {
      return Left(CacheFailure('Erreur compteur chapitres', stackTrace: st));
    }
  }

  @override
  Future<Either<Failure, void>> incrementAnnotationsCount() async {
    try {
      var model = await _isar.bibleReadingStatModels
          .filter()
          .userIdEqualTo(_userId)
          .findFirst();

      await _isar.db.writeTxn(() async {
        if (model == null) {
          model = BibleReadingStatModel()
            ..userId = _userId
            ..churchId = 'default'
            ..totalAnnotations = 1;
          await _isar.bibleReadingStatModels.put(model!);
        } else {
          model!.totalAnnotations += 1;
          model!.updatedAt = DateTime.now();
          await _isar.bibleReadingStatModels.put(model!);
        }
      });
      return const Right(null);
    } catch (e, st) {
      return Left(CacheFailure('Erreur compteur annotations', stackTrace: st));
    }
  }

  // ── IMPORT LOCAL ────────────────────────────────────────

  @override
  Future<Either<Failure, void>> importLocalBibles() async {
    try {
      await _importService.importAllBibles();
      return const Right(null);
    } catch (e, st) {
      return Left(CacheFailure('Erreur import Bibles locales', stackTrace: st));
    }
  }

  @override
  Future<bool> isBibleImported(String translationId) async {
    final count = await getDownloadedChaptersCount(translationId);
    return count > 100; // Au moins 100 chapitres = Bible partiellement importée
  }

  // ── TÉLÉCHARGEMENT EN LIGNE ─────────────────────────────

  @override
  Future<Either<Failure, void>> downloadEntireBible(
      String translationId) async {
    final books = getAllBooks();
    int downloaded = 0;
    for (final book in books) {
      for (int i = 1; i <= book.chapterCount; i++) {
        final result = await getChapter(
          translationId: translationId,
          bookIdentifier: book.identifier,
          chapterNumber: i,
        );
        if (result.isRight()) downloaded++;
      }
    }
    AppLogger.i('Bible: téléchargé $downloaded chapitres pour $translationId',
        'BIBLE_REPO');
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> clearCachedTranslation(
      String translationId) async {
    try {
      await _isar.db.writeTxn(() async {
        await _isar.bibleChapterModels
            .filter()
            .translationIdEqualTo(translationId)
            .deleteAll();
      });
      return const Right(null);
    } catch (e, st) {
      return Left(CacheFailure('Erreur suppression cache', stackTrace: st));
    }
  }

  @override
  Future<Either<Failure, void>> clearAllTranslations() async {
    try {
      await _isar.db.writeTxn(() async {
        await _isar.bibleChapterModels.clear();
      });
      return const Right(null);
    } catch (e, st) {
      return Left(CacheFailure('Erreur suppression cache total', stackTrace: st));
    }
  }

  // ── SUPABASE HELPERS (PRIVATE) ──────────────────────────

  Future<void> _upsertBookmarkToSupabase(BibleBookmarkModel model) async {
    if (_userId == 'anonymous') return;
    try {
      final verseId =
          '${model.translationId}_${model.bookIdentifier}_${model.chapter}_${model.verse}';
      await Supabase.instance.client.from('bible_bookmarks').upsert({
        'user_id': _userId,
        'verse_id': verseId,
        'book_id': model.bookIdentifier,
        'chapter': model.chapter,
        'verse': model.verse,
        'version': model.translationId,
        'verse_text': model.verseText,
        'reference': model.reference,
        'collection_name': model.collectionName,
      }, onConflict: 'user_id,verse_id');
    } catch (e) {
      AppLogger.w('Bookmark Supabase sync failed: $e', 'BIBLE_REPO');
    }
  }

  Future<void> _deleteBookmarkFromSupabase(String? supabaseId) async {
    if (_userId == 'anonymous' || supabaseId == null) return;
    try {
      await Supabase.instance.client
          .from('bible_bookmarks')
          .delete()
          .eq('id', supabaseId);
    } catch (e) {
      AppLogger.w('Bookmark delete sync failed: $e', 'BIBLE_REPO');
    }
  }

  Future<void> _deleteAnnotationFromSupabase(String supabaseId) async {
    if (_userId == 'anonymous') return;
    try {
      await Supabase.instance.client
          .from('bible_highlights')
          .delete()
          .eq('id', supabaseId);
    } catch (e) {
      AppLogger.w('Annotation delete sync failed: $e', 'BIBLE_REPO');
    }
  }
}
