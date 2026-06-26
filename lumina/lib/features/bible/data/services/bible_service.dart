import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/data/local/isar_service.dart';
import '../../../../core/logging/app_logger.dart';
import 'package:lumina/features/bible/core/models/bible_models.dart';
import 'package:isar/isar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'bible_service.g.dart';

@Riverpod(keepAlive: true)
class BibleService extends _$BibleService {
  late final IsarService _isarService;

  // Metadata for Bible books (Nombre de chapitres)
  static const Map<String, int> bibleMetadata = {
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

  @override
  FutureOr<void> build() {
    _isarService = ref.watch(isarServiceProvider);
  }

  /// Fetch a chapter of the Bible.
  /// Checks local cache first, then falls back to bible-api.com.
  Future<BibleChapterModel?> getChapter({
    required String translation,
    required String book,
    required int chapter,
  }) async {
    final bookId = book.toUpperCase();

    // 1. Check Cache
    try {
      final cached = await _isarService.bibleChapterModels
          .filter()
          .translationIdEqualTo(translation)
          .bookIdentifierEqualTo(bookId)
          .chapterNumberEqualTo(chapter)
          .findFirst();

      if (cached != null) {
        AppLogger.d(
            'Bible: serving from cache ($bookId $chapter)', 'BIBLE_SERVICE');
        // Update last read
        await _isarService.db.writeTxn(() async {
          cached.lastReadAt = DateTime.now();
          await _isarService.bibleChapterModels.put(cached);
        });
        return cached;
      }
    } catch (e) {
      AppLogger.w('Bible: Cache check failed: $e', 'BIBLE_SERVICE');
    }

    // 2. Fetch Remote
    try {
      AppLogger.i(
          'Bible: fetching from API ($bookId $chapter)', 'BIBLE_SERVICE');
      final url =
          'https://bible-api.com/$bookId+$chapter?translation=$translation';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final versesData = data['verses'] as List?;
        if (versesData == null) {
          AppLogger.e(
              'Bible: No verses found in API response', 'BIBLE_SERVICE');
          return null;
        }

        final verses =
            versesData.map((v) => (v['text'] as String?) ?? '').toList();

        final newChapter = BibleChapterModel()
          ..bookIdentifier = bookId
          ..chapterNumber = chapter
          ..translationId = translation
          ..verses = verses
          ..lastReadAt = DateTime.now();

        // Save to cache
        await _isarService.db.writeTxn(() async {
          await _isarService.bibleChapterModels.put(newChapter);
        });

        return newChapter;
      } else {
        AppLogger.e(
            'Bible: API error (${response.statusCode})', 'BIBLE_SERVICE');
      }
    } catch (e) {
      AppLogger.e('Bible: Fetch failed', 'BIBLE_SERVICE', e);
    }

    return null;
  }

  /// Get recent readings from local cache
  Future<List<BibleChapterModel>> getRecentReadings({int limit = 3}) async {
    return await _isarService.bibleChapterModels
        .where()
        .anyId()
        .sortByLastReadAtDesc()
        .limit(limit)
        .findAll();
  }

