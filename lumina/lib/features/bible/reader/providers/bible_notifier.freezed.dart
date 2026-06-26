// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bible_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$BibleState {
// Navigation
  String get currentBook => throw _privateConstructorUsedError;
  int get currentChapter => throw _privateConstructorUsedError;
  String get currentTranslation =>
      throw _privateConstructorUsedError; // Données
  BibleChapter? get chapter => throw _privateConstructorUsedError;
  List<BibleBook> get books => throw _privateConstructorUsedError;
  List<BibleBookmark> get bookmarks => throw _privateConstructorUsedError;
  List<BibleAnnotation> get annotations => throw _privateConstructorUsedError;
  List<BibleVerse> get searchResults => throw _privateConstructorUsedError;
  List<BibleChapter> get recentReadings =>
      throw _privateConstructorUsedError; // Sélection de versets
  Set<int> get selectedVerses => throw _privateConstructorUsedError;
  bool get isSelectionMode => throw _privateConstructorUsedError; // Recherche
  String get searchQuery => throw _privateConstructorUsedError;
  bool get isSearching => throw _privateConstructorUsedError; // Chargement
  bool get isLoadingChapter => throw _privateConstructorUsedError;
  bool get isSearchingVerses => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError; // TTS
  TtsPlaybackState get ttsState => throw _privateConstructorUsedError;
  int get speakingVerseIndex => throw _privateConstructorUsedError;
  bool get ttsLoopMode => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BibleStateCopyWith<BibleState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BibleStateCopyWith<$Res> {
  factory $BibleStateCopyWith(
          BibleState value, $Res Function(BibleState) then) =
      _$BibleStateCopyWithImpl<$Res, BibleState>;
  @useResult
  $Res call(
      {String currentBook,
      int currentChapter,
      String currentTranslation,
      BibleChapter? chapter,
      List<BibleBook> books,
      List<BibleBookmark> bookmarks,
      List<BibleAnnotation> annotations,
      List<BibleVerse> searchResults,
      List<BibleChapter> recentReadings,
      Set<int> selectedVerses,
      bool isSelectionMode,
      String searchQuery,
      bool isSearching,
      bool isLoadingChapter,
      bool isSearchingVerses,
      String? errorMessage,
      TtsPlaybackState ttsState,
      int speakingVerseIndex,
      bool ttsLoopMode});

  $BibleChapterCopyWith<$Res>? get chapter;
}

