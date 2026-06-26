// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sacrament.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Sacrament _$SacramentFromJson(Map<String, dynamic> json) {
  return _Sacrament.fromJson(json);
}

/// @nodoc
mixin _$Sacrament {
  String get id => throw _privateConstructorUsedError;
  String get churchId => throw _privateConstructorUsedError;
  @SacramentTypeConverter()
  SacramentType get type => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  String? get memberFirstName => throw _privateConstructorUsedError;
  String? get memberLastName => throw _privateConstructorUsedError;
  String get memberId => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  String? get celebrant => throw _privateConstructorUsedError;
  String? get godfather => throw _privateConstructorUsedError;
  String? get godmother => throw _privateConstructorUsedError;
  String? get spouseName => throw _privateConstructorUsedError;
  DateTime? get spouseBirthDate => throw _privateConstructorUsedError;
  String? get witnesses => throw _privateConstructorUsedError;
  String? get certificateNumber => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  String? get attachmentUrl => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  String? get createdBy => throw _privateConstructorUsedError;
  String? get updatedBy => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SacramentCopyWith<Sacrament> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SacramentCopyWith<$Res> {
  factory $SacramentCopyWith(Sacrament value, $Res Function(Sacrament) then) =
      _$SacramentCopyWithImpl<$Res, Sacrament>;
  @useResult
  $Res call(
      {String id,
      String churchId,
      @SacramentTypeConverter() SacramentType type,
      DateTime date,
      String? memberFirstName,
      String? memberLastName,
      String memberId,
      String? location,
      String? celebrant,
      String? godfather,
      String? godmother,
      String? spouseName,
      DateTime? spouseBirthDate,
      String? witnesses,
      String? certificateNumber,
      String? notes,
      String? attachmentUrl,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? createdBy,
      String? updatedBy});

  $SacramentTypeCopyWith<$Res> get type;
}

/// @nodoc
class _$SacramentCopyWithImpl<$Res, $Val extends Sacrament>
    implements $SacramentCopyWith<$Res> {
  _$SacramentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? churchId = null,
    Object? type = null,
    Object? date = null,
    Object? memberFirstName = freezed,
    Object? memberLastName = freezed,
    Object? memberId = null,
    Object? location = freezed,
    Object? celebrant = freezed,
    Object? godfather = freezed,
    Object? godmother = freezed,
    Object? spouseName = freezed,
    Object? spouseBirthDate = freezed,
    Object? witnesses = freezed,
    Object? certificateNumber = freezed,
    Object? notes = freezed,
    Object? attachmentUrl = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? createdBy = freezed,
    Object? updatedBy = freezed,
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
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as SacramentType,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      memberFirstName: freezed == memberFirstName
          ? _value.memberFirstName
          : memberFirstName // ignore: cast_nullable_to_non_nullable
              as String?,
      memberLastName: freezed == memberLastName
          ? _value.memberLastName
          : memberLastName // ignore: cast_nullable_to_non_nullable
              as String?,
      memberId: null == memberId
          ? _value.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as String,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      celebrant: freezed == celebrant
          ? _value.celebrant
          : celebrant // ignore: cast_nullable_to_non_nullable
              as String?,
      godfather: freezed == godfather
          ? _value.godfather
          : godfather // ignore: cast_nullable_to_non_nullable
              as String?,
      godmother: freezed == godmother
          ? _value.godmother
          : godmother // ignore: cast_nullable_to_non_nullable
              as String?,
      spouseName: freezed == spouseName
          ? _value.spouseName
          : spouseName // ignore: cast_nullable_to_non_nullable
              as String?,
      spouseBirthDate: freezed == spouseBirthDate
          ? _value.spouseBirthDate
          : spouseBirthDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      witnesses: freezed == witnesses
          ? _value.witnesses
          : witnesses // ignore: cast_nullable_to_non_nullable
              as String?,
      certificateNumber: freezed == certificateNumber
          ? _value.certificateNumber
          : certificateNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      attachmentUrl: freezed == attachmentUrl
          ? _value.attachmentUrl
          : attachmentUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedBy: freezed == updatedBy
          ? _value.updatedBy
          : updatedBy // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $SacramentTypeCopyWith<$Res> get type {
    return $SacramentTypeCopyWith<$Res>(_value.type, (value) {
      return _then(_value.copyWith(type: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SacramentImplCopyWith<$Res>
    implements $SacramentCopyWith<$Res> {
  factory _$$SacramentImplCopyWith(
          _$SacramentImpl value, $Res Function(_$SacramentImpl) then) =
      __$$SacramentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String churchId,
      @SacramentTypeConverter() SacramentType type,
      DateTime date,
      String? memberFirstName,
      String? memberLastName,
      String memberId,
      String? location,
      String? celebrant,
      String? godfather,
      String? godmother,
      String? spouseName,
      DateTime? spouseBirthDate,
      String? witnesses,
      String? certificateNumber,
      String? notes,
      String? attachmentUrl,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? createdBy,
      String? updatedBy});

  @override
  $SacramentTypeCopyWith<$Res> get type;
}

/// @nodoc
class __$$SacramentImplCopyWithImpl<$Res>
    extends _$SacramentCopyWithImpl<$Res, _$SacramentImpl>
    implements _$$SacramentImplCopyWith<$Res> {
  __$$SacramentImplCopyWithImpl(
      _$SacramentImpl _value, $Res Function(_$SacramentImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? churchId = null,
    Object? type = null,
    Object? date = null,
    Object? memberFirstName = freezed,
    Object? memberLastName = freezed,
    Object? memberId = null,
    Object? location = freezed,
    Object? celebrant = freezed,
    Object? godfather = freezed,
    Object? godmother = freezed,
    Object? spouseName = freezed,
    Object? spouseBirthDate = freezed,
    Object? witnesses = freezed,
    Object? certificateNumber = freezed,
    Object? notes = freezed,
    Object? attachmentUrl = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? createdBy = freezed,
    Object? updatedBy = freezed,
  }) {
    return _then(_$SacramentImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      churchId: null == churchId
          ? _value.churchId
          : churchId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as SacramentType,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      memberFirstName: freezed == memberFirstName
          ? _value.memberFirstName
          : memberFirstName // ignore: cast_nullable_to_non_nullable
              as String?,
      memberLastName: freezed == memberLastName
          ? _value.memberLastName
          : memberLastName // ignore: cast_nullable_to_non_nullable
              as String?,
      memberId: null == memberId
          ? _value.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as String,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      celebrant: freezed == celebrant
          ? _value.celebrant
          : celebrant // ignore: cast_nullable_to_non_nullable
              as String?,
      godfather: freezed == godfather
          ? _value.godfather
          : godfather // ignore: cast_nullable_to_non_nullable
              as String?,
      godmother: freezed == godmother
          ? _value.godmother
          : godmother // ignore: cast_nullable_to_non_nullable
              as String?,
      spouseName: freezed == spouseName
          ? _value.spouseName
          : spouseName // ignore: cast_nullable_to_non_nullable
              as String?,
      spouseBirthDate: freezed == spouseBirthDate
          ? _value.spouseBirthDate
          : spouseBirthDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      witnesses: freezed == witnesses
          ? _value.witnesses
          : witnesses // ignore: cast_nullable_to_non_nullable
              as String?,
      certificateNumber: freezed == certificateNumber
          ? _value.certificateNumber
          : certificateNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      attachmentUrl: freezed == attachmentUrl
          ? _value.attachmentUrl
          : attachmentUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedBy: freezed == updatedBy
          ? _value.updatedBy
          : updatedBy // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SacramentImpl extends _Sacrament {
  const _$SacramentImpl(
      {required this.id,
      required this.churchId,
      @SacramentTypeConverter() required this.type,
      required this.date,
      this.memberFirstName,
      this.memberLastName,
      required this.memberId,
      this.location,
      this.celebrant,
      this.godfather,
      this.godmother,
      this.spouseName,
      this.spouseBirthDate,
      this.witnesses,
      this.certificateNumber,
      this.notes,
      this.attachmentUrl,
      this.createdAt,
      this.updatedAt,
      this.createdBy,
      this.updatedBy})
      : super._();

  factory _$SacramentImpl.fromJson(Map<String, dynamic> json) =>
      _$$SacramentImplFromJson(json);

  @override
  final String id;
  @override
  final String churchId;
  @override
  @SacramentTypeConverter()
  final SacramentType type;
  @override
  final DateTime date;
  @override
  final String? memberFirstName;
  @override
  final String? memberLastName;
  @override
  final String memberId;
  @override
  final String? location;
  @override
  final String? celebrant;
  @override
  final String? godfather;
  @override
  final String? godmother;
  @override
  final String? spouseName;
  @override
  final DateTime? spouseBirthDate;
  @override
  final String? witnesses;
  @override
  final String? certificateNumber;
  @override
  final String? notes;
  @override
  final String? attachmentUrl;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final String? createdBy;
  @override
  final String? updatedBy;

  @override
  String toString() {
    return 'Sacrament(id: $id, churchId: $churchId, type: $type, date: $date, memberFirstName: $memberFirstName, memberLastName: $memberLastName, memberId: $memberId, location: $location, celebrant: $celebrant, godfather: $godfather, godmother: $godmother, spouseName: $spouseName, spouseBirthDate: $spouseBirthDate, witnesses: $witnesses, certificateNumber: $certificateNumber, notes: $notes, attachmentUrl: $attachmentUrl, createdAt: $createdAt, updatedAt: $updatedAt, createdBy: $createdBy, updatedBy: $updatedBy)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SacramentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.churchId, churchId) ||
                other.churchId == churchId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.memberFirstName, memberFirstName) ||
                other.memberFirstName == memberFirstName) &&
            (identical(other.memberLastName, memberLastName) ||
                other.memberLastName == memberLastName) &&
            (identical(other.memberId, memberId) ||
                other.memberId == memberId) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.celebrant, celebrant) ||
                other.celebrant == celebrant) &&
            (identical(other.godfather, godfather) ||
                other.godfather == godfather) &&
            (identical(other.godmother, godmother) ||
                other.godmother == godmother) &&
            (identical(other.spouseName, spouseName) ||
                other.spouseName == spouseName) &&
            (identical(other.spouseBirthDate, spouseBirthDate) ||
                other.spouseBirthDate == spouseBirthDate) &&
            (identical(other.witnesses, witnesses) ||
                other.witnesses == witnesses) &&
            (identical(other.certificateNumber, certificateNumber) ||
                other.certificateNumber == certificateNumber) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.attachmentUrl, attachmentUrl) ||
                other.attachmentUrl == attachmentUrl) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.updatedBy, updatedBy) ||
                other.updatedBy == updatedBy));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        churchId,
        type,
        date,
        memberFirstName,
        memberLastName,
        memberId,
        location,
        celebrant,
        godfather,
        godmother,
        spouseName,
        spouseBirthDate,
        witnesses,
        certificateNumber,
        notes,
        attachmentUrl,
        createdAt,
        updatedAt,
        createdBy,
        updatedBy
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SacramentImplCopyWith<_$SacramentImpl> get copyWith =>
      __$$SacramentImplCopyWithImpl<_$SacramentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SacramentImplToJson(
      this,
    );
  }
}

