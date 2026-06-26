import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:lumina/features/bible/core/repositories/bible_repository_impl.dart';

part 'bible_stats_notifier.freezed.dart';
part 'bible_stats_notifier.g.dart';

@freezed
class BibleStatsState with _$BibleStatsState {
  const factory BibleStatsState({
    @Default(0) int currentStreak,
    @Default(0) int maxStreak,
    @Default(0) int totalChaptersRead,
    @Default(0) int totalAnnotations,
    DateTime? lastReadDate,
    @Default(true) bool isLoading,
  }) = _BibleStatsState;
}

@riverpod
class BibleStatsNotifier extends _$BibleStatsNotifier {
  @override
  BibleStatsState build() {
    _loadStats();
    return const BibleStatsState();
  }

  Future<void> _loadStats() async {
    final repo = ref.read(bibleRepositoryProvider);
    final result = await repo.getReadingStats();
    result.fold(
      (_) => state = state.copyWith(isLoading: false),
      (stats) => state = state.copyWith(
        currentStreak: stats.currentStreak,
        maxStreak: stats.maxStreak,
        totalChaptersRead: stats.totalChaptersRead,
        totalAnnotations: stats.totalAnnotations,
        lastReadDate: stats.lastReadDate,
        isLoading: false,
      ),
    );
  }

  Future<void> onChapterRead() async {
    final repo = ref.read(bibleRepositoryProvider);
    await repo.incrementChaptersRead();
    await repo.updateReadingStreak();
    await _loadStats();
  }

  Future<void> onAnnotationCreated() async {
    final repo = ref.read(bibleRepositoryProvider);
    await repo.incrementAnnotationsCount();
    await _loadStats();
  }

  Future<void> refresh() async => _loadStats();
}