  /// Get Verse of the Day (pseudo-randomly based on day of month)
  Map<String, String> getVerseOfTheDay() {
    final now = DateTime.now();
    final day = now.day;

    final verses = [
      {
        'book': 'GEN',
        'chapter': '1',
        'text': 'Au commencement, Dieu créa les cieux et la terre.',
        'ref': 'Genèse 1:1'
      },
      {
        'book': 'PSA',
        'chapter': '23',
        'text': 'L\'Éternel est mon berger: je ne manquerai de rien.',
        'ref': 'Psaume 23:1'
      },
      {
        'book': 'PSA',
        'chapter': '119',
        'text':
            'Ta parole est une lampe à mes pieds, Et une lumière sur mon sentier.',
        'ref': 'Psaume 119:105'
      },
      {
        'book': 'PRO',
        'chapter': '3',
        'text':
            'Confie-toi en l\'Éternel de tout ton coeur, Et ne t\'appuie pas sur ta sagesse;',
        'ref': 'Proverbes 3:5'
      },
      {
        'book': 'ISA',
        'chapter': '40',
        'text':
            'Mais ceux qui se confient en l\'Éternel renouvellent leur force. Ils prennent le vol comme les aigles; Ils courent, et ne se lassent point, Ils marchent, et ne se fatiguent point.',
        'ref': 'Ésaïe 40:31'
      },
      {
        'book': 'JER',
        'chapter': '29',
        'text':
            'Car je connais les projets que j\'ai formés sur vous, dit l\'Éternel, projets de paix et non de malheur, afin de vous donner un avenir et de l\'espérance.',
        'ref': 'Jérémie 29:11'
      },
      {
        'book': 'MAT',
        'chapter': '6',
        'text':
            'Cherchez premièrement le royaume et la justice de Dieu; et toutes ces choses vous seront données par-dessus.',
        'ref': 'Matthieu 6:33'
      },
      {
        'book': 'MAT',
        'chapter': '11',
        'text':
            'Venez à moi, vous tous qui êtes fatigués et chargés, et je vous donnerai du repos.',
        'ref': 'Matthieu 11:28'
      },
      {
        'book': 'MAT',
        'chapter': '28',
        'text':
            'Allez, faites de toutes les nations des disciples, les baptisant au nom du Père, du Fils et du Saint-Esprit,',
        'ref': 'Matthieu 28:19'
      },
      {
        'book': 'MRK',
        'chapter': '16',
        'text':
            'Puis il leur dit: Allez par tout le monde, et prêchez la bonne nouvelle à toute la création.',
        'ref': 'Marc 16:15'
      },
      {
        'book': 'JHN',
        'chapter': '3',
        'text':
            'Car Dieu a tant aimé le monde qu\'il a donné son Fils unique, afin que quiconque croit en lui ne périsse point, mais qu\'il ait la vie éternelle.',
        'ref': 'Jean 3:16'
      },
      {
        'book': 'JHN',
        'chapter': '14',
        'text':
            'Jésus lui dit: Je suis le chemin, la vérité, et la vie. Nul ne vient au Père que par moi.',
        'ref': 'Jean 14:6'
      },
      {
        'book': 'ROM',
        'chapter': '8',
        'text':
            'Nous savons, du reste, que toutes choses concourent au bien de ceux qui aiment Dieu, de ceux qui sont appelés selon son dessein.',
        'ref': 'Romains 8:28'
      },
      {
        'book': '1CO',
        'chapter': '13',
        'text':
            'Maintenant donc ces trois choses demeurent: la foi, l\'espérance, la charité; mais la plus grande de ces choses, c\'est la charité.',
        'ref': '1 Corinthiens 13:13'
      },
      {
        'book': '2CO',
        'chapter': '5',
        'text':
            'Si quelqu\'un est en Christ, il est une nouvelle créature. Les choses anciennes sont passées; voici, toutes choses sont devenues nouvelles.',
        'ref': '2 Corinthiens 5:17'
      },
      {
        'book': 'GAL',
        'chapter': '5',
        'text':
            'Mais le fruit de l\'Esprit, c\'est l\'amour, la joie, la paix, la patience, la bonté, la bénignité, la fidélité, la douceur, la tempérance;',
        'ref': 'Galates 5:22'
      },
      {
        'book': 'EPH',
        'chapter': '2',
        'text':
            'Car c\'est par la grâce que vous êtes sauvés, par le moyen de la foi. Et cela ne vient pas de vous, c\'est le don de Dieu.',
        'ref': 'Éphésiens 2:8'
      },
      {
        'book': 'PHP',
        'chapter': '4',
        'text': 'Je puis tout par celui qui me fortifie.',
        'ref': 'Philippiens 4:13'
      },
      {
        'book': 'COL',
        'chapter': '3',
        'text':
            'Et quoi que vous fassiez, en parole ou en oeuvre, faites tout au nom du Seigneur Jésus, en rendant par lui des actions de grâces à Dieu le Père.',
        'ref': 'Colossiens 3:17'
      },
      {
        'book': '1TH',
        'chapter': '5',
        'text':
            'Soyez toujours joyeux. Priez sans cesse. Rendez grâces en toutes choses, car c\'est à votre égard la volonté de Dieu en Jésus-Christ.',
        'ref': '1 Thessaloniciens 5:16-18'
      },
      {
        'book': '2TI',
        'chapter': '1',
        'text':
            'Car ce n\'est pas un esprit de timidité que Dieu nous a donné, mais un esprit de force, d\'amour et de sagesse.',
        'ref': '2 Timothée 1:7'
      },
      {
        'book': 'HEB',
        'chapter': '11',
        'text':
            'Or la foi est une ferme assurance des choses qu\'on espère, une démonstration de celles qu\'on ne voit pas.',
        'ref': 'Hébreux 11:1'
      },
      {
        'book': 'JAS',
        'chapter': '1',
        'text':
            'Si quelqu\'un d\'entre vous manque de sagesse, qu\'il l\'a demande à Dieu, qui donne à tous simplement et sans reproche, et elle lui sera donnée.',
        'ref': 'Jacques 1:5'
      },
      {
        'book': '1PE',
        'chapter': '5',
        'text':
            'et déchargez-vous sur lui de tous vos soucis, car lui-même prend soin de vous.',
        'ref': '1 Pierre 5:7'
      },
      {
        'book': '1JN',
        'chapter': '4',
        'text':
            'Celui qui n\'aime pas n\'a pas connu Dieu, car Dieu est amour.',
        'ref': '1 Jean 4:8'
      },
      {
        'book': 'REV',
        'chapter': '3',
        'text':
            'Voici, je me tiens à la porte, et je frappe. Si quelqu\'un entend ma voix et ouvre la porte, j\'entrerai chez lui, je souperai avec lui, et lui avec moi.',
        'ref': 'Apocalypse 3:20'
      },
      {
        'book': 'PSA',
        'chapter': '27',
        'text':
            'L\'Éternel est ma lumière et mon salut: De qui aurais-je crainte? L\'Éternel est le soutien de ma vie: De qui aurais-je peur?',
        'ref': 'Psaume 27:1'
      },
      {
        'book': 'PSA',
        'chapter': '46',
        'text':
            'Dieu est pour nous un refuge et un appui, Un secours qui ne manque jamais dans la détresse.',
        'ref': 'Psaume 46:1'
      },
      {
        'book': 'PSA',
        'chapter': '121',
        'text':
            'Je lève mes yeux vers les montagnes... D\'où me viendra le secours? Le secours me vient de l\'Éternel, Qui a fait les cieux et la terre.',
        'ref': 'Psaume 121:1-2'
      },
      {
        'book': 'ISA',
        'chapter': '41',
        'text':
            'Ne crains rien, car je suis avec toi; Ne promène pas des regards inquiets, car je suis ton Dieu; Je te fortifie, je viens à ton secours, Je te soutiens de ma droite triomphante.',
        'ref': 'Ésaïe 41:10'
      },
      {
        'book': 'JOS',
        'chapter': '1',
        'text':
            'Ne t\'ai-je pas donné cet ordre: Fortifie-toi et prends courage? Ne t\'effraie point et ne t\'épouvante point, car l\'Éternel, ton Dieu, est avec toi dans tout ce que tu entreprendras.',
        'ref': 'Josué 1:9'
      },
    ];

    // Pick based on day of month (1 to 31). Index is day - 1.
    return verses[(day - 1) % verses.length];
  }