/// @nodoc
class _$BibleStateCopyWithImpl<$Res, $Val extends BibleState>
    implements $BibleStateCopyWith<$Res> {
  _$BibleStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentBook = null,
    Object? currentChapter = null,
    Object? currentTranslation = null,
    Object? chapter = freezed,
    Object? books = null,
    Object? bookmarks = null,
    Object? annotations = null,
    Object? searchResults = null,
    Object? recentReadings = null,
    Object? selectedVerses = null,
    Object? isSelectionMode = null,
    Object? searchQuery = null,
    Object? isSearching = null,
    Object? isLoadingChapter = null,
    Object? isSearchingVerses = null,
    Object? errorMessage = freezed,
    Object? ttsState = null,
    Object? speakingVerseIndex = null,
    Object? ttsLoopMode = null,
  }) {
    return _then(_value.copyWith(
      currentBook: null == currentBook
          ? _value.currentBook
          : currentBook // ignore: cast_nullable_to_non_nullable
              as String,
      currentChapter: null == currentChapter
          ? _value.currentChapter
          : currentChapter // ignore: cast_nullable_to_non_nullable
              as int,
      currentTranslation: null == currentTranslation
          ? _value.currentTranslation
          : currentTranslation // ignore: cast_nullable_to_non_nullable
              as String,
      chapter: freezed == chapter
          ? _value.chapter
          : chapter // ignore: cast_nullable_to_non_nullable
              as BibleChapter?,
      books: null == books
          ? _value.books
          : books // ignore: cast_nullable_to_non_nullable
              as List<BibleBook>,
      bookmarks: null == bookmarks
          ? _value.bookmarks
          : bookmarks // ignore: cast_nullable_to_non_nullable
              as List<BibleBookmark>,
      annotations: null == annotations
          ? _value.annotations
          : annotations // ignore: cast_nullable_to_non_nullable
              as List<BibleAnnotation>,
      searchResults: null == searchResults
          ? _value.searchResults
          : searchResults // ignore: cast_nullable_to_non_nullable
              as List<BibleVerse>,
      recentReadings: null == recentReadings
          ? _value.recentReadings
          : recentReadings // ignore: cast_nullable_to_non_nullable
              as List<BibleChapter>,
      selectedVerses: null == selectedVerses
          ? _value.selectedVerses
          : selectedVerses // ignore: cast_nullable_to_non_nullable
              as Set<int>,
      isSelectionMode: null == isSelectionMode
          ? _value.isSelectionMode
          : isSelectionMode // ignore: cast_nullable_to_non_nullable
              as bool,
      searchQuery: null == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String,
      isSearching: null == isSearching
          ? _value.isSearching
          : isSearching // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingChapter: null == isLoadingChapter
          ? _value.isLoadingChapter
          : isLoadingChapter // ignore: cast_nullable_to_non_nullable
              as bool,
      isSearchingVerses: null == isSearchingVerses
          ? _value.isSearchingVerses
          : isSearchingVerses // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      ttsState: null == ttsState
          ? _value.ttsState
          : ttsState // ignore: cast_nullable_to_non_nullable
              as TtsPlaybackState,
      speakingVerseIndex: null == speakingVerseIndex
          ? _value.speakingVerseIndex
          : speakingVerseIndex // ignore: cast_nullable_to_non_nullable
              as int,
      ttsLoopMode: null == ttsLoopMode
          ? _value.ttsLoopMode
          : ttsLoopMode // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $BibleChapterCopyWith<$Res>? get chapter {
    if (_value.chapter == null) {
      return null;
    }

    return $BibleChapterCopyWith<$Res>(_value.chapter!, (value) {
      return _then(_value.copyWith(chapter: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BibleStateImplCopyWith<$Res>
    implements $BibleStateCopyWith<$Res> {
  factory _$$BibleStateImplCopyWith(
          _$BibleStateImpl value, $Res Function(_$BibleStateImpl) then) =
      __$$BibleStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String currentBook,
      int currentChapter,
      String currentTranslation,
      BibleChapter? chapter,
      List<BibleBook> books,
      List<BibleBookmark> bookmarks,
      List<BibleAnnotation> annotations,
      List<BibleVerse> searchResults,
      List<BibleChapter> recentReadings,
      Set<int> selectedVerses,
      bool isSelectionMode,
      String searchQuery,
      bool isSearching,
      bool isLoadingChapter,
      bool isSearchingVerses,
      String? errorMessage,
      TtsPlaybackState ttsState,
      int speakingVerseIndex,
      bool ttsLoopMode});

  @override
  $BibleChapterCopyWith<$Res>? get chapter;
}

/// @nodoc
class __$$BibleStateImplCopyWithImpl<$Res>
    extends _$BibleStateCopyWithImpl<$Res, _$BibleStateImpl>
    implements _$$BibleStateImplCopyWith<$Res> {
  __$$BibleStateImplCopyWithImpl(
      _$BibleStateImpl _value, $Res Function(_$BibleStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentBook = null,
    Object? currentChapter = null,
    Object? currentTranslation = null,
    Object? chapter = freezed,
    Object? books = null,
    Object? bookmarks = null,
    Object? annotations = null,
    Object? searchResults = null,
    Object? recentReadings = null,
    Object? selectedVerses = null,
    Object? isSelectionMode = null,
    Object? searchQuery = null,
    Object? isSearching = null,
    Object? isLoadingChapter = null,
    Object? isSearchingVerses = null,
    Object? errorMessage = freezed,
    Object? ttsState = null,
    Object? speakingVerseIndex = null,
    Object? ttsLoopMode = null,
  }) {
    return _then(_$BibleStateImpl(
      currentBook: null == currentBook
          ? _value.currentBook
          : currentBook // ignore: cast_nullable_to_non_nullable
              as String,
      currentChapter: null == currentChapter
          ? _value.currentChapter
          : currentChapter // ignore: cast_nullable_to_non_nullable
              as int,
      currentTranslation: null == currentTranslation
          ? _value.currentTranslation
          : currentTranslation // ignore: cast_nullable_to_non_nullable
              as String,
      chapter: freezed == chapter
          ? _value.chapter
          : chapter // ignore: cast_nullable_to_non_nullable
              as BibleChapter?,
      books: null == books
          ? _value._books
          : books // ignore: cast_nullable_to_non_nullable
              as List<BibleBook>,
      bookmarks: null == bookmarks
          ? _value._bookmarks
          : bookmarks // ignore: cast_nullable_to_non_nullable
              as List<BibleBookmark>,
      annotations: null == annotations
          ? _value._annotations
          : annotations // ignore: cast_nullable_to_non_nullable
              as List<BibleAnnotation>,
      searchResults: null == searchResults
          ? _value._searchResults
          : searchResults // ignore: cast_nullable_to_non_nullable
              as List<BibleVerse>,
      recentReadings: null == recentReadings
          ? _value._recentReadings
          : recentReadings // ignore: cast_nullable_to_non_nullable
              as List<BibleChapter>,
      selectedVerses: null == selectedVerses
          ? _value._selectedVerses
          : selectedVerses // ignore: cast_nullable_to_non_nullable
              as Set<int>,
      isSelectionMode: null == isSelectionMode
          ? _value.isSelectionMode
          : isSelectionMode // ignore: cast_nullable_to_non_nullable
              as bool,
      searchQuery: null == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String,
      isSearching: null == isSearching
          ? _value.isSearching
          : isSearching // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingChapter: null == isLoadingChapter
          ? _value.isLoadingChapter
          : isLoadingChapter // ignore: cast_nullable_to_non_nullable
              as bool,
      isSearchingVerses: null == isSearchingVerses
          ? _value.isSearchingVerses
          : isSearchingVerses // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      ttsState: null == ttsState
          ? _value.ttsState
          : ttsState // ignore: cast_nullable_to_non_nullable
              as TtsPlaybackState,
      speakingVerseIndex: null == speakingVerseIndex
          ? _value.speakingVerseIndex
          : speakingVerseIndex // ignore: cast_nullable_to_non_nullable
              as int,
      ttsLoopMode: null == ttsLoopMode
          ? _value.ttsLoopMode
          : ttsLoopMode // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$BibleStateImpl with DiagnosticableTreeMixin implements _BibleState {
  const _$BibleStateImpl(
      {this.currentBook = 'GEN',
      this.currentChapter = 1,
      this.currentTranslation = 'ls1910',
      this.chapter,
      final List<BibleBook> books = const [],
      final List<BibleBookmark> bookmarks = const [],
      final List<BibleAnnotation> annotations = const [],
      final List<BibleVerse> searchResults = const [],
      final List<BibleChapter> recentReadings = const [],
      final Set<int> selectedVerses = const {},
      this.isSelectionMode = false,
      this.searchQuery = '',
      this.isSearching = false,
      this.isLoadingChapter = false,
      this.isSearchingVerses = false,
      this.errorMessage,
      this.ttsState = TtsPlaybackState.idle,
      this.speakingVerseIndex = -1,
      this.ttsLoopMode = false})
      : _books = books,
        _bookmarks = bookmarks,
        _annotations = annotations,
        _searchResults = searchResults,
        _recentReadings = recentReadings,
        _selectedVerses = selectedVerses;

// Navigation
  @override
  @JsonKey()
  final String currentBook;
  @override
  @JsonKey()
  final int currentChapter;
  @override
  @JsonKey()
  final String currentTranslation;
// Données
  @override
  final BibleChapter? chapter;
  final List<BibleBook> _books;
  @override
  @JsonKey()
  List<BibleBook> get books {
    if (_books is EqualUnmodifiableListView) return _books;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_books);
  }

  final List<BibleBookmark> _bookmarks;
  @override
  @JsonKey()
  List<BibleBookmark> get bookmarks {
    if (_bookmarks is EqualUnmodifiableListView) return _bookmarks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_bookmarks);
  }

  final List<BibleAnnotation> _annotations;
  @override
  @JsonKey()
  List<BibleAnnotation> get annotations {
    if (_annotations is EqualUnmodifiableListView) return _annotations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_annotations);
  }

  final List<BibleVerse> _searchResults;
  @override
  @JsonKey()
  List<BibleVerse> get searchResults {
    if (_searchResults is EqualUnmodifiableListView) return _searchResults;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_searchResults);
  }

  final List<BibleChapter> _recentReadings;
  @override
  @JsonKey()
  List<BibleChapter> get recentReadings {
    if (_recentReadings is EqualUnmodifiableListView) return _recentReadings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recentReadings);
  }

// Sélection de versets
  final Set<int> _selectedVerses;
// Sélection de versets
  @override
  @JsonKey()
  Set<int> get selectedVerses {
    if (_selectedVerses is EqualUnmodifiableSetView) return _selectedVerses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_selectedVerses);
  }

  @override
  @JsonKey()
  final bool isSelectionMode;
// Recherche
  @override
  @JsonKey()
  final String searchQuery;
  @override
  @JsonKey()
  final bool isSearching;
// Chargement
  @override
  @JsonKey()
  final bool isLoadingChapter;
  @override
  @JsonKey()
  final bool isSearchingVerses;
  @override
  final String? errorMessage;
// TTS
  @override
  @JsonKey()
  final TtsPlaybackState ttsState;
  @override
  @JsonKey()
  final int speakingVerseIndex;
  @override
  @JsonKey()
  final bool ttsLoopMode;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'BibleState(currentBook: $currentBook, currentChapter: $currentChapter, currentTranslation: $currentTranslation, chapter: $chapter, books: $books, bookmarks: $bookmarks, annotations: $annotations, searchResults: $searchResults, recentReadings: $recentReadings, selectedVerses: $selectedVerses, isSelectionMode: $isSelectionMode, searchQuery: $searchQuery, isSearching: $isSearching, isLoadingChapter: $isLoadingChapter, isSearchingVerses: $isSearchingVerses, errorMessage: $errorMessage, ttsState: $ttsState, speakingVerseIndex: $speakingVerseIndex, ttsLoopMode: $ttsLoopMode)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'BibleState'))
      ..add(DiagnosticsProperty('currentBook', currentBook))
      ..add(DiagnosticsProperty('currentChapter', currentChapter))
      ..add(DiagnosticsProperty('currentTranslation', currentTranslation))
      ..add(DiagnosticsProperty('chapter', chapter))
      ..add(DiagnosticsProperty('books', books))
      ..add(DiagnosticsProperty('bookmarks', bookmarks))
      ..add(DiagnosticsProperty('annotations', annotations))
      ..add(DiagnosticsProperty('searchResults', searchResults))
      ..add(DiagnosticsProperty('recentReadings', recentReadings))
      ..add(DiagnosticsProperty('selectedVerses', selectedVerses))
      ..add(DiagnosticsProperty('isSelectionMode', isSelectionMode))
      ..add(DiagnosticsProperty('searchQuery', searchQuery))
      ..add(DiagnosticsProperty('isSearching', isSearching))
      ..add(DiagnosticsProperty('isLoadingChapter', isLoadingChapter))
      ..add(DiagnosticsProperty('isSearchingVerses', isSearchingVerses))
      ..add(DiagnosticsProperty('errorMessage', errorMessage))
      ..add(DiagnosticsProperty('ttsState', ttsState))
      ..add(DiagnosticsProperty('speakingVerseIndex', speakingVerseIndex))
      ..add(DiagnosticsProperty('ttsLoopMode', ttsLoopMode));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BibleStateImpl &&
            (identical(other.currentBook, currentBook) ||
                other.currentBook == currentBook) &&
            (identical(other.currentChapter, currentChapter) ||
                other.currentChapter == currentChapter) &&
            (identical(other.currentTranslation, currentTranslation) ||
                other.currentTranslation == currentTranslation) &&
            (identical(other.chapter, chapter) || other.chapter == chapter) &&
            const DeepCollectionEquality().equals(other._books, _books) &&
            const DeepCollectionEquality()
                .equals(other._bookmarks, _bookmarks) &&
            const DeepCollectionEquality()
                .equals(other._annotations, _annotations) &&
            const DeepCollectionEquality()
                .equals(other._searchResults, _searchResults) &&
            const DeepCollectionEquality()
                .equals(other._recentReadings, _recentReadings) &&
            const DeepCollectionEquality()
                .equals(other._selectedVerses, _selectedVerses) &&
            (identical(other.isSelectionMode, isSelectionMode) ||
                other.isSelectionMode == isSelectionMode) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery) &&
            (identical(other.isSearching, isSearching) ||
                other.isSearching == isSearching) &&
            (identical(other.isLoadingChapter, isLoadingChapter) ||
                other.isLoadingChapter == isLoadingChapter) &&
            (identical(other.isSearchingVerses, isSearchingVerses) ||
                other.isSearchingVerses == isSearchingVerses) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.ttsState, ttsState) ||
                other.ttsState == ttsState) &&
            (identical(other.speakingVerseIndex, speakingVerseIndex) ||
                other.speakingVerseIndex == speakingVerseIndex) &&
            (identical(other.ttsLoopMode, ttsLoopMode) ||
                other.ttsLoopMode == ttsLoopMode));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        currentBook,
        currentChapter,
        currentTranslation,
        chapter,
        const DeepCollectionEquality().hash(_books),
        const DeepCollectionEquality().hash(_bookmarks),
        const DeepCollectionEquality().hash(_annotations),
        const DeepCollectionEquality().hash(_searchResults),
        const DeepCollectionEquality().hash(_recentReadings),
        const DeepCollectionEquality().hash(_selectedVerses),
        isSelectionMode,
        searchQuery,
        isSearching,
        isLoadingChapter,
        isSearchingVerses,
        errorMessage,
        ttsState,
        speakingVerseIndex,
        ttsLoopMode
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BibleStateImplCopyWith<_$BibleStateImpl> get copyWith =>
      __$$BibleStateImplCopyWithImpl<_$BibleStateImpl>(this, _$identity);
}

