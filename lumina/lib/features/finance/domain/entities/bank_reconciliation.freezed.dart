// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bank_reconciliation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

BankReconciliation _$BankReconciliationFromJson(Map<String, dynamic> json) {
  return _BankReconciliation.fromJson(json);
}

/// @nodoc
mixin _$BankReconciliation {
  String get id => throw _privateConstructorUsedError;
  String get bankAccountId => throw _privateConstructorUsedError;
  String get churchId => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime get endDate => throw _privateConstructorUsedError;
  double get startBalance => throw _privateConstructorUsedError;
  double get endBalance => throw _privateConstructorUsedError;
  double get calculatedBalance => throw _privateConstructorUsedError;
  ReconciliationStatus get status => throw _privateConstructorUsedError;
  int get matchedCount => throw _privateConstructorUsedError;
  int get unmatchedCount => throw _privateConstructorUsedError;
  int get totalImported => throw _privateConstructorUsedError;
  String? get csvFileName => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  String? get reconciledBy => throw _privateConstructorUsedError;
  DateTime? get reconciledAt => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BankReconciliationCopyWith<BankReconciliation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BankReconciliationCopyWith<$Res> {
  factory $BankReconciliationCopyWith(
          BankReconciliation value, $Res Function(BankReconciliation) then) =
      _$BankReconciliationCopyWithImpl<$Res, BankReconciliation>;
  @useResult
  $Res call(
      {String id,
      String bankAccountId,
      String churchId,
      DateTime startDate,
      DateTime endDate,
      double startBalance,
      double endBalance,
      double calculatedBalance,
      ReconciliationStatus status,
      int matchedCount,
      int unmatchedCount,
      int totalImported,
      String? csvFileName,
      String? notes,
      String? reconciledBy,
      DateTime? reconciledAt,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$BankReconciliationCopyWithImpl<$Res, $Val extends BankReconciliation>
    implements $BankReconciliationCopyWith<$Res> {
  _$BankReconciliationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? bankAccountId = null,
    Object? churchId = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? startBalance = null,
    Object? endBalance = null,
    Object? calculatedBalance = null,
    Object? status = null,
    Object? matchedCount = null,
    Object? unmatchedCount = null,
    Object? totalImported = null,
    Object? csvFileName = freezed,
    Object? notes = freezed,
    Object? reconciledBy = freezed,
    Object? reconciledAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      bankAccountId: null == bankAccountId
          ? _value.bankAccountId
          : bankAccountId // ignore: cast_nullable_to_non_nullable
              as String,
      churchId: null == churchId
          ? _value.churchId
          : churchId // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      startBalance: null == startBalance
          ? _value.startBalance
          : startBalance // ignore: cast_nullable_to_non_nullable
              as double,
      endBalance: null == endBalance
          ? _value.endBalance
          : endBalance // ignore: cast_nullable_to_non_nullable
              as double,
      calculatedBalance: null == calculatedBalance
          ? _value.calculatedBalance
          : calculatedBalance // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ReconciliationStatus,
      matchedCount: null == matchedCount
          ? _value.matchedCount
          : matchedCount // ignore: cast_nullable_to_non_nullable
              as int,
      unmatchedCount: null == unmatchedCount
          ? _value.unmatchedCount
          : unmatchedCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalImported: null == totalImported
          ? _value.totalImported
          : totalImported // ignore: cast_nullable_to_non_nullable
              as int,
      csvFileName: freezed == csvFileName
          ? _value.csvFileName
          : csvFileName // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      reconciledBy: freezed == reconciledBy
          ? _value.reconciledBy
          : reconciledBy // ignore: cast_nullable_to_non_nullable
              as String?,
      reconciledAt: freezed == reconciledAt
          ? _value.reconciledAt
          : reconciledAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BankReconciliationImplCopyWith<$Res>
    implements $BankReconciliationCopyWith<$Res> {
  factory _$$BankReconciliationImplCopyWith(_$BankReconciliationImpl value,
          $Res Function(_$BankReconciliationImpl) then) =
      __$$BankReconciliationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String bankAccountId,
      String churchId,
      DateTime startDate,
      DateTime endDate,
      double startBalance,
      double endBalance,
      double calculatedBalance,
      ReconciliationStatus status,
      int matchedCount,
      int unmatchedCount,
      int totalImported,
      String? csvFileName,
      String? notes,
      String? reconciledBy,
      DateTime? reconciledAt,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$BankReconciliationImplCopyWithImpl<$Res>
    extends _$BankReconciliationCopyWithImpl<$Res, _$BankReconciliationImpl>
    implements _$$BankReconciliationImplCopyWith<$Res> {
  __$$BankReconciliationImplCopyWithImpl(_$BankReconciliationImpl _value,
      $Res Function(_$BankReconciliationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? bankAccountId = null,
    Object? churchId = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? startBalance = null,
    Object? endBalance = null,
    Object? calculatedBalance = null,
    Object? status = null,
    Object? matchedCount = null,
    Object? unmatchedCount = null,
    Object? totalImported = null,
    Object? csvFileName = freezed,
    Object? notes = freezed,
    Object? reconciledBy = freezed,
    Object? reconciledAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$BankReconciliationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      bankAccountId: null == bankAccountId
          ? _value.bankAccountId
          : bankAccountId // ignore: cast_nullable_to_non_nullable
              as String,
      churchId: null == churchId
          ? _value.churchId
          : churchId // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      startBalance: null == startBalance
          ? _value.startBalance
          : startBalance // ignore: cast_nullable_to_non_nullable
              as double,
      endBalance: null == endBalance
          ? _value.endBalance
          : endBalance // ignore: cast_nullable_to_non_nullable
              as double,
      calculatedBalance: null == calculatedBalance
          ? _value.calculatedBalance
          : calculatedBalance // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ReconciliationStatus,
      matchedCount: null == matchedCount
          ? _value.matchedCount
          : matchedCount // ignore: cast_nullable_to_non_nullable
              as int,
      unmatchedCount: null == unmatchedCount
          ? _value.unmatchedCount
          : unmatchedCount // ignore: cast_nullable_to_non_nullable
              as int,
      totalImported: null == totalImported
          ? _value.totalImported
          : totalImported // ignore: cast_nullable_to_non_nullable
              as int,
      csvFileName: freezed == csvFileName
          ? _value.csvFileName
          : csvFileName // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      reconciledBy: freezed == reconciledBy
          ? _value.reconciledBy
          : reconciledBy // ignore: cast_nullable_to_non_nullable
              as String?,
      reconciledAt: freezed == reconciledAt
          ? _value.reconciledAt
          : reconciledAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BankReconciliationImpl extends _BankReconciliation {
  const _$BankReconciliationImpl(
      {required this.id,
      required this.bankAccountId,
      required this.churchId,
      required this.startDate,
      required this.endDate,
      required this.startBalance,
      required this.endBalance,
      this.calculatedBalance = 0.0,
      this.status = ReconciliationStatus.draft,
      this.matchedCount = 0,
      this.unmatchedCount = 0,
      this.totalImported = 0,
      this.csvFileName,
      this.notes,
      this.reconciledBy,
      this.reconciledAt,
      this.createdAt,
      this.updatedAt})
      : super._();

  factory _$BankReconciliationImpl.fromJson(Map<String, dynamic> json) =>
      _$$BankReconciliationImplFromJson(json);

  @override
  final String id;
  @override
  final String bankAccountId;
  @override
  final String churchId;
  @override
  final DateTime startDate;
  @override
  final DateTime endDate;
  @override
  final double startBalance;
  @override
  final double endBalance;
  @override
  @JsonKey()
  final double calculatedBalance;
  @override
  @JsonKey()
  final ReconciliationStatus status;
  @override
  @JsonKey()
  final int matchedCount;
  @override
  @JsonKey()
  final int unmatchedCount;
  @override
  @JsonKey()
  final int totalImported;
  @override
  final String? csvFileName;
  @override
  final String? notes;
  @override
  final String? reconciledBy;
  @override
  final DateTime? reconciledAt;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'BankReconciliation(id: $id, bankAccountId: $bankAccountId, churchId: $churchId, startDate: $startDate, endDate: $endDate, startBalance: $startBalance, endBalance: $endBalance, calculatedBalance: $calculatedBalance, status: $status, matchedCount: $matchedCount, unmatchedCount: $unmatchedCount, totalImported: $totalImported, csvFileName: $csvFileName, notes: $notes, reconciledBy: $reconciledBy, reconciledAt: $reconciledAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BankReconciliationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.bankAccountId, bankAccountId) ||
                other.bankAccountId == bankAccountId) &&
            (identical(other.churchId, churchId) ||
                other.churchId == churchId) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.startBalance, startBalance) ||
                other.startBalance == startBalance) &&
            (identical(other.endBalance, endBalance) ||
                other.endBalance == endBalance) &&
            (identical(other.calculatedBalance, calculatedBalance) ||
                other.calculatedBalance == calculatedBalance) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.matchedCount, matchedCount) ||
                other.matchedCount == matchedCount) &&
            (identical(other.unmatchedCount, unmatchedCount) ||
                other.unmatchedCount == unmatchedCount) &&
            (identical(other.totalImported, totalImported) ||
                other.totalImported == totalImported) &&
            (identical(other.csvFileName, csvFileName) ||
                other.csvFileName == csvFileName) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.reconciledBy, reconciledBy) ||
                other.reconciledBy == reconciledBy) &&
            (identical(other.reconciledAt, reconciledAt) ||
                other.reconciledAt == reconciledAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      bankAccountId,
      churchId,
      startDate,
      endDate,
      startBalance,
      endBalance,
      calculatedBalance,
      status,
      matchedCount,
      unmatchedCount,
      totalImported,
      csvFileName,
      notes,
      reconciledBy,
      reconciledAt,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BankReconciliationImplCopyWith<_$BankReconciliationImpl> get copyWith =>
      __$$BankReconciliationImplCopyWithImpl<_$BankReconciliationImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BankReconciliationImplToJson(
      this,
    );
  }
}

abstract class _BankReconciliation extends BankReconciliation {
  const factory _BankReconciliation(
      {required final String id,
      required final String bankAccountId,
      required final String churchId,
      required final DateTime startDate,
      required final DateTime endDate,
      required final double startBalance,
      required final double endBalance,
      final double calculatedBalance,
      final ReconciliationStatus status,
      final int matchedCount,
      final int unmatchedCount,
      final int totalImported,
      final String? csvFileName,
      final String? notes,
      final String? reconciledBy,
      final DateTime? reconciledAt,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$BankReconciliationImpl;
  const _BankReconciliation._() : super._();

  factory _BankReconciliation.fromJson(Map<String, dynamic> json) =
      _$BankReconciliationImpl.fromJson;

  @override
  String get id;
  @override
  String get bankAccountId;
  @override
  String get churchId;
  @override
  DateTime get startDate;
  @override
  DateTime get endDate;
  @override
  double get startBalance;
  @override
  double get endBalance;
  @override
  double get calculatedBalance;
  @override
  ReconciliationStatus get status;
  @override
  int get matchedCount;
  @override
  int get unmatchedCount;
  @override
  int get totalImported;
  @override
  String? get csvFileName;
  @override
  String? get notes;
  @override
  String? get reconciledBy;
  @override
  DateTime? get reconciledAt;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$BankReconciliationImplCopyWith<_$BankReconciliationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
