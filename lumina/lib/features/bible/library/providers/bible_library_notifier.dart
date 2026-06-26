import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:lumina/features/bible/domain/entities/bible_entities.dart';
import 'package:lumina/features/bible/core/repositories/bible_repository_impl.dart';

part 'bible_library_notifier.freezed.dart';
part 'bible_library_notifier.g.dart';

@freezed
class BibleLibraryState with _$BibleLibraryState {
  const factory BibleLibraryState({
    @Default([]) List<BibleBookmark> bookmarks,
    @Default([]) List<BibleAnnotation> annotations,
    @Default([]) List<String> collections,
    String? activeCollection,
    @Default(true) bool isLoading,
    String? error,
  }) = _BibleLibraryState;
}

@riverpod
class BibleLibraryNotifier extends _$BibleLibraryNotifier {
  @override
  BibleLibraryState build() {
    _loadData();
    return const BibleLibraryState();
  }

  Future<void> _loadData() async {
    state = state.copyWith(isLoading: true, error: null);
    final repo = ref.read(bibleRepositoryProvider);

    try {
      final bookmarksResult = state.activeCollection != null
          ? await repo.getBookmarksByCollection(state.activeCollection!)
          : await repo.getBookmarks();
          
      final collectionsResult = await repo.getCollections();

      bookmarksResult.fold(
        (failure) => state = state.copyWith(error: failure.message, isLoading: false),
        (bookmarks) {
          collectionsResult.fold(
            (failure) => state = state.copyWith(error: failure.message, isLoading: false),
            (collections) => state = state.copyWith(
              bookmarks: bookmarks,
              collections: collections,
              isLoading: false,
            ),
          );
        },
      );
    } catch (e) {
      state = state.copyWith(error: 'Erreur inattendue: $e', isLoading: false);
    }
  }

  void setActiveCollection(String? collection) {
    state = state.copyWith(activeCollection: collection);
    _loadData();
  }

  Future<void> deleteBookmark(String book, int chapter, int verse) async {
    final repo = ref.read(bibleRepositoryProvider);
    await repo.removeBookmark(
      bookIdentifier: book,
      chapter: chapter,
      verse: verse,
    );
    await _loadData();
  }
}
