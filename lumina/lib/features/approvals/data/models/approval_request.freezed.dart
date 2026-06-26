// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'approval_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ApprovalRequest _$ApprovalRequestFromJson(Map<String, dynamic> json) {
  return _ApprovalRequest.fromJson(json);
}

/// @nodoc
mixin _$ApprovalRequest {
  String get id => throw _privateConstructorUsedError;
  String get entityType => throw _privateConstructorUsedError;
  String get entityId => throw _privateConstructorUsedError;
  String? get entityLabel => throw _privateConstructorUsedError;
  double? get entityAmount => throw _privateConstructorUsedError;
  String get status =>
      throw _privateConstructorUsedError; // pending, approved, etc.
  int get currentStepOrder => throw _privateConstructorUsedError;
  int get totalSteps => throw _privateConstructorUsedError;
  DateTime get requestedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ApprovalRequestCopyWith<ApprovalRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApprovalRequestCopyWith<$Res> {
  factory $ApprovalRequestCopyWith(
          ApprovalRequest value, $Res Function(ApprovalRequest) then) =
      _$ApprovalRequestCopyWithImpl<$Res, ApprovalRequest>;
  @useResult
  $Res call(
      {String id,
      String entityType,
      String entityId,
      String? entityLabel,
      double? entityAmount,
      String status,
      int currentStepOrder,
      int totalSteps,
      DateTime requestedAt});
}

/// @nodoc
class _$ApprovalRequestCopyWithImpl<$Res, $Val extends ApprovalRequest>
    implements $ApprovalRequestCopyWith<$Res> {
  _$ApprovalRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? entityType = null,
    Object? entityId = null,
    Object? entityLabel = freezed,
    Object? entityAmount = freezed,
    Object? status = null,
    Object? currentStepOrder = null,
    Object? totalSteps = null,
    Object? requestedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      entityType: null == entityType
          ? _value.entityType
          : entityType // ignore: cast_nullable_to_non_nullable
              as String,
      entityId: null == entityId
          ? _value.entityId
          : entityId // ignore: cast_nullable_to_non_nullable
              as String,
      entityLabel: freezed == entityLabel
          ? _value.entityLabel
          : entityLabel // ignore: cast_nullable_to_non_nullable
              as String?,
      entityAmount: freezed == entityAmount
          ? _value.entityAmount
          : entityAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      currentStepOrder: null == currentStepOrder
          ? _value.currentStepOrder
          : currentStepOrder // ignore: cast_nullable_to_non_nullable
              as int,
      totalSteps: null == totalSteps
          ? _value.totalSteps
          : totalSteps // ignore: cast_nullable_to_non_nullable
              as int,
      requestedAt: null == requestedAt
          ? _value.requestedAt
          : requestedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ApprovalRequestImplCopyWith<$Res>
    implements $ApprovalRequestCopyWith<$Res> {
  factory _$$ApprovalRequestImplCopyWith(_$ApprovalRequestImpl value,
          $Res Function(_$ApprovalRequestImpl) then) =
      __$$ApprovalRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String entityType,
      String entityId,
      String? entityLabel,
      double? entityAmount,
      String status,
      int currentStepOrder,
      int totalSteps,
      DateTime requestedAt});
}

