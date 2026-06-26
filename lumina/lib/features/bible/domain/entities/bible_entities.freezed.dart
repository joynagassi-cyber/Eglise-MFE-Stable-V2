// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bible_entities.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$BibleBook {
  String get identifier => throw _privateConstructorUsedError; // e.g. "GEN"
  String get name => throw _privateConstructorUsedError; // e.g. "Genèse"
  int get chapterCount => throw _privateConstructorUsedError;
  BibleTestament get testament => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BibleBookCopyWith<BibleBook> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BibleBookCopyWith<$Res> {
  factory $BibleBookCopyWith(BibleBook value, $Res Function(BibleBook) then) =
      _$BibleBookCopyWithImpl<$Res, BibleBook>;
  @useResult
  $Res call(
      {String identifier,
      String name,
      int chapterCount,
      BibleTestament testament});
}

/// @nodoc
class _$BibleBookCopyWithImpl<$Res, $Val extends BibleBook>
    implements $BibleBookCopyWith<$Res> {
  _$BibleBookCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? identifier = null,
    Object? name = null,
    Object? chapterCount = null,
    Object? testament = null,
  }) {
    return _then(_value.copyWith(
      identifier: null == identifier
          ? _value.identifier
          : identifier // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      chapterCount: null == chapterCount
          ? _value.chapterCount
          : chapterCount // ignore: cast_nullable_to_non_nullable
              as int,
      testament: null == testament
          ? _value.testament
          : testament // ignore: cast_nullable_to_non_nullable
              as BibleTestament,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BibleBookImplCopyWith<$Res>
    implements $BibleBookCopyWith<$Res> {
  factory _$$BibleBookImplCopyWith(
          _$BibleBookImpl value, $Res Function(_$BibleBookImpl) then) =
      __$$BibleBookImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String identifier,
      String name,
      int chapterCount,
      BibleTestament testament});
}

/// @nodoc
class __$$BibleBookImplCopyWithImpl<$Res>
    extends _$BibleBookCopyWithImpl<$Res, _$BibleBookImpl>
    implements _$$BibleBookImplCopyWith<$Res> {
  __$$BibleBookImplCopyWithImpl(
      _$BibleBookImpl _value, $Res Function(_$BibleBookImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? identifier = null,
    Object? name = null,
    Object? chapterCount = null,
    Object? testament = null,
  }) {
    return _then(_$BibleBookImpl(
      identifier: null == identifier
          ? _value.identifier
          : identifier // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      chapterCount: null == chapterCount
          ? _value.chapterCount
          : chapterCount // ignore: cast_nullable_to_non_nullable
              as int,
      testament: null == testament
          ? _value.testament
          : testament // ignore: cast_nullable_to_non_nullable
              as BibleTestament,
    ));
  }
}

/// @nodoc

class _$BibleBookImpl implements _BibleBook {
  const _$BibleBookImpl(
      {required this.identifier,
      required this.name,
      required this.chapterCount,
      required this.testament});

  @override
  final String identifier;
// e.g. "GEN"
  @override
  final String name;
// e.g. "Genèse"
  @override
  final int chapterCount;
  @override
  final BibleTestament testament;

  @override
  String toString() {
    return 'BibleBook(identifier: $identifier, name: $name, chapterCount: $chapterCount, testament: $testament)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BibleBookImpl &&
            (identical(other.identifier, identifier) ||
                other.identifier == identifier) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.chapterCount, chapterCount) ||
                other.chapterCount == chapterCount) &&
            (identical(other.testament, testament) ||
                other.testament == testament));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, identifier, name, chapterCount, testament);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BibleBookImplCopyWith<_$BibleBookImpl> get copyWith =>
      __$$BibleBookImplCopyWithImpl<_$BibleBookImpl>(this, _$identity);
}

abstract class _BibleBook implements BibleBook {
  const factory _BibleBook(
      {required final String identifier,
      required final String name,
      required final int chapterCount,
      required final BibleTestament testament}) = _$BibleBookImpl;