  /// Get list of books (Hardcoded for now as bible-api.com doesn't have a clean list endpoint)
  List<Map<String, String>> getBooks() {
    return [
      {'id': 'GEN', 'name': 'Genèse'},
      {'id': 'EXO', 'name': 'Exode'},
      {'id': 'LEV', 'name': 'Lévitique'},
      {'id': 'NUM', 'name': 'Nombres'},
      {'id': 'DEU', 'name': 'Deutéronome'},
      {'id': 'JOS', 'name': 'Josué'},
      {'id': 'JDG', 'name': 'Juges'},
      {'id': 'RUT', 'name': 'Ruth'},
      {'id': '1SA', 'name': '1 Samuel'},
      {'id': '2SA', 'name': '2 Samuel'},
      {'id': '1KI', 'name': '1 Roi'},
      {'id': '2KI', 'name': '2 Rois'},
      {'id': '1CH', 'name': '1 Chroniques'},
      {'id': '2CH', 'name': '2 Chroniques'},
      {'id': 'EZR', 'name': 'Esdras'},
      {'id': 'NEH', 'name': 'Néhémie'},
      {'id': 'EST', 'name': 'Esther'},
      {'id': 'JOB', 'name': 'Job'},
      {'id': 'PSA', 'name': 'Psaumes'},
      {'id': 'PRO', 'name': 'Proverbes'},
      {'id': 'ECC', 'name': 'Ecclésiaste'},
      {'id': 'SNG', 'name': 'Cantique des Cantiques'},
      {'id': 'ISA', 'name': 'Ésaïe'},
      {'id': 'JER', 'name': 'Jérémie'},
      {'id': 'LAM', 'name': 'Lamentations'},
      {'id': 'EZK', 'name': 'Ézéchiel'},
      {'id': 'DAN', 'name': 'Daniel'},
      {'id': 'HOS', 'name': 'Osée'},
      {'id': 'JOL', 'name': 'Joël'},
      {'id': 'AMO', 'name': 'Amos'},
      {'id': 'OBA', 'name': 'Abdias'},
      {'id': 'JON', 'name': 'Jonas'},
      {'id': 'MIC', 'name': 'Michée'},
      {'id': 'NAM', 'name': 'Nahum'},
      {'id': 'HAB', 'name': 'Habacuc'},
      {'id': 'ZEP', 'name': 'Sophonie'},
      {'id': 'HAG', 'name': 'Aggée'},
      {'id': 'ZEC', 'name': 'Zacharie'},
      {'id': 'MAL', 'name': 'Malachie'},
      {'id': 'MAT', 'name': 'Matthieu'},
      {'id': 'MRK', 'name': 'Marc'},
      {'id': 'LUK', 'name': 'Luc'},
      {'id': 'JHN', 'name': 'Jean'},
      {'id': 'ACT', 'name': 'Actes'},
      {'id': 'ROM', 'name': 'Romains'},
      {'id': '1CO', 'name': '1 Corinthiens'},
      {'id': '2CO', 'name': '2 Corinthiens'},
      {'id': 'GAL', 'name': 'Galates'},
      {'id': 'EPH', 'name': 'Éphésiens'},
      {'id': 'PHP', 'name': 'Philippiens'},
      {'id': 'COL', 'name': 'Colossiens'},
      {'id': '1TH', 'name': '1 Thessaloniciens'},
      {'id': '2TH', 'name': '2 Thessaloniciens'},
      {'id': '1TI', 'name': '1 Timothée'},
      {'id': '2TI', 'name': '2 Timothée'},
      {'id': 'TIT', 'name': 'Tite'},
      {'id': 'PHM', 'name': 'Philémon'},
      {'id': 'HEB', 'name': 'Hébreux'},
      {'id': 'JAS', 'name': 'Jacques'},
      {'id': '1PE', 'name': '1 Pierre'},
      {'id': '2PE', 'name': '2 Pierre'},
      {'id': '1JN', 'name': '1 Jean'},
      {'id': '2JN', 'name': '2 Jean'},
      {'id': '3JN', 'name': '3 Jean'},
      {'id': 'JUD', 'name': 'Jude'},
      {'id': 'REV', 'name': 'Apocalypse'},
    ];
  }

