// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'approval.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Approval _$ApprovalFromJson(Map<String, dynamic> json) {
  return _Approval.fromJson(json);
}

/// @nodoc
mixin _$Approval {
  String get id => throw _privateConstructorUsedError;
  String get transactionId => throw _privateConstructorUsedError;
  String get approverId => throw _privateConstructorUsedError;
  String get roleUsed => throw _privateConstructorUsedError;
  ApprovalDecision get decision => throw _privateConstructorUsedError;
  String? get approverName => throw _privateConstructorUsedError;
  String? get comment => throw _privateConstructorUsedError;
  DateTime get decidedAt => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ApprovalCopyWith<Approval> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApprovalCopyWith<$Res> {
  factory $ApprovalCopyWith(Approval value, $Res Function(Approval) then) =
      _$ApprovalCopyWithImpl<$Res, Approval>;
  @useResult
  $Res call(
      {String id,
      String transactionId,
      String approverId,
      String roleUsed,
      ApprovalDecision decision,
      String? approverName,
      String? comment,
      DateTime decidedAt,
      DateTime createdAt});
}

/// @nodoc
class _$ApprovalCopyWithImpl<$Res, $Val extends Approval>
    implements $ApprovalCopyWith<$Res> {
  _$ApprovalCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? transactionId = null,
    Object? approverId = null,
    Object? roleUsed = null,
    Object? decision = null,
    Object? approverName = freezed,
    Object? comment = freezed,
    Object? decidedAt = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      transactionId: null == transactionId
          ? _value.transactionId
          : transactionId // ignore: cast_nullable_to_non_nullable
              as String,
      approverId: null == approverId
          ? _value.approverId
          : approverId // ignore: cast_nullable_to_non_nullable
              as String,
      roleUsed: null == roleUsed
          ? _value.roleUsed
          : roleUsed // ignore: cast_nullable_to_non_nullable
              as String,
      decision: null == decision
          ? _value.decision
          : decision // ignore: cast_nullable_to_non_nullable
              as ApprovalDecision,
      approverName: freezed == approverName
          ? _value.approverName
          : approverName // ignore: cast_nullable_to_non_nullable
              as String?,
      comment: freezed == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
      decidedAt: null == decidedAt
          ? _value.decidedAt
          : decidedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ApprovalImplCopyWith<$Res>
    implements $ApprovalCopyWith<$Res> {
  factory _$$ApprovalImplCopyWith(
          _$ApprovalImpl value, $Res Function(_$ApprovalImpl) then) =
      __$$ApprovalImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String transactionId,
      String approverId,
      String roleUsed,
      ApprovalDecision decision,
      String? approverName,
      String? comment,
      DateTime decidedAt,
      DateTime createdAt});
}

/// @nodoc
class __$$ApprovalImplCopyWithImpl<$Res>
    extends _$ApprovalCopyWithImpl<$Res, _$ApprovalImpl>
    implements _$$ApprovalImplCopyWith<$Res> {
  __$$ApprovalImplCopyWithImpl(
      _$ApprovalImpl _value, $Res Function(_$ApprovalImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? transactionId = null,
    Object? approverId = null,
    Object? roleUsed = null,
    Object? decision = null,
    Object? approverName = freezed,
    Object? comment = freezed,
    Object? decidedAt = null,
    Object? createdAt = null,
  }) {
    return _then(_$ApprovalImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      transactionId: null == transactionId
          ? _value.transactionId
          : transactionId // ignore: cast_nullable_to_non_nullable
              as String,
      approverId: null == approverId
          ? _value.approverId
          : approverId // ignore: cast_nullable_to_non_nullable
              as String,
      roleUsed: null == roleUsed
          ? _value.roleUsed
          : roleUsed // ignore: cast_nullable_to_non_nullable
              as String,
      decision: null == decision
          ? _value.decision
          : decision // ignore: cast_nullable_to_non_nullable
              as ApprovalDecision,
      approverName: freezed == approverName
          ? _value.approverName
          : approverName // ignore: cast_nullable_to_non_nullable
              as String?,
      comment: freezed == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
      decidedAt: null == decidedAt
          ? _value.decidedAt
          : decidedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ApprovalImpl implements _Approval {
  const _$ApprovalImpl(
      {required this.id,
      required this.transactionId,
      required this.approverId,
      required this.roleUsed,
      required this.decision,
      this.approverName,
      this.comment,
      required this.decidedAt,
      required this.createdAt});

  factory _$ApprovalImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApprovalImplFromJson(json);

  @override
  final String id;
  @override
  final String transactionId;
  @override
  final String approverId;
  @override
  final String roleUsed;
  @override
  final ApprovalDecision decision;
  @override
  final String? approverName;
  @override
  final String? comment;
  @override
  final DateTime decidedAt;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'Approval(id: $id, transactionId: $transactionId, approverId: $approverId, roleUsed: $roleUsed, decision: $decision, approverName: $approverName, comment: $comment, decidedAt: $decidedAt, createdAt: $createdAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApprovalImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.transactionId, transactionId) ||
                other.transactionId == transactionId) &&
            (identical(other.approverId, approverId) ||
                other.approverId == approverId) &&
            (identical(other.roleUsed, roleUsed) ||
                other.roleUsed == roleUsed) &&
            (identical(other.decision, decision) ||
                other.decision == decision) &&
            (identical(other.approverName, approverName) ||
                other.approverName == approverName) &&
            (identical(other.comment, comment) || other.comment == comment) &&
            (identical(other.decidedAt, decidedAt) ||
                other.decidedAt == decidedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, transactionId, approverId,
      roleUsed, decision, approverName, comment, decidedAt, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ApprovalImplCopyWith<_$ApprovalImpl> get copyWith =>
      __$$ApprovalImplCopyWithImpl<_$ApprovalImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ApprovalImplToJson(
      this,
    );
  }
}

abstract class _Approval implements Approval {
  const factory _Approval(
      {required final String id,
      required final String transactionId,
      required final String approverId,
      required final String roleUsed,
      required final ApprovalDecision decision,
      final String? approverName,
      final String? comment,
      required final DateTime decidedAt,
      required final DateTime createdAt}) = _$ApprovalImpl;

  factory _Approval.fromJson(Map<String, dynamic> json) =
      _$ApprovalImpl.fromJson;

  @override
  String get id;
  @override
  String get transactionId;
  @override
  String get approverId;
  @override
  String get roleUsed;
  @override
  ApprovalDecision get decision;
  @override
  String? get approverName;
  @override
  String? get comment;
  @override
  DateTime get decidedAt;
  @override
  DateTime get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$ApprovalImplCopyWith<_$ApprovalImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
