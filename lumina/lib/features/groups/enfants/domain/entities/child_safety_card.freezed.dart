// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'child_safety_card.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ChildSafetyCard _$ChildSafetyCardFromJson(Map<String, dynamic> json) {
  return _ChildSafetyCard.fromJson(json);
}

/// @nodoc
mixin _$ChildSafetyCard {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'church_id')
  String get churchId => throw _privateConstructorUsedError;
  String get memberId => throw _privateConstructorUsedError;
  Map<String, dynamic> get medicalInfo => throw _privateConstructorUsedError;
  String? get emergencyContact => throw _privateConstructorUsedError;
  List<String> get allergies => throw _privateConstructorUsedError;
  String? get bloodType => throw _privateConstructorUsedError;
  DateTime? get lastCheckIn => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChildSafetyCardCopyWith<ChildSafetyCard> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChildSafetyCardCopyWith<$Res> {
  factory $ChildSafetyCardCopyWith(
          ChildSafetyCard value, $Res Function(ChildSafetyCard) then) =
      _$ChildSafetyCardCopyWithImpl<$Res, ChildSafetyCard>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'church_id') String churchId,
      String memberId,
      Map<String, dynamic> medicalInfo,
      String? emergencyContact,
      List<String> allergies,
      String? bloodType,
      DateTime? lastCheckIn,
      bool isActive,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$ChildSafetyCardCopyWithImpl<$Res, $Val extends ChildSafetyCard>
    implements $ChildSafetyCardCopyWith<$Res> {
  _$ChildSafetyCardCopyWithImpl(this._value, this._then);

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
    Object? medicalInfo = null,
    Object? emergencyContact = freezed,
    Object? allergies = null,
    Object? bloodType = freezed,
    Object? lastCheckIn = freezed,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = null,
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
      medicalInfo: null == medicalInfo
          ? _value.medicalInfo
          : medicalInfo // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      emergencyContact: freezed == emergencyContact
          ? _value.emergencyContact
          : emergencyContact // ignore: cast_nullable_to_non_nullable
              as String?,
      allergies: null == allergies
          ? _value.allergies
          : allergies // ignore: cast_nullable_to_non_nullable
              as List<String>,
      bloodType: freezed == bloodType
          ? _value.bloodType
          : bloodType // ignore: cast_nullable_to_non_nullable
              as String?,
      lastCheckIn: freezed == lastCheckIn
          ? _value.lastCheckIn
          : lastCheckIn // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChildSafetyCardImplCopyWith<$Res>
    implements $ChildSafetyCardCopyWith<$Res> {
  factory _$$ChildSafetyCardImplCopyWith(_$ChildSafetyCardImpl value,
          $Res Function(_$ChildSafetyCardImpl) then) =
      __$$ChildSafetyCardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'church_id') String churchId,
      String memberId,
      Map<String, dynamic> medicalInfo,
      String? emergencyContact,
      List<String> allergies,
      String? bloodType,
      DateTime? lastCheckIn,
      bool isActive,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$ChildSafetyCardImplCopyWithImpl<$Res>
    extends _$ChildSafetyCardCopyWithImpl<$Res, _$ChildSafetyCardImpl>
    implements _$$ChildSafetyCardImplCopyWith<$Res> {
  __$$ChildSafetyCardImplCopyWithImpl(
      _$ChildSafetyCardImpl _value, $Res Function(_$ChildSafetyCardImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? churchId = null,
    Object? memberId = null,
    Object? medicalInfo = null,
    Object? emergencyContact = freezed,
    Object? allergies = null,
    Object? bloodType = freezed,
    Object? lastCheckIn = freezed,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$ChildSafetyCardImpl(
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
      medicalInfo: null == medicalInfo
          ? _value._medicalInfo
          : medicalInfo // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      emergencyContact: freezed == emergencyContact
          ? _value.emergencyContact
          : emergencyContact // ignore: cast_nullable_to_non_nullable
              as String?,
      allergies: null == allergies
          ? _value._allergies
          : allergies // ignore: cast_nullable_to_non_nullable
              as List<String>,
      bloodType: freezed == bloodType
          ? _value.bloodType
          : bloodType // ignore: cast_nullable_to_non_nullable
              as String?,
      lastCheckIn: freezed == lastCheckIn
          ? _value.lastCheckIn
          : lastCheckIn // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChildSafetyCardImpl implements _ChildSafetyCard {
  const _$ChildSafetyCardImpl(
      {required this.id,
      @JsonKey(name: 'church_id') required this.churchId,
      required this.memberId,
      final Map<String, dynamic> medicalInfo = const {},
      this.emergencyContact,
      final List<String> allergies = const [],
      this.bloodType,
      this.lastCheckIn,
      this.isActive = true,
      required this.createdAt,
      required this.updatedAt})
      : _medicalInfo = medicalInfo,
        _allergies = allergies;

  factory _$ChildSafetyCardImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChildSafetyCardImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'church_id')
  final String churchId;
  @override
  final String memberId;
  final Map<String, dynamic> _medicalInfo;
  @override
  @JsonKey()
  Map<String, dynamic> get medicalInfo {
    if (_medicalInfo is EqualUnmodifiableMapView) return _medicalInfo;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_medicalInfo);
  }

  @override
  final String? emergencyContact;
  final List<String> _allergies;
  @override
  @JsonKey()
  List<String> get allergies {
    if (_allergies is EqualUnmodifiableListView) return _allergies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allergies);
  }

  @override
  final String? bloodType;
  @override
  final DateTime? lastCheckIn;
  @override
  @JsonKey()
  final bool isActive;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'ChildSafetyCard(id: $id, churchId: $churchId, memberId: $memberId, medicalInfo: $medicalInfo, emergencyContact: $emergencyContact, allergies: $allergies, bloodType: $bloodType, lastCheckIn: $lastCheckIn, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChildSafetyCardImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.churchId, churchId) ||
                other.churchId == churchId) &&
            (identical(other.memberId, memberId) ||
                other.memberId == memberId) &&
            const DeepCollectionEquality()
                .equals(other._medicalInfo, _medicalInfo) &&
            (identical(other.emergencyContact, emergencyContact) ||
                other.emergencyContact == emergencyContact) &&
            const DeepCollectionEquality()
                .equals(other._allergies, _allergies) &&
            (identical(other.bloodType, bloodType) ||
                other.bloodType == bloodType) &&
            (identical(other.lastCheckIn, lastCheckIn) ||
                other.lastCheckIn == lastCheckIn) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
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
      const DeepCollectionEquality().hash(_medicalInfo),
      emergencyContact,
      const DeepCollectionEquality().hash(_allergies),
      bloodType,
      lastCheckIn,
      isActive,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChildSafetyCardImplCopyWith<_$ChildSafetyCardImpl> get copyWith =>
      __$$ChildSafetyCardImplCopyWithImpl<_$ChildSafetyCardImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChildSafetyCardImplToJson(
      this,
    );
  }
}

abstract class _ChildSafetyCard implements ChildSafetyCard {
  const factory _ChildSafetyCard(
      {required final String id,
      @JsonKey(name: 'church_id') required final String churchId,
      required final String memberId,
      final Map<String, dynamic> medicalInfo,
      final String? emergencyContact,
      final List<String> allergies,
      final String? bloodType,
      final DateTime? lastCheckIn,
      final bool isActive,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$ChildSafetyCardImpl;

  factory _ChildSafetyCard.fromJson(Map<String, dynamic> json) =
      _$ChildSafetyCardImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'church_id')
  String get churchId;
  @override
  String get memberId;
  @override
  Map<String, dynamic> get medicalInfo;
  @override
  String? get emergencyContact;
  @override
  List<String> get allergies;
  @override
  String? get bloodType;
  @override
  DateTime? get lastCheckIn;
  @override
  bool get isActive;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$ChildSafetyCardImplCopyWith<_$ChildSafetyCardImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
