// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bible_library_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$BibleLibraryState {
  List<BibleBookmark> get bookmarks => throw _privateConstructorUsedError;
  List<BibleAnnotation> get annotations => throw _privateConstructorUsedError;
  List<String> get collections => throw _privateConstructorUsedError;
  String? get activeCollection => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BibleLibraryStateCopyWith<BibleLibraryState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BibleLibraryStateCopyWith<$Res> {
  factory $BibleLibraryStateCopyWith(
          BibleLibraryState value, $Res Function(BibleLibraryState) then) =
      _$BibleLibraryStateCopyWithImpl<$Res, BibleLibraryState>;
  @useResult
  $Res call(
      {List<BibleBookmark> bookmarks,
      List<BibleAnnotation> annotations,
      List<String> collections,
      String? activeCollection,
      bool isLoading,
      String? error});
}

/// @nodoc
class _$BibleLibraryStateCopyWithImpl<$Res, $Val extends BibleLibraryState>
    implements $BibleLibraryStateCopyWith<$Res> {
  _$BibleLibraryStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bookmarks = null,
    Object? annotations = null,
    Object? collections = null,
    Object? activeCollection = freezed,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      bookmarks: null == bookmarks
          ? _value.bookmarks
          : bookmarks // ignore: cast_nullable_to_non_nullable
              as List<BibleBookmark>,
      annotations: null == annotations
          ? _value.annotations
          : annotations // ignore: cast_nullable_to_non_nullable
              as List<BibleAnnotation>,
      collections: null == collections
          ? _value.collections
          : collections // ignore: cast_nullable_to_non_nullable
              as List<String>,
      activeCollection: freezed == activeCollection
          ? _value.activeCollection
          : activeCollection // ignore: cast_nullable_to_non_nullable
              as String?,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BibleLibraryStateImplCopyWith<$Res>
    implements $BibleLibraryStateCopyWith<$Res> {
  factory _$$BibleLibraryStateImplCopyWith(_$BibleLibraryStateImpl value,
          $Res Function(_$BibleLibraryStateImpl) then) =
      __$$BibleLibraryStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<BibleBookmark> bookmarks,
      List<BibleAnnotation> annotations,
      List<String> collections,
      String? activeCollection,
      bool isLoading,
      String? error});
}

/// @nodoc
class __$$BibleLibraryStateImplCopyWithImpl<$Res>
    extends _$BibleLibraryStateCopyWithImpl<$Res, _$BibleLibraryStateImpl>
    implements _$$BibleLibraryStateImplCopyWith<$Res> {
  __$$BibleLibraryStateImplCopyWithImpl(_$BibleLibraryStateImpl _value,
      $Res Function(_$BibleLibraryStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bookmarks = null,
    Object? annotations = null,
    Object? collections = null,
    Object? activeCollection = freezed,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_$BibleLibraryStateImpl(
      bookmarks: null == bookmarks
          ? _value._bookmarks
          : bookmarks // ignore: cast_nullable_to_non_nullable
              as List<BibleBookmark>,
      annotations: null == annotations
          ? _value._annotations
          : annotations // ignore: cast_nullable_to_non_nullable
              as List<BibleAnnotation>,
      collections: null == collections
          ? _value._collections
          : collections // ignore: cast_nullable_to_non_nullable
              as List<String>,
      activeCollection: freezed == activeCollection
          ? _value.activeCollection
          : activeCollection // ignore: cast_nullable_to_non_nullable
              as String?,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$BibleLibraryStateImpl implements _BibleLibraryState {
  const _$BibleLibraryStateImpl(
      {final List<BibleBookmark> bookmarks = const [],
      final List<BibleAnnotation> annotations = const [],
      final List<String> collections = const [],
      this.activeCollection,
      this.isLoading = true,
      this.error})
      : _bookmarks = bookmarks,
        _annotations = annotations,
        _collections = collections;

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

  final List<String> _collections;
  @override
  @JsonKey()
  List<String> get collections {
    if (_collections is EqualUnmodifiableListView) return _collections;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_collections);
  }

  @override
  final String? activeCollection;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? error;

  @override
  String toString() {
    return 'BibleLibraryState(bookmarks: $bookmarks, annotations: $annotations, collections: $collections, activeCollection: $activeCollection, isLoading: $isLoading, error: $error)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BibleLibraryStateImpl &&
            const DeepCollectionEquality()
                .equals(other._bookmarks, _bookmarks) &&
            const DeepCollectionEquality()
                .equals(other._annotations, _annotations) &&
            const DeepCollectionEquality()
                .equals(other._collections, _collections) &&
            (identical(other.activeCollection, activeCollection) ||
                other.activeCollection == activeCollection) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_bookmarks),
      const DeepCollectionEquality().hash(_annotations),
      const DeepCollectionEquality().hash(_collections),
      activeCollection,
      isLoading,
      error);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BibleLibraryStateImplCopyWith<_$BibleLibraryStateImpl> get copyWith =>
      __$$BibleLibraryStateImplCopyWithImpl<_$BibleLibraryStateImpl>(
          this, _$identity);
}

abstract class _BibleLibraryState implements BibleLibraryState {
  const factory _BibleLibraryState(
      {final List<BibleBookmark> bookmarks,
      final List<BibleAnnotation> annotations,
      final List<String> collections,
      final String? activeCollection,
      final bool isLoading,
      final String? error}) = _$BibleLibraryStateImpl;

  @override
  List<BibleBookmark> get bookmarks;
  @override
  List<BibleAnnotation> get annotations;
  @override
  List<String> get collections;
  @override
  String? get activeCollection;
  @override
  bool get isLoading;
  @override
  String? get error;
  @override
  @JsonKey(ignore: true)
  _$$BibleLibraryStateImplCopyWith<_$BibleLibraryStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
