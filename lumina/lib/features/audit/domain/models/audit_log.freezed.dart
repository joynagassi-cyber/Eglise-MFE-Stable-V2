// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'audit_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

AuditLog _$AuditLogFromJson(Map<String, dynamic> json) {
  return _AuditLog.fromJson(json);
}

/// @nodoc
mixin _$AuditLog {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'entity_type')
  String get entityType => throw _privateConstructorUsedError;
  @JsonKey(name: 'entity_id')
  String get entityId => throw _privateConstructorUsedError;
  AuditAction get action => throw _privateConstructorUsedError;
  @JsonKey(name: 'old_value')
  Map<String, dynamic>? get oldData => throw _privateConstructorUsedError;
  @JsonKey(name: 'new_value')
  Map<String, dynamic>? get newData => throw _privateConstructorUsedError;
  @JsonKey(name: 'actor_id')
  String? get actorId => throw _privateConstructorUsedError;
  @JsonKey(name: 'ip_address')
  String? get ipAddress => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_agent')
  String? get userAgent => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;
  @JsonKey(name: 'occurred_at')
  DateTime get occurredAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AuditLogCopyWith<AuditLog> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuditLogCopyWith<$Res> {
  factory $AuditLogCopyWith(AuditLog value, $Res Function(AuditLog) then) =
      _$AuditLogCopyWithImpl<$Res, AuditLog>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'entity_type') String entityType,
      @JsonKey(name: 'entity_id') String entityId,
      AuditAction action,
      @JsonKey(name: 'old_value') Map<String, dynamic>? oldData,
      @JsonKey(name: 'new_value') Map<String, dynamic>? newData,
      @JsonKey(name: 'actor_id') String? actorId,
      @JsonKey(name: 'ip_address') String? ipAddress,
      @JsonKey(name: 'user_agent') String? userAgent,
      Map<String, dynamic>? metadata,
      @JsonKey(name: 'occurred_at') DateTime occurredAt});
}

/// @nodoc
class _$AuditLogCopyWithImpl<$Res, $Val extends AuditLog>
    implements $AuditLogCopyWith<$Res> {
  _$AuditLogCopyWithImpl(this._value, this._then);

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
    Object? action = null,
    Object? oldData = freezed,
    Object? newData = freezed,
    Object? actorId = freezed,
    Object? ipAddress = freezed,
    Object? userAgent = freezed,
    Object? metadata = freezed,
    Object? occurredAt = null,
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
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as AuditAction,
      oldData: freezed == oldData
          ? _value.oldData
          : oldData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      newData: freezed == newData
          ? _value.newData
          : newData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      actorId: freezed == actorId
          ? _value.actorId
          : actorId // ignore: cast_nullable_to_non_nullable
              as String?,
      ipAddress: freezed == ipAddress
          ? _value.ipAddress
          : ipAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      userAgent: freezed == userAgent
          ? _value.userAgent
          : userAgent // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      occurredAt: null == occurredAt
          ? _value.occurredAt
          : occurredAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AuditLogImplCopyWith<$Res>
    implements $AuditLogCopyWith<$Res> {
  factory _$$AuditLogImplCopyWith(
          _$AuditLogImpl value, $Res Function(_$AuditLogImpl) then) =
      __$$AuditLogImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'entity_type') String entityType,
      @JsonKey(name: 'entity_id') String entityId,
      AuditAction action,
      @JsonKey(name: 'old_value') Map<String, dynamic>? oldData,
      @JsonKey(name: 'new_value') Map<String, dynamic>? newData,
      @JsonKey(name: 'actor_id') String? actorId,
      @JsonKey(name: 'ip_address') String? ipAddress,
      @JsonKey(name: 'user_agent') String? userAgent,
      Map<String, dynamic>? metadata,
      @JsonKey(name: 'occurred_at') DateTime occurredAt});
}

