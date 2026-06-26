import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/data/local/isar_service.dart';
import '../../../../core/logging/app_logger.dart';
import 'package:isar/isar.dart';
import 'package:lumina/features/bible/core/models/bible_models.dart';

part 'bible_import_service.g.dart';

class BibleImportState {
  final bool isImporting;
  final double progress;
  final String? currentItem;
  final String? error;

  BibleImportState({
    this.isImporting = false,
    this.progress = 0.0,
    this.currentItem,
    this.error,
  });

  BibleImportState copyWith({
    bool? isImporting,
    double? progress,
    String? currentItem,
    String? error,
  }) {
    return BibleImportState(
      isImporting: isImporting ?? this.isImporting,
      progress: progress ?? this.progress,
      currentItem: currentItem ?? this.currentItem,
      error: error ?? this.error,
    );
  }
}

@Riverpod(keepAlive: true)
class BibleImportService extends _$BibleImportService {
  late final IsarService _isarService;

  @override
  BibleImportState build() {
    _isarService = ref.watch(isarServiceProvider);
    return BibleImportState();
  }

  /// Map of book index (0-indexed) to Book Identifier
  static const List<String> _bookIds = [
    'GEN',
    'EXO',
    'LEV',
    'NUM',
    'DEU',
    'JOS',
    'JDG',
    'RUT',
    '1SA',
    '2SA',
    '1KI',
    '2KI',
    '1CH',
    '2CH',
    'EZR',
    'NEH',
    'EST',
    'JOB',
    'PSA',
    'PRO',
    'ECC',
    'SNG',
    'ISA',
    'JER',
    'LAM',
    'EZK',
    'DAN',
    'HOS',
    'JOL',
    'AMO',
    'OBA',
    'JON',
    'MIC',
    'NAM',
    'HAB',
    'ZEP',
    'HAG',
    'ZEC',
    'MAL',
    'MAT',
    'MRK',
    'LUK',
    'JHN',
    'ACT',
    'ROM',
    '1CO',
    '2CO',
    'GAL',
    'EPH',
    'PHP',
    'COL',
    '1TH',
    '2TH',
    '1TI',
    '2TI',
    'TIT',
    'PHM',
    'HEB',
    'JAS',
    '1PE',
    '2PE',
    '1JN',
    '2JN',
    '3JN',
    'JUD',
    'REV'
  ];

  /// List of bibles to import from assets
  static const List<Map<String, String>> _availableBibles = [
    {'id': 'ls1910', 'file': 'lsg1910.json', 'name': 'Louis Segond 1910'},
    {'id': 'kjv', 'file': 'kjv.json', 'name': 'King James Version'},
    {'id': 'darby', 'file': 'darby.json', 'name': 'Darby (Fr)'},
    {'id': 'bds', 'file': 'bds.json', 'name': 'Bible du Semeur'},
  ];

  Future<void> importAllBibles() async {
    if (state.isImporting) return;

    state = BibleImportState(isImporting: true, progress: 0.0);
    AppLogger.i('Bible: Starting multi-version import', 'IMPORT_SERVICE');

    try {
      int completed = 0;
      for (final bible in _availableBibles) {
        final id = bible['id']!;
        final file = bible['file']!;
        final name = bible['name']!;

        state = state.copyWith(
          currentItem: 'Importation de $name...',
          progress: completed / _availableBibles.length,
        );

        try {
          await _importSingleBible(id, file);
          completed++;
        } catch (e) {
          AppLogger.w('Bible: Could not import $file: $e', 'IMPORT_SERVICE');
          // Skip if file doesn't exist or other error, but continue others
        }
      }

      state = BibleImportState(isImporting: false, progress: 1.0);
      AppLogger.i('Bible: Global import complete!', 'IMPORT_SERVICE');
    } catch (e, stack) {
      AppLogger.e('Bible: Global import failed', 'IMPORT_SERVICE', e, stack);
      state =
          BibleImportState(isImporting: false, error: 'Échec de l\'import: $e');
    }
  }

  Future<void> _importSingleBible(String translationId, String fileName) async {
    final String content =
        await rootBundle.loadString('assets/bible/$fileName');
    final dynamic data = jsonDecode(content);

    List<BibleChapterModel> chaptersToInsert = [];

    if (data is Map && data.containsKey('Testaments')) {
      // Format A: LSG 1910
      chaptersToInsert =
          _parseFormatA(data.cast<String, dynamic>(), translationId);
    } else if (data is List) {
      // Format B: KJV
      chaptersToInsert =
          _parseFormatB(data.cast<Map<String, dynamic>>(), translationId);
    } else if (data is Map && data.containsKey('books')) {
      // Format C: getbible / Darby
      chaptersToInsert =
          _parseFormatC(data.cast<String, dynamic>(), translationId);
    } else if (data is List &&
        data.isNotEmpty &&
        data[0] is Map &&
        data[0].containsKey('pk')) {
      // Format D: Bolls
      chaptersToInsert =
          _parseFormatBolls(data.cast<Map<String, dynamic>>(), translationId);
    } else {
      throw Exception('Format de fichier Bible inconnu pour $fileName');
    }

    if (chaptersToInsert.isNotEmpty) {
      await _isarService.db.writeTxn(() async {
        final chaptersToDelete = await _isarService.bibleChapterModels
            .filter()
            .translationIdEqualTo(translationId)
            .build()
            .findAll();
        final idsToDelete = chaptersToDelete.map((e) => e.id).toList();
        await _isarService.bibleChapterModels.deleteAll(idsToDelete);
        await _isarService.bibleChapterModels.putAll(chaptersToInsert);
      });
    }
  }

