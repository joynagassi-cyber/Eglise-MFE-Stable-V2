// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fund_source.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

FundSource _$FundSourceFromJson(Map<String, dynamic> json) {
  return _FundSource.fromJson(json);
}

/// @nodoc
mixin _$FundSource {
  String get code => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  bool get requiresForeignDeclaration => throw _privateConstructorUsedError;
  bool get requiresNif => throw _privateConstructorUsedError;
  int? get maxAmountCfa => throw _privateConstructorUsedError;
  bool get active => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FundSourceCopyWith<FundSource> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FundSourceCopyWith<$Res> {
  factory $FundSourceCopyWith(
          FundSource value, $Res Function(FundSource) then) =
      _$FundSourceCopyWithImpl<$Res, FundSource>;
  @useResult
  $Res call(
      {String code,
      String label,
      bool requiresForeignDeclaration,
      bool requiresNif,
      int? maxAmountCfa,
      bool active,
      DateTime? createdAt});
}

/// @nodoc
class _$FundSourceCopyWithImpl<$Res, $Val extends FundSource>
    implements $FundSourceCopyWith<$Res> {
  _$FundSourceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? label = null,
    Object? requiresForeignDeclaration = null,
    Object? requiresNif = null,
    Object? maxAmountCfa = freezed,
    Object? active = null,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      requiresForeignDeclaration: null == requiresForeignDeclaration
          ? _value.requiresForeignDeclaration
          : requiresForeignDeclaration // ignore: cast_nullable_to_non_nullable
              as bool,
      requiresNif: null == requiresNif
          ? _value.requiresNif
          : requiresNif // ignore: cast_nullable_to_non_nullable
              as bool,
      maxAmountCfa: freezed == maxAmountCfa
          ? _value.maxAmountCfa
          : maxAmountCfa // ignore: cast_nullable_to_non_nullable
              as int?,
      active: null == active
          ? _value.active
          : active // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FundSourceImplCopyWith<$Res>
    implements $FundSourceCopyWith<$Res> {
  factory _$$FundSourceImplCopyWith(
          _$FundSourceImpl value, $Res Function(_$FundSourceImpl) then) =
      __$$FundSourceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String code,
      String label,
      bool requiresForeignDeclaration,
      bool requiresNif,
      int? maxAmountCfa,
      bool active,
      DateTime? createdAt});
}

/// @nodoc
class __$$FundSourceImplCopyWithImpl<$Res>
    extends _$FundSourceCopyWithImpl<$Res, _$FundSourceImpl>
    implements _$$FundSourceImplCopyWith<$Res> {
  __$$FundSourceImplCopyWithImpl(
      _$FundSourceImpl _value, $Res Function(_$FundSourceImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? label = null,
    Object? requiresForeignDeclaration = null,
    Object? requiresNif = null,
    Object? maxAmountCfa = freezed,
    Object? active = null,
    Object? createdAt = freezed,
  }) {
    return _then(_$FundSourceImpl(
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      requiresForeignDeclaration: null == requiresForeignDeclaration
          ? _value.requiresForeignDeclaration
          : requiresForeignDeclaration // ignore: cast_nullable_to_non_nullable
              as bool,
      requiresNif: null == requiresNif
          ? _value.requiresNif
          : requiresNif // ignore: cast_nullable_to_non_nullable
              as bool,
      maxAmountCfa: freezed == maxAmountCfa
          ? _value.maxAmountCfa
          : maxAmountCfa // ignore: cast_nullable_to_non_nullable
              as int?,
      active: null == active
          ? _value.active
          : active // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FundSourceImpl extends _FundSource {
  const _$FundSourceImpl(
      {required this.code,
      required this.label,
      this.requiresForeignDeclaration = false,
      this.requiresNif = false,
      this.maxAmountCfa,
      this.active = true,
      this.createdAt})
      : super._();

  factory _$FundSourceImpl.fromJson(Map<String, dynamic> json) =>
      _$$FundSourceImplFromJson(json);

  @override
  final String code;
  @override
  final String label;
  @override
  @JsonKey()
  final bool requiresForeignDeclaration;
  @override
  @JsonKey()
  final bool requiresNif;
  @override
  final int? maxAmountCfa;
  @override
  @JsonKey()
  final bool active;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'FundSource(code: $code, label: $label, requiresForeignDeclaration: $requiresForeignDeclaration, requiresNif: $requiresNif, maxAmountCfa: $maxAmountCfa, active: $active, createdAt: $createdAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FundSourceImpl &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.requiresForeignDeclaration,
                    requiresForeignDeclaration) ||
                other.requiresForeignDeclaration ==
                    requiresForeignDeclaration) &&
            (identical(other.requiresNif, requiresNif) ||
                other.requiresNif == requiresNif) &&
            (identical(other.maxAmountCfa, maxAmountCfa) ||
                other.maxAmountCfa == maxAmountCfa) &&
            (identical(other.active, active) || other.active == active) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, code, label,
      requiresForeignDeclaration, requiresNif, maxAmountCfa, active, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FundSourceImplCopyWith<_$FundSourceImpl> get copyWith =>
      __$$FundSourceImplCopyWithImpl<_$FundSourceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FundSourceImplToJson(
      this,
    );
  }
}

abstract class _FundSource extends FundSource {
  const factory _FundSource(
      {required final String code,
      required final String label,
      final bool requiresForeignDeclaration,
      final bool requiresNif,
      final int? maxAmountCfa,
      final bool active,
      final DateTime? createdAt}) = _$FundSourceImpl;
  const _FundSource._() : super._();

  factory _FundSource.fromJson(Map<String, dynamic> json) =
      _$FundSourceImpl.fromJson;

  @override
  String get code;
  @override
  String get label;
  @override
  bool get requiresForeignDeclaration;
  @override
  bool get requiresNif;
  @override
  int? get maxAmountCfa;
  @override
  bool get active;
  @override
  DateTime? get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$FundSourceImplCopyWith<_$FundSourceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
