import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/data/local/isar_service.dart';
import '../../../../core/logging/app_logger.dart';
import 'package:lumina/features/bible/core/models/bible_models.dart';
import 'package:isar/isar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'bible_annotation_service.g.dart';

/// Highlight category presets
class HighlightCategories {
  static const promesse = 'Promesse';
  static const priere = 'Prière';
  static const avertissement = 'Avertissement';
  static const louange = 'Louange';
  static const prophetie = 'Prophétie';

  static List<String> all = [
    promesse,
    priere,
    avertissement,
    louange,
    prophetie,
  ];
}

@riverpod
class BibleAnnotations extends _$BibleAnnotations {
  late final IsarService _isarService;

  @override
  FutureOr<List<BibleAnnotationModel>> build(String book, int chapter) async {
    _isarService = ref.watch(isarServiceProvider);
    return _fetchAnnotations();
  }

  Future<List<BibleAnnotationModel>> _fetchAnnotations() async {
    return await _isarService.bibleAnnotationModels
        .filter()
        .bookIdentifierEqualTo(book)
        .chapterEqualTo(chapter)
        .findAll();
  }

  String get _userId =>
      Supabase.instance.client.auth.currentUser?.id ?? 'anonymous';

  // ── Highlights ──────────────────────────────────────────────

  Future<void> toggleHighlight(
    int verse,
    String colorHex,
    String translationId, {
    String? category,
  }) async {
    final existing = await _isarService.bibleAnnotationModels
        .filter()
        .bookIdentifierEqualTo(book)
        .chapterEqualTo(chapter)
        .verseEqualTo(verse)
        .typeEqualTo('highlight')
        .findFirst();

    await _isarService.db.writeTxn(() async {
      if (existing != null) {
        if (existing.color == colorHex && existing.category == category) {
          // Remove if toggling same color + same category
          await _isarService.bibleAnnotationModels.delete(existing.id);
          unawaited(_deleteHighlightFromSupabase(existing.supabaseId));
        } else {
          // Update color/category
          existing.color = colorHex;
          existing.category = category;
          existing.updatedAt = DateTime.now();
          await _isarService.bibleAnnotationModels.put(existing);
          unawaited(_upsertHighlightToSupabase(existing));
        }
      } else {
        final annotation = BibleAnnotationModel()
          ..bookIdentifier = book
          ..chapter = chapter
          ..verse = verse
          ..translationId = translationId
          ..type = 'highlight'
          ..color = colorHex
          ..category = category
          ..createdAt = DateTime.now()
          ..updatedAt = DateTime.now();
        await _isarService.bibleAnnotationModels.put(annotation);
        unawaited(_upsertHighlightToSupabase(annotation));
      }
    });

    state = AsyncValue.data(await _fetchAnnotations());
  }

  // ── Notes ──────────────────────────────────────────────────

  Future<void> saveNote(int verse, String content, String translationId) async {
    if (content.isEmpty) return;

    // Check if a note already exists for this verse
    final existing = await _isarService.bibleAnnotationModels
        .filter()
        .bookIdentifierEqualTo(book)
        .chapterEqualTo(chapter)
        .verseEqualTo(verse)
        .typeEqualTo('note')
        .findFirst();

    await _isarService.db.writeTxn(() async {
      if (existing != null) {
        existing.content = content;
        existing.updatedAt = DateTime.now();
        await _isarService.bibleAnnotationModels.put(existing);
      } else {
        final annotation = BibleAnnotationModel()
          ..bookIdentifier = book
          ..chapter = chapter
          ..verse = verse
          ..translationId = translationId
          ..type = 'note'
          ..content = content
          ..createdAt = DateTime.now()
          ..updatedAt = DateTime.now();
        await _isarService.bibleAnnotationModels.put(annotation);
      }
    });

    state = AsyncValue.data(await _fetchAnnotations());
  }

