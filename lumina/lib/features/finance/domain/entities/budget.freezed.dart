// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'budget.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Budget _$BudgetFromJson(Map<String, dynamic> json) {
  return _Budget.fromJson(json);
}

/// @nodoc
mixin _$Budget {
  String get id => throw _privateConstructorUsedError;
  String get churchId => throw _privateConstructorUsedError;
  String get categoryId =>
      throw _privateConstructorUsedError; // Lié aux Rubriques
  BudgetPeriod get period => throw _privateConstructorUsedError;
  int get year => throw _privateConstructorUsedError;
  int? get fiscalYear => throw _privateConstructorUsedError;
  int? get month => throw _privateConstructorUsedError; // 1-12 pour monthly
  int? get quarter => throw _privateConstructorUsedError; // 1-4 pour quarterly
  double get plannedAmount => throw _privateConstructorUsedError;
  double get actualAmount => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  bool get isApproved => throw _privateConstructorUsedError;
  String? get approvedBy => throw _privateConstructorUsedError;
  DateTime? get approvedAt => throw _privateConstructorUsedError;
  DateTime? get startDate => throw _privateConstructorUsedError;
  DateTime? get endDate => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BudgetCopyWith<Budget> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BudgetCopyWith<$Res> {
  factory $BudgetCopyWith(Budget value, $Res Function(Budget) then) =
      _$BudgetCopyWithImpl<$Res, Budget>;
  @useResult
  $Res call(
      {String id,
      String churchId,
      String categoryId,
      BudgetPeriod period,
      int year,
      int? fiscalYear,
      int? month,
      int? quarter,
      double plannedAmount,
      double actualAmount,
      String status,
      bool isApproved,
      String? approvedBy,
      DateTime? approvedAt,
      DateTime? startDate,
      DateTime? endDate,
      String? notes,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$BudgetCopyWithImpl<$Res, $Val extends Budget>
    implements $BudgetCopyWith<$Res> {
  _$BudgetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? churchId = null,
    Object? categoryId = null,
    Object? period = null,
    Object? year = null,
    Object? fiscalYear = freezed,
    Object? month = freezed,
    Object? quarter = freezed,
    Object? plannedAmount = null,
    Object? actualAmount = null,
    Object? status = null,
    Object? isApproved = null,
    Object? approvedBy = freezed,
    Object? approvedAt = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? notes = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
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
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      period: null == period
          ? _value.period
          : period // ignore: cast_nullable_to_non_nullable
              as BudgetPeriod,
      year: null == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as int,
      fiscalYear: freezed == fiscalYear
          ? _value.fiscalYear
          : fiscalYear // ignore: cast_nullable_to_non_nullable
              as int?,
      month: freezed == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as int?,
      quarter: freezed == quarter
          ? _value.quarter
          : quarter // ignore: cast_nullable_to_non_nullable
              as int?,
      plannedAmount: null == plannedAmount
          ? _value.plannedAmount
          : plannedAmount // ignore: cast_nullable_to_non_nullable
              as double,
      actualAmount: null == actualAmount
          ? _value.actualAmount
          : actualAmount // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      isApproved: null == isApproved
          ? _value.isApproved
          : isApproved // ignore: cast_nullable_to_non_nullable
              as bool,
      approvedBy: freezed == approvedBy
          ? _value.approvedBy
          : approvedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      approvedAt: freezed == approvedAt
          ? _value.approvedAt
          : approvedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
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
abstract class _$$BudgetImplCopyWith<$Res> implements $BudgetCopyWith<$Res> {
  factory _$$BudgetImplCopyWith(
          _$BudgetImpl value, $Res Function(_$BudgetImpl) then) =
      __$$BudgetImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String churchId,
      String categoryId,
      BudgetPeriod period,
      int year,
      int? fiscalYear,
      int? month,
      int? quarter,
      double plannedAmount,
      double actualAmount,
      String status,
      bool isApproved,
      String? approvedBy,
      DateTime? approvedAt,
      DateTime? startDate,
      DateTime? endDate,
      String? notes,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$BudgetImplCopyWithImpl<$Res>
    extends _$BudgetCopyWithImpl<$Res, _$BudgetImpl>
    implements _$$BudgetImplCopyWith<$Res> {
  __$$BudgetImplCopyWithImpl(
      _$BudgetImpl _value, $Res Function(_$BudgetImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? churchId = null,
    Object? categoryId = null,
    Object? period = null,
    Object? year = null,
    Object? fiscalYear = freezed,
    Object? month = freezed,
    Object? quarter = freezed,
    Object? plannedAmount = null,
    Object? actualAmount = null,
    Object? status = null,
    Object? isApproved = null,
    Object? approvedBy = freezed,
    Object? approvedAt = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? notes = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$BudgetImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      churchId: null == churchId
          ? _value.churchId
          : churchId // ignore: cast_nullable_to_non_nullable
              as String,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      period: null == period
          ? _value.period
          : period // ignore: cast_nullable_to_non_nullable
              as BudgetPeriod,
      year: null == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as int,
      fiscalYear: freezed == fiscalYear
          ? _value.fiscalYear
          : fiscalYear // ignore: cast_nullable_to_non_nullable
              as int?,
      month: freezed == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as int?,
      quarter: freezed == quarter
          ? _value.quarter
          : quarter // ignore: cast_nullable_to_non_nullable
              as int?,
      plannedAmount: null == plannedAmount
          ? _value.plannedAmount
          : plannedAmount // ignore: cast_nullable_to_non_nullable
              as double,
      actualAmount: null == actualAmount
          ? _value.actualAmount
          : actualAmount // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      isApproved: null == isApproved
          ? _value.isApproved
          : isApproved // ignore: cast_nullable_to_non_nullable
              as bool,
      approvedBy: freezed == approvedBy
          ? _value.approvedBy
          : approvedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      approvedAt: freezed == approvedAt
          ? _value.approvedAt
          : approvedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
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
class _$BudgetImpl extends _Budget {
  const _$BudgetImpl(
      {required this.id,
      required this.churchId,
      required this.categoryId,
      required this.period,
      required this.year,
      this.fiscalYear,
      this.month,
      this.quarter,
      required this.plannedAmount,
      this.actualAmount = 0.0,
      this.status = 'active',
      this.isApproved = false,
      this.approvedBy,
      this.approvedAt,
      this.startDate,
      this.endDate,
      this.notes,
      this.createdAt,
      this.updatedAt})
      : super._();

  factory _$BudgetImpl.fromJson(Map<String, dynamic> json) =>
      _$$BudgetImplFromJson(json);

  @override
  final String id;
  @override
  final String churchId;
  @override
  final String categoryId;
// Lié aux Rubriques
  @override
  final BudgetPeriod period;
  @override
  final int year;
  @override
  final int? fiscalYear;
  @override
  final int? month;
// 1-12 pour monthly
  @override
  final int? quarter;
// 1-4 pour quarterly
  @override
  final double plannedAmount;
  @override
  @JsonKey()
  final double actualAmount;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey()
  final bool isApproved;
  @override
  final String? approvedBy;
  @override
  final DateTime? approvedAt;
  @override
  final DateTime? startDate;
  @override
  final DateTime? endDate;
  @override
  final String? notes;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Budget(id: $id, churchId: $churchId, categoryId: $categoryId, period: $period, year: $year, fiscalYear: $fiscalYear, month: $month, quarter: $quarter, plannedAmount: $plannedAmount, actualAmount: $actualAmount, status: $status, isApproved: $isApproved, approvedBy: $approvedBy, approvedAt: $approvedAt, startDate: $startDate, endDate: $endDate, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BudgetImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.churchId, churchId) ||
                other.churchId == churchId) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.period, period) || other.period == period) &&
            (identical(other.year, year) || other.year == year) &&
            (identical(other.fiscalYear, fiscalYear) ||
                other.fiscalYear == fiscalYear) &&
            (identical(other.month, month) || other.month == month) &&
            (identical(other.quarter, quarter) || other.quarter == quarter) &&
            (identical(other.plannedAmount, plannedAmount) ||
                other.plannedAmount == plannedAmount) &&
            (identical(other.actualAmount, actualAmount) ||
                other.actualAmount == actualAmount) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.isApproved, isApproved) ||
                other.isApproved == isApproved) &&
            (identical(other.approvedBy, approvedBy) ||
                other.approvedBy == approvedBy) &&
            (identical(other.approvedAt, approvedAt) ||
                other.approvedAt == approvedAt) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        churchId,
        categoryId,
        period,
        year,
        fiscalYear,
        month,
        quarter,
        plannedAmount,
        actualAmount,
        status,
        isApproved,
        approvedBy,
        approvedAt,
        startDate,
        endDate,
        notes,
        createdAt,
        updatedAt
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BudgetImplCopyWith<_$BudgetImpl> get copyWith =>
      __$$BudgetImplCopyWithImpl<_$BudgetImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BudgetImplToJson(
      this,
    );
  }
}

abstract class _Budget extends Budget {
  const factory _Budget(
      {required final String id,
      required final String churchId,
      required final String categoryId,
      required final BudgetPeriod period,
      required final int year,
      final int? fiscalYear,
      final int? month,
      final int? quarter,
      required final double plannedAmount,
      final double actualAmount,
      final String status,
      final bool isApproved,
      final String? approvedBy,
      final DateTime? approvedAt,
      final DateTime? startDate,
      final DateTime? endDate,
      final String? notes,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$BudgetImpl;
  const _Budget._() : super._();

  factory _Budget.fromJson(Map<String, dynamic> json) = _$BudgetImpl.fromJson;

  @override
  String get id;
  @override
  String get churchId;
  @override
  String get categoryId;
  @override // Lié aux Rubriques
  BudgetPeriod get period;
  @override
  int get year;
  @override
  int? get fiscalYear;
  @override
  int? get month;
  @override // 1-12 pour monthly
  int? get quarter;
  @override // 1-4 pour quarterly
  double get plannedAmount;
  @override
  double get actualAmount;
  @override
  String get status;
  @override
  bool get isApproved;
  @override
  String? get approvedBy;
  @override
  DateTime? get approvedAt;
  @override
  DateTime? get startDate;
  @override
  DateTime? get endDate;
  @override
  String? get notes;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$BudgetImplCopyWith<_$BudgetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
