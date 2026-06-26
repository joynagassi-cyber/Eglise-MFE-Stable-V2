// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'engagement_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ChurchRole _$ChurchRoleFromJson(Map<String, dynamic> json) {
  return _ChurchRole.fromJson(json);
}

/// @nodoc
mixin _$ChurchRole {
  ChurchRoleType get type => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get department => throw _privateConstructorUsedError;
  String? get ministry => throw _privateConstructorUsedError;
  DateTime? get startDate => throw _privateConstructorUsedError;
  DateTime? get endDate => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChurchRoleCopyWith<ChurchRole> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChurchRoleCopyWith<$Res> {
  factory $ChurchRoleCopyWith(
          ChurchRole value, $Res Function(ChurchRole) then) =
      _$ChurchRoleCopyWithImpl<$Res, ChurchRole>;
  @useResult
  $Res call(
      {ChurchRoleType type,
      String title,
      String? department,
      String? ministry,
      DateTime? startDate,
      DateTime? endDate,
      bool isActive,
      String? notes});
}

/// @nodoc
class _$ChurchRoleCopyWithImpl<$Res, $Val extends ChurchRole>
    implements $ChurchRoleCopyWith<$Res> {
  _$ChurchRoleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? title = null,
    Object? department = freezed,
    Object? ministry = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? isActive = null,
    Object? notes = freezed,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ChurchRoleType,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      department: freezed == department
          ? _value.department
          : department // ignore: cast_nullable_to_non_nullable
              as String?,
      ministry: freezed == ministry
          ? _value.ministry
          : ministry // ignore: cast_nullable_to_non_nullable
              as String?,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChurchRoleImplCopyWith<$Res>
    implements $ChurchRoleCopyWith<$Res> {
  factory _$$ChurchRoleImplCopyWith(
          _$ChurchRoleImpl value, $Res Function(_$ChurchRoleImpl) then) =
      __$$ChurchRoleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {ChurchRoleType type,
      String title,
      String? department,
      String? ministry,
      DateTime? startDate,
      DateTime? endDate,
      bool isActive,
      String? notes});
}

/// @nodoc
class __$$ChurchRoleImplCopyWithImpl<$Res>
    extends _$ChurchRoleCopyWithImpl<$Res, _$ChurchRoleImpl>
    implements _$$ChurchRoleImplCopyWith<$Res> {
  __$$ChurchRoleImplCopyWithImpl(
      _$ChurchRoleImpl _value, $Res Function(_$ChurchRoleImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? title = null,
    Object? department = freezed,
    Object? ministry = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? isActive = null,
    Object? notes = freezed,
  }) {
    return _then(_$ChurchRoleImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ChurchRoleType,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      department: freezed == department
          ? _value.department
          : department // ignore: cast_nullable_to_non_nullable
              as String?,
      ministry: freezed == ministry
          ? _value.ministry
          : ministry // ignore: cast_nullable_to_non_nullable
              as String?,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChurchRoleImpl extends _ChurchRole {
  const _$ChurchRoleImpl(
      {required this.type,
      required this.title,
      this.department,
      this.ministry,
      this.startDate,
      this.endDate,
      this.isActive = true,
      this.notes})
      : super._();

  factory _$ChurchRoleImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChurchRoleImplFromJson(json);

  @override
  final ChurchRoleType type;
  @override
  final String title;
  @override
  final String? department;
  @override
  final String? ministry;
  @override
  final DateTime? startDate;
  @override
  final DateTime? endDate;
  @override
  @JsonKey()
  final bool isActive;
  @override
  final String? notes;

  @override
  String toString() {
    return 'ChurchRole(type: $type, title: $title, department: $department, ministry: $ministry, startDate: $startDate, endDate: $endDate, isActive: $isActive, notes: $notes)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChurchRoleImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.department, department) ||
                other.department == department) &&
            (identical(other.ministry, ministry) ||
                other.ministry == ministry) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, type, title, department,
      ministry, startDate, endDate, isActive, notes);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChurchRoleImplCopyWith<_$ChurchRoleImpl> get copyWith =>
      __$$ChurchRoleImplCopyWithImpl<_$ChurchRoleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChurchRoleImplToJson(
      this,
    );
  }
}

abstract class _ChurchRole extends ChurchRole {
  const factory _ChurchRole(
      {required final ChurchRoleType type,
      required final String title,
      final String? department,
      final String? ministry,
      final DateTime? startDate,
      final DateTime? endDate,
      final bool isActive,
      final String? notes}) = _$ChurchRoleImpl;
  const _ChurchRole._() : super._();

  factory _ChurchRole.fromJson(Map<String, dynamic> json) =
      _$ChurchRoleImpl.fromJson;

  @override
  ChurchRoleType get type;
  @override
  String get title;
  @override
  String? get department;
  @override
  String? get ministry;
  @override
  DateTime? get startDate;
  @override
  DateTime? get endDate;
  @override
  bool get isActive;
  @override
  String? get notes;
  @override
  @JsonKey(ignore: true)
  _$$ChurchRoleImplCopyWith<_$ChurchRoleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MinistryMembership _$MinistryMembershipFromJson(Map<String, dynamic> json) {
  return _MinistryMembership.fromJson(json);
}

/// @nodoc
mixin _$MinistryMembership {
  String get ministryId => throw _privateConstructorUsedError;
  String get ministryName => throw _privateConstructorUsedError;
  String? get role => throw _privateConstructorUsedError;
  DateTime? get joinDate => throw _privateConstructorUsedError;
  DateTime? get leaveDate => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  bool get isLeader => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MinistryMembershipCopyWith<MinistryMembership> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MinistryMembershipCopyWith<$Res> {
  factory $MinistryMembershipCopyWith(
          MinistryMembership value, $Res Function(MinistryMembership) then) =
      _$MinistryMembershipCopyWithImpl<$Res, MinistryMembership>;
  @useResult
  $Res call(
      {String ministryId,
      String ministryName,
      String? role,
      DateTime? joinDate,
      DateTime? leaveDate,
      bool isActive,
      bool isLeader});
}

/// @nodoc
class _$MinistryMembershipCopyWithImpl<$Res, $Val extends MinistryMembership>
    implements $MinistryMembershipCopyWith<$Res> {
  _$MinistryMembershipCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ministryId = null,
    Object? ministryName = null,
    Object? role = freezed,
    Object? joinDate = freezed,
    Object? leaveDate = freezed,
    Object? isActive = null,
    Object? isLeader = null,
  }) {
    return _then(_value.copyWith(
      ministryId: null == ministryId
          ? _value.ministryId
          : ministryId // ignore: cast_nullable_to_non_nullable
              as String,
      ministryName: null == ministryName
          ? _value.ministryName
          : ministryName // ignore: cast_nullable_to_non_nullable
              as String,
      role: freezed == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
      joinDate: freezed == joinDate
          ? _value.joinDate
          : joinDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      leaveDate: freezed == leaveDate
          ? _value.leaveDate
          : leaveDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isLeader: null == isLeader
          ? _value.isLeader
          : isLeader // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MinistryMembershipImplCopyWith<$Res>
    implements $MinistryMembershipCopyWith<$Res> {
  factory _$$MinistryMembershipImplCopyWith(_$MinistryMembershipImpl value,
          $Res Function(_$MinistryMembershipImpl) then) =
      __$$MinistryMembershipImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String ministryId,
      String ministryName,
      String? role,
      DateTime? joinDate,
      DateTime? leaveDate,
      bool isActive,
      bool isLeader});
}

/// @nodoc
class __$$MinistryMembershipImplCopyWithImpl<$Res>
    extends _$MinistryMembershipCopyWithImpl<$Res, _$MinistryMembershipImpl>
    implements _$$MinistryMembershipImplCopyWith<$Res> {
  __$$MinistryMembershipImplCopyWithImpl(_$MinistryMembershipImpl _value,
      $Res Function(_$MinistryMembershipImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ministryId = null,
    Object? ministryName = null,
    Object? role = freezed,
    Object? joinDate = freezed,
    Object? leaveDate = freezed,
    Object? isActive = null,
    Object? isLeader = null,
  }) {
    return _then(_$MinistryMembershipImpl(
      ministryId: null == ministryId
          ? _value.ministryId
          : ministryId // ignore: cast_nullable_to_non_nullable
              as String,
      ministryName: null == ministryName
          ? _value.ministryName
          : ministryName // ignore: cast_nullable_to_non_nullable
              as String,
      role: freezed == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
      joinDate: freezed == joinDate
          ? _value.joinDate
          : joinDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      leaveDate: freezed == leaveDate
          ? _value.leaveDate
          : leaveDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isLeader: null == isLeader
          ? _value.isLeader
          : isLeader // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MinistryMembershipImpl implements _MinistryMembership {
  const _$MinistryMembershipImpl(
      {required this.ministryId,
      required this.ministryName,
      this.role,
      this.joinDate,
      this.leaveDate,
      this.isActive = true,
      this.isLeader = false});

  factory _$MinistryMembershipImpl.fromJson(Map<String, dynamic> json) =>
      _$$MinistryMembershipImplFromJson(json);

  @override
  final String ministryId;
  @override
  final String ministryName;
  @override
  final String? role;
  @override
  final DateTime? joinDate;
  @override
  final DateTime? leaveDate;
  @override
  @JsonKey()
  final bool isActive;
  @override
  @JsonKey()
  final bool isLeader;

  @override
  String toString() {
    return 'MinistryMembership(ministryId: $ministryId, ministryName: $ministryName, role: $role, joinDate: $joinDate, leaveDate: $leaveDate, isActive: $isActive, isLeader: $isLeader)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MinistryMembershipImpl &&
            (identical(other.ministryId, ministryId) ||
                other.ministryId == ministryId) &&
            (identical(other.ministryName, ministryName) ||
                other.ministryName == ministryName) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.joinDate, joinDate) ||
                other.joinDate == joinDate) &&
            (identical(other.leaveDate, leaveDate) ||
                other.leaveDate == leaveDate) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isLeader, isLeader) ||
                other.isLeader == isLeader));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, ministryId, ministryName, role,
      joinDate, leaveDate, isActive, isLeader);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MinistryMembershipImplCopyWith<_$MinistryMembershipImpl> get copyWith =>
      __$$MinistryMembershipImplCopyWithImpl<_$MinistryMembershipImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MinistryMembershipImplToJson(
      this,
    );
  }
}

abstract class _MinistryMembership implements MinistryMembership {
  const factory _MinistryMembership(
      {required final String ministryId,
      required final String ministryName,
      final String? role,
      final DateTime? joinDate,
      final DateTime? leaveDate,
      final bool isActive,
      final bool isLeader}) = _$MinistryMembershipImpl;

  factory _MinistryMembership.fromJson(Map<String, dynamic> json) =
      _$MinistryMembershipImpl.fromJson;

  @override
  String get ministryId;
  @override
  String get ministryName;
  @override
  String? get role;
  @override
  DateTime? get joinDate;
  @override
  DateTime? get leaveDate;
  @override
  bool get isActive;
  @override
  bool get isLeader;
  @override
  @JsonKey(ignore: true)
  _$$MinistryMembershipImplCopyWith<_$MinistryMembershipImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CellMembership _$CellMembershipFromJson(Map<String, dynamic> json) {
  return _CellMembership.fromJson(json);
}

/// @nodoc
mixin _$CellMembership {
  String get cellId => throw _privateConstructorUsedError;
  String get cellName => throw _privateConstructorUsedError;
  String? get cellLeaderName => throw _privateConstructorUsedError;
  String? get cellLocation => throw _privateConstructorUsedError;
  DateTime? get joinDate => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  bool get isLeader => throw _privateConstructorUsedError;
  bool get isHost => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CellMembershipCopyWith<CellMembership> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CellMembershipCopyWith<$Res> {
  factory $CellMembershipCopyWith(
          CellMembership value, $Res Function(CellMembership) then) =
      _$CellMembershipCopyWithImpl<$Res, CellMembership>;
  @useResult
  $Res call(
      {String cellId,
      String cellName,
      String? cellLeaderName,
      String? cellLocation,
      DateTime? joinDate,
      bool isActive,
      bool isLeader,
      bool isHost});
}

/// @nodoc
class _$CellMembershipCopyWithImpl<$Res, $Val extends CellMembership>
    implements $CellMembershipCopyWith<$Res> {
  _$CellMembershipCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cellId = null,
    Object? cellName = null,
    Object? cellLeaderName = freezed,
    Object? cellLocation = freezed,
    Object? joinDate = freezed,
    Object? isActive = null,
    Object? isLeader = null,
    Object? isHost = null,
  }) {
    return _then(_value.copyWith(
      cellId: null == cellId
          ? _value.cellId
          : cellId // ignore: cast_nullable_to_non_nullable
              as String,
      cellName: null == cellName
          ? _value.cellName
          : cellName // ignore: cast_nullable_to_non_nullable
              as String,
      cellLeaderName: freezed == cellLeaderName
          ? _value.cellLeaderName
          : cellLeaderName // ignore: cast_nullable_to_non_nullable
              as String?,
      cellLocation: freezed == cellLocation
          ? _value.cellLocation
          : cellLocation // ignore: cast_nullable_to_non_nullable
              as String?,
      joinDate: freezed == joinDate
          ? _value.joinDate
          : joinDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isLeader: null == isLeader
          ? _value.isLeader
          : isLeader // ignore: cast_nullable_to_non_nullable
              as bool,
      isHost: null == isHost
          ? _value.isHost
          : isHost // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CellMembershipImplCopyWith<$Res>
    implements $CellMembershipCopyWith<$Res> {
  factory _$$CellMembershipImplCopyWith(_$CellMembershipImpl value,
          $Res Function(_$CellMembershipImpl) then) =
      __$$CellMembershipImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String cellId,
      String cellName,
      String? cellLeaderName,
      String? cellLocation,
      DateTime? joinDate,
      bool isActive,
      bool isLeader,
      bool isHost});
}

/// @nodoc
class __$$CellMembershipImplCopyWithImpl<$Res>
    extends _$CellMembershipCopyWithImpl<$Res, _$CellMembershipImpl>
    implements _$$CellMembershipImplCopyWith<$Res> {
  __$$CellMembershipImplCopyWithImpl(
      _$CellMembershipImpl _value, $Res Function(_$CellMembershipImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cellId = null,
    Object? cellName = null,
    Object? cellLeaderName = freezed,
    Object? cellLocation = freezed,
    Object? joinDate = freezed,
    Object? isActive = null,
    Object? isLeader = null,
    Object? isHost = null,
  }) {
    return _then(_$CellMembershipImpl(
      cellId: null == cellId
          ? _value.cellId
          : cellId // ignore: cast_nullable_to_non_nullable
              as String,
      cellName: null == cellName
          ? _value.cellName
          : cellName // ignore: cast_nullable_to_non_nullable
              as String,
      cellLeaderName: freezed == cellLeaderName
          ? _value.cellLeaderName
          : cellLeaderName // ignore: cast_nullable_to_non_nullable
              as String?,
      cellLocation: freezed == cellLocation
          ? _value.cellLocation
          : cellLocation // ignore: cast_nullable_to_non_nullable
              as String?,
      joinDate: freezed == joinDate
          ? _value.joinDate
          : joinDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isLeader: null == isLeader
          ? _value.isLeader
          : isLeader // ignore: cast_nullable_to_non_nullable
              as bool,
      isHost: null == isHost
          ? _value.isHost
          : isHost // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CellMembershipImpl implements _CellMembership {
  const _$CellMembershipImpl(
      {required this.cellId,
      required this.cellName,
      this.cellLeaderName,
      this.cellLocation,
      this.joinDate,
      this.isActive = true,
      this.isLeader = false,
      this.isHost = false});

  factory _$CellMembershipImpl.fromJson(Map<String, dynamic> json) =>
      _$$CellMembershipImplFromJson(json);

  @override
  final String cellId;
  @override
  final String cellName;
  @override
  final String? cellLeaderName;
  @override
  final String? cellLocation;
  @override
  final DateTime? joinDate;
  @override
  @JsonKey()
  final bool isActive;
  @override
  @JsonKey()
  final bool isLeader;
  @override
  @JsonKey()
  final bool isHost;

  @override
  String toString() {
    return 'CellMembership(cellId: $cellId, cellName: $cellName, cellLeaderName: $cellLeaderName, cellLocation: $cellLocation, joinDate: $joinDate, isActive: $isActive, isLeader: $isLeader, isHost: $isHost)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CellMembershipImpl &&
            (identical(other.cellId, cellId) || other.cellId == cellId) &&
            (identical(other.cellName, cellName) ||
                other.cellName == cellName) &&
            (identical(other.cellLeaderName, cellLeaderName) ||
                other.cellLeaderName == cellLeaderName) &&
            (identical(other.cellLocation, cellLocation) ||
                other.cellLocation == cellLocation) &&
            (identical(other.joinDate, joinDate) ||
                other.joinDate == joinDate) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isLeader, isLeader) ||
                other.isLeader == isLeader) &&
            (identical(other.isHost, isHost) || other.isHost == isHost));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, cellId, cellName, cellLeaderName,
      cellLocation, joinDate, isActive, isLeader, isHost);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CellMembershipImplCopyWith<_$CellMembershipImpl> get copyWith =>
      __$$CellMembershipImplCopyWithImpl<_$CellMembershipImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CellMembershipImplToJson(
      this,
    );
  }
}

abstract class _CellMembership implements CellMembership {
  const factory _CellMembership(
      {required final String cellId,
      required final String cellName,
      final String? cellLeaderName,
      final String? cellLocation,
      final DateTime? joinDate,
      final bool isActive,
      final bool isLeader,
      final bool isHost}) = _$CellMembershipImpl;

  factory _CellMembership.fromJson(Map<String, dynamic> json) =
      _$CellMembershipImpl.fromJson;

  @override
  String get cellId;
  @override
  String get cellName;
  @override
  String? get cellLeaderName;
  @override
  String? get cellLocation;
  @override
  DateTime? get joinDate;
  @override
  bool get isActive;
  @override
  bool get isLeader;
  @override
  bool get isHost;
  @override
  @JsonKey(ignore: true)
  _$$CellMembershipImplCopyWith<_$CellMembershipImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EngagementInfo _$EngagementInfoFromJson(Map<String, dynamic> json) {
  return _EngagementInfo.fromJson(json);
}

/// @nodoc
mixin _$EngagementInfo {
// Rôles
  List<ChurchRole> get roles => throw _privateConstructorUsedError;
  ChurchRoleType? get primaryRole =>
      throw _privateConstructorUsedError; // Ministères
  List<MinistryMembership> get ministries =>
      throw _privateConstructorUsedError; // Cellule de maison
  CellMembership? get cell => throw _privateConstructorUsedError; // Assiduité
  AttendanceLevel get attendanceLevel => throw _privateConstructorUsedError;
  DateTime? get lastAttendanceDate => throw _privateConstructorUsedError;
  DateTime? get lastCellAttendanceDate => throw _privateConstructorUsedError;
  int get attendanceStreakWeeks =>
      throw _privateConstructorUsedError; // Contributions
  bool get isRegularTither => throw _privateConstructorUsedError;
  bool get isOfferingGiver => throw _privateConstructorUsedError;
  DateTime? get lastContributionDate =>
      throw _privateConstructorUsedError; // Bénévolat
  List<String> get volunteerAreas => throw _privateConstructorUsedError;
  int get volunteerHoursThisYear =>
      throw _privateConstructorUsedError; // Événements
  int get eventsAttendedThisYear => throw _privateConstructorUsedError;
  List<String> get upcomingEventIds =>
      throw _privateConstructorUsedError; // Disponibilité
  List<String> get availableDays => throw _privateConstructorUsedError;
  String? get availabilityNotes => throw _privateConstructorUsedError;
  List<String> get skills => throw _privateConstructorUsedError;
  List<String> get talents =>
      throw _privateConstructorUsedError; // Formation suivie
  List<String> get completedTrainings => throw _privateConstructorUsedError;
  List<String> get currentTrainings => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EngagementInfoCopyWith<EngagementInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EngagementInfoCopyWith<$Res> {
  factory $EngagementInfoCopyWith(
          EngagementInfo value, $Res Function(EngagementInfo) then) =
      _$EngagementInfoCopyWithImpl<$Res, EngagementInfo>;
  @useResult
  $Res call(
      {List<ChurchRole> roles,
      ChurchRoleType? primaryRole,
      List<MinistryMembership> ministries,
      CellMembership? cell,
      AttendanceLevel attendanceLevel,
      DateTime? lastAttendanceDate,
      DateTime? lastCellAttendanceDate,
      int attendanceStreakWeeks,
      bool isRegularTither,
      bool isOfferingGiver,
      DateTime? lastContributionDate,
      List<String> volunteerAreas,
      int volunteerHoursThisYear,
      int eventsAttendedThisYear,
      List<String> upcomingEventIds,
      List<String> availableDays,
      String? availabilityNotes,
      List<String> skills,
      List<String> talents,
      List<String> completedTrainings,
      List<String> currentTrainings});

  $CellMembershipCopyWith<$Res>? get cell;
}

/// @nodoc
class _$EngagementInfoCopyWithImpl<$Res, $Val extends EngagementInfo>
    implements $EngagementInfoCopyWith<$Res> {
  _$EngagementInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roles = null,
    Object? primaryRole = freezed,
    Object? ministries = null,
    Object? cell = freezed,
    Object? attendanceLevel = null,
    Object? lastAttendanceDate = freezed,
    Object? lastCellAttendanceDate = freezed,
    Object? attendanceStreakWeeks = null,
    Object? isRegularTither = null,
    Object? isOfferingGiver = null,
    Object? lastContributionDate = freezed,
    Object? volunteerAreas = null,
    Object? volunteerHoursThisYear = null,
    Object? eventsAttendedThisYear = null,
    Object? upcomingEventIds = null,
    Object? availableDays = null,
    Object? availabilityNotes = freezed,
    Object? skills = null,
    Object? talents = null,
    Object? completedTrainings = null,
    Object? currentTrainings = null,
  }) {
    return _then(_value.copyWith(
      roles: null == roles
          ? _value.roles
          : roles // ignore: cast_nullable_to_non_nullable
              as List<ChurchRole>,
      primaryRole: freezed == primaryRole
          ? _value.primaryRole
          : primaryRole // ignore: cast_nullable_to_non_nullable
              as ChurchRoleType?,
      ministries: null == ministries
          ? _value.ministries
          : ministries // ignore: cast_nullable_to_non_nullable
              as List<MinistryMembership>,
      cell: freezed == cell
          ? _value.cell
          : cell // ignore: cast_nullable_to_non_nullable
              as CellMembership?,
      attendanceLevel: null == attendanceLevel
          ? _value.attendanceLevel
          : attendanceLevel // ignore: cast_nullable_to_non_nullable
              as AttendanceLevel,
      lastAttendanceDate: freezed == lastAttendanceDate
          ? _value.lastAttendanceDate
          : lastAttendanceDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastCellAttendanceDate: freezed == lastCellAttendanceDate
          ? _value.lastCellAttendanceDate
          : lastCellAttendanceDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      attendanceStreakWeeks: null == attendanceStreakWeeks
          ? _value.attendanceStreakWeeks
          : attendanceStreakWeeks // ignore: cast_nullable_to_non_nullable
              as int,
      isRegularTither: null == isRegularTither
          ? _value.isRegularTither
          : isRegularTither // ignore: cast_nullable_to_non_nullable
              as bool,
      isOfferingGiver: null == isOfferingGiver
          ? _value.isOfferingGiver
          : isOfferingGiver // ignore: cast_nullable_to_non_nullable
              as bool,
      lastContributionDate: freezed == lastContributionDate
          ? _value.lastContributionDate
          : lastContributionDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      volunteerAreas: null == volunteerAreas
          ? _value.volunteerAreas
          : volunteerAreas // ignore: cast_nullable_to_non_nullable
              as List<String>,
      volunteerHoursThisYear: null == volunteerHoursThisYear
          ? _value.volunteerHoursThisYear
          : volunteerHoursThisYear // ignore: cast_nullable_to_non_nullable
              as int,
      eventsAttendedThisYear: null == eventsAttendedThisYear
          ? _value.eventsAttendedThisYear
          : eventsAttendedThisYear // ignore: cast_nullable_to_non_nullable
              as int,
      upcomingEventIds: null == upcomingEventIds
          ? _value.upcomingEventIds
          : upcomingEventIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      availableDays: null == availableDays
          ? _value.availableDays
          : availableDays // ignore: cast_nullable_to_non_nullable
              as List<String>,
      availabilityNotes: freezed == availabilityNotes
          ? _value.availabilityNotes
          : availabilityNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      skills: null == skills
          ? _value.skills
          : skills // ignore: cast_nullable_to_non_nullable
              as List<String>,
      talents: null == talents
          ? _value.talents
          : talents // ignore: cast_nullable_to_non_nullable
              as List<String>,
      completedTrainings: null == completedTrainings
          ? _value.completedTrainings
          : completedTrainings // ignore: cast_nullable_to_non_nullable
              as List<String>,
      currentTrainings: null == currentTrainings
          ? _value.currentTrainings
          : currentTrainings // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $CellMembershipCopyWith<$Res>? get cell {
    if (_value.cell == null) {
      return null;
    }

    return $CellMembershipCopyWith<$Res>(_value.cell!, (value) {
      return _then(_value.copyWith(cell: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$EngagementInfoImplCopyWith<$Res>
    implements $EngagementInfoCopyWith<$Res> {
  factory _$$EngagementInfoImplCopyWith(_$EngagementInfoImpl value,
          $Res Function(_$EngagementInfoImpl) then) =
      __$$EngagementInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<ChurchRole> roles,
      ChurchRoleType? primaryRole,
      List<MinistryMembership> ministries,
      CellMembership? cell,
      AttendanceLevel attendanceLevel,
      DateTime? lastAttendanceDate,
      DateTime? lastCellAttendanceDate,
      int attendanceStreakWeeks,
      bool isRegularTither,
      bool isOfferingGiver,
      DateTime? lastContributionDate,
      List<String> volunteerAreas,
      int volunteerHoursThisYear,
      int eventsAttendedThisYear,
      List<String> upcomingEventIds,
      List<String> availableDays,
      String? availabilityNotes,
      List<String> skills,
      List<String> talents,
      List<String> completedTrainings,
      List<String> currentTrainings});

  @override
  $CellMembershipCopyWith<$Res>? get cell;
}

/// @nodoc
class __$$EngagementInfoImplCopyWithImpl<$Res>
    extends _$EngagementInfoCopyWithImpl<$Res, _$EngagementInfoImpl>
    implements _$$EngagementInfoImplCopyWith<$Res> {
  __$$EngagementInfoImplCopyWithImpl(
      _$EngagementInfoImpl _value, $Res Function(_$EngagementInfoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roles = null,
    Object? primaryRole = freezed,
    Object? ministries = null,
    Object? cell = freezed,
    Object? attendanceLevel = null,
    Object? lastAttendanceDate = freezed,
    Object? lastCellAttendanceDate = freezed,
    Object? attendanceStreakWeeks = null,
    Object? isRegularTither = null,
    Object? isOfferingGiver = null,
    Object? lastContributionDate = freezed,
    Object? volunteerAreas = null,
    Object? volunteerHoursThisYear = null,
    Object? eventsAttendedThisYear = null,
    Object? upcomingEventIds = null,
    Object? availableDays = null,
    Object? availabilityNotes = freezed,
    Object? skills = null,
    Object? talents = null,
    Object? completedTrainings = null,
    Object? currentTrainings = null,
  }) {
    return _then(_$EngagementInfoImpl(
      roles: null == roles
          ? _value._roles
          : roles // ignore: cast_nullable_to_non_nullable
              as List<ChurchRole>,
      primaryRole: freezed == primaryRole
          ? _value.primaryRole
          : primaryRole // ignore: cast_nullable_to_non_nullable
              as ChurchRoleType?,
      ministries: null == ministries
          ? _value._ministries
          : ministries // ignore: cast_nullable_to_non_nullable
              as List<MinistryMembership>,
      cell: freezed == cell
          ? _value.cell
          : cell // ignore: cast_nullable_to_non_nullable
              as CellMembership?,
      attendanceLevel: null == attendanceLevel
          ? _value.attendanceLevel
          : attendanceLevel // ignore: cast_nullable_to_non_nullable
              as AttendanceLevel,
      lastAttendanceDate: freezed == lastAttendanceDate
          ? _value.lastAttendanceDate
          : lastAttendanceDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastCellAttendanceDate: freezed == lastCellAttendanceDate
          ? _value.lastCellAttendanceDate
          : lastCellAttendanceDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      attendanceStreakWeeks: null == attendanceStreakWeeks
          ? _value.attendanceStreakWeeks
          : attendanceStreakWeeks // ignore: cast_nullable_to_non_nullable
              as int,
      isRegularTither: null == isRegularTither
          ? _value.isRegularTither
          : isRegularTither // ignore: cast_nullable_to_non_nullable
              as bool,
      isOfferingGiver: null == isOfferingGiver
          ? _value.isOfferingGiver
          : isOfferingGiver // ignore: cast_nullable_to_non_nullable
              as bool,
      lastContributionDate: freezed == lastContributionDate
          ? _value.lastContributionDate
          : lastContributionDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      volunteerAreas: null == volunteerAreas
          ? _value._volunteerAreas
          : volunteerAreas // ignore: cast_nullable_to_non_nullable
              as List<String>,
      volunteerHoursThisYear: null == volunteerHoursThisYear
          ? _value.volunteerHoursThisYear
          : volunteerHoursThisYear // ignore: cast_nullable_to_non_nullable
              as int,
      eventsAttendedThisYear: null == eventsAttendedThisYear
          ? _value.eventsAttendedThisYear
          : eventsAttendedThisYear // ignore: cast_nullable_to_non_nullable
              as int,
      upcomingEventIds: null == upcomingEventIds
          ? _value._upcomingEventIds
          : upcomingEventIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      availableDays: null == availableDays
          ? _value._availableDays
          : availableDays // ignore: cast_nullable_to_non_nullable
              as List<String>,
      availabilityNotes: freezed == availabilityNotes
          ? _value.availabilityNotes
          : availabilityNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      skills: null == skills
          ? _value._skills
          : skills // ignore: cast_nullable_to_non_nullable
              as List<String>,
      talents: null == talents
          ? _value._talents
          : talents // ignore: cast_nullable_to_non_nullable
              as List<String>,
      completedTrainings: null == completedTrainings
          ? _value._completedTrainings
          : completedTrainings // ignore: cast_nullable_to_non_nullable
              as List<String>,
      currentTrainings: null == currentTrainings
          ? _value._currentTrainings
          : currentTrainings // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EngagementInfoImpl extends _EngagementInfo {
  const _$EngagementInfoImpl(
      {final List<ChurchRole> roles = const [],
      this.primaryRole,
      final List<MinistryMembership> ministries = const [],
      this.cell,
      this.attendanceLevel = AttendanceLevel.regular,
      this.lastAttendanceDate,
      this.lastCellAttendanceDate,
      this.attendanceStreakWeeks = 0,
      this.isRegularTither = false,
      this.isOfferingGiver = false,
      this.lastContributionDate,
      final List<String> volunteerAreas = const [],
      this.volunteerHoursThisYear = 0,
      this.eventsAttendedThisYear = 0,
      final List<String> upcomingEventIds = const [],
      final List<String> availableDays = const [],
      this.availabilityNotes,
      final List<String> skills = const [],
      final List<String> talents = const [],
      final List<String> completedTrainings = const [],
      final List<String> currentTrainings = const []})
      : _roles = roles,
        _ministries = ministries,
        _volunteerAreas = volunteerAreas,
        _upcomingEventIds = upcomingEventIds,
        _availableDays = availableDays,
        _skills = skills,
        _talents = talents,
        _completedTrainings = completedTrainings,
        _currentTrainings = currentTrainings,
        super._();

  factory _$EngagementInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$EngagementInfoImplFromJson(json);

// Rôles
  final List<ChurchRole> _roles;
// Rôles
  @override
  @JsonKey()
  List<ChurchRole> get roles {
    if (_roles is EqualUnmodifiableListView) return _roles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_roles);
  }

  @override
  final ChurchRoleType? primaryRole;
// Ministères
  final List<MinistryMembership> _ministries;
// Ministères
  @override
  @JsonKey()
  List<MinistryMembership> get ministries {
    if (_ministries is EqualUnmodifiableListView) return _ministries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ministries);
  }

// Cellule de maison
  @override
  final CellMembership? cell;
// Assiduité
  @override
  @JsonKey()
  final AttendanceLevel attendanceLevel;
  @override
  final DateTime? lastAttendanceDate;
  @override
  final DateTime? lastCellAttendanceDate;
  @override
  @JsonKey()
  final int attendanceStreakWeeks;
// Contributions
  @override
  @JsonKey()
  final bool isRegularTither;
  @override
  @JsonKey()
  final bool isOfferingGiver;
  @override
  final DateTime? lastContributionDate;
// Bénévolat
  final List<String> _volunteerAreas;
// Bénévolat
  @override
  @JsonKey()
  List<String> get volunteerAreas {
    if (_volunteerAreas is EqualUnmodifiableListView) return _volunteerAreas;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_volunteerAreas);
  }

  @override
  @JsonKey()
  final int volunteerHoursThisYear;
// Événements
  @override
  @JsonKey()
  final int eventsAttendedThisYear;
  final List<String> _upcomingEventIds;
  @override
  @JsonKey()
  List<String> get upcomingEventIds {
    if (_upcomingEventIds is EqualUnmodifiableListView)
      return _upcomingEventIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_upcomingEventIds);
  }

// Disponibilité
  final List<String> _availableDays;
// Disponibilité
  @override
  @JsonKey()
  List<String> get availableDays {
    if (_availableDays is EqualUnmodifiableListView) return _availableDays;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_availableDays);
  }

  @override
  final String? availabilityNotes;
  final List<String> _skills;
  @override
  @JsonKey()
  List<String> get skills {
    if (_skills is EqualUnmodifiableListView) return _skills;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_skills);
  }

  final List<String> _talents;
  @override
  @JsonKey()
  List<String> get talents {
    if (_talents is EqualUnmodifiableListView) return _talents;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_talents);
  }

// Formation suivie
  final List<String> _completedTrainings;
// Formation suivie
  @override
  @JsonKey()
  List<String> get completedTrainings {
    if (_completedTrainings is EqualUnmodifiableListView)
      return _completedTrainings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_completedTrainings);
  }

  final List<String> _currentTrainings;
  @override
  @JsonKey()
  List<String> get currentTrainings {
    if (_currentTrainings is EqualUnmodifiableListView)
      return _currentTrainings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_currentTrainings);
  }

  @override
  String toString() {
    return 'EngagementInfo(roles: $roles, primaryRole: $primaryRole, ministries: $ministries, cell: $cell, attendanceLevel: $attendanceLevel, lastAttendanceDate: $lastAttendanceDate, lastCellAttendanceDate: $lastCellAttendanceDate, attendanceStreakWeeks: $attendanceStreakWeeks, isRegularTither: $isRegularTither, isOfferingGiver: $isOfferingGiver, lastContributionDate: $lastContributionDate, volunteerAreas: $volunteerAreas, volunteerHoursThisYear: $volunteerHoursThisYear, eventsAttendedThisYear: $eventsAttendedThisYear, upcomingEventIds: $upcomingEventIds, availableDays: $availableDays, availabilityNotes: $availabilityNotes, skills: $skills, talents: $talents, completedTrainings: $completedTrainings, currentTrainings: $currentTrainings)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EngagementInfoImpl &&
            const DeepCollectionEquality().equals(other._roles, _roles) &&
            (identical(other.primaryRole, primaryRole) ||
                other.primaryRole == primaryRole) &&
            const DeepCollectionEquality()
                .equals(other._ministries, _ministries) &&
            (identical(other.cell, cell) || other.cell == cell) &&
            (identical(other.attendanceLevel, attendanceLevel) ||
                other.attendanceLevel == attendanceLevel) &&
            (identical(other.lastAttendanceDate, lastAttendanceDate) ||
                other.lastAttendanceDate == lastAttendanceDate) &&
            (identical(other.lastCellAttendanceDate, lastCellAttendanceDate) ||
                other.lastCellAttendanceDate == lastCellAttendanceDate) &&
            (identical(other.attendanceStreakWeeks, attendanceStreakWeeks) ||
                other.attendanceStreakWeeks == attendanceStreakWeeks) &&
            (identical(other.isRegularTither, isRegularTither) ||
                other.isRegularTither == isRegularTither) &&
            (identical(other.isOfferingGiver, isOfferingGiver) ||
                other.isOfferingGiver == isOfferingGiver) &&
            (identical(other.lastContributionDate, lastContributionDate) ||
                other.lastContributionDate == lastContributionDate) &&
            const DeepCollectionEquality()
                .equals(other._volunteerAreas, _volunteerAreas) &&
            (identical(other.volunteerHoursThisYear, volunteerHoursThisYear) ||
                other.volunteerHoursThisYear == volunteerHoursThisYear) &&
            (identical(other.eventsAttendedThisYear, eventsAttendedThisYear) ||
                other.eventsAttendedThisYear == eventsAttendedThisYear) &&
            const DeepCollectionEquality()
                .equals(other._upcomingEventIds, _upcomingEventIds) &&
            const DeepCollectionEquality()
                .equals(other._availableDays, _availableDays) &&
            (identical(other.availabilityNotes, availabilityNotes) ||
                other.availabilityNotes == availabilityNotes) &&
            const DeepCollectionEquality().equals(other._skills, _skills) &&
            const DeepCollectionEquality().equals(other._talents, _talents) &&
            const DeepCollectionEquality()
                .equals(other._completedTrainings, _completedTrainings) &&
            const DeepCollectionEquality()
                .equals(other._currentTrainings, _currentTrainings));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        const DeepCollectionEquality().hash(_roles),
        primaryRole,
        const DeepCollectionEquality().hash(_ministries),
        cell,
        attendanceLevel,
        lastAttendanceDate,
        lastCellAttendanceDate,
        attendanceStreakWeeks,
        isRegularTither,
        isOfferingGiver,
        lastContributionDate,
        const DeepCollectionEquality().hash(_volunteerAreas),
        volunteerHoursThisYear,
        eventsAttendedThisYear,
        const DeepCollectionEquality().hash(_upcomingEventIds),
        const DeepCollectionEquality().hash(_availableDays),
        availabilityNotes,
        const DeepCollectionEquality().hash(_skills),
        const DeepCollectionEquality().hash(_talents),
        const DeepCollectionEquality().hash(_completedTrainings),
        const DeepCollectionEquality().hash(_currentTrainings)
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EngagementInfoImplCopyWith<_$EngagementInfoImpl> get copyWith =>
      __$$EngagementInfoImplCopyWithImpl<_$EngagementInfoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EngagementInfoImplToJson(
      this,
    );
  }
}

abstract class _EngagementInfo extends EngagementInfo {
  const factory _EngagementInfo(
      {final List<ChurchRole> roles,
      final ChurchRoleType? primaryRole,
      final List<MinistryMembership> ministries,
      final CellMembership? cell,
      final AttendanceLevel attendanceLevel,
      final DateTime? lastAttendanceDate,
      final DateTime? lastCellAttendanceDate,
      final int attendanceStreakWeeks,
      final bool isRegularTither,
      final bool isOfferingGiver,
      final DateTime? lastContributionDate,
      final List<String> volunteerAreas,
      final int volunteerHoursThisYear,
      final int eventsAttendedThisYear,
      final List<String> upcomingEventIds,
      final List<String> availableDays,
      final String? availabilityNotes,
      final List<String> skills,
      final List<String> talents,
      final List<String> completedTrainings,
      final List<String> currentTrainings}) = _$EngagementInfoImpl;
  const _EngagementInfo._() : super._();

  factory _EngagementInfo.fromJson(Map<String, dynamic> json) =
      _$EngagementInfoImpl.fromJson;

  @override // Rôles
  List<ChurchRole> get roles;
  @override
  ChurchRoleType? get primaryRole;
  @override // Ministères
  List<MinistryMembership> get ministries;
  @override // Cellule de maison
  CellMembership? get cell;
  @override // Assiduité
  AttendanceLevel get attendanceLevel;
  @override
  DateTime? get lastAttendanceDate;
  @override
  DateTime? get lastCellAttendanceDate;
  @override
  int get attendanceStreakWeeks;
  @override // Contributions
  bool get isRegularTither;
  @override
  bool get isOfferingGiver;
  @override
  DateTime? get lastContributionDate;
  @override // Bénévolat
  List<String> get volunteerAreas;
  @override
  int get volunteerHoursThisYear;
  @override // Événements
  int get eventsAttendedThisYear;
  @override
  List<String> get upcomingEventIds;
  @override // Disponibilité
  List<String> get availableDays;
  @override
  String? get availabilityNotes;
  @override
  List<String> get skills;
  @override
  List<String> get talents;
  @override // Formation suivie
  List<String> get completedTrainings;
  @override
  List<String> get currentTrainings;
  @override
  @JsonKey(ignore: true)
  _$$EngagementInfoImplCopyWith<_$EngagementInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