abstract class _Sacrament extends Sacrament {
  const factory _Sacrament(
      {required final String id,
      required final String churchId,
      @SacramentTypeConverter() required final SacramentType type,
      required final DateTime date,
      final String? memberFirstName,
      final String? memberLastName,
      required final String memberId,
      final String? location,
      final String? celebrant,
      final String? godfather,
      final String? godmother,
      final String? spouseName,
      final DateTime? spouseBirthDate,
      final String? witnesses,
      final String? certificateNumber,
      final String? notes,
      final String? attachmentUrl,
      final DateTime? createdAt,
      final DateTime? updatedAt,
      final String? createdBy,
      final String? updatedBy}) = _$SacramentImpl;
  const _Sacrament._() : super._();

  factory _Sacrament.fromJson(Map<String, dynamic> json) =
      _$SacramentImpl.fromJson;

  @override
  String get id;
  @override
  String get churchId;
  @override
  @SacramentTypeConverter()
  SacramentType get type;
  @override
  DateTime get date;
  @override
  String? get memberFirstName;
  @override
  String? get memberLastName;
  @override
  String get memberId;
  @override
  String? get location;
  @override
  String? get celebrant;
  @override
  String? get godfather;
  @override
  String? get godmother;
  @override
  String? get spouseName;
  @override
  DateTime? get spouseBirthDate;
  @override
  String? get witnesses;
  @override
  String? get certificateNumber;
  @override
  String? get notes;
  @override
  String? get attachmentUrl;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  String? get createdBy;
  @override
  String? get updatedBy;
  @override
  @JsonKey(ignore: true)
  _$$SacramentImplCopyWith<_$SacramentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