  /// Search Bible chapters in local cache by keyword
  Future<List<Map<String, dynamic>>> searchBible(String query) async {
    if (query.trim().isEmpty) return [];

    final queryLower = query.toLowerCase();
    final chapters = await _isarService.bibleChapterModels.where().findAll();

    final results = <Map<String, dynamic>>[];

    for (final chapter in chapters) {
      for (int i = 0; i < chapter.verses.length; i++) {
        if (chapter.verses[i].toLowerCase().contains(queryLower)) {
          results.add({
            'book': chapter.bookIdentifier,
            'chapter': chapter.chapterNumber,
            'verse': i + 1,
            'text': chapter.verses[i],
            'translation': chapter.translationId,
          });
          if (results.length >= 50) return results;
        }
      }
    }
    return results;
  }

  // ── Bookmarks / Favorites ──────────────────────────────────

  String get _userId =>
      Supabase.instance.client.auth.currentUser?.id ?? 'anonymous';

  /// Get book name from ID
  String getBookName(String bookId) {
    final books = getBooks();
    final book = books.firstWhere(
      (b) => b['id'] == bookId,
      orElse: () => {'name': bookId},
    );
    return book['name'] ?? bookId;
  }

  Future<void> toggleBookmark({
    required String book,
    required int chapter,
    required int verse,
    required String text,
    String translation = 'ls1910',
    String collectionName = 'Général',
  }) async {
    final existing = await _isarService.bibleBookmarkModels
        .filter()
        .bookIdentifierEqualTo(book)
        .chapterEqualTo(chapter)
        .verseEqualTo(verse)
        .userIdEqualTo(_userId)
        .findFirst();

    if (existing != null) {
      // Remove bookmark
      await _isarService.db.writeTxn(() async {
        await _isarService.bibleBookmarkModels.delete(existing.id);
      });
      unawaited(_deleteBookmarkFromSupabase(existing.supabaseId));
    } else {
      // Add bookmark
      final bookName = getBookName(book);
      final reference = '$bookName $chapter:$verse';

      final bookmark = BibleBookmarkModel()
        ..bookIdentifier = book
        ..chapter = chapter
        ..verse = verse
        ..verseText = text
        ..translationId = translation
        ..userId = _userId
        ..reference = reference
        ..collectionName = collectionName;

      await _isarService.db.writeTxn(() async {
        await _isarService.bibleBookmarkModels.put(bookmark);
      });
      unawaited(_upsertBookmarkToSupabase(bookmark));
    }
  }