abstract class _BibleState implements BibleState {
  const factory _BibleState(
      {final String currentBook,
      final int currentChapter,
      final String currentTranslation,
      final BibleChapter? chapter,
      final List<BibleBook> books,
      final List<BibleBookmark> bookmarks,
      final List<BibleAnnotation> annotations,
      final List<BibleVerse> searchResults,
      final List<BibleChapter> recentReadings,
      final Set<int> selectedVerses,
      final bool isSelectionMode,
      final String searchQuery,
      final bool isSearching,
      final bool isLoadingChapter,
      final bool isSearchingVerses,
      final String? errorMessage,
      final TtsPlaybackState ttsState,
      final int speakingVerseIndex,
      final bool ttsLoopMode}) = _$BibleStateImpl;

  @override // Navigation
  String get currentBook;
  @override
  int get currentChapter;
  @override
  String get currentTranslation;
  @override // Données
  BibleChapter? get chapter;
  @override
  List<BibleBook> get books;
  @override
  List<BibleBookmark> get bookmarks;
  @override
  List<BibleAnnotation> get annotations;
  @override
  List<BibleVerse> get searchResults;
  @override
  List<BibleChapter> get recentReadings;
  @override // Sélection de versets
  Set<int> get selectedVerses;
  @override
  bool get isSelectionMode;
  @override // Recherche
  String get searchQuery;
  @override
  bool get isSearching;
  @override // Chargement
  bool get isLoadingChapter;
  @override
  bool get isSearchingVerses;
  @override
  String? get errorMessage;
  @override // TTS
  TtsPlaybackState get ttsState;
  @override
  int get speakingVerseIndex;
  @override
  bool get ttsLoopMode;
  @override
  @JsonKey(ignore: true)
  _$$BibleStateImplCopyWith<_$BibleStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