  Future<String?> getNoteForVerse(int verse) async {
    final existing = await _isarService.bibleAnnotationModels
        .filter()
        .bookIdentifierEqualTo(book)
        .chapterEqualTo(chapter)
        .verseEqualTo(verse)
        .typeEqualTo('note')
        .findFirst();
    return existing?.content;
  }

  // ── Delete ──────────────────────────────────────────────────

  Future<void> deleteAnnotation(int id) async {
    final annotation = await _isarService.bibleAnnotationModels.get(id);

    await _isarService.db.writeTxn(() async {
      await _isarService.bibleAnnotationModels.delete(id);
    });

    if (annotation?.supabaseId != null) {
      unawaited(_deleteHighlightFromSupabase(annotation!.supabaseId));
    }

    state = AsyncValue.data(await _fetchAnnotations());
  }

  // ── Supabase Sync (Fire & Forget) ──────────────────────────

  Future<void> _upsertHighlightToSupabase(BibleAnnotationModel model) async {
    if (_userId == 'anonymous') return;
    try {
      final verseId =
          '${model.translationId}_${model.bookIdentifier}_${model.chapter}_${model.verse}';

      final data = {
        'user_id': _userId,
        'verse_id': verseId,
        'book_id': model.bookIdentifier,
        'chapter': model.chapter,
        'verse': model.verse,
        'version': model.translationId,
        'color': model.color ?? '#ff4d00',
        'category': model.category,
      };

      if (model.supabaseId != null) {
        await Supabase.instance.client
            .from('bible_highlights')
            .update(data)
            .eq('id', model.supabaseId!);
      } else {
        final response = await Supabase.instance.client
            .from('bible_highlights')
            .upsert(data, onConflict: 'user_id,verse_id')
            .select('id')
            .single();

        // Save the Supabase ID back to Isar
        final supabaseId = response['id'] as String?;
        if (supabaseId != null) {
          await _isarService.db.writeTxn(() async {
            model.supabaseId = supabaseId;
            await _isarService.bibleAnnotationModels.put(model);
          });
        }
      }
    } catch (e) {
      AppLogger.w('Highlight sync failed: $e', 'BIBLE_ANNOTATIONS');
    }
  }

  Future<void> _deleteHighlightFromSupabase(String? supabaseId) async {
    if (_userId == 'anonymous' || supabaseId == null) return;
    try {
      await Supabase.instance.client
          .from('bible_highlights')
          .delete()
          .eq('id', supabaseId);
    } catch (e) {
      AppLogger.w('Highlight delete sync failed: $e', 'BIBLE_ANNOTATIONS');
    }
  }

  /// Pull all highlights from Supabase and merge into Isar
  Future<void> syncFromSupabase() async {
    if (_userId == 'anonymous') return;
    try {
      final remoteHighlights = await Supabase.instance.client
          .from('bible_highlights')
          .select()
          .eq('user_id', _userId);

      await _isarService.db.writeTxn(() async {
        for (final remote in remoteHighlights) {
          final existing = await _isarService.bibleAnnotationModels
              .filter()
              .supabaseIdEqualTo(remote['id'] as String)
              .findFirst();

          if (existing == null) {
            final annotation = BibleAnnotationModel()
              ..bookIdentifier = remote['book_id'] as String
              ..chapter = remote['chapter'] as int
              ..verse = remote['verse'] as int
              ..translationId = remote['version'] as String
              ..type = 'highlight'
              ..color = remote['color'] as String?
              ..category = remote['category'] as String?
              ..supabaseId = remote['id'] as String
              ..createdAt = DateTime.parse(remote['created_at'] as String)
              ..updatedAt = DateTime.now();
            await _isarService.bibleAnnotationModels.put(annotation);
          }
        }
      });

      state = AsyncValue.data(await _fetchAnnotations());
    } catch (e) {
      AppLogger.e(
          'Highlight sync from Supabase failed: $e', 'BIBLE_ANNOTATIONS');
    }
  }
}