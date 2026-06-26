// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bible_stats_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$BibleStatsState {
  int get currentStreak => throw _privateConstructorUsedError;
  int get maxStreak => throw _privateConstructorUsedError;
  int get totalChaptersRead => throw _privateConstructorUsedError;
  int get totalAnnotations => throw _privateConstructorUsedError;
  DateTime? get lastReadDate => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BibleStatsStateCopyWith<BibleStatsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BibleStatsStateCopyWith<$Res> {
  factory $BibleStatsStateCopyWith(
          BibleStatsState value, $Res Function(BibleStatsState) then) =
      _$BibleStatsStateCopyWithImpl<$Res, BibleStatsState>;
  @useResult
  $Res call(
      {int currentStreak,
      int maxStreak,
      int totalChaptersRead,
      int totalAnnotations,
      DateTime? lastReadDate,
      bool isLoading});
}

/// @nodoc
class _$BibleStatsStateCopyWithImpl<$Res, $Val extends BibleStatsState>
    implements $BibleStatsStateCopyWith<$Res> {
  _$BibleStatsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentStreak = null,
    Object? maxStreak = null,
    Object? totalChaptersRead = null,
    Object? totalAnnotations = null,
    Object? lastReadDate = freezed,
    Object? isLoading = null,
  }) {
    return _then(_value.copyWith(
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
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BibleStatsStateImplCopyWith<$Res>
    implements $BibleStatsStateCopyWith<$Res> {
  factory _$$BibleStatsStateImplCopyWith(_$BibleStatsStateImpl value,
          $Res Function(_$BibleStatsStateImpl) then) =
      __$$BibleStatsStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int currentStreak,
      int maxStreak,
      int totalChaptersRead,
      int totalAnnotations,
      DateTime? lastReadDate,
      bool isLoading});
}

/// @nodoc
class __$$BibleStatsStateImplCopyWithImpl<$Res>
    extends _$BibleStatsStateCopyWithImpl<$Res, _$BibleStatsStateImpl>
    implements _$$BibleStatsStateImplCopyWith<$Res> {
  __$$BibleStatsStateImplCopyWithImpl(
      _$BibleStatsStateImpl _value, $Res Function(_$BibleStatsStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentStreak = null,
    Object? maxStreak = null,
    Object? totalChaptersRead = null,
    Object? totalAnnotations = null,
    Object? lastReadDate = freezed,
    Object? isLoading = null,
  }) {
    return _then(_$BibleStatsStateImpl(
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
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$BibleStatsStateImpl implements _BibleStatsState {
  const _$BibleStatsStateImpl(
      {this.currentStreak = 0,
      this.maxStreak = 0,
      this.totalChaptersRead = 0,
      this.totalAnnotations = 0,
      this.lastReadDate,
      this.isLoading = true});

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
  @JsonKey()
  final bool isLoading;

  @override
  String toString() {
    return 'BibleStatsState(currentStreak: $currentStreak, maxStreak: $maxStreak, totalChaptersRead: $totalChaptersRead, totalAnnotations: $totalAnnotations, lastReadDate: $lastReadDate, isLoading: $isLoading)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BibleStatsStateImpl &&
            (identical(other.currentStreak, currentStreak) ||
                other.currentStreak == currentStreak) &&
            (identical(other.maxStreak, maxStreak) ||
                other.maxStreak == maxStreak) &&
            (identical(other.totalChaptersRead, totalChaptersRead) ||
                other.totalChaptersRead == totalChaptersRead) &&
            (identical(other.totalAnnotations, totalAnnotations) ||
                other.totalAnnotations == totalAnnotations) &&
            (identical(other.lastReadDate, lastReadDate) ||
                other.lastReadDate == lastReadDate) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading));
  }

  @override
  int get hashCode => Object.hash(runtimeType, currentStreak, maxStreak,
      totalChaptersRead, totalAnnotations, lastReadDate, isLoading);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BibleStatsStateImplCopyWith<_$BibleStatsStateImpl> get copyWith =>
      __$$BibleStatsStateImplCopyWithImpl<_$BibleStatsStateImpl>(
          this, _$identity);
}

abstract class _BibleStatsState implements BibleStatsState {
  const factory _BibleStatsState(
      {final int currentStreak,
      final int maxStreak,
      final int totalChaptersRead,
      final int totalAnnotations,
      final DateTime? lastReadDate,
      final bool isLoading}) = _$BibleStatsStateImpl;

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
  bool get isLoading;
  @override
  @JsonKey(ignore: true)
  _$$BibleStatsStateImplCopyWith<_$BibleStatsStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
