// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bilan_breakdown_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

BilanBreakdownItem _$BilanBreakdownItemFromJson(Map<String, dynamic> json) {
  return _BilanBreakdownItem.fromJson(json);
}

/// @nodoc
mixin _$BilanBreakdownItem {
  String get key =>
      throw _privateConstructorUsedError; // Category name, Group ID, or Month
  double get totalIncome => throw _privateConstructorUsedError;
  double get totalExpense => throw _privateConstructorUsedError;
  int get transactionCount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BilanBreakdownItemCopyWith<BilanBreakdownItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BilanBreakdownItemCopyWith<$Res> {
  factory $BilanBreakdownItemCopyWith(
          BilanBreakdownItem value, $Res Function(BilanBreakdownItem) then) =
      _$BilanBreakdownItemCopyWithImpl<$Res, BilanBreakdownItem>;
  @useResult
  $Res call(
      {String key,
      double totalIncome,
      double totalExpense,
      int transactionCount});
}

/// @nodoc
class _$BilanBreakdownItemCopyWithImpl<$Res, $Val extends BilanBreakdownItem>
    implements $BilanBreakdownItemCopyWith<$Res> {
  _$BilanBreakdownItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? totalIncome = null,
    Object? totalExpense = null,
    Object? transactionCount = null,
  }) {
    return _then(_value.copyWith(
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      totalIncome: null == totalIncome
          ? _value.totalIncome
          : totalIncome // ignore: cast_nullable_to_non_nullable
              as double,
      totalExpense: null == totalExpense
          ? _value.totalExpense
          : totalExpense // ignore: cast_nullable_to_non_nullable
              as double,
      transactionCount: null == transactionCount
          ? _value.transactionCount
          : transactionCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BilanBreakdownItemImplCopyWith<$Res>
    implements $BilanBreakdownItemCopyWith<$Res> {
  factory _$$BilanBreakdownItemImplCopyWith(_$BilanBreakdownItemImpl value,
          $Res Function(_$BilanBreakdownItemImpl) then) =
      __$$BilanBreakdownItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String key,
      double totalIncome,
      double totalExpense,
      int transactionCount});
}

/// @nodoc
class __$$BilanBreakdownItemImplCopyWithImpl<$Res>
    extends _$BilanBreakdownItemCopyWithImpl<$Res, _$BilanBreakdownItemImpl>
    implements _$$BilanBreakdownItemImplCopyWith<$Res> {
  __$$BilanBreakdownItemImplCopyWithImpl(_$BilanBreakdownItemImpl _value,
      $Res Function(_$BilanBreakdownItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? totalIncome = null,
    Object? totalExpense = null,
    Object? transactionCount = null,
  }) {
    return _then(_$BilanBreakdownItemImpl(
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      totalIncome: null == totalIncome
          ? _value.totalIncome
          : totalIncome // ignore: cast_nullable_to_non_nullable
              as double,
      totalExpense: null == totalExpense
          ? _value.totalExpense
          : totalExpense // ignore: cast_nullable_to_non_nullable
              as double,
      transactionCount: null == transactionCount
          ? _value.transactionCount
          : transactionCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BilanBreakdownItemImpl implements _BilanBreakdownItem {
  const _$BilanBreakdownItemImpl(
      {required this.key,
      this.totalIncome = 0,
      this.totalExpense = 0,
      this.transactionCount = 0});

  factory _$BilanBreakdownItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$BilanBreakdownItemImplFromJson(json);

  @override
  final String key;
// Category name, Group ID, or Month
  @override
  @JsonKey()
  final double totalIncome;
  @override
  @JsonKey()
  final double totalExpense;
  @override
  @JsonKey()
  final int transactionCount;

  @override
  String toString() {
    return 'BilanBreakdownItem(key: $key, totalIncome: $totalIncome, totalExpense: $totalExpense, transactionCount: $transactionCount)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BilanBreakdownItemImpl &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.totalIncome, totalIncome) ||
                other.totalIncome == totalIncome) &&
            (identical(other.totalExpense, totalExpense) ||
                other.totalExpense == totalExpense) &&
            (identical(other.transactionCount, transactionCount) ||
                other.transactionCount == transactionCount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, key, totalIncome, totalExpense, transactionCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BilanBreakdownItemImplCopyWith<_$BilanBreakdownItemImpl> get copyWith =>
      __$$BilanBreakdownItemImplCopyWithImpl<_$BilanBreakdownItemImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BilanBreakdownItemImplToJson(
      this,
    );
  }
}

abstract class _BilanBreakdownItem implements BilanBreakdownItem {
  const factory _BilanBreakdownItem(
      {required final String key,
      final double totalIncome,
      final double totalExpense,
      final int transactionCount}) = _$BilanBreakdownItemImpl;

  factory _BilanBreakdownItem.fromJson(Map<String, dynamic> json) =
      _$BilanBreakdownItemImpl.fromJson;

  @override
  String get key;
  @override // Category name, Group ID, or Month
  double get totalIncome;
  @override
  double get totalExpense;
  @override
  int get transactionCount;
  @override
  @JsonKey(ignore: true)
  _$$BilanBreakdownItemImplCopyWith<_$BilanBreakdownItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
