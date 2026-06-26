// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bible_search_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$BibleSearchState {
  String get query => throw _privateConstructorUsedError;
  List<BibleVerse> get results => throw _privateConstructorUsedError;
  List<BibleSearchHistory> get history => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isSearching => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BibleSearchStateCopyWith<BibleSearchState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BibleSearchStateCopyWith<$Res> {
  factory $BibleSearchStateCopyWith(
          BibleSearchState value, $Res Function(BibleSearchState) then) =
      _$BibleSearchStateCopyWithImpl<$Res, BibleSearchState>;
  @useResult
  $Res call(
      {String query,
      List<BibleVerse> results,
      List<BibleSearchHistory> history,
      bool isLoading,
      bool isSearching,
      String? error});
}

/// @nodoc
class _$BibleSearchStateCopyWithImpl<$Res, $Val extends BibleSearchState>
    implements $BibleSearchStateCopyWith<$Res> {
  _$BibleSearchStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? query = null,
    Object? results = null,
    Object? history = null,
    Object? isLoading = null,
    Object? isSearching = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      query: null == query
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as String,
      results: null == results
          ? _value.results
          : results // ignore: cast_nullable_to_non_nullable
              as List<BibleVerse>,
      history: null == history
          ? _value.history
          : history // ignore: cast_nullable_to_non_nullable
              as List<BibleSearchHistory>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isSearching: null == isSearching
          ? _value.isSearching
          : isSearching // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BibleSearchStateImplCopyWith<$Res>
    implements $BibleSearchStateCopyWith<$Res> {
  factory _$$BibleSearchStateImplCopyWith(_$BibleSearchStateImpl value,
          $Res Function(_$BibleSearchStateImpl) then) =
      __$$BibleSearchStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String query,
      List<BibleVerse> results,
      List<BibleSearchHistory> history,
      bool isLoading,
      bool isSearching,
      String? error});
}

/// @nodoc
class __$$BibleSearchStateImplCopyWithImpl<$Res>
    extends _$BibleSearchStateCopyWithImpl<$Res, _$BibleSearchStateImpl>
    implements _$$BibleSearchStateImplCopyWith<$Res> {
  __$$BibleSearchStateImplCopyWithImpl(_$BibleSearchStateImpl _value,
      $Res Function(_$BibleSearchStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? query = null,
    Object? results = null,
    Object? history = null,
    Object? isLoading = null,
    Object? isSearching = null,
    Object? error = freezed,
  }) {
    return _then(_$BibleSearchStateImpl(
      query: null == query
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as String,
      results: null == results
          ? _value._results
          : results // ignore: cast_nullable_to_non_nullable
              as List<BibleVerse>,
      history: null == history
          ? _value._history
          : history // ignore: cast_nullable_to_non_nullable
              as List<BibleSearchHistory>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isSearching: null == isSearching
          ? _value.isSearching
          : isSearching // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$BibleSearchStateImpl implements _BibleSearchState {
  const _$BibleSearchStateImpl(
      {this.query = '',
      final List<BibleVerse> results = const [],
      final List<BibleSearchHistory> history = const [],
      this.isLoading = false,
      this.isSearching = false,
      this.error})
      : _results = results,
        _history = history;

  @override
  @JsonKey()
  final String query;
  final List<BibleVerse> _results;
  @override
  @JsonKey()
  List<BibleVerse> get results {
    if (_results is EqualUnmodifiableListView) return _results;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_results);
  }

  final List<BibleSearchHistory> _history;
  @override
  @JsonKey()
  List<BibleSearchHistory> get history {
    if (_history is EqualUnmodifiableListView) return _history;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_history);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isSearching;
  @override
  final String? error;

  @override
  String toString() {
    return 'BibleSearchState(query: $query, results: $results, history: $history, isLoading: $isLoading, isSearching: $isSearching, error: $error)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BibleSearchStateImpl &&
            (identical(other.query, query) || other.query == query) &&
            const DeepCollectionEquality().equals(other._results, _results) &&
            const DeepCollectionEquality().equals(other._history, _history) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isSearching, isSearching) ||
                other.isSearching == isSearching) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      query,
      const DeepCollectionEquality().hash(_results),
      const DeepCollectionEquality().hash(_history),
      isLoading,
      isSearching,
      error);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BibleSearchStateImplCopyWith<_$BibleSearchStateImpl> get copyWith =>
      __$$BibleSearchStateImplCopyWithImpl<_$BibleSearchStateImpl>(
          this, _$identity);
}

abstract class _BibleSearchState implements BibleSearchState {
  const factory _BibleSearchState(
      {final String query,
      final List<BibleVerse> results,
      final List<BibleSearchHistory> history,
      final bool isLoading,
      final bool isSearching,
      final String? error}) = _$BibleSearchStateImpl;

  @override
  String get query;
  @override
  List<BibleVerse> get results;
  @override
  List<BibleSearchHistory> get history;
  @override
  bool get isLoading;
  @override
  bool get isSearching;
  @override
  String? get error;
  @override
  @JsonKey(ignore: true)
  _$$BibleSearchStateImplCopyWith<_$BibleSearchStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
