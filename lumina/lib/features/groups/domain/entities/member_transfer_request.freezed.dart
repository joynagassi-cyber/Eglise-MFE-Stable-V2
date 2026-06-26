// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'member_transfer_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

MemberTransferRequest _$MemberTransferRequestFromJson(
    Map<String, dynamic> json) {
  return _MemberTransferRequest.fromJson(json);
}

/// @nodoc
mixin _$MemberTransferRequest {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'church_id')
  String get churchId => throw _privateConstructorUsedError;
  @JsonKey(name: 'member_id')
  String get memberId => throw _privateConstructorUsedError;
  @JsonKey(name: 'from_group_id')
  String get fromGroupId => throw _privateConstructorUsedError;
  @JsonKey(name: 'to_group_id')
  String? get toGroupId => throw _privateConstructorUsedError;
  @JsonKey(name: 'requester_id')
  String get requesterId => throw _privateConstructorUsedError;
  String? get reason => throw _privateConstructorUsedError;
  @JsonKey(unknownEnumValue: TransferStatus.pending)
  TransferStatus get status => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'approved_by')
  String? get approvedBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'approved_at')
  DateTime? get approvedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MemberTransferRequestCopyWith<MemberTransferRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MemberTransferRequestCopyWith<$Res> {
  factory $MemberTransferRequestCopyWith(MemberTransferRequest value,
          $Res Function(MemberTransferRequest) then) =
      _$MemberTransferRequestCopyWithImpl<$Res, MemberTransferRequest>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'church_id') String churchId,
      @JsonKey(name: 'member_id') String memberId,
      @JsonKey(name: 'from_group_id') String fromGroupId,
      @JsonKey(name: 'to_group_id') String? toGroupId,
      @JsonKey(name: 'requester_id') String requesterId,
      String? reason,
      @JsonKey(unknownEnumValue: TransferStatus.pending) TransferStatus status,
      String? notes,
      @JsonKey(name: 'approved_by') String? approvedBy,
      @JsonKey(name: 'approved_at') DateTime? approvedAt,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class _$MemberTransferRequestCopyWithImpl<$Res,
        $Val extends MemberTransferRequest>
    implements $MemberTransferRequestCopyWith<$Res> {
  _$MemberTransferRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? churchId = null,
    Object? memberId = null,
    Object? fromGroupId = null,
    Object? toGroupId = freezed,
    Object? requesterId = null,
    Object? reason = freezed,
    Object? status = null,
    Object? notes = freezed,
    Object? approvedBy = freezed,
    Object? approvedAt = freezed,
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
      memberId: null == memberId
          ? _value.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as String,
      fromGroupId: null == fromGroupId
          ? _value.fromGroupId
          : fromGroupId // ignore: cast_nullable_to_non_nullable
              as String,
      toGroupId: freezed == toGroupId
          ? _value.toGroupId
          : toGroupId // ignore: cast_nullable_to_non_nullable
              as String?,
      requesterId: null == requesterId
          ? _value.requesterId
          : requesterId // ignore: cast_nullable_to_non_nullable
              as String,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TransferStatus,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      approvedBy: freezed == approvedBy
          ? _value.approvedBy
          : approvedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      approvedAt: freezed == approvedAt
          ? _value.approvedAt
          : approvedAt // ignore: cast_nullable_to_non_nullable
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
abstract class _$$MemberTransferRequestImplCopyWith<$Res>
    implements $MemberTransferRequestCopyWith<$Res> {
  factory _$$MemberTransferRequestImplCopyWith(
          _$MemberTransferRequestImpl value,
          $Res Function(_$MemberTransferRequestImpl) then) =
      __$$MemberTransferRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'church_id') String churchId,
      @JsonKey(name: 'member_id') String memberId,
      @JsonKey(name: 'from_group_id') String fromGroupId,
      @JsonKey(name: 'to_group_id') String? toGroupId,
      @JsonKey(name: 'requester_id') String requesterId,
      String? reason,
      @JsonKey(unknownEnumValue: TransferStatus.pending) TransferStatus status,
      String? notes,
      @JsonKey(name: 'approved_by') String? approvedBy,
      @JsonKey(name: 'approved_at') DateTime? approvedAt,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class __$$MemberTransferRequestImplCopyWithImpl<$Res>
    extends _$MemberTransferRequestCopyWithImpl<$Res,
        _$MemberTransferRequestImpl>
    implements _$$MemberTransferRequestImplCopyWith<$Res> {
  __$$MemberTransferRequestImplCopyWithImpl(_$MemberTransferRequestImpl _value,
      $Res Function(_$MemberTransferRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? churchId = null,
    Object? memberId = null,
    Object? fromGroupId = null,
    Object? toGroupId = freezed,
    Object? requesterId = null,
    Object? reason = freezed,
    Object? status = null,
    Object? notes = freezed,
    Object? approvedBy = freezed,
    Object? approvedAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$MemberTransferRequestImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      churchId: null == churchId
          ? _value.churchId
          : churchId // ignore: cast_nullable_to_non_nullable
              as String,
      memberId: null == memberId
          ? _value.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as String,
      fromGroupId: null == fromGroupId
          ? _value.fromGroupId
          : fromGroupId // ignore: cast_nullable_to_non_nullable
              as String,
      toGroupId: freezed == toGroupId
          ? _value.toGroupId
          : toGroupId // ignore: cast_nullable_to_non_nullable
              as String?,
      requesterId: null == requesterId
          ? _value.requesterId
          : requesterId // ignore: cast_nullable_to_non_nullable
              as String,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TransferStatus,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      approvedBy: freezed == approvedBy
          ? _value.approvedBy
          : approvedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      approvedAt: freezed == approvedAt
          ? _value.approvedAt
          : approvedAt // ignore: cast_nullable_to_non_nullable
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
class _$MemberTransferRequestImpl implements _MemberTransferRequest {
  const _$MemberTransferRequestImpl(
      {required this.id,
      @JsonKey(name: 'church_id') required this.churchId,
      @JsonKey(name: 'member_id') required this.memberId,
      @JsonKey(name: 'from_group_id') required this.fromGroupId,
      @JsonKey(name: 'to_group_id') this.toGroupId,
      @JsonKey(name: 'requester_id') required this.requesterId,
      this.reason,
      @JsonKey(unknownEnumValue: TransferStatus.pending)
      this.status = TransferStatus.pending,
      this.notes,
      @JsonKey(name: 'approved_by') this.approvedBy,
      @JsonKey(name: 'approved_at') this.approvedAt,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt});

  factory _$MemberTransferRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$MemberTransferRequestImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'church_id')
  final String churchId;
  @override
  @JsonKey(name: 'member_id')
  final String memberId;
  @override
  @JsonKey(name: 'from_group_id')
  final String fromGroupId;
  @override
  @JsonKey(name: 'to_group_id')
  final String? toGroupId;
  @override
  @JsonKey(name: 'requester_id')
  final String requesterId;
  @override
  final String? reason;
  @override
  @JsonKey(unknownEnumValue: TransferStatus.pending)
  final TransferStatus status;
  @override
  final String? notes;
  @override
  @JsonKey(name: 'approved_by')
  final String? approvedBy;
  @override
  @JsonKey(name: 'approved_at')
  final DateTime? approvedAt;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'MemberTransferRequest(id: $id, churchId: $churchId, memberId: $memberId, fromGroupId: $fromGroupId, toGroupId: $toGroupId, requesterId: $requesterId, reason: $reason, status: $status, notes: $notes, approvedBy: $approvedBy, approvedAt: $approvedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MemberTransferRequestImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.churchId, churchId) ||
                other.churchId == churchId) &&
            (identical(other.memberId, memberId) ||
                other.memberId == memberId) &&
            (identical(other.fromGroupId, fromGroupId) ||
                other.fromGroupId == fromGroupId) &&
            (identical(other.toGroupId, toGroupId) ||
                other.toGroupId == toGroupId) &&
            (identical(other.requesterId, requesterId) ||
                other.requesterId == requesterId) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.approvedBy, approvedBy) ||
                other.approvedBy == approvedBy) &&
            (identical(other.approvedAt, approvedAt) ||
                other.approvedAt == approvedAt) &&
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
      churchId,
      memberId,
      fromGroupId,
      toGroupId,
      requesterId,
      reason,
      status,
      notes,
      approvedBy,
      approvedAt,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MemberTransferRequestImplCopyWith<_$MemberTransferRequestImpl>
      get copyWith => __$$MemberTransferRequestImplCopyWithImpl<
          _$MemberTransferRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MemberTransferRequestImplToJson(
      this,
    );
  }
}

