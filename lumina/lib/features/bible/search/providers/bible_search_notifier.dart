import 'dart:async';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:lumina/features/bible/domain/entities/bible_entities.dart';
import 'package:lumina/features/bible/core/repositories/bible_repository_impl.dart';

part 'bible_search_notifier.freezed.dart';
part 'bible_search_notifier.g.dart';

@freezed
class BibleSearchState with _$BibleSearchState {
  const factory BibleSearchState({
    @Default('') String query,
    @Default([]) List<BibleVerse> results,
    @Default([]) List<BibleSearchHistory> history,
    @Default(false) bool isLoading,
    @Default(false) bool isSearching,
    String? error,
  }) = _BibleSearchState;
}

@riverpod
class BibleSearchNotifier extends _$BibleSearchNotifier {
  Timer? _searchDebounce;

  @override
  BibleSearchState build() {
    _loadHistory();
    return const BibleSearchState();
  }

  Future<void> _loadHistory() async {
    final repo = ref.read(bibleRepositoryProvider);
    final result = await repo.getSearchHistory();
    result.fold(
      (failure) => state = state.copyWith(error: failure.message),
      (history) => state = state.copyWith(history: history),
    );
  }

  void onQueryChanged(String query) {
    state = state.copyWith(query: query);
    _searchDebounce?.cancel();
    
    if (query.trim().isEmpty) {
      state = state.copyWith(results: [], isSearching: false);
      return;
    }

    if (query.trim().length < 3) return;

    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      search(query);
    });
  }

  Future<void> search(String query) async {
    if (query.trim().isEmpty) return;
    
    state = state.copyWith(isLoading: true, isSearching: true, error: null);
    
    final repo = ref.read(bibleRepositoryProvider);
    final result = await repo.searchVerses(query: query);
    
    result.fold(
      (failure) => state = state.copyWith(isLoading: false, error: failure.message),
      (verses) {
        state = state.copyWith(
          results: verses,
          isLoading: false,
        );
        if (verses.isNotEmpty) {
          unawaited(_saveToHistory(query, verses.length));
        }
      },
    );
  }

  Future<void> _saveToHistory(String query, int count) async {
    final repo = ref.read(bibleRepositoryProvider);
    await repo.saveSearchHistory(query, count);
    await _loadHistory();
  }

  Future<void> deleteHistoryItem(int id) async {
    final repo = ref.read(bibleRepositoryProvider);
    await repo.deleteSearchHistory(id);
    await _loadHistory();
  }

  Future<void> clearHistory() async {
    final repo = ref.read(bibleRepositoryProvider);
    await repo.clearSearchHistory();
    await _loadHistory();
  }

  void clearSearch() {
    state = state.copyWith(query: '', results: [], isSearching: false, error: null);
  }
}