  List<BibleChapterModel> _parseFormatA(
      Map<String, dynamic> data, String translationId) {
    final List testaments = data['Testaments'] ?? [];
    final List<BibleChapterModel> chapters = [];
    int bookIdx = 0;

    for (var testament in testaments) {
      final List books = testament['Books'] ?? [];
      for (var book in books) {
        final String bookId =
            bookIdx < _bookIds.length ? _bookIds[bookIdx] : 'UNK';
        final List chaptersData = book['Chapters'] ?? [];
        for (var chapterData in chaptersData) {
          final int chapterNum = (chapterData['ID'] as num?)?.toInt() ?? 1;
          final List versesData = chapterData['Verses'] ?? [];
          final verses =
              versesData.map((v) => (v['Text'] as String?) ?? '').toList();

          chapters.add(BibleChapterModel()
            ..bookIdentifier = bookId
            ..chapterNumber = chapterNum
            ..translationId = translationId
            ..verses = verses
            ..lastReadAt = DateTime.now());
        }
        bookIdx++;
      }
    }
    return chapters;
  }

  List<BibleChapterModel> _parseFormatB(
      List<dynamic> data, String translationId) {
    final List<BibleChapterModel> chapters = [];
    for (int i = 0; i < data.length; i++) {
      final bookData = data[i];
      final String bookId = i < _bookIds.length ? _bookIds[i] : 'UNK';
      final List chaptersData = bookData['chapters'] ?? [];

      for (int c = 0; c < chaptersData.length; c++) {
        final List versesData = chaptersData[c] ?? [];
        final verses = versesData.map((v) => v.toString()).toList();

        chapters.add(BibleChapterModel()
          ..bookIdentifier = bookId
          ..chapterNumber = c + 1
          ..translationId = translationId
          ..verses = verses
          ..lastReadAt = DateTime.now());
      }
    }
    return chapters;
  }

  List<BibleChapterModel> _parseFormatC(
      Map<String, dynamic> data, String translationId) {
    final List<BibleChapterModel> chapters = [];
    final List books = data['books'] ?? [];

    for (int i = 0; i < books.length; i++) {
      final book = books[i];
      final int bookNr = (book['nr'] as num?)?.toInt() ?? (i + 1);
      final String bookId =
          (bookNr - 1) < _bookIds.length ? _bookIds[bookNr - 1] : 'UNK';

      final List chaptersData = book['chapters'] ?? [];
      for (var chapterData in chaptersData) {
        final int chapterNum = (chapterData['chapter'] as num?)?.toInt() ?? 1;
        final List versesData = chapterData['verses'] ?? [];
        final verses =
            versesData.map((v) => (v['text'] as String?) ?? '').toList();

        chapters.add(BibleChapterModel()
          ..bookIdentifier = bookId
          ..chapterNumber = chapterNum
          ..translationId = translationId
          ..verses = verses
          ..lastReadAt = DateTime.now());
      }
    }
    return chapters;
  }

  List<BibleChapterModel> _parseFormatBolls(
      List<Map<String, dynamic>> data, String translationId) {
    final Map<String, Map<int, List<String>>> grouped = {};

    for (var entry in data) {
      final int bookNr = (entry['book'] as num?)?.toInt() ?? 1;
      final int chapterNum = (entry['chapter'] as num?)?.toInt() ?? 1;
      final String text = (entry['text'] as String?) ?? '';

      // Map Bolls book number (1-indexed) to our identifier
      final String bookId =
          (bookNr - 1) < _bookIds.length ? _bookIds[bookNr - 1] : 'UNK';

      grouped.putIfAbsent(bookId, () => {});
      grouped[bookId]!.putIfAbsent(chapterNum, () => []);
      grouped[bookId]![chapterNum]!.add(text);
    }

    final List<BibleChapterModel> chapters = [];
    grouped.forEach((bookId, chaptersMap) {
      chaptersMap.forEach((chapterNum, versesList) {
        chapters.add(BibleChapterModel()
          ..bookIdentifier = bookId
          ..chapterNumber = chapterNum
          ..translationId = translationId
          ..verses = versesList
          ..lastReadAt = DateTime.now());
      });
    });

    return chapters;
  }
}
