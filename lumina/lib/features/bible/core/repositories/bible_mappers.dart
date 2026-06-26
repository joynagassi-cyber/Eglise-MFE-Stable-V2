// lib/features/bible/data/mappers/bible_mappers.dart
// Conversion entre les modèles Isar (data) et les entités pures (domain).
// Aucune logique métier ici — mapping pur.

import 'package:lumina/features/bible/core/models/bible_models.dart';
import 'package:lumina/features/bible/domain/entities/bible_entities.dart';

class BibleMappers {
  BibleMappers._();

  // ── BibleChapterModel → BibleChapter ────────────────────
  static BibleChapter chapterFromModel(BibleChapterModel model) {
    return BibleChapter(
      bookIdentifier: model.bookIdentifier,
      chapterNumber: model.chapterNumber,
      translationId: model.translationId,
      verses: List<String>.from(model.verses),
      lastReadAt: model.lastReadAt,
    );
  }

  // ── BibleChapter → BibleChapterModel ────────────────────
  static BibleChapterModel chapterToModel(BibleChapter entity) {
    final model = BibleChapterModel()
      ..bookIdentifier = entity.bookIdentifier
      ..chapterNumber = entity.chapterNumber
      ..translationId = entity.translationId
      ..verses = entity.verses
      ..lastReadAt = entity.lastReadAt;
    return model;
  }

  // ── BibleBookmarkModel → BibleBookmark ──────────────────
  static BibleBookmark bookmarkFromModel(
    BibleBookmarkModel model, {
    String bookName = '',
  }) {
    return BibleBookmark(
      bookIdentifier: model.bookIdentifier,
      bookName: bookName,
      chapter: model.chapter,
      verse: model.verse,
      verseText: model.verseText,
      translationId: model.translationId,
      userId: model.userId,
      collectionName: model.collectionName,
      reference: model.reference,
      supabaseId: model.supabaseId,
      createdAt: model.createdAt,
    );
  }

  // ── BibleAnnotationModel → BibleAnnotation ──────────────
  static BibleAnnotation annotationFromModel(BibleAnnotationModel model) {
    return BibleAnnotation(
      bookIdentifier: model.bookIdentifier,
      chapter: model.chapter,
      verse: model.verse,
      translationId: model.translationId,
      type: _annotationTypeFromString(model.type),
      color: model.color,
      content: model.content,
      category: model.category,
      supabaseId: model.supabaseId,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }

  static BibleAnnotationType _annotationTypeFromString(String type) {
    switch (type) {
      case 'highlight':
        return BibleAnnotationType.highlight;
      case 'note':
        return BibleAnnotationType.note;
      case 'marker':
        return BibleAnnotationType.marker;
      default:
        return BibleAnnotationType.highlight;
    }
  }

  static String annotationTypeToString(BibleAnnotationType type) {
    switch (type) {
      case BibleAnnotationType.highlight:
        return 'highlight';
      case BibleAnnotationType.note:
        return 'note';
      case BibleAnnotationType.marker:
        return 'marker';
    }
  }

  // ── BibleReadingPlanModel → BibleReadingPlan ────────────
  static BibleReadingPlan planFromModel(BibleReadingPlanModel model) {
    return BibleReadingPlan(
      planId: model.planId,
      title: model.title,
      description: model.description,
      durationInDays: model.durationInDays,
      imageUrl: model.imageUrl,
      days: model.days
          .map((d) => PlanDay(
                dayNumber: d.dayNumber ?? 0,
                title: d.title ?? '',
                references: d.references ?? [],
              ))
          .toList(),
    );
  }

  // ── BiblePlanProgressModel → BiblePlanProgress ──────────
  static BiblePlanProgress progressFromModel(BiblePlanProgressModel model) {
    return BiblePlanProgress(
      planId: model.planId,
      userId: model.userId,
      startDate: model.startDate,
      completedDays: List<int>.from(model.completedDays),
      lastReadAt: model.lastReadAt,
    );
  }

  // ── BibleReadingStatModel → BibleReadingStat ────────────
  static BibleReadingStat statFromModel(BibleReadingStatModel model) {
    return BibleReadingStat(
      userId: model.userId,
      currentStreak: model.currentStreak,
      maxStreak: model.maxStreak,
      totalChaptersRead: model.totalChaptersRead,
      totalAnnotations: model.totalAnnotations,
      lastReadDate: model.lastReadDate,
    );
  }

  // ── BibleSearchHistoryModel → BibleSearchHistory ────────
  static BibleSearchHistory searchHistoryFromModel(BibleSearchHistoryModel model) {
    return BibleSearchHistory(
      id: model.id,
      query: model.query,
      resultCount: model.resultCount,
      createdAt: model.createdAt,
    );
  }
}