  Future<void> addToFavorites({
    required String book,
    required int chapter,
    required int verse,
    required String text,
    required String translation,
    String collectionName = 'Général',
  }) async {
    final existing = await _isarService.bibleBookmarkModels
        .filter()
        .bookIdentifierEqualTo(book)
        .chapterEqualTo(chapter)
        .verseEqualTo(verse)
        .userIdEqualTo(_userId)
        .findFirst();

    if (existing != null) return; // Already exists

    final bookName = getBookName(book);
    final reference = '$bookName $chapter:$verse';

    final bookmark = BibleBookmarkModel()
      ..bookIdentifier = book
      ..chapter = chapter
      ..verse = verse
      ..verseText = text
      ..translationId = translation
      ..userId = _userId
      ..reference = reference
      ..collectionName = collectionName;

    await _isarService.db.writeTxn(() async {
      await _isarService.bibleBookmarkModels.put(bookmark);
    });
    unawaited(_upsertBookmarkToSupabase(bookmark));
  }

  Future<bool> isBookmarked(String book, int chapter, int verse) async {
    final existing = await _isarService.bibleBookmarkModels
        .filter()
        .bookIdentifierEqualTo(book)
        .chapterEqualTo(chapter)
        .verseEqualTo(verse)
        .userIdEqualTo(_userId)
        .findFirst();
    return existing != null;
  }

  Future<List<BibleBookmarkModel>> getBookmarks() async {
    return _isarService.bibleBookmarkModels
        .filter()
        .userIdEqualTo(_userId)
        .sortByCreatedAtDesc()
        .findAll();
  }

  Future<List<BibleBookmarkModel>> getBookmarksByCollection(
      String collection) async {
    return _isarService.bibleBookmarkModels
        .filter()
        .userIdEqualTo(_userId)
        .collectionNameEqualTo(collection)
        .sortByCreatedAtDesc()
        .findAll();
  }

  Future<List<String>> getCollections() async {
    final bookmarks = await getBookmarks();
    return bookmarks.map((b) => b.collectionName).toSet().toList()..sort();
  }

  Future<List<BibleBookmarkModel>> searchBookmarks(String query) async {
    if (query.isEmpty) return getBookmarks();
    final queryLower = query.toLowerCase();
    final all = await getBookmarks();
    return all
        .where((b) =>
            b.verseText.toLowerCase().contains(queryLower) ||
            (b.reference?.toLowerCase().contains(queryLower) ?? false))
        .toList();
  }

  // ── Supabase Bookmark Sync ─────────────────────────────────

  Future<void> _upsertBookmarkToSupabase(BibleBookmarkModel model) async {
    if (_userId == 'anonymous') return;
    try {
      final verseId =
          '${model.translationId}_${model.bookIdentifier}_${model.chapter}_${model.verse}';

      final response = await Supabase.instance.client
          .from('bible_bookmarks')
          .upsert({
            'user_id': _userId,
            'verse_id': verseId,
            'book_id': model.bookIdentifier,
            'chapter': model.chapter,
            'verse': model.verse,
            'version': model.translationId,
            'verse_text': model.verseText,
            'reference': model.reference,
            'collection_name': model.collectionName,
          }, onConflict: 'user_id,verse_id')
          .select('id')
          .single();

      final supabaseId = response['id'] as String?;
      if (supabaseId != null) {
        await _isarService.db.writeTxn(() async {
          model.supabaseId = supabaseId;
          await _isarService.bibleBookmarkModels.put(model);
        });
      }
    } catch (e) {
      AppLogger.w('Bookmark sync failed: $e', 'BIBLE_SERVICE');
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
      AppLogger.w('Bookmark delete sync failed: $e', 'BIBLE_SERVICE');
    }
  }