/// @nodoc
class __$$AuditLogImplCopyWithImpl<$Res>
    extends _$AuditLogCopyWithImpl<$Res, _$AuditLogImpl>
    implements _$$AuditLogImplCopyWith<$Res> {
  __$$AuditLogImplCopyWithImpl(
      _$AuditLogImpl _value, $Res Function(_$AuditLogImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? entityType = null,
    Object? entityId = null,
    Object? action = null,
    Object? oldData = freezed,
    Object? newData = freezed,
    Object? actorId = freezed,
    Object? ipAddress = freezed,
    Object? userAgent = freezed,
    Object? metadata = freezed,
    Object? occurredAt = null,
  }) {
    return _then(_$AuditLogImpl(
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
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as AuditAction,
      oldData: freezed == oldData
          ? _value._oldData
          : oldData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      newData: freezed == newData
          ? _value._newData
          : newData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      actorId: freezed == actorId
          ? _value.actorId
          : actorId // ignore: cast_nullable_to_non_nullable
              as String?,
      ipAddress: freezed == ipAddress
          ? _value.ipAddress
          : ipAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      userAgent: freezed == userAgent
          ? _value.userAgent
          : userAgent // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      occurredAt: null == occurredAt
          ? _value.occurredAt
          : occurredAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AuditLogImpl extends _AuditLog {
  const _$AuditLogImpl(
      {required this.id,
      @JsonKey(name: 'entity_type') required this.entityType,
      @JsonKey(name: 'entity_id') required this.entityId,
      required this.action,
      @JsonKey(name: 'old_value') final Map<String, dynamic>? oldData,
      @JsonKey(name: 'new_value') final Map<String, dynamic>? newData,
      @JsonKey(name: 'actor_id') this.actorId,
      @JsonKey(name: 'ip_address') this.ipAddress,
      @JsonKey(name: 'user_agent') this.userAgent,
      final Map<String, dynamic>? metadata,
      @JsonKey(name: 'occurred_at') required this.occurredAt})
      : _oldData = oldData,
        _newData = newData,
        _metadata = metadata,
        super._();

  factory _$AuditLogImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuditLogImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'entity_type')
  final String entityType;
  @override
  @JsonKey(name: 'entity_id')
  final String entityId;
  @override
  final AuditAction action;
  final Map<String, dynamic>? _oldData;
  @override
  @JsonKey(name: 'old_value')
  Map<String, dynamic>? get oldData {
    final value = _oldData;
    if (value == null) return null;
    if (_oldData is EqualUnmodifiableMapView) return _oldData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _newData;
  @override
  @JsonKey(name: 'new_value')
  Map<String, dynamic>? get newData {
    final value = _newData;
    if (value == null) return null;
    if (_newData is EqualUnmodifiableMapView) return _newData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey(name: 'actor_id')
  final String? actorId;
  @override
  @JsonKey(name: 'ip_address')
  final String? ipAddress;
  @override
  @JsonKey(name: 'user_agent')
  final String? userAgent;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey(name: 'occurred_at')
  final DateTime occurredAt;

  @override
  String toString() {
    return 'AuditLog(id: $id, entityType: $entityType, entityId: $entityId, action: $action, oldData: $oldData, newData: $newData, actorId: $actorId, ipAddress: $ipAddress, userAgent: $userAgent, metadata: $metadata, occurredAt: $occurredAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuditLogImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.entityType, entityType) ||
                other.entityType == entityType) &&
            (identical(other.entityId, entityId) ||
                other.entityId == entityId) &&
            (identical(other.action, action) || other.action == action) &&
            const DeepCollectionEquality().equals(other._oldData, _oldData) &&
            const DeepCollectionEquality().equals(other._newData, _newData) &&
            (identical(other.actorId, actorId) || other.actorId == actorId) &&
            (identical(other.ipAddress, ipAddress) ||
                other.ipAddress == ipAddress) &&
            (identical(other.userAgent, userAgent) ||
                other.userAgent == userAgent) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.occurredAt, occurredAt) ||
                other.occurredAt == occurredAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      entityType,
      entityId,
      action,
      const DeepCollectionEquality().hash(_oldData),
      const DeepCollectionEquality().hash(_newData),
      actorId,
      ipAddress,
      userAgent,
      const DeepCollectionEquality().hash(_metadata),
      occurredAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AuditLogImplCopyWith<_$AuditLogImpl> get copyWith =>
      __$$AuditLogImplCopyWithImpl<_$AuditLogImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AuditLogImplToJson(
      this,
    );
  }
}

abstract class _AuditLog extends AuditLog {
  const factory _AuditLog(
          {required final String id,
          @JsonKey(name: 'entity_type') required final String entityType,
          @JsonKey(name: 'entity_id') required final String entityId,
          required final AuditAction action,
          @JsonKey(name: 'old_value') final Map<String, dynamic>? oldData,
          @JsonKey(name: 'new_value') final Map<String, dynamic>? newData,
          @JsonKey(name: 'actor_id') final String? actorId,
          @JsonKey(name: 'ip_address') final String? ipAddress,
          @JsonKey(name: 'user_agent') final String? userAgent,
          final Map<String, dynamic>? metadata,
          @JsonKey(name: 'occurred_at') required final DateTime occurredAt}) =
      _$AuditLogImpl;
  const _AuditLog._() : super._();

  factory _AuditLog.fromJson(Map<String, dynamic> json) =
      _$AuditLogImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'entity_type')
  String get entityType;
  @override
  @JsonKey(name: 'entity_id')
  String get entityId;
  @override
  AuditAction get action;
  @override
  @JsonKey(name: 'old_value')
  Map<String, dynamic>? get oldData;
  @override
  @JsonKey(name: 'new_value')
  Map<String, dynamic>? get newData;
  @override
  @JsonKey(name: 'actor_id')
  String? get actorId;
  @override
  @JsonKey(name: 'ip_address')
  String? get ipAddress;
  @override
  @JsonKey(name: 'user_agent')
  String? get userAgent;
  @override
  Map<String, dynamic>? get metadata;
  @override
  @JsonKey(name: 'occurred_at')
  DateTime get occurredAt;
  @override
  @JsonKey(ignore: true)
  _$$AuditLogImplCopyWith<_$AuditLogImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
