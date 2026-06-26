// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'financial_account.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

FinancialAccount _$FinancialAccountFromJson(Map<String, dynamic> json) {
  return _FinancialAccount.fromJson(json);
}

/// @nodoc
mixin _$FinancialAccount {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  FinancialAccountType get type => throw _privateConstructorUsedError;
  double get balance => throw _privateConstructorUsedError;
  String? get currency =>
      throw _privateConstructorUsedError; // 'XOF', 'EUR', 'USD' (Default XOF)
  String? get bankName => throw _privateConstructorUsedError;
  String? get accountNumber => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  bool get isManual => throw _privateConstructorUsedError;
  bool get isLocked => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get groupId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FinancialAccountCopyWith<FinancialAccount> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FinancialAccountCopyWith<$Res> {
  factory $FinancialAccountCopyWith(
          FinancialAccount value, $Res Function(FinancialAccount) then) =
      _$FinancialAccountCopyWithImpl<$Res, FinancialAccount>;
  @useResult
  $Res call(
      {String id,
      String name,
      FinancialAccountType type,
      double balance,
      String? currency,
      String? bankName,
      String? accountNumber,
      bool isActive,
      bool isManual,
      bool isLocked,
      String? description,
      String? groupId});
}

/// @nodoc
class _$FinancialAccountCopyWithImpl<$Res, $Val extends FinancialAccount>
    implements $FinancialAccountCopyWith<$Res> {
  _$FinancialAccountCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? balance = null,
    Object? currency = freezed,
    Object? bankName = freezed,
    Object? accountNumber = freezed,
    Object? isActive = null,
    Object? isManual = null,
    Object? isLocked = null,
    Object? description = freezed,
    Object? groupId = freezed,
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
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as FinancialAccountType,
      balance: null == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as double,
      currency: freezed == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
      bankName: freezed == bankName
          ? _value.bankName
          : bankName // ignore: cast_nullable_to_non_nullable
              as String?,
      accountNumber: freezed == accountNumber
          ? _value.accountNumber
          : accountNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isManual: null == isManual
          ? _value.isManual
          : isManual // ignore: cast_nullable_to_non_nullable
              as bool,
      isLocked: null == isLocked
          ? _value.isLocked
          : isLocked // ignore: cast_nullable_to_non_nullable
              as bool,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      groupId: freezed == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FinancialAccountImplCopyWith<$Res>
    implements $FinancialAccountCopyWith<$Res> {
  factory _$$FinancialAccountImplCopyWith(_$FinancialAccountImpl value,
          $Res Function(_$FinancialAccountImpl) then) =
      __$$FinancialAccountImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      FinancialAccountType type,
      double balance,
      String? currency,
      String? bankName,
      String? accountNumber,
      bool isActive,
      bool isManual,
      bool isLocked,
      String? description,
      String? groupId});
}

/// @nodoc
class __$$FinancialAccountImplCopyWithImpl<$Res>
    extends _$FinancialAccountCopyWithImpl<$Res, _$FinancialAccountImpl>
    implements _$$FinancialAccountImplCopyWith<$Res> {
  __$$FinancialAccountImplCopyWithImpl(_$FinancialAccountImpl _value,
      $Res Function(_$FinancialAccountImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? balance = null,
    Object? currency = freezed,
    Object? bankName = freezed,
    Object? accountNumber = freezed,
    Object? isActive = null,
    Object? isManual = null,
    Object? isLocked = null,
    Object? description = freezed,
    Object? groupId = freezed,
  }) {
    return _then(_$FinancialAccountImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as FinancialAccountType,
      balance: null == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as double,
      currency: freezed == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
      bankName: freezed == bankName
          ? _value.bankName
          : bankName // ignore: cast_nullable_to_non_nullable
              as String?,
      accountNumber: freezed == accountNumber
          ? _value.accountNumber
          : accountNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isManual: null == isManual
          ? _value.isManual
          : isManual // ignore: cast_nullable_to_non_nullable
              as bool,
      isLocked: null == isLocked
          ? _value.isLocked
          : isLocked // ignore: cast_nullable_to_non_nullable
              as bool,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      groupId: freezed == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FinancialAccountImpl implements _FinancialAccount {
  const _$FinancialAccountImpl(
      {required this.id,
      required this.name,
      required this.type,
      this.balance = 0.0,
      this.currency,
      this.bankName,
      this.accountNumber,
      this.isActive = true,
      this.isManual = false,
      this.isLocked = false,
      this.description,
      this.groupId});

  factory _$FinancialAccountImpl.fromJson(Map<String, dynamic> json) =>
      _$$FinancialAccountImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final FinancialAccountType type;
  @override
  @JsonKey()
  final double balance;
  @override
  final String? currency;
// 'XOF', 'EUR', 'USD' (Default XOF)
  @override
  final String? bankName;
  @override
  final String? accountNumber;
  @override
  @JsonKey()
  final bool isActive;
  @override
  @JsonKey()
  final bool isManual;
  @override
  @JsonKey()
  final bool isLocked;
  @override
  final String? description;
  @override
  final String? groupId;

  @override
  String toString() {
    return 'FinancialAccount(id: $id, name: $name, type: $type, balance: $balance, currency: $currency, bankName: $bankName, accountNumber: $accountNumber, isActive: $isActive, isManual: $isManual, isLocked: $isLocked, description: $description, groupId: $groupId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FinancialAccountImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.balance, balance) || other.balance == balance) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.bankName, bankName) ||
                other.bankName == bankName) &&
            (identical(other.accountNumber, accountNumber) ||
                other.accountNumber == accountNumber) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isManual, isManual) ||
                other.isManual == isManual) &&
            (identical(other.isLocked, isLocked) ||
                other.isLocked == isLocked) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.groupId, groupId) || other.groupId == groupId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      type,
      balance,
      currency,
      bankName,
      accountNumber,
      isActive,
      isManual,
      isLocked,
      description,
      groupId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FinancialAccountImplCopyWith<_$FinancialAccountImpl> get copyWith =>
      __$$FinancialAccountImplCopyWithImpl<_$FinancialAccountImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FinancialAccountImplToJson(
      this,
    );
  }
}

abstract class _FinancialAccount implements FinancialAccount {
  const factory _FinancialAccount(
      {required final String id,
      required final String name,
      required final FinancialAccountType type,
      final double balance,
      final String? currency,
      final String? bankName,
      final String? accountNumber,
      final bool isActive,
      final bool isManual,
      final bool isLocked,
      final String? description,
      final String? groupId}) = _$FinancialAccountImpl;

  factory _FinancialAccount.fromJson(Map<String, dynamic> json) =
      _$FinancialAccountImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  FinancialAccountType get type;
  @override
  double get balance;
  @override
  String? get currency;
  @override // 'XOF', 'EUR', 'USD' (Default XOF)
  String? get bankName;
  @override
  String? get accountNumber;
  @override
  bool get isActive;
  @override
  bool get isManual;
  @override
  bool get isLocked;
  @override
  String? get description;
  @override
  String? get groupId;
  @override
  @JsonKey(ignore: true)
  _$$FinancialAccountImplCopyWith<_$FinancialAccountImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
