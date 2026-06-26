// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recurring_transaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

RecurringTransaction _$RecurringTransactionFromJson(Map<String, dynamic> json) {
  return _RecurringTransaction.fromJson(json);
}

/// @nodoc
mixin _$RecurringTransaction {
  String get id => throw _privateConstructorUsedError;
  String get churchId => throw _privateConstructorUsedError;
  String get accountId => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  TransactionType get type => throw _privateConstructorUsedError;
  String? get categoryId => throw _privateConstructorUsedError;
  String? get categoryName => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  RecurringFrequency get frequency => throw _privateConstructorUsedError;
  int get intervalValue => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime get nextOccurrence => throw _privateConstructorUsedError;
  DateTime? get endDate => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  String? get createdBy => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RecurringTransactionCopyWith<RecurringTransaction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecurringTransactionCopyWith<$Res> {
  factory $RecurringTransactionCopyWith(RecurringTransaction value,
          $Res Function(RecurringTransaction) then) =
      _$RecurringTransactionCopyWithImpl<$Res, RecurringTransaction>;
  @useResult
  $Res call(
      {String id,
      String churchId,
      String accountId,
      double amount,
      TransactionType type,
      String? categoryId,
      String? categoryName,
      String description,
      RecurringFrequency frequency,
      int intervalValue,
      DateTime startDate,
      DateTime nextOccurrence,
      DateTime? endDate,
      bool isActive,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? createdBy});
}

/// @nodoc
class _$RecurringTransactionCopyWithImpl<$Res,
        $Val extends RecurringTransaction>
    implements $RecurringTransactionCopyWith<$Res> {
  _$RecurringTransactionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? churchId = null,
    Object? accountId = null,
    Object? amount = null,
    Object? type = null,
    Object? categoryId = freezed,
    Object? categoryName = freezed,
    Object? description = null,
    Object? frequency = null,
    Object? intervalValue = null,
    Object? startDate = null,
    Object? nextOccurrence = null,
    Object? endDate = freezed,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? createdBy = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      churchId: null == churchId
          ? _value.churchId
          : churchId // ignore: cast_nullable_to_non_nullable
              as String,
      accountId: null == accountId
          ? _value.accountId
          : accountId // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as TransactionType,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryName: freezed == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String?,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      frequency: null == frequency
          ? _value.frequency
          : frequency // ignore: cast_nullable_to_non_nullable
              as RecurringFrequency,
      intervalValue: null == intervalValue
          ? _value.intervalValue
          : intervalValue // ignore: cast_nullable_to_non_nullable
              as int,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      nextOccurrence: null == nextOccurrence
          ? _value.nextOccurrence
          : nextOccurrence // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecurringTransactionImplCopyWith<$Res>
    implements $RecurringTransactionCopyWith<$Res> {
  factory _$$RecurringTransactionImplCopyWith(_$RecurringTransactionImpl value,
          $Res Function(_$RecurringTransactionImpl) then) =
      __$$RecurringTransactionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String churchId,
      String accountId,
      double amount,
      TransactionType type,
      String? categoryId,
      String? categoryName,
      String description,
      RecurringFrequency frequency,
      int intervalValue,
      DateTime startDate,
      DateTime nextOccurrence,
      DateTime? endDate,
      bool isActive,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? createdBy});
}