/// @nodoc
class __$$ApprovalRequestImplCopyWithImpl<$Res>
    extends _$ApprovalRequestCopyWithImpl<$Res, _$ApprovalRequestImpl>
    implements _$$ApprovalRequestImplCopyWith<$Res> {
  __$$ApprovalRequestImplCopyWithImpl(
      _$ApprovalRequestImpl _value, $Res Function(_$ApprovalRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? entityType = null,
    Object? entityId = null,
    Object? entityLabel = freezed,
    Object? entityAmount = freezed,
    Object? status = null,
    Object? currentStepOrder = null,
    Object? totalSteps = null,
    Object? requestedAt = null,
  }) {
    return _then(_$ApprovalRequestImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      entityType: null == entityType
          ? _value.entityType
          : entityType // ignore: cast_nullable_to_non_nullable
              as String,
      entityId: null == entityId
          ? _value.entityId
          : entityId // ignore: cast_nullable_to_non_nullable
              as String,
      entityLabel: freezed == entityLabel
          ? _value.entityLabel
          : entityLabel // ignore: cast_nullable_to_non_nullable
              as String?,
      entityAmount: freezed == entityAmount
          ? _value.entityAmount
          : entityAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      currentStepOrder: null == currentStepOrder
          ? _value.currentStepOrder
          : currentStepOrder // ignore: cast_nullable_to_non_nullable
              as int,
      totalSteps: null == totalSteps
          ? _value.totalSteps
          : totalSteps // ignore: cast_nullable_to_non_nullable
              as int,
      requestedAt: null == requestedAt
          ? _value.requestedAt
          : requestedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ApprovalRequestImpl implements _ApprovalRequest {
  const _$ApprovalRequestImpl(
      {required this.id,
      required this.entityType,
      required this.entityId,
      this.entityLabel,
      this.entityAmount,
      required this.status,
      required this.currentStepOrder,
      required this.totalSteps,
      required this.requestedAt});

  factory _$ApprovalRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApprovalRequestImplFromJson(json);

  @override
  final String id;
  @override
  final String entityType;
  @override
  final String entityId;
  @override
  final String? entityLabel;
  @override
  final double? entityAmount;
  @override
  final String status;
// pending, approved, etc.
  @override
  final int currentStepOrder;
  @override
  final int totalSteps;
  @override
  final DateTime requestedAt;

  @override
  String toString() {
    return 'ApprovalRequest(id: $id, entityType: $entityType, entityId: $entityId, entityLabel: $entityLabel, entityAmount: $entityAmount, status: $status, currentStepOrder: $currentStepOrder, totalSteps: $totalSteps, requestedAt: $requestedAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApprovalRequestImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.entityType, entityType) ||
                other.entityType == entityType) &&
            (identical(other.entityId, entityId) ||
                other.entityId == entityId) &&
            (identical(other.entityLabel, entityLabel) ||
                other.entityLabel == entityLabel) &&
            (identical(other.entityAmount, entityAmount) ||
                other.entityAmount == entityAmount) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.currentStepOrder, currentStepOrder) ||
                other.currentStepOrder == currentStepOrder) &&
            (identical(other.totalSteps, totalSteps) ||
                other.totalSteps == totalSteps) &&
            (identical(other.requestedAt, requestedAt) ||
                other.requestedAt == requestedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      entityType,
      entityId,
      entityLabel,
      entityAmount,
      status,
      currentStepOrder,
      totalSteps,
      requestedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ApprovalRequestImplCopyWith<_$ApprovalRequestImpl> get copyWith =>
      __$$ApprovalRequestImplCopyWithImpl<_$ApprovalRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ApprovalRequestImplToJson(
      this,
    );
  }
}

abstract class _ApprovalRequest implements ApprovalRequest {
  const factory _ApprovalRequest(
      {required final String id,
      required final String entityType,
      required final String entityId,
      final String? entityLabel,
      final double? entityAmount,
      required final String status,
      required final int currentStepOrder,
      required final int totalSteps,
      required final DateTime requestedAt}) = _$ApprovalRequestImpl;

  factory _ApprovalRequest.fromJson(Map<String, dynamic> json) =
      _$ApprovalRequestImpl.fromJson;

  @override
  String get id;
  @override
  String get entityType;
  @override
  String get entityId;
  @override
  String? get entityLabel;
  @override
  double? get entityAmount;
  @override
  String get status;
  @override // pending, approved, etc.
  int get currentStepOrder;
  @override
  int get totalSteps;
  @override
  DateTime get requestedAt;
  @override
  @JsonKey(ignore: true)
  _$$ApprovalRequestImplCopyWith<_$ApprovalRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