abstract class _MemberTransferRequest implements MemberTransferRequest {
  const factory _MemberTransferRequest(
          {required final String id,
          @JsonKey(name: 'church_id') required final String churchId,
          @JsonKey(name: 'member_id') required final String memberId,
          @JsonKey(name: 'from_group_id') required final String fromGroupId,
          @JsonKey(name: 'to_group_id') final String? toGroupId,
          @JsonKey(name: 'requester_id') required final String requesterId,
          final String? reason,
          @JsonKey(unknownEnumValue: TransferStatus.pending)
          final TransferStatus status,
          final String? notes,
          @JsonKey(name: 'approved_by') final String? approvedBy,
          @JsonKey(name: 'approved_at') final DateTime? approvedAt,
          @JsonKey(name: 'created_at') final DateTime? createdAt,
          @JsonKey(name: 'updated_at') final DateTime? updatedAt}) =
      _$MemberTransferRequestImpl;

  factory _MemberTransferRequest.fromJson(Map<String, dynamic> json) =
      _$MemberTransferRequestImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'church_id')
  String get churchId;
  @override
  @JsonKey(name: 'member_id')
  String get memberId;
  @override
  @JsonKey(name: 'from_group_id')
  String get fromGroupId;
  @override
  @JsonKey(name: 'to_group_id')
  String? get toGroupId;
  @override
  @JsonKey(name: 'requester_id')
  String get requesterId;
  @override
  String? get reason;
  @override
  @JsonKey(unknownEnumValue: TransferStatus.pending)
  TransferStatus get status;
  @override
  String? get notes;
  @override
  @JsonKey(name: 'approved_by')
  String? get approvedBy;
  @override
  @JsonKey(name: 'approved_at')
  DateTime? get approvedAt;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$MemberTransferRequestImplCopyWith<_$MemberTransferRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}