/// @nodoc
class __$$RecurringTransactionImplCopyWithImpl<$Res>
    extends _$RecurringTransactionCopyWithImpl<$Res, _$RecurringTransactionImpl>
    implements _$$RecurringTransactionImplCopyWith<$Res> {
  __$$RecurringTransactionImplCopyWithImpl(_$RecurringTransactionImpl _value,
      $Res Function(_$RecurringTransactionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? churchId = null,
    Object? accountId = null,
    Object? amount = null,
    Object? type = null,
    Object? categoryId = freezed,
    Object? categoryName = freezed,
    Object? description = null,
    Object? frequency = null,
    Object? intervalValue = null,
    Object? startDate = null,
    Object? nextOccurrence = null,
    Object? endDate = freezed,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? createdBy = freezed,
  }) {
    return _then(_$RecurringTransactionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      churchId: null == churchId
          ? _value.churchId
          : churchId // ignore: cast_nullable_to_non_nullable
              as String,
      accountId: null == accountId
          ? _value.accountId
          : accountId // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as TransactionType,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryName: freezed == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String?,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      frequency: null == frequency
          ? _value.frequency
          : frequency // ignore: cast_nullable_to_non_nullable
              as RecurringFrequency,
      intervalValue: null == intervalValue
          ? _value.intervalValue
          : intervalValue // ignore: cast_nullable_to_non_nullable
              as int,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      nextOccurrence: null == nextOccurrence
          ? _value.nextOccurrence
          : nextOccurrence // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RecurringTransactionImpl implements _RecurringTransaction {
  const _$RecurringTransactionImpl(
      {required this.id,
      required this.churchId,
      required this.accountId,
      required this.amount,
      required this.type,
      this.categoryId,
      this.categoryName,
      required this.description,
      required this.frequency,
      this.intervalValue = 1,
      required this.startDate,
      required this.nextOccurrence,
      this.endDate,
      this.isActive = true,
      this.createdAt,
      this.updatedAt,
      this.createdBy});

  factory _$RecurringTransactionImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecurringTransactionImplFromJson(json);

  @override
  final String id;
  @override
  final String churchId;
  @override
  final String accountId;
  @override
  final double amount;
  @override
  final TransactionType type;
  @override
  final String? categoryId;
  @override
  final String? categoryName;
  @override
  final String description;
  @override
  final RecurringFrequency frequency;
  @override
  @JsonKey()
  final int intervalValue;
  @override
  final DateTime startDate;
  @override
  final DateTime nextOccurrence;
  @override
  final DateTime? endDate;
  @override
  @JsonKey()
  final bool isActive;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final String? createdBy;

  @override
  String toString() {
    return 'RecurringTransaction(id: $id, churchId: $churchId, accountId: $accountId, amount: $amount, type: $type, categoryId: $categoryId, categoryName: $categoryName, description: $description, frequency: $frequency, intervalValue: $intervalValue, startDate: $startDate, nextOccurrence: $nextOccurrence, endDate: $endDate, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt, createdBy: $createdBy)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecurringTransactionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.churchId, churchId) ||
                other.churchId == churchId) &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.categoryName, categoryName) ||
                other.categoryName == categoryName) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.frequency, frequency) ||
                other.frequency == frequency) &&
            (identical(other.intervalValue, intervalValue) ||
                other.intervalValue == intervalValue) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.nextOccurrence, nextOccurrence) ||
                other.nextOccurrence == nextOccurrence) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      churchId,
      accountId,
      amount,
      type,
      categoryId,
      categoryName,
      description,
      frequency,
      intervalValue,
      startDate,
      nextOccurrence,
      endDate,
      isActive,
      createdAt,
      updatedAt,
      createdBy);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RecurringTransactionImplCopyWith<_$RecurringTransactionImpl>
      get copyWith =>
          __$$RecurringTransactionImplCopyWithImpl<_$RecurringTransactionImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RecurringTransactionImplToJson(
      this,
    );
  }
}

abstract class _RecurringTransaction implements RecurringTransaction {
  const factory _RecurringTransaction(
      {required final String id,
      required final String churchId,
      required final String accountId,
      required final double amount,
      required final TransactionType type,
      final String? categoryId,
      final String? categoryName,
      required final String description,
      required final RecurringFrequency frequency,
      final int intervalValue,
      required final DateTime startDate,
      required final DateTime nextOccurrence,
      final DateTime? endDate,
      final bool isActive,
      final DateTime? createdAt,
      final DateTime? updatedAt,
      final String? createdBy}) = _$RecurringTransactionImpl;

  factory _RecurringTransaction.fromJson(Map<String, dynamic> json) =
      _$RecurringTransactionImpl.fromJson;

  @override
  String get id;
  @override
  String get churchId;
  @override
  String get accountId;
  @override
  double get amount;
  @override
  TransactionType get type;
  @override
  String? get categoryId;
  @override
  String? get categoryName;
  @override
  String get description;
  @override
  RecurringFrequency get frequency;
  @override
  int get intervalValue;
  @override
  DateTime get startDate;
  @override
  DateTime get nextOccurrence;
  @override
  DateTime? get endDate;
  @override
  bool get isActive;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  String? get createdBy;
  @override
  @JsonKey(ignore: true)
  _$$RecurringTransactionImplCopyWith<_$RecurringTransactionImpl>
      get copyWith => throw _privateConstructorUsedError;
}
