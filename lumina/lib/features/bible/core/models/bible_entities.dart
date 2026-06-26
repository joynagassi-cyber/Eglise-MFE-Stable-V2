// lib/features/bible/domain/entities/bible_entities.dart
// Pure domain entities — NO Isar, NO Supabase, NO Flutter dependencies.

import 'package:freezed_annotation/freezed_annotation.dart';

part 'bible_entities.freezed.dart';

// ─────────────────────────────────────────────────────────
// BIBLE BOOK
// ─────────────────────────────────────────────────────────

@freezed
class BibleBook with _$BibleBook {
  const factory BibleBook({
    required String identifier, // e.g. "GEN"
    required String name, // e.g. "Genèse"
    required int chapterCount,
    required BibleTestament testament,
  }) = _BibleBook;
}

enum BibleTestament { old, newTestament }

// ─────────────────────────────────────────────────────────
// BIBLE CHAPTER
// ─────────────────────────────────────────────────────────

@freezed
class BibleChapter with _$BibleChapter {
  const factory BibleChapter({
    required String bookIdentifier,
    required int chapterNumber,
    required String translationId,
    required List<String> verses,
    required DateTime lastReadAt,
  }) = _BibleChapter;
}

// ─────────────────────────────────────────────────────────
// BIBLE VERSE (search result unit)
// ─────────────────────────────────────────────────────────

@freezed
class BibleVerse with _$BibleVerse {
  const BibleVerse._();

  const factory BibleVerse({
    required String bookIdentifier,
    required String bookName,
    required int chapter,
    required int verse,
    required String text,
    required String translationId,
  }) = _BibleVerse;

  String get reference => '$bookName $chapter:$verse';
}

// ─────────────────────────────────────────────────────────
// BIBLE BOOKMARK
// ─────────────────────────────────────────────────────────

@freezed
class BibleBookmark with _$BibleBookmark {
  const BibleBookmark._();

  const factory BibleBookmark({
    required String bookIdentifier,
    required String bookName,
    required int chapter,
    required int verse,
    required String verseText,
    required String translationId,
    required String userId,
    @Default('Général') String collectionName,
    String? reference,
    String? supabaseId,
    required DateTime createdAt,
  }) = _BibleBookmark;

  String get formattedReference => reference ?? '$bookName $chapter:$verse';
}

// ─────────────────────────────────────────────────────────
// BIBLE ANNOTATION
// ─────────────────────────────────────────────────────────

@freezed
class BibleAnnotation with _$BibleAnnotation {
  const factory BibleAnnotation({
    required String bookIdentifier,
    required int chapter,
    required int verse,
    required String translationId,
    required BibleAnnotationType type,
    String? color,
    String? content,
    String? category,
    String? supabaseId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _BibleAnnotation;
}

enum BibleAnnotationType { highlight, note, marker }

// ─────────────────────────────────────────────────────────
// BIBLE READING PLAN
// ─────────────────────────────────────────────────────────

@freezed
class BibleReadingPlan with _$BibleReadingPlan {
  const factory BibleReadingPlan({
    required String planId,
    required String title,
    required String description,
    required int durationInDays,
    required List<PlanDay> days,
    String? imageUrl,
  }) = _BibleReadingPlan;
}

@freezed
class PlanDay with _$PlanDay {
  const factory PlanDay({
    required int dayNumber,
    required String title,
    required List<String> references,
  }) = _PlanDay;
}

// ─────────────────────────────────────────────────────────
// BIBLE PLAN PROGRESS
// ─────────────────────────────────────────────────────────

@freezed
class BiblePlanProgress with _$BiblePlanProgress {
  const BiblePlanProgress._();

  const factory BiblePlanProgress({
    required String planId,
    required String userId,
    required DateTime startDate,
    @Default([]) List<int> completedDays,
    required DateTime lastReadAt,
  }) = _BiblePlanProgress;

  double get progressPercent =>
      completedDays.isEmpty ? 0.0 : completedDays.length / 365.0;
}

// ─────────────────────────────────────────────────────────
// BIBLE TRANSLATION
// ─────────────────────────────────────────────────────────

@freezed
class BibleTranslation with _$BibleTranslation {
  const factory BibleTranslation({
    required String id,
    required String name,
    required String shortName,
    required String language,
    @Default(false) bool isDownloaded,
    @Default(0) int downloadedChapters,
    @Default(1189) int totalChapters,
  }) = _BibleTranslation;
}

// ─────────────────────────────────────────────────────────
// TTS SETTINGS
// ─────────────────────────────────────────────────────────

@freezed
class BibleTtsSettings with _$BibleTtsSettings {
  const factory BibleTtsSettings({
    @Default('fr-FR') String languageCode,
    @Default(0.5) double speechRate,   // 0.0 → 1.0
    @Default(1.0) double pitch,        // 0.5 → 2.0
    @Default(1.0) double volume,       // 0.0 → 1.0
    @Default(false) bool isEnabled,
  }) = _BibleTtsSettings;
}

// ─────────────────────────────────────────────────────────
// GAMIFICATION STATS
// ─────────────────────────────────────────────────────────

@freezed
class BibleReadingStat with _$BibleReadingStat {
  const factory BibleReadingStat({
    required String userId,
    @Default(0) int currentStreak,
    @Default(0) int maxStreak,
    @Default(0) int totalChaptersRead,
    @Default(0) int totalAnnotations,
    DateTime? lastReadDate,
  }) = _BibleReadingStat;
}

// ─────────────────────────────────────────────────────────
// SEARCH HISTORY
// ─────────────────────────────────────────────────────────

@freezed
class BibleSearchHistory with _$BibleSearchHistory {
  const factory BibleSearchHistory({
    required int id,
    required String query,
    required int resultCount,
    required DateTime createdAt,
  }) = _BibleSearchHistory;
}