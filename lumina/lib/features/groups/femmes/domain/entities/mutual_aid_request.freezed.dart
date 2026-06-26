// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mutual_aid_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

MutualAidRequest _$MutualAidRequestFromJson(Map<String, dynamic> json) {
  return _MutualAidRequest.fromJson(json);
}

/// @nodoc
mixin _$MutualAidRequest {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'church_id')
  String get churchId => throw _privateConstructorUsedError;
  @JsonKey(name: 'group_id')
  String get groupId => throw _privateConstructorUsedError;
  @JsonKey(name: 'requester_id')
  String get requesterId => throw _privateConstructorUsedError;
  String get type =>
      throw _privateConstructorUsedError; // financial, material, emotional, practical
  String? get description => throw _privateConstructorUsedError;
  String get status =>
      throw _privateConstructorUsedError; // active, fulfilled, closed
  @JsonKey(name: 'responses_count')
  int get responsesCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MutualAidRequestCopyWith<MutualAidRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MutualAidRequestCopyWith<$Res> {
  factory $MutualAidRequestCopyWith(
          MutualAidRequest value, $Res Function(MutualAidRequest) then) =
      _$MutualAidRequestCopyWithImpl<$Res, MutualAidRequest>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'church_id') String churchId,
      @JsonKey(name: 'group_id') String groupId,
      @JsonKey(name: 'requester_id') String requesterId,
      String type,
      String? description,
      String status,
      @JsonKey(name: 'responses_count') int responsesCount,
      @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class _$MutualAidRequestCopyWithImpl<$Res, $Val extends MutualAidRequest>
    implements $MutualAidRequestCopyWith<$Res> {
  _$MutualAidRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? churchId = null,
    Object? groupId = null,
    Object? requesterId = null,
    Object? type = null,
    Object? description = freezed,
    Object? status = null,
    Object? responsesCount = null,
    Object? createdAt = freezed,
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
      groupId: null == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as String,
      requesterId: null == requesterId
          ? _value.requesterId
          : requesterId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      responsesCount: null == responsesCount
          ? _value.responsesCount
          : responsesCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MutualAidRequestImplCopyWith<$Res>
    implements $MutualAidRequestCopyWith<$Res> {
  factory _$$MutualAidRequestImplCopyWith(_$MutualAidRequestImpl value,
          $Res Function(_$MutualAidRequestImpl) then) =
      __$$MutualAidRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'church_id') String churchId,
      @JsonKey(name: 'group_id') String groupId,
      @JsonKey(name: 'requester_id') String requesterId,
      String type,
      String? description,
      String status,
      @JsonKey(name: 'responses_count') int responsesCount,
      @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class __$$MutualAidRequestImplCopyWithImpl<$Res>
    extends _$MutualAidRequestCopyWithImpl<$Res, _$MutualAidRequestImpl>
    implements _$$MutualAidRequestImplCopyWith<$Res> {
  __$$MutualAidRequestImplCopyWithImpl(_$MutualAidRequestImpl _value,
      $Res Function(_$MutualAidRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? churchId = null,
    Object? groupId = null,
    Object? requesterId = null,
    Object? type = null,
    Object? description = freezed,
    Object? status = null,
    Object? responsesCount = null,
    Object? createdAt = freezed,
  }) {
    return _then(_$MutualAidRequestImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      churchId: null == churchId
          ? _value.churchId
          : churchId // ignore: cast_nullable_to_non_nullable
              as String,
      groupId: null == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as String,
      requesterId: null == requesterId
          ? _value.requesterId
          : requesterId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      responsesCount: null == responsesCount
          ? _value.responsesCount
          : responsesCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MutualAidRequestImpl implements _MutualAidRequest {
  const _$MutualAidRequestImpl(
      {required this.id,
      @JsonKey(name: 'church_id') required this.churchId,
      @JsonKey(name: 'group_id') required this.groupId,
      @JsonKey(name: 'requester_id') required this.requesterId,
      required this.type,
      this.description,
      this.status = 'active',
      @JsonKey(name: 'responses_count') this.responsesCount = 0,
      @JsonKey(name: 'created_at') this.createdAt});

  factory _$MutualAidRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$MutualAidRequestImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'church_id')
  final String churchId;
  @override
  @JsonKey(name: 'group_id')
  final String groupId;
  @override
  @JsonKey(name: 'requester_id')
  final String requesterId;
  @override
  final String type;
// financial, material, emotional, practical
  @override
  final String? description;
  @override
  @JsonKey()
  final String status;
// active, fulfilled, closed
  @override
  @JsonKey(name: 'responses_count')
  final int responsesCount;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @override
  String toString() {
    return 'MutualAidRequest(id: $id, churchId: $churchId, groupId: $groupId, requesterId: $requesterId, type: $type, description: $description, status: $status, responsesCount: $responsesCount, createdAt: $createdAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MutualAidRequestImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.churchId, churchId) ||
                other.churchId == churchId) &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.requesterId, requesterId) ||
                other.requesterId == requesterId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.responsesCount, responsesCount) ||
                other.responsesCount == responsesCount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, churchId, groupId,
      requesterId, type, description, status, responsesCount, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MutualAidRequestImplCopyWith<_$MutualAidRequestImpl> get copyWith =>
      __$$MutualAidRequestImplCopyWithImpl<_$MutualAidRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MutualAidRequestImplToJson(
      this,
    );
  }
}

abstract class _MutualAidRequest implements MutualAidRequest {
  const factory _MutualAidRequest(
          {required final String id,
          @JsonKey(name: 'church_id') required final String churchId,
          @JsonKey(name: 'group_id') required final String groupId,
          @JsonKey(name: 'requester_id') required final String requesterId,
          required final String type,
          final String? description,
          final String status,
          @JsonKey(name: 'responses_count') final int responsesCount,
          @JsonKey(name: 'created_at') final DateTime? createdAt}) =
      _$MutualAidRequestImpl;

  factory _MutualAidRequest.fromJson(Map<String, dynamic> json) =
      _$MutualAidRequestImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'church_id')
  String get churchId;
  @override
  @JsonKey(name: 'group_id')
  String get groupId;
  @override
  @JsonKey(name: 'requester_id')
  String get requesterId;
  @override
  String get type;
  @override // financial, material, emotional, practical
  String? get description;
  @override
  String get status;
  @override // active, fulfilled, closed
  @JsonKey(name: 'responses_count')
  int get responsesCount;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$MutualAidRequestImplCopyWith<_$MutualAidRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
