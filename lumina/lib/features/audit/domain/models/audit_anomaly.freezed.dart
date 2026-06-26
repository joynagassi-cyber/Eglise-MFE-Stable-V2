// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'audit_anomaly.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

AuditAnomaly _$AuditAnomalyFromJson(Map<String, dynamic> json) {
  return _AuditAnomaly.fromJson(json);
}

/// @nodoc
mixin _$AuditAnomaly {
  String get logId => throw _privateConstructorUsedError;
  AnomalySeverity get severity => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  DateTime get detectedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AuditAnomalyCopyWith<AuditAnomaly> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuditAnomalyCopyWith<$Res> {
  factory $AuditAnomalyCopyWith(
          AuditAnomaly value, $Res Function(AuditAnomaly) then) =
      _$AuditAnomalyCopyWithImpl<$Res, AuditAnomaly>;
  @useResult
  $Res call(
      {String logId,
      AnomalySeverity severity,
      String description,
      DateTime detectedAt});
}

/// @nodoc
class _$AuditAnomalyCopyWithImpl<$Res, $Val extends AuditAnomaly>
    implements $AuditAnomalyCopyWith<$Res> {
  _$AuditAnomalyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? logId = null,
    Object? severity = null,
    Object? description = null,
    Object? detectedAt = null,
  }) {
    return _then(_value.copyWith(
      logId: null == logId
          ? _value.logId
          : logId // ignore: cast_nullable_to_non_nullable
              as String,
      severity: null == severity
          ? _value.severity
          : severity // ignore: cast_nullable_to_non_nullable
              as AnomalySeverity,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      detectedAt: null == detectedAt
          ? _value.detectedAt
          : detectedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AuditAnomalyImplCopyWith<$Res>
    implements $AuditAnomalyCopyWith<$Res> {
  factory _$$AuditAnomalyImplCopyWith(
          _$AuditAnomalyImpl value, $Res Function(_$AuditAnomalyImpl) then) =
      __$$AuditAnomalyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String logId,
      AnomalySeverity severity,
      String description,
      DateTime detectedAt});
}

/// @nodoc
class __$$AuditAnomalyImplCopyWithImpl<$Res>
    extends _$AuditAnomalyCopyWithImpl<$Res, _$AuditAnomalyImpl>
    implements _$$AuditAnomalyImplCopyWith<$Res> {
  __$$AuditAnomalyImplCopyWithImpl(
      _$AuditAnomalyImpl _value, $Res Function(_$AuditAnomalyImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? logId = null,
    Object? severity = null,
    Object? description = null,
    Object? detectedAt = null,
  }) {
    return _then(_$AuditAnomalyImpl(
      logId: null == logId
          ? _value.logId
          : logId // ignore: cast_nullable_to_non_nullable
              as String,
      severity: null == severity
          ? _value.severity
          : severity // ignore: cast_nullable_to_non_nullable
              as AnomalySeverity,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      detectedAt: null == detectedAt
          ? _value.detectedAt
          : detectedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AuditAnomalyImpl implements _AuditAnomaly {
  const _$AuditAnomalyImpl(
      {required this.logId,
      required this.severity,
      required this.description,
      required this.detectedAt});

  factory _$AuditAnomalyImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuditAnomalyImplFromJson(json);

  @override
  final String logId;
  @override
  final AnomalySeverity severity;
  @override
  final String description;
  @override
  final DateTime detectedAt;

  @override
  String toString() {
    return 'AuditAnomaly(logId: $logId, severity: $severity, description: $description, detectedAt: $detectedAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuditAnomalyImpl &&
            (identical(other.logId, logId) || other.logId == logId) &&
            (identical(other.severity, severity) ||
                other.severity == severity) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.detectedAt, detectedAt) ||
                other.detectedAt == detectedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, logId, severity, description, detectedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AuditAnomalyImplCopyWith<_$AuditAnomalyImpl> get copyWith =>
      __$$AuditAnomalyImplCopyWithImpl<_$AuditAnomalyImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AuditAnomalyImplToJson(
      this,
    );
  }
}

abstract class _AuditAnomaly implements AuditAnomaly {
  const factory _AuditAnomaly(
      {required final String logId,
      required final AnomalySeverity severity,
      required final String description,
      required final DateTime detectedAt}) = _$AuditAnomalyImpl;

  factory _AuditAnomaly.fromJson(Map<String, dynamic> json) =
      _$AuditAnomalyImpl.fromJson;

  @override
  String get logId;
  @override
  AnomalySeverity get severity;
  @override
  String get description;
  @override
  DateTime get detectedAt;
  @override
  @JsonKey(ignore: true)
  _$$AuditAnomalyImplCopyWith<_$AuditAnomalyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