  Future<void> syncBookmarksFromSupabase() async {
    if (_userId == 'anonymous') return;
    try {
      final remoteBookmarks = await Supabase.instance.client
          .from('bible_bookmarks')
          .select()
          .eq('user_id', _userId);

      await _isarService.db.writeTxn(() async {
        for (final remote in remoteBookmarks) {
          final existing = await _isarService.bibleBookmarkModels
              .filter()
              .bookIdentifierEqualTo(remote['book_id'] as String)
              .chapterEqualTo(remote['chapter'] as int)
              .verseEqualTo(remote['verse'] as int)
              .userIdEqualTo(_userId)
              .findFirst();

          if (existing == null) {
            final bookmark = BibleBookmarkModel()
              ..bookIdentifier = remote['book_id'] as String
              ..chapter = remote['chapter'] as int
              ..verse = remote['verse'] as int
              ..verseText = remote['verse_text'] as String
              ..translationId = remote['version'] as String
              ..userId = _userId
              ..reference = remote['reference'] as String?
              ..collectionName =
                  (remote['collection_name'] as String?) ?? 'Général'
              ..supabaseId = remote['id'] as String
              ..createdAt = DateTime.parse(remote['created_at'] as String);
            await _isarService.bibleBookmarkModels.put(bookmark);
          }
        }
      });
    } catch (e) {
      AppLogger.e('Bookmark sync from Supabase failed: $e', 'BIBLE_SERVICE');
    }
  }

  /// Get a random encouragement message
  String getEncouragement() {
    final messages = [
      "Excellent travail ! Vous vous rapprochez de la source.",
      "La constance est la clé de la croissance spirituelle. Continuez !",
      "Gloire à Dieu ! Un jour de plus dans Sa Parole.",
      "Votre persévérance porte du fruit. Restez focalisé.",
      "Que cette Parole habite en vous richement aujourd'hui.",
      "Chaque verset est une graine de vie. Belle progression !",
    ];
    return messages[DateTime.now().millisecond % messages.length];
  }

  /// Initialize default reading plans if they don't exist
  Future<void> initializeDefaultPlans() async {
    final existing = await _isarService.bibleReadingPlanModels.count();
    if (existing > 0) return;

    final plans = [
      BibleReadingPlanModel()
        ..planId = 'bible_90_days'
        ..title = 'Bible en 90 Jours'
        ..description =
            'Un parcours intensif pour traverser toute la Bible en 3 mois.'
        ..durationInDays = 90
        ..days = List.generate(90, (i) {
          // Simplified logic for example, would ideally be a real schedule
          return PlanDayModel()
            ..dayNumber = i + 1
            ..title = 'Jour ${i + 1}'
            ..references = [
              'GEN ${i * 5 + 1}-${i * 5 + 5}'
            ]; // Placeholder logic
        }),
      BibleReadingPlanModel()
        ..planId = 'bible_1_year'
        ..title = 'La Bible en 1 An'
        ..description =
            'Le rythme classique pour méditer toute la Parole en une année.'
        ..durationInDays = 365
        ..days = List.generate(365, (i) {
          return PlanDayModel()
            ..dayNumber = i + 1
            ..title = 'Jour ${i + 1}'
            ..references = ['PSA ${i + 1}']; // Placeholder logic
        }),
    ];

    await _isarService.db.writeTxn(() async {
      await _isarService.bibleReadingPlanModels.putAll(plans);
    });
  }

  /// Available translations
  List<Map<String, String>> getAvailableTranslations() {
    return [
      {'id': 'ls1910', 'name': 'Louis Segond 1910', 'short': 'LSG'},
      {'id': 'kjv', 'name': 'King James Version', 'short': 'KJV'},
      {'id': 'darby', 'name': 'Darby (Français)', 'short': 'DARBY'},
      {'id': 'bds', 'name': 'Bible du Semeur', 'short': 'BDS'},
    ];
  }

  static int getChapterCount(String bookId) {
    return bibleMetadata[bookId] ?? 50;
  }

  /// Get the active reading plan
  Future<BibleReadingPlanModel?> getActivePlan() async {
    return await _isarService.bibleReadingPlanModels.where().findFirst();
  }
}