  @override
  String get identifier;
  @override // e.g. "GEN"
  String get name;
  @override // e.g. "Genèse"
  int get chapterCount;
  @override
  BibleTestament get testament;
  @override
  @JsonKey(ignore: true)
  _$$BibleBookImplCopyWith<_$BibleBookImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$BibleChapter {
  String get bookIdentifier => throw _privateConstructorUsedError;
  int get chapterNumber => throw _privateConstructorUsedError;
  String get translationId => throw _privateConstructorUsedError;
  List<String> get verses => throw _privateConstructorUsedError;
  DateTime get lastReadAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BibleChapterCopyWith<BibleChapter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BibleChapterCopyWith<$Res> {
  factory $BibleChapterCopyWith(
          BibleChapter value, $Res Function(BibleChapter) then) =
      _$BibleChapterCopyWithImpl<$Res, BibleChapter>;
  @useResult
  $Res call(
      {String bookIdentifier,
      int chapterNumber,
      String translationId,
      List<String> verses,
      DateTime lastReadAt});
}

/// @nodoc
class _$BibleChapterCopyWithImpl<$Res, $Val extends BibleChapter>
    implements $BibleChapterCopyWith<$Res> {
  _$BibleChapterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bookIdentifier = null,
    Object? chapterNumber = null,
    Object? translationId = null,
    Object? verses = null,
    Object? lastReadAt = null,
  }) {
    return _then(_value.copyWith(
      bookIdentifier: null == bookIdentifier
          ? _value.bookIdentifier
          : bookIdentifier // ignore: cast_nullable_to_non_nullable
              as String,
      chapterNumber: null == chapterNumber
          ? _value.chapterNumber
          : chapterNumber // ignore: cast_nullable_to_non_nullable
              as int,
      translationId: null == translationId
          ? _value.translationId
          : translationId // ignore: cast_nullable_to_non_nullable
              as String,
      verses: null == verses
          ? _value.verses
          : verses // ignore: cast_nullable_to_non_nullable
              as List<String>,
      lastReadAt: null == lastReadAt
          ? _value.lastReadAt
          : lastReadAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BibleChapterImplCopyWith<$Res>
    implements $BibleChapterCopyWith<$Res> {
  factory _$$BibleChapterImplCopyWith(
          _$BibleChapterImpl value, $Res Function(_$BibleChapterImpl) then) =
      __$$BibleChapterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String bookIdentifier,
      int chapterNumber,
      String translationId,
      List<String> verses,
      DateTime lastReadAt});
}

/// @nodoc
class __$$BibleChapterImplCopyWithImpl<$Res>
    extends _$BibleChapterCopyWithImpl<$Res, _$BibleChapterImpl>
    implements _$$BibleChapterImplCopyWith<$Res> {
  __$$BibleChapterImplCopyWithImpl(
      _$BibleChapterImpl _value, $Res Function(_$BibleChapterImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bookIdentifier = null,
    Object? chapterNumber = null,
    Object? translationId = null,
    Object? verses = null,
    Object? lastReadAt = null,
  }) {
    return _then(_$BibleChapterImpl(
      bookIdentifier: null == bookIdentifier
          ? _value.bookIdentifier
          : bookIdentifier // ignore: cast_nullable_to_non_nullable
              as String,
      chapterNumber: null == chapterNumber
          ? _value.chapterNumber
          : chapterNumber // ignore: cast_nullable_to_non_nullable
              as int,
      translationId: null == translationId
          ? _value.translationId
          : translationId // ignore: cast_nullable_to_non_nullable
              as String,
      verses: null == verses
          ? _value._verses
          : verses // ignore: cast_nullable_to_non_nullable
              as List<String>,
      lastReadAt: null == lastReadAt
          ? _value.lastReadAt
          : lastReadAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$BibleChapterImpl implements _BibleChapter {
  const _$BibleChapterImpl(
      {required this.bookIdentifier,
      required this.chapterNumber,
      required this.translationId,
      required final List<String> verses,
      required this.lastReadAt})
      : _verses = verses;

  @override
  final String bookIdentifier;
  @override
  final int chapterNumber;
  @override
  final String translationId;
  final List<String> _verses;
  @override
  List<String> get verses {
    if (_verses is EqualUnmodifiableListView) return _verses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_verses);
  }

  @override
  final DateTime lastReadAt;

  @override
  String toString() {
    return 'BibleChapter(bookIdentifier: $bookIdentifier, chapterNumber: $chapterNumber, translationId: $translationId, verses: $verses, lastReadAt: $lastReadAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BibleChapterImpl &&
            (identical(other.bookIdentifier, bookIdentifier) ||
                other.bookIdentifier == bookIdentifier) &&
            (identical(other.chapterNumber, chapterNumber) ||
                other.chapterNumber == chapterNumber) &&
            (identical(other.translationId, translationId) ||
                other.translationId == translationId) &&
            const DeepCollectionEquality().equals(other._verses, _verses) &&
            (identical(other.lastReadAt, lastReadAt) ||
                other.lastReadAt == lastReadAt));
  }

  @override
  int get hashCode => Object.hash(runtimeType, bookIdentifier, chapterNumber,
      translationId, const DeepCollectionEquality().hash(_verses), lastReadAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BibleChapterImplCopyWith<_$BibleChapterImpl> get copyWith =>
      __$$BibleChapterImplCopyWithImpl<_$BibleChapterImpl>(this, _$identity);
}

abstract class _BibleChapter implements BibleChapter {
  const factory _BibleChapter(
      {required final String bookIdentifier,
      required final int chapterNumber,
      required final String translationId,
      required final List<String> verses,
      required final DateTime lastReadAt}) = _$BibleChapterImpl;

  @override
  String get bookIdentifier;
  @override
  int get chapterNumber;
  @override
  String get translationId;
  @override
  List<String> get verses;
  @override
  DateTime get lastReadAt;
  @override
  @JsonKey(ignore: true)
  _$$BibleChapterImplCopyWith<_$BibleChapterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$BibleVerse {
  String get bookIdentifier => throw _privateConstructorUsedError;
  String get bookName => throw _privateConstructorUsedError;
  int get chapter => throw _privateConstructorUsedError;
  int get verse => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  String get translationId => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BibleVerseCopyWith<BibleVerse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BibleVerseCopyWith<$Res> {
  factory $BibleVerseCopyWith(
          BibleVerse value, $Res Function(BibleVerse) then) =
      _$BibleVerseCopyWithImpl<$Res, BibleVerse>;
  @useResult
  $Res call(
      {String bookIdentifier,
      String bookName,
      int chapter,
      int verse,
      String text,
      String translationId});
}

/// @nodoc
class _$BibleVerseCopyWithImpl<$Res, $Val extends BibleVerse>
    implements $BibleVerseCopyWith<$Res> {
  _$BibleVerseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bookIdentifier = null,
    Object? bookName = null,
    Object? chapter = null,
    Object? verse = null,
    Object? text = null,
    Object? translationId = null,
  }) {
    return _then(_value.copyWith(
      bookIdentifier: null == bookIdentifier
          ? _value.bookIdentifier
          : bookIdentifier // ignore: cast_nullable_to_non_nullable
              as String,
      bookName: null == bookName
          ? _value.bookName
          : bookName // ignore: cast_nullable_to_non_nullable
              as String,
      chapter: null == chapter
          ? _value.chapter
          : chapter // ignore: cast_nullable_to_non_nullable
              as int,
      verse: null == verse
          ? _value.verse
          : verse // ignore: cast_nullable_to_non_nullable
              as int,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      translationId: null == translationId
          ? _value.translationId
          : translationId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BibleVerseImplCopyWith<$Res>
    implements $BibleVerseCopyWith<$Res> {
  factory _$$BibleVerseImplCopyWith(
          _$BibleVerseImpl value, $Res Function(_$BibleVerseImpl) then) =
      __$$BibleVerseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String bookIdentifier,
      String bookName,
      int chapter,
      int verse,
      String text,
      String translationId});
}

/// @nodoc
class __$$BibleVerseImplCopyWithImpl<$Res>
    extends _$BibleVerseCopyWithImpl<$Res, _$BibleVerseImpl>
    implements _$$BibleVerseImplCopyWith<$Res> {
  __$$BibleVerseImplCopyWithImpl(
      _$BibleVerseImpl _value, $Res Function(_$BibleVerseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bookIdentifier = null,
    Object? bookName = null,
    Object? chapter = null,
    Object? verse = null,
    Object? text = null,
    Object? translationId = null,
  }) {
    return _then(_$BibleVerseImpl(
      bookIdentifier: null == bookIdentifier
          ? _value.bookIdentifier
          : bookIdentifier // ignore: cast_nullable_to_non_nullable
              as String,
      bookName: null == bookName
          ? _value.bookName
          : bookName // ignore: cast_nullable_to_non_nullable
              as String,
      chapter: null == chapter
          ? _value.chapter
          : chapter // ignore: cast_nullable_to_non_nullable
              as int,
      verse: null == verse
          ? _value.verse
          : verse // ignore: cast_nullable_to_non_nullable
              as int,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      translationId: null == translationId
          ? _value.translationId
          : translationId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$BibleVerseImpl extends _BibleVerse {
  const _$BibleVerseImpl(
      {required this.bookIdentifier,
      required this.bookName,
      required this.chapter,
      required this.verse,
      required this.text,
      required this.translationId})
      : super._();

  @override
  final String bookIdentifier;
  @override
  final String bookName;
  @override
  final int chapter;
  @override
  final int verse;
  @override
  final String text;
  @override
  final String translationId;

  @override
  String toString() {
    return 'BibleVerse(bookIdentifier: $bookIdentifier, bookName: $bookName, chapter: $chapter, verse: $verse, text: $text, translationId: $translationId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BibleVerseImpl &&
            (identical(other.bookIdentifier, bookIdentifier) ||
                other.bookIdentifier == bookIdentifier) &&
            (identical(other.bookName, bookName) ||
                other.bookName == bookName) &&
            (identical(other.chapter, chapter) || other.chapter == chapter) &&
            (identical(other.verse, verse) || other.verse == verse) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.translationId, translationId) ||
                other.translationId == translationId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, bookIdentifier, bookName,
      chapter, verse, text, translationId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BibleVerseImplCopyWith<_$BibleVerseImpl> get copyWith =>
      __$$BibleVerseImplCopyWithImpl<_$BibleVerseImpl>(this, _$identity);
}

abstract class _BibleVerse extends BibleVerse {
  const factory _BibleVerse(
      {required final String bookIdentifier,
      required final String bookName,
      required final int chapter,
      required final int verse,
      required final String text,
      required final String translationId}) = _$BibleVerseImpl;
  const _BibleVerse._() : super._();

  @override
  String get bookIdentifier;
  @override
  String get bookName;
  @override
  int get chapter;
  @override
  int get verse;
  @override
  String get text;
  @override
  String get translationId;
  @override
  @JsonKey(ignore: true)
  _$$BibleVerseImplCopyWith<_$BibleVerseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$BibleBookmark {
  String get bookIdentifier => throw _privateConstructorUsedError;
  String get bookName => throw _privateConstructorUsedError;
  int get chapter => throw _privateConstructorUsedError;
  int get verse => throw _privateConstructorUsedError;
  String get verseText => throw _privateConstructorUsedError;
  String get translationId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get collectionName => throw _privateConstructorUsedError;
  String? get reference => throw _privateConstructorUsedError;
  String? get supabaseId => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BibleBookmarkCopyWith<BibleBookmark> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BibleBookmarkCopyWith<$Res> {
  factory $BibleBookmarkCopyWith(
          BibleBookmark value, $Res Function(BibleBookmark) then) =
      _$BibleBookmarkCopyWithImpl<$Res, BibleBookmark>;
  @useResult
  $Res call(
      {String bookIdentifier,
      String bookName,
      int chapter,
      int verse,
      String verseText,
      String translationId,
      String userId,
      String collectionName,
      String? reference,
      String? supabaseId,
      DateTime createdAt});
}

/// @nodoc
class _$BibleBookmarkCopyWithImpl<$Res, $Val extends BibleBookmark>
    implements $BibleBookmarkCopyWith<$Res> {
  _$BibleBookmarkCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bookIdentifier = null,
    Object? bookName = null,
    Object? chapter = null,
    Object? verse = null,
    Object? verseText = null,
    Object? translationId = null,
    Object? userId = null,
    Object? collectionName = null,
    Object? reference = freezed,
    Object? supabaseId = freezed,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      bookIdentifier: null == bookIdentifier
          ? _value.bookIdentifier
          : bookIdentifier // ignore: cast_nullable_to_non_nullable
              as String,
      bookName: null == bookName
          ? _value.bookName
          : bookName // ignore: cast_nullable_to_non_nullable
              as String,
      chapter: null == chapter
          ? _value.chapter
          : chapter // ignore: cast_nullable_to_non_nullable
              as int,
      verse: null == verse
          ? _value.verse
          : verse // ignore: cast_nullable_to_non_nullable
              as int,
      verseText: null == verseText
          ? _value.verseText
          : verseText // ignore: cast_nullable_to_non_nullable
              as String,
      translationId: null == translationId
          ? _value.translationId
          : translationId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      collectionName: null == collectionName
          ? _value.collectionName
          : collectionName // ignore: cast_nullable_to_non_nullable
              as String,
      reference: freezed == reference
          ? _value.reference
          : reference // ignore: cast_nullable_to_non_nullable
              as String?,
      supabaseId: freezed == supabaseId
          ? _value.supabaseId
          : supabaseId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BibleBookmarkImplCopyWith<$Res>
    implements $BibleBookmarkCopyWith<$Res> {
  factory _$$BibleBookmarkImplCopyWith(
          _$BibleBookmarkImpl value, $Res Function(_$BibleBookmarkImpl) then) =
      __$$BibleBookmarkImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String bookIdentifier,
      String bookName,
      int chapter,
      int verse,
      String verseText,
      String translationId,
      String userId,
      String collectionName,
      String? reference,
      String? supabaseId,
      DateTime createdAt});
}

/// @nodoc
class __$$BibleBookmarkImplCopyWithImpl<$Res>
    extends _$BibleBookmarkCopyWithImpl<$Res, _$BibleBookmarkImpl>
    implements _$$BibleBookmarkImplCopyWith<$Res> {
  __$$BibleBookmarkImplCopyWithImpl(
      _$BibleBookmarkImpl _value, $Res Function(_$BibleBookmarkImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bookIdentifier = null,
    Object? bookName = null,
    Object? chapter = null,
    Object? verse = null,
    Object? verseText = null,
    Object? translationId = null,
    Object? userId = null,
    Object? collectionName = null,
    Object? reference = freezed,
    Object? supabaseId = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$BibleBookmarkImpl(
      bookIdentifier: null == bookIdentifier
          ? _value.bookIdentifier
          : bookIdentifier // ignore: cast_nullable_to_non_nullable
              as String,
      bookName: null == bookName
          ? _value.bookName
          : bookName // ignore: cast_nullable_to_non_nullable
              as String,
      chapter: null == chapter
          ? _value.chapter
          : chapter // ignore: cast_nullable_to_non_nullable
              as int,
      verse: null == verse
          ? _value.verse
          : verse // ignore: cast_nullable_to_non_nullable
              as int,
      verseText: null == verseText
          ? _value.verseText
          : verseText // ignore: cast_nullable_to_non_nullable
              as String,
      translationId: null == translationId
          ? _value.translationId
          : translationId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      collectionName: null == collectionName
          ? _value.collectionName
          : collectionName // ignore: cast_nullable_to_non_nullable
              as String,
      reference: freezed == reference
          ? _value.reference
          : reference // ignore: cast_nullable_to_non_nullable
              as String?,
      supabaseId: freezed == supabaseId
          ? _value.supabaseId
          : supabaseId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$BibleBookmarkImpl extends _BibleBookmark {
  const _$BibleBookmarkImpl(
      {required this.bookIdentifier,
      required this.bookName,
      required this.chapter,
      required this.verse,
      required this.verseText,
      required this.translationId,
      required this.userId,
      this.collectionName = 'Général',
      this.reference,
      this.supabaseId,
      required this.createdAt})
      : super._();

  @override
  final String bookIdentifier;
  @override
  final String bookName;
  @override
  final int chapter;
  @override
  final int verse;
  @override
  final String verseText;
  @override
  final String translationId;
  @override
  final String userId;
  @override
  @JsonKey()
  final String collectionName;
  @override
  final String? reference;
  @override
  final String? supabaseId;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'BibleBookmark(bookIdentifier: $bookIdentifier, bookName: $bookName, chapter: $chapter, verse: $verse, verseText: $verseText, translationId: $translationId, userId: $userId, collectionName: $collectionName, reference: $reference, supabaseId: $supabaseId, createdAt: $createdAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BibleBookmarkImpl &&
            (identical(other.bookIdentifier, bookIdentifier) ||
                other.bookIdentifier == bookIdentifier) &&
            (identical(other.bookName, bookName) ||
                other.bookName == bookName) &&
            (identical(other.chapter, chapter) || other.chapter == chapter) &&
            (identical(other.verse, verse) || other.verse == verse) &&
            (identical(other.verseText, verseText) ||
                other.verseText == verseText) &&
            (identical(other.translationId, translationId) ||
                other.translationId == translationId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.collectionName, collectionName) ||
                other.collectionName == collectionName) &&
            (identical(other.reference, reference) ||
                other.reference == reference) &&
            (identical(other.supabaseId, supabaseId) ||
                other.supabaseId == supabaseId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      bookIdentifier,
      bookName,
      chapter,
      verse,
      verseText,
      translationId,
      userId,
      collectionName,
      reference,
      supabaseId,
      createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BibleBookmarkImplCopyWith<_$BibleBookmarkImpl> get copyWith =>
      __$$BibleBookmarkImplCopyWithImpl<_$BibleBookmarkImpl>(this, _$identity);
}

abstract class _BibleBookmark extends BibleBookmark {
  const factory _BibleBookmark(
      {required final String bookIdentifier,
      required final String bookName,
      required final int chapter,
      required final int verse,
      required final String verseText,
      required final String translationId,
      required final String userId,
      final String collectionName,
      final String? reference,
      final String? supabaseId,
      required final DateTime createdAt}) = _$BibleBookmarkImpl;
  const _BibleBookmark._() : super._();

  @override
  String get bookIdentifier;
  @override
  String get bookName;
  @override
  int get chapter;
  @override
  int get verse;
  @override
  String get verseText;
  @override
  String get translationId;
  @override
  String get userId;
  @override
  String get collectionName;
  @override
  String? get reference;
  @override
  String? get supabaseId;
  @override
  DateTime get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$BibleBookmarkImplCopyWith<_$BibleBookmarkImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$BibleAnnotation {
  String get bookIdentifier => throw _privateConstructorUsedError;
  int get chapter => throw _privateConstructorUsedError;
  int get verse => throw _privateConstructorUsedError;
  String get translationId => throw _privateConstructorUsedError;
  BibleAnnotationType get type => throw _privateConstructorUsedError;
  String? get color => throw _privateConstructorUsedError;
  String? get content => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  String? get supabaseId => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BibleAnnotationCopyWith<BibleAnnotation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BibleAnnotationCopyWith<$Res> {
  factory $BibleAnnotationCopyWith(
          BibleAnnotation value, $Res Function(BibleAnnotation) then) =
      _$BibleAnnotationCopyWithImpl<$Res, BibleAnnotation>;
  @useResult
  $Res call(
      {String bookIdentifier,
      int chapter,
      int verse,
      String translationId,
      BibleAnnotationType type,
      String? color,
      String? content,
      String? category,
      String? supabaseId,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$BibleAnnotationCopyWithImpl<$Res, $Val extends BibleAnnotation>
    implements $BibleAnnotationCopyWith<$Res> {
  _$BibleAnnotationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bookIdentifier = null,
    Object? chapter = null,
    Object? verse = null,
    Object? translationId = null,
    Object? type = null,
    Object? color = freezed,
    Object? content = freezed,
    Object? category = freezed,
    Object? supabaseId = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      bookIdentifier: null == bookIdentifier
          ? _value.bookIdentifier
          : bookIdentifier // ignore: cast_nullable_to_non_nullable
              as String,
      chapter: null == chapter
          ? _value.chapter
          : chapter // ignore: cast_nullable_to_non_nullable
              as int,
      verse: null == verse
          ? _value.verse
          : verse // ignore: cast_nullable_to_non_nullable
              as int,
      translationId: null == translationId
          ? _value.translationId
          : translationId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as BibleAnnotationType,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      content: freezed == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      supabaseId: freezed == supabaseId
          ? _value.supabaseId
          : supabaseId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BibleAnnotationImplCopyWith<$Res>
    implements $BibleAnnotationCopyWith<$Res> {
  factory _$$BibleAnnotationImplCopyWith(_$BibleAnnotationImpl value,
          $Res Function(_$BibleAnnotationImpl) then) =
      __$$BibleAnnotationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String bookIdentifier,
      int chapter,
      int verse,
      String translationId,
      BibleAnnotationType type,
      String? color,
      String? content,
      String? category,
      String? supabaseId,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$BibleAnnotationImplCopyWithImpl<$Res>
    extends _$BibleAnnotationCopyWithImpl<$Res, _$BibleAnnotationImpl>
    implements _$$BibleAnnotationImplCopyWith<$Res> {
  __$$BibleAnnotationImplCopyWithImpl(
      _$BibleAnnotationImpl _value, $Res Function(_$BibleAnnotationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bookIdentifier = null,
    Object? chapter = null,
    Object? verse = null,
    Object? translationId = null,
    Object? type = null,
    Object? color = freezed,
    Object? content = freezed,
    Object? category = freezed,
    Object? supabaseId = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$BibleAnnotationImpl(
      bookIdentifier: null == bookIdentifier
          ? _value.bookIdentifier
          : bookIdentifier // ignore: cast_nullable_to_non_nullable
              as String,
      chapter: null == chapter
          ? _value.chapter
          : chapter // ignore: cast_nullable_to_non_nullable
              as int,
      verse: null == verse
          ? _value.verse
          : verse // ignore: cast_nullable_to_non_nullable
              as int,
      translationId: null == translationId
          ? _value.translationId
          : translationId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as BibleAnnotationType,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      content: freezed == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      supabaseId: freezed == supabaseId
          ? _value.supabaseId
          : supabaseId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$BibleAnnotationImpl implements _BibleAnnotation {
  const _$BibleAnnotationImpl(
      {required this.bookIdentifier,
      required this.chapter,
      required this.verse,
      required this.translationId,
      required this.type,
      this.color,
      this.content,
      this.category,
      this.supabaseId,
      required this.createdAt,
      required this.updatedAt});

  @override
  final String bookIdentifier;
  @override
  final int chapter;
  @override
  final int verse;
  @override
  final String translationId;
  @override
  final BibleAnnotationType type;
  @override
  final String? color;
  @override
  final String? content;
  @override
  final String? category;
  @override
  final String? supabaseId;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'BibleAnnotation(bookIdentifier: $bookIdentifier, chapter: $chapter, verse: $verse, translationId: $translationId, type: $type, color: $color, content: $content, category: $category, supabaseId: $supabaseId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BibleAnnotationImpl &&
            (identical(other.bookIdentifier, bookIdentifier) ||
                other.bookIdentifier == bookIdentifier) &&
            (identical(other.chapter, chapter) || other.chapter == chapter) &&
            (identical(other.verse, verse) || other.verse == verse) &&
            (identical(other.translationId, translationId) ||
                other.translationId == translationId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.supabaseId, supabaseId) ||
                other.supabaseId == supabaseId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      bookIdentifier,
      chapter,
      verse,
      translationId,
      type,
      color,
      content,
      category,
      supabaseId,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BibleAnnotationImplCopyWith<_$BibleAnnotationImpl> get copyWith =>
      __$$BibleAnnotationImplCopyWithImpl<_$BibleAnnotationImpl>(
          this, _$identity);
}

abstract class _BibleAnnotation implements BibleAnnotation {
  const factory _BibleAnnotation(
      {required final String bookIdentifier,
      required final int chapter,
      required final int verse,
      required final String translationId,
      required final BibleAnnotationType type,
      final String? color,
      final String? content,
      final String? category,
      final String? supabaseId,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$BibleAnnotationImpl;

  @override
  String get bookIdentifier;
  @override
  int get chapter;
  @override
  int get verse;
  @override
  String get translationId;
  @override
  BibleAnnotationType get type;
  @override
  String? get color;
  @override
  String? get content;
  @override
  String? get category;
  @override
  String? get supabaseId;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$BibleAnnotationImplCopyWith<_$BibleAnnotationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$BibleReadingPlan {
  String get planId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  int get durationInDays => throw _privateConstructorUsedError;
  List<PlanDay> get days => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BibleReadingPlanCopyWith<BibleReadingPlan> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BibleReadingPlanCopyWith<$Res> {
  factory $BibleReadingPlanCopyWith(
          BibleReadingPlan value, $Res Function(BibleReadingPlan) then) =
      _$BibleReadingPlanCopyWithImpl<$Res, BibleReadingPlan>;
  @useResult
  $Res call(
      {String planId,
      String title,
      String description,
      int durationInDays,
      List<PlanDay> days,
      String? imageUrl});
}

/// @nodoc
class _$BibleReadingPlanCopyWithImpl<$Res, $Val extends BibleReadingPlan>
    implements $BibleReadingPlanCopyWith<$Res> {
  _$BibleReadingPlanCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? planId = null,
    Object? title = null,
    Object? description = null,
    Object? durationInDays = null,
    Object? days = null,
    Object? imageUrl = freezed,
  }) {
    return _then(_value.copyWith(
      planId: null == planId
          ? _value.planId
          : planId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      durationInDays: null == durationInDays
          ? _value.durationInDays
          : durationInDays // ignore: cast_nullable_to_non_nullable
              as int,
      days: null == days
          ? _value.days
          : days // ignore: cast_nullable_to_non_nullable
              as List<PlanDay>,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BibleReadingPlanImplCopyWith<$Res>
    implements $BibleReadingPlanCopyWith<$Res> {
  factory _$$BibleReadingPlanImplCopyWith(_$BibleReadingPlanImpl value,
          $Res Function(_$BibleReadingPlanImpl) then) =
      __$$BibleReadingPlanImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String planId,
      String title,
      String description,
      int durationInDays,
      List<PlanDay> days,
      String? imageUrl});
}

/// @nodoc
class __$$BibleReadingPlanImplCopyWithImpl<$Res>
    extends _$BibleReadingPlanCopyWithImpl<$Res, _$BibleReadingPlanImpl>
    implements _$$BibleReadingPlanImplCopyWith<$Res> {
  __$$BibleReadingPlanImplCopyWithImpl(_$BibleReadingPlanImpl _value,
      $Res Function(_$BibleReadingPlanImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? planId = null,
    Object? title = null,
    Object? description = null,
    Object? durationInDays = null,
    Object? days = null,
    Object? imageUrl = freezed,
  }) {
    return _then(_$BibleReadingPlanImpl(
      planId: null == planId
          ? _value.planId
          : planId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      durationInDays: null == durationInDays
          ? _value.durationInDays
          : durationInDays // ignore: cast_nullable_to_non_nullable
              as int,
      days: null == days
          ? _value._days
          : days // ignore: cast_nullable_to_non_nullable
              as List<PlanDay>,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$BibleReadingPlanImpl implements _BibleReadingPlan {
  const _$BibleReadingPlanImpl(
      {required this.planId,
      required this.title,
      required this.description,
      required this.durationInDays,
      required final List<PlanDay> days,
      this.imageUrl})
      : _days = days;

  @override
  final String planId;
  @override
  final String title;
  @override
  final String description;
  @override
  final int durationInDays;
  final List<PlanDay> _days;
  @override
  List<PlanDay> get days {
    if (_days is EqualUnmodifiableListView) return _days;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_days);
  }

  @override
  final String? imageUrl;

  @override
  String toString() {
    return 'BibleReadingPlan(planId: $planId, title: $title, description: $description, durationInDays: $durationInDays, days: $days, imageUrl: $imageUrl)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BibleReadingPlanImpl &&
            (identical(other.planId, planId) || other.planId == planId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.durationInDays, durationInDays) ||
                other.durationInDays == durationInDays) &&
            const DeepCollectionEquality().equals(other._days, _days) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl));
  }

  @override
  int get hashCode => Object.hash(runtimeType, planId, title, description,
      durationInDays, const DeepCollectionEquality().hash(_days), imageUrl);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BibleReadingPlanImplCopyWith<_$BibleReadingPlanImpl> get copyWith =>
      __$$BibleReadingPlanImplCopyWithImpl<_$BibleReadingPlanImpl>(
          this, _$identity);
}

abstract class _BibleReadingPlan implements BibleReadingPlan {
  const factory _BibleReadingPlan(
      {required final String planId,
      required final String title,
      required final String description,
      required final int durationInDays,
      required final List<PlanDay> days,
      final String? imageUrl}) = _$BibleReadingPlanImpl;

  @override
  String get planId;
  @override
  String get title;
  @override
  String get description;
  @override
  int get durationInDays;
  @override
  List<PlanDay> get days;
  @override
  String? get imageUrl;
  @override
  @JsonKey(ignore: true)
  _$$BibleReadingPlanImplCopyWith<_$BibleReadingPlanImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$PlanDay {
  int get dayNumber => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  List<String> get references => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PlanDayCopyWith<PlanDay> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlanDayCopyWith<$Res> {
  factory $PlanDayCopyWith(PlanDay value, $Res Function(PlanDay) then) =
      _$PlanDayCopyWithImpl<$Res, PlanDay>;
  @useResult
  $Res call({int dayNumber, String title, List<String> references});
}

/// @nodoc
class _$PlanDayCopyWithImpl<$Res, $Val extends PlanDay>
    implements $PlanDayCopyWith<$Res> {
  _$PlanDayCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dayNumber = null,
    Object? title = null,
    Object? references = null,
  }) {
    return _then(_value.copyWith(
      dayNumber: null == dayNumber
          ? _value.dayNumber
          : dayNumber // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      references: null == references
          ? _value.references
          : references // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PlanDayImplCopyWith<$Res> implements $PlanDayCopyWith<$Res> {
  factory _$$PlanDayImplCopyWith(
          _$PlanDayImpl value, $Res Function(_$PlanDayImpl) then) =
      __$$PlanDayImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int dayNumber, String title, List<String> references});
}

/// @nodoc
class __$$PlanDayImplCopyWithImpl<$Res>
    extends _$PlanDayCopyWithImpl<$Res, _$PlanDayImpl>
    implements _$$PlanDayImplCopyWith<$Res> {
  __$$PlanDayImplCopyWithImpl(
      _$PlanDayImpl _value, $Res Function(_$PlanDayImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dayNumber = null,
    Object? title = null,
    Object? references = null,
  }) {
    return _then(_$PlanDayImpl(
      dayNumber: null == dayNumber
          ? _value.dayNumber
          : dayNumber // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      references: null == references
          ? _value._references
          : references // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc

class _$PlanDayImpl implements _PlanDay {
  const _$PlanDayImpl(
      {required this.dayNumber,
      required this.title,
      required final List<String> references})
      : _references = references;

  @override
  final int dayNumber;
  @override
  final String title;
  final List<String> _references;
  @override
  List<String> get references {
    if (_references is EqualUnmodifiableListView) return _references;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_references);
  }

  @override
  String toString() {
    return 'PlanDay(dayNumber: $dayNumber, title: $title, references: $references)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlanDayImpl &&
            (identical(other.dayNumber, dayNumber) ||
                other.dayNumber == dayNumber) &&
            (identical(other.title, title) || other.title == title) &&
            const DeepCollectionEquality()
                .equals(other._references, _references));
  }

  @override
  int get hashCode => Object.hash(runtimeType, dayNumber, title,
      const DeepCollectionEquality().hash(_references));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PlanDayImplCopyWith<_$PlanDayImpl> get copyWith =>
      __$$PlanDayImplCopyWithImpl<_$PlanDayImpl>(this, _$identity);
}

abstract class _PlanDay implements PlanDay {
  const factory _PlanDay(
      {required final int dayNumber,
      required final String title,
      required final List<String> references}) = _$PlanDayImpl;

  @override
  int get dayNumber;
  @override
  String get title;
  @override
  List<String> get references;
  @override
  @JsonKey(ignore: true)
  _$$PlanDayImplCopyWith<_$PlanDayImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$BiblePlanProgress {
  String get planId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  List<int> get completedDays => throw _privateConstructorUsedError;
  DateTime get lastReadAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BiblePlanProgressCopyWith<BiblePlanProgress> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BiblePlanProgressCopyWith<$Res> {
  factory $BiblePlanProgressCopyWith(
          BiblePlanProgress value, $Res Function(BiblePlanProgress) then) =
      _$BiblePlanProgressCopyWithImpl<$Res, BiblePlanProgress>;
  @useResult
  $Res call(
      {String planId,
      String userId,
      DateTime startDate,
      List<int> completedDays,
      DateTime lastReadAt});
}

/// @nodoc
class _$BiblePlanProgressCopyWithImpl<$Res, $Val extends BiblePlanProgress>
    implements $BiblePlanProgressCopyWith<$Res> {
  _$BiblePlanProgressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? planId = null,
    Object? userId = null,
    Object? startDate = null,
    Object? completedDays = null,
    Object? lastReadAt = null,
  }) {
    return _then(_value.copyWith(
      planId: null == planId
          ? _value.planId
          : planId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      completedDays: null == completedDays
          ? _value.completedDays
          : completedDays // ignore: cast_nullable_to_non_nullable
              as List<int>,
      lastReadAt: null == lastReadAt
          ? _value.lastReadAt
          : lastReadAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BiblePlanProgressImplCopyWith<$Res>
    implements $BiblePlanProgressCopyWith<$Res> {
  factory _$$BiblePlanProgressImplCopyWith(_$BiblePlanProgressImpl value,
          $Res Function(_$BiblePlanProgressImpl) then) =
      __$$BiblePlanProgressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String planId,
      String userId,
      DateTime startDate,
      List<int> completedDays,
      DateTime lastReadAt});
}

/// @nodoc
class __$$BiblePlanProgressImplCopyWithImpl<$Res>
    extends _$BiblePlanProgressCopyWithImpl<$Res, _$BiblePlanProgressImpl>
    implements _$$BiblePlanProgressImplCopyWith<$Res> {
  __$$BiblePlanProgressImplCopyWithImpl(_$BiblePlanProgressImpl _value,
      $Res Function(_$BiblePlanProgressImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? planId = null,
    Object? userId = null,
    Object? startDate = null,
    Object? completedDays = null,
    Object? lastReadAt = null,
  }) {
    return _then(_$BiblePlanProgressImpl(
      planId: null == planId
          ? _value.planId
          : planId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      completedDays: null == completedDays
          ? _value._completedDays
          : completedDays // ignore: cast_nullable_to_non_nullable
              as List<int>,
      lastReadAt: null == lastReadAt
          ? _value.lastReadAt
          : lastReadAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$BiblePlanProgressImpl extends _BiblePlanProgress {
  const _$BiblePlanProgressImpl(
      {required this.planId,
      required this.userId,
      required this.startDate,
      final List<int> completedDays = const [],
      required this.lastReadAt})
      : _completedDays = completedDays,
        super._();

  @override
  final String planId;
  @override
  final String userId;
  @override
  final DateTime startDate;
  final List<int> _completedDays;
  @override
  @JsonKey()
  List<int> get completedDays {
    if (_completedDays is EqualUnmodifiableListView) return _completedDays;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_completedDays);
  }

  @override
  final DateTime lastReadAt;

  @override
  String toString() {
    return 'BiblePlanProgress(planId: $planId, userId: $userId, startDate: $startDate, completedDays: $completedDays, lastReadAt: $lastReadAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BiblePlanProgressImpl &&
            (identical(other.planId, planId) || other.planId == planId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            const DeepCollectionEquality()
                .equals(other._completedDays, _completedDays) &&
            (identical(other.lastReadAt, lastReadAt) ||
                other.lastReadAt == lastReadAt));
  }

  @override
  int get hashCode => Object.hash(runtimeType, planId, userId, startDate,
      const DeepCollectionEquality().hash(_completedDays), lastReadAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BiblePlanProgressImplCopyWith<_$BiblePlanProgressImpl> get copyWith =>
      __$$BiblePlanProgressImplCopyWithImpl<_$BiblePlanProgressImpl>(
          this, _$identity);
}

abstract class _BiblePlanProgress extends BiblePlanProgress {
  const factory _BiblePlanProgress(
      {required final String planId,
      required final String userId,
      required final DateTime startDate,
      final List<int> completedDays,
      required final DateTime lastReadAt}) = _$BiblePlanProgressImpl;
  const _BiblePlanProgress._() : super._();

  @override
  String get planId;
  @override
  String get userId;
  @override
  DateTime get startDate;
  @override
  List<int> get completedDays;
  @override
  DateTime get lastReadAt;
  @override
  @JsonKey(ignore: true)
  _$$BiblePlanProgressImplCopyWith<_$BiblePlanProgressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$BibleTranslation {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get shortName => throw _privateConstructorUsedError;
  String get language => throw _privateConstructorUsedError;
  bool get isDownloaded => throw _privateConstructorUsedError;
  int get downloadedChapters => throw _privateConstructorUsedError;
  int get totalChapters => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BibleTranslationCopyWith<BibleTranslation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BibleTranslationCopyWith<$Res> {
  factory $BibleTranslationCopyWith(
          BibleTranslation value, $Res Function(BibleTranslation) then) =
      _$BibleTranslationCopyWithImpl<$Res, BibleTranslation>;
  @useResult
  $Res call(
      {String id,
      String name,
      String shortName,
      String language,
      bool isDownloaded,
      int downloadedChapters,
      int totalChapters});
}

/// @nodoc
class _$BibleTranslationCopyWithImpl<$Res, $Val extends BibleTranslation>
    implements $BibleTranslationCopyWith<$Res> {
  _$BibleTranslationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? shortName = null,
    Object? language = null,
    Object? isDownloaded = null,
    Object? downloadedChapters = null,
    Object? totalChapters = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      shortName: null == shortName
          ? _value.shortName
          : shortName // ignore: cast_nullable_to_non_nullable
              as String,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      isDownloaded: null == isDownloaded
          ? _value.isDownloaded
          : isDownloaded // ignore: cast_nullable_to_non_nullable
              as bool,
      downloadedChapters: null == downloadedChapters
          ? _value.downloadedChapters
          : downloadedChapters // ignore: cast_nullable_to_non_nullable
              as int,
      totalChapters: null == totalChapters
          ? _value.totalChapters
          : totalChapters // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BibleTranslationImplCopyWith<$Res>
    implements $BibleTranslationCopyWith<$Res> {
  factory _$$BibleTranslationImplCopyWith(_$BibleTranslationImpl value,
          $Res Function(_$BibleTranslationImpl) then) =
      __$$BibleTranslationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String shortName,
      String language,
      bool isDownloaded,
      int downloadedChapters,
      int totalChapters});
}

/// @nodoc
class __$$BibleTranslationImplCopyWithImpl<$Res>
    extends _$BibleTranslationCopyWithImpl<$Res, _$BibleTranslationImpl>
    implements _$$BibleTranslationImplCopyWith<$Res> {
  __$$BibleTranslationImplCopyWithImpl(_$BibleTranslationImpl _value,
      $Res Function(_$BibleTranslationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? shortName = null,
    Object? language = null,
    Object? isDownloaded = null,
    Object? downloadedChapters = null,
    Object? totalChapters = null,
  }) {
    return _then(_$BibleTranslationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      shortName: null == shortName
          ? _value.shortName
          : shortName // ignore: cast_nullable_to_non_nullable
              as String,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      isDownloaded: null == isDownloaded
          ? _value.isDownloaded
          : isDownloaded // ignore: cast_nullable_to_non_nullable
              as bool,
      downloadedChapters: null == downloadedChapters
          ? _value.downloadedChapters
          : downloadedChapters // ignore: cast_nullable_to_non_nullable
              as int,
      totalChapters: null == totalChapters
          ? _value.totalChapters
          : totalChapters // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$BibleTranslationImpl implements _BibleTranslation {
  const _$BibleTranslationImpl(
      {required this.id,
      required this.name,
      required this.shortName,
      required this.language,
      this.isDownloaded = false,
      this.downloadedChapters = 0,
      this.totalChapters = 1189});

  @override
  final String id;
  @override
  final String name;
  @override
  final String shortName;
  @override
  final String language;
  @override
  @JsonKey()
  final bool isDownloaded;
  @override
  @JsonKey()
  final int downloadedChapters;
  @override
  @JsonKey()
  final int totalChapters;

  @override
  String toString() {
    return 'BibleTranslation(id: $id, name: $name, shortName: $shortName, language: $language, isDownloaded: $isDownloaded, downloadedChapters: $downloadedChapters, totalChapters: $totalChapters)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BibleTranslationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.shortName, shortName) ||
                other.shortName == shortName) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.isDownloaded, isDownloaded) ||
                other.isDownloaded == isDownloaded) &&
            (identical(other.downloadedChapters, downloadedChapters) ||
                other.downloadedChapters == downloadedChapters) &&
            (identical(other.totalChapters, totalChapters) ||
                other.totalChapters == totalChapters));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, name, shortName, language,
      isDownloaded, downloadedChapters, totalChapters);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BibleTranslationImplCopyWith<_$BibleTranslationImpl> get copyWith =>
      __$$BibleTranslationImplCopyWithImpl<_$BibleTranslationImpl>(
          this, _$identity);
}

abstract class _BibleTranslation implements BibleTranslation {
  const factory _BibleTranslation(
      {required final String id,
      required final String name,
      required final String shortName,
      required final String language,
      final bool isDownloaded,
      final int downloadedChapters,
      final int totalChapters}) = _$BibleTranslationImpl;

  @override
  String get id;
  @override
  String get name;
  @override
  String get shortName;
  @override
  String get language;
  @override
  bool get isDownloaded;
  @override
  int get downloadedChapters;
  @override
  int get totalChapters;
  @override
  @JsonKey(ignore: true)
  _$$BibleTranslationImplCopyWith<_$BibleTranslationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$BibleTtsSettings {
  String get languageCode => throw _privateConstructorUsedError;
  double get speechRate => throw _privateConstructorUsedError; // 0.0 → 1.0
  double get pitch => throw _privateConstructorUsedError; // 0.5 → 2.0
  double get volume => throw _privateConstructorUsedError; // 0.0 → 1.0
  bool get isEnabled => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BibleTtsSettingsCopyWith<BibleTtsSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BibleTtsSettingsCopyWith<$Res> {
  factory $BibleTtsSettingsCopyWith(
          BibleTtsSettings value, $Res Function(BibleTtsSettings) then) =
      _$BibleTtsSettingsCopyWithImpl<$Res, BibleTtsSettings>;
  @useResult
  $Res call(
      {String languageCode,
      double speechRate,
      double pitch,
      double volume,
      bool isEnabled});
}

/// @nodoc
class _$BibleTtsSettingsCopyWithImpl<$Res, $Val extends BibleTtsSettings>
    implements $BibleTtsSettingsCopyWith<$Res> {
  _$BibleTtsSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? languageCode = null,
    Object? speechRate = null,
    Object? pitch = null,
    Object? volume = null,
    Object? isEnabled = null,
  }) {
    return _then(_value.copyWith(
      languageCode: null == languageCode
          ? _value.languageCode
          : languageCode // ignore: cast_nullable_to_non_nullable
              as String,
      speechRate: null == speechRate
          ? _value.speechRate
          : speechRate // ignore: cast_nullable_to_non_nullable
              as double,
      pitch: null == pitch
          ? _value.pitch
          : pitch // ignore: cast_nullable_to_non_nullable
              as double,
      volume: null == volume
          ? _value.volume
          : volume // ignore: cast_nullable_to_non_nullable
              as double,
      isEnabled: null == isEnabled
          ? _value.isEnabled
          : isEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BibleTtsSettingsImplCopyWith<$Res>
    implements $BibleTtsSettingsCopyWith<$Res> {
  factory _$$BibleTtsSettingsImplCopyWith(_$BibleTtsSettingsImpl value,
          $Res Function(_$BibleTtsSettingsImpl) then) =
      __$$BibleTtsSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String languageCode,
      double speechRate,
      double pitch,
      double volume,
      bool isEnabled});
}

/// @nodoc
class __$$BibleTtsSettingsImplCopyWithImpl<$Res>
    extends _$BibleTtsSettingsCopyWithImpl<$Res, _$BibleTtsSettingsImpl>
    implements _$$BibleTtsSettingsImplCopyWith<$Res> {
  __$$BibleTtsSettingsImplCopyWithImpl(_$BibleTtsSettingsImpl _value,
      $Res Function(_$BibleTtsSettingsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? languageCode = null,
    Object? speechRate = null,
    Object? pitch = null,
    Object? volume = null,
    Object? isEnabled = null,
  }) {
    return _then(_$BibleTtsSettingsImpl(
      languageCode: null == languageCode
          ? _value.languageCode
          : languageCode // ignore: cast_nullable_to_non_nullable
              as String,
      speechRate: null == speechRate
          ? _value.speechRate
          : speechRate // ignore: cast_nullable_to_non_nullable
              as double,
      pitch: null == pitch
          ? _value.pitch
          : pitch // ignore: cast_nullable_to_non_nullable
              as double,
      volume: null == volume
          ? _value.volume
          : volume // ignore: cast_nullable_to_non_nullable
              as double,
      isEnabled: null == isEnabled
          ? _value.isEnabled
          : isEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$BibleTtsSettingsImpl implements _BibleTtsSettings {
  const _$BibleTtsSettingsImpl(
      {this.languageCode = 'fr-FR',
      this.speechRate = 0.5,
      this.pitch = 1.0,
      this.volume = 1.0,
      this.isEnabled = false});

  @override
  @JsonKey()
  final String languageCode;
  @override
  @JsonKey()
  final double speechRate;
// 0.0 → 1.0
  @override
  @JsonKey()
  final double pitch;
// 0.5 → 2.0
  @override
  @JsonKey()
  final double volume;
// 0.0 → 1.0
  @override
  @JsonKey()
  final bool isEnabled;

  @override
  String toString() {
    return 'BibleTtsSettings(languageCode: $languageCode, speechRate: $speechRate, pitch: $pitch, volume: $volume, isEnabled: $isEnabled)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BibleTtsSettingsImpl &&
            (identical(other.languageCode, languageCode) ||
                other.languageCode == languageCode) &&
            (identical(other.speechRate, speechRate) ||
                other.speechRate == speechRate) &&
            (identical(other.pitch, pitch) || other.pitch == pitch) &&
            (identical(other.volume, volume) || other.volume == volume) &&
            (identical(other.isEnabled, isEnabled) ||
                other.isEnabled == isEnabled));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, languageCode, speechRate, pitch, volume, isEnabled);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BibleTtsSettingsImplCopyWith<_$BibleTtsSettingsImpl> get copyWith =>
      __$$BibleTtsSettingsImplCopyWithImpl<_$BibleTtsSettingsImpl>(
          this, _$identity);
}

abstract class _BibleTtsSettings implements BibleTtsSettings {
  const factory _BibleTtsSettings(
      {final String languageCode,
      final double speechRate,
      final double pitch,
      final double volume,
      final bool isEnabled}) = _$BibleTtsSettingsImpl;

  @override
  String get languageCode;
  @override
  double get speechRate;
  @override // 0.0 → 1.0
  double get pitch;
  @override // 0.5 → 2.0
  double get volume;
  @override // 0.0 → 1.0
  bool get isEnabled;
  @override
  @JsonKey(ignore: true)
  _$$BibleTtsSettingsImplCopyWith<_$BibleTtsSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$BibleReadingStat {
  String get userId => throw _privateConstructorUsedError;
  int get currentStreak => throw _privateConstructorUsedError;
  int get maxStreak => throw _privateConstructorUsedError;
  int get totalChaptersRead => throw _privateConstructorUsedError;
  int get totalAnnotations => throw _privateConstructorUsedError;
  DateTime? get lastReadDate => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BibleReadingStatCopyWith<BibleReadingStat> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BibleReadingStatCopyWith<$Res> {
  factory $BibleReadingStatCopyWith(
          BibleReadingStat value, $Res Function(BibleReadingStat) then) =
      _$BibleReadingStatCopyWithImpl<$Res, BibleReadingStat>;
  @useResult
  $Res call(
      {String userId,
      int currentStreak,
      int maxStreak,
      int totalChaptersRead,
      int totalAnnotations,
      DateTime? lastReadDate});
}

/// @nodoc
class _$BibleReadingStatCopyWithImpl<$Res, $Val extends BibleReadingStat>
    implements $BibleReadingStatCopyWith<$Res> {
  _$BibleReadingStatCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? currentStreak = null,
    Object? maxStreak = null,
    Object? totalChaptersRead = null,
    Object? totalAnnotations = null,
    Object? lastReadDate = freezed,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      currentStreak: null == currentStreak
          ? _value.currentStreak
          : currentStreak // ignore: cast_nullable_to_non_nullable
              as int,
      maxStreak: null == maxStreak
          ? _value.maxStreak
          : maxStreak // ignore: cast_nullable_to_non_nullable
              as int,
      totalChaptersRead: null == totalChaptersRead
          ? _value.totalChaptersRead
          : totalChaptersRead // ignore: cast_nullable_to_non_nullable
              as int,
      totalAnnotations: null == totalAnnotations
          ? _value.totalAnnotations
          : totalAnnotations // ignore: cast_nullable_to_non_nullable
              as int,
      lastReadDate: freezed == lastReadDate
          ? _value.lastReadDate
          : lastReadDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BibleReadingStatImplCopyWith<$Res>
    implements $BibleReadingStatCopyWith<$Res> {
  factory _$$BibleReadingStatImplCopyWith(_$BibleReadingStatImpl value,
          $Res Function(_$BibleReadingStatImpl) then) =
      __$$BibleReadingStatImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      int currentStreak,
      int maxStreak,
      int totalChaptersRead,
      int totalAnnotations,
      DateTime? lastReadDate});
}

/// @nodoc
class __$$BibleReadingStatImplCopyWithImpl<$Res>
    extends _$BibleReadingStatCopyWithImpl<$Res, _$BibleReadingStatImpl>
    implements _$$BibleReadingStatImplCopyWith<$Res> {
  __$$BibleReadingStatImplCopyWithImpl(_$BibleReadingStatImpl _value,
      $Res Function(_$BibleReadingStatImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? currentStreak = null,
    Object? maxStreak = null,
    Object? totalChaptersRead = null,
    Object? totalAnnotations = null,
    Object? lastReadDate = freezed,
  }) {
    return _then(_$BibleReadingStatImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      currentStreak: null == currentStreak
          ? _value.currentStreak
          : currentStreak // ignore: cast_nullable_to_non_nullable
              as int,
      maxStreak: null == maxStreak
          ? _value.maxStreak
          : maxStreak // ignore: cast_nullable_to_non_nullable
              as int,
      totalChaptersRead: null == totalChaptersRead
          ? _value.totalChaptersRead
          : totalChaptersRead // ignore: cast_nullable_to_non_nullable
              as int,
      totalAnnotations: null == totalAnnotations
          ? _value.totalAnnotations
          : totalAnnotations // ignore: cast_nullable_to_non_nullable
              as int,
      lastReadDate: freezed == lastReadDate
          ? _value.lastReadDate
          : lastReadDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$BibleReadingStatImpl implements _BibleReadingStat {
  const _$BibleReadingStatImpl(
      {required this.userId,
      this.currentStreak = 0,
      this.maxStreak = 0,
      this.totalChaptersRead = 0,
      this.totalAnnotations = 0,
      this.lastReadDate});

  @override
  final String userId;
  @override
  @JsonKey()
  final int currentStreak;
  @override
  @JsonKey()
  final int maxStreak;
  @override
  @JsonKey()
  final int totalChaptersRead;
  @override
  @JsonKey()
  final int totalAnnotations;
  @override
  final DateTime? lastReadDate;

  @override
  String toString() {
    return 'BibleReadingStat(userId: $userId, currentStreak: $currentStreak, maxStreak: $maxStreak, totalChaptersRead: $totalChaptersRead, totalAnnotations: $totalAnnotations, lastReadDate: $lastReadDate)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BibleReadingStatImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.currentStreak, currentStreak) ||
                other.currentStreak == currentStreak) &&
            (identical(other.maxStreak, maxStreak) ||
                other.maxStreak == maxStreak) &&
            (identical(other.totalChaptersRead, totalChaptersRead) ||
                other.totalChaptersRead == totalChaptersRead) &&
            (identical(other.totalAnnotations, totalAnnotations) ||
                other.totalAnnotations == totalAnnotations) &&
            (identical(other.lastReadDate, lastReadDate) ||
                other.lastReadDate == lastReadDate));
  }

  @override
  int get hashCode => Object.hash(runtimeType, userId, currentStreak, maxStreak,
      totalChaptersRead, totalAnnotations, lastReadDate);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BibleReadingStatImplCopyWith<_$BibleReadingStatImpl> get copyWith =>
      __$$BibleReadingStatImplCopyWithImpl<_$BibleReadingStatImpl>(
          this, _$identity);
}

abstract class _BibleReadingStat implements BibleReadingStat {
  const factory _BibleReadingStat(
      {required final String userId,
      final int currentStreak,
      final int maxStreak,
      final int totalChaptersRead,
      final int totalAnnotations,
      final DateTime? lastReadDate}) = _$BibleReadingStatImpl;

  @override
  String get userId;
  @override
  int get currentStreak;
  @override
  int get maxStreak;
  @override
  int get totalChaptersRead;
  @override
  int get totalAnnotations;
  @override
  DateTime? get lastReadDate;
  @override
  @JsonKey(ignore: true)
  _$$BibleReadingStatImplCopyWith<_$BibleReadingStatImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$BibleSearchHistory {
  int get id => throw _privateConstructorUsedError;
  String get query => throw _privateConstructorUsedError;
  int get resultCount => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BibleSearchHistoryCopyWith<BibleSearchHistory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BibleSearchHistoryCopyWith<$Res> {
  factory $BibleSearchHistoryCopyWith(
          BibleSearchHistory value, $Res Function(BibleSearchHistory) then) =
      _$BibleSearchHistoryCopyWithImpl<$Res, BibleSearchHistory>;
  @useResult
  $Res call({int id, String query, int resultCount, DateTime createdAt});
}

/// @nodoc
class _$BibleSearchHistoryCopyWithImpl<$Res, $Val extends BibleSearchHistory>
    implements $BibleSearchHistoryCopyWith<$Res> {
  _$BibleSearchHistoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? query = null,
    Object? resultCount = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      query: null == query
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as String,
      resultCount: null == resultCount
          ? _value.resultCount
          : resultCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BibleSearchHistoryImplCopyWith<$Res>
    implements $BibleSearchHistoryCopyWith<$Res> {
  factory _$$BibleSearchHistoryImplCopyWith(_$BibleSearchHistoryImpl value,
          $Res Function(_$BibleSearchHistoryImpl) then) =
      __$$BibleSearchHistoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String query, int resultCount, DateTime createdAt});
}

/// @nodoc
class __$$BibleSearchHistoryImplCopyWithImpl<$Res>
    extends _$BibleSearchHistoryCopyWithImpl<$Res, _$BibleSearchHistoryImpl>
    implements _$$BibleSearchHistoryImplCopyWith<$Res> {
  __$$BibleSearchHistoryImplCopyWithImpl(_$BibleSearchHistoryImpl _value,
      $Res Function(_$BibleSearchHistoryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? query = null,
    Object? resultCount = null,
    Object? createdAt = null,
  }) {
    return _then(_$BibleSearchHistoryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      query: null == query
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as String,
      resultCount: null == resultCount
          ? _value.resultCount
          : resultCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$BibleSearchHistoryImpl implements _BibleSearchHistory {
  const _$BibleSearchHistoryImpl(
      {required this.id,
      required this.query,
      required this.resultCount,
      required this.createdAt});

  @override
  final int id;
  @override
  final String query;
  @override
  final int resultCount;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'BibleSearchHistory(id: $id, query: $query, resultCount: $resultCount, createdAt: $createdAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BibleSearchHistoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.query, query) || other.query == query) &&
            (identical(other.resultCount, resultCount) ||
                other.resultCount == resultCount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, query, resultCount, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BibleSearchHistoryImplCopyWith<_$BibleSearchHistoryImpl> get copyWith =>
      __$$BibleSearchHistoryImplCopyWithImpl<_$BibleSearchHistoryImpl>(
          this, _$identity);
}

abstract class _BibleSearchHistory implements BibleSearchHistory {
  const factory _BibleSearchHistory(
      {required final int id,
      required final String query,
      required final int resultCount,
      required final DateTime createdAt}) = _$BibleSearchHistoryImpl;

  @override
  int get id;
  @override
  String get query;
  @override
  int get resultCount;
  @override
  DateTime get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$BibleSearchHistoryImplCopyWith<_$BibleSearchHistoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
