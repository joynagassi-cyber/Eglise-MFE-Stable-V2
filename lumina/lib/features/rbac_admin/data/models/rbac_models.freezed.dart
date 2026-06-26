// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rbac_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Permission _$PermissionFromJson(Map<String, dynamic> json) {
  return _Permission.fromJson(json);
}

/// @nodoc
mixin _$Permission {
  String get id => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String get module => throw _privateConstructorUsedError;
  String get category =>
      throw _privateConstructorUsedError; // read, write, etc.
  bool get isSensitive => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PermissionCopyWith<Permission> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PermissionCopyWith<$Res> {
  factory $PermissionCopyWith(
          Permission value, $Res Function(Permission) then) =
      _$PermissionCopyWithImpl<$Res, Permission>;
  @useResult
  $Res call(
      {String id,
      String code,
      String label,
      String? description,
      String module,
      String category,
      bool isSensitive});
}

/// @nodoc
class _$PermissionCopyWithImpl<$Res, $Val extends Permission>
    implements $PermissionCopyWith<$Res> {
  _$PermissionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? label = null,
    Object? description = freezed,
    Object? module = null,
    Object? category = null,
    Object? isSensitive = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      module: null == module
          ? _value.module
          : module // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      isSensitive: null == isSensitive
          ? _value.isSensitive
          : isSensitive // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PermissionImplCopyWith<$Res>
    implements $PermissionCopyWith<$Res> {
  factory _$$PermissionImplCopyWith(
          _$PermissionImpl value, $Res Function(_$PermissionImpl) then) =
      __$$PermissionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String code,
      String label,
      String? description,
      String module,
      String category,
      bool isSensitive});
}

/// @nodoc
class __$$PermissionImplCopyWithImpl<$Res>
    extends _$PermissionCopyWithImpl<$Res, _$PermissionImpl>
    implements _$$PermissionImplCopyWith<$Res> {
  __$$PermissionImplCopyWithImpl(
      _$PermissionImpl _value, $Res Function(_$PermissionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? label = null,
    Object? description = freezed,
    Object? module = null,
    Object? category = null,
    Object? isSensitive = null,
  }) {
    return _then(_$PermissionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      module: null == module
          ? _value.module
          : module // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      isSensitive: null == isSensitive
          ? _value.isSensitive
          : isSensitive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PermissionImpl implements _Permission {
  const _$PermissionImpl(
      {required this.id,
      required this.code,
      required this.label,
      this.description,
      required this.module,
      required this.category,
      this.isSensitive = false});

  factory _$PermissionImpl.fromJson(Map<String, dynamic> json) =>
      _$$PermissionImplFromJson(json);

  @override
  final String id;
  @override
  final String code;
  @override
  final String label;
  @override
  final String? description;
  @override
  final String module;
  @override
  final String category;
// read, write, etc.
  @override
  @JsonKey()
  final bool isSensitive;

  @override
  String toString() {
    return 'Permission(id: $id, code: $code, label: $label, description: $description, module: $module, category: $category, isSensitive: $isSensitive)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PermissionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.module, module) || other.module == module) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.isSensitive, isSensitive) ||
                other.isSensitive == isSensitive));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, code, label, description, module, category, isSensitive);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PermissionImplCopyWith<_$PermissionImpl> get copyWith =>
      __$$PermissionImplCopyWithImpl<_$PermissionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PermissionImplToJson(
      this,
    );
  }
}

abstract class _Permission implements Permission {
  const factory _Permission(
      {required final String id,
      required final String code,
      required final String label,
      final String? description,
      required final String module,
      required final String category,
      final bool isSensitive}) = _$PermissionImpl;

  factory _Permission.fromJson(Map<String, dynamic> json) =
      _$PermissionImpl.fromJson;

  @override
  String get id;
  @override
  String get code;
  @override
  String get label;
  @override
  String? get description;
  @override
  String get module;
  @override
  String get category;
  @override // read, write, etc.
  bool get isSensitive;
  @override
  @JsonKey(ignore: true)
  _$$PermissionImplCopyWith<_$PermissionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Role _$RoleFromJson(Map<String, dynamic> json) {
  return _Role.fromJson(json);
}

/// @nodoc
mixin _$Role {
  String get id => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  bool get isSuper => throw _privateConstructorUsedError;
  int get priorityLevel => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RoleCopyWith<Role> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoleCopyWith<$Res> {
  factory $RoleCopyWith(Role value, $Res Function(Role) then) =
      _$RoleCopyWithImpl<$Res, Role>;
  @useResult
  $Res call(
      {String id, String code, String label, bool isSuper, int priorityLevel});
}

/// @nodoc
class _$RoleCopyWithImpl<$Res, $Val extends Role>
    implements $RoleCopyWith<$Res> {
  _$RoleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? label = null,
    Object? isSuper = null,
    Object? priorityLevel = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      isSuper: null == isSuper
          ? _value.isSuper
          : isSuper // ignore: cast_nullable_to_non_nullable
              as bool,
      priorityLevel: null == priorityLevel
          ? _value.priorityLevel
          : priorityLevel // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RoleImplCopyWith<$Res> implements $RoleCopyWith<$Res> {
  factory _$$RoleImplCopyWith(
          _$RoleImpl value, $Res Function(_$RoleImpl) then) =
      __$$RoleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id, String code, String label, bool isSuper, int priorityLevel});
}

/// @nodoc
class __$$RoleImplCopyWithImpl<$Res>
    extends _$RoleCopyWithImpl<$Res, _$RoleImpl>
    implements _$$RoleImplCopyWith<$Res> {
  __$$RoleImplCopyWithImpl(_$RoleImpl _value, $Res Function(_$RoleImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? label = null,
    Object? isSuper = null,
    Object? priorityLevel = null,
  }) {
    return _then(_$RoleImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      isSuper: null == isSuper
          ? _value.isSuper
          : isSuper // ignore: cast_nullable_to_non_nullable
              as bool,
      priorityLevel: null == priorityLevel
          ? _value.priorityLevel
          : priorityLevel // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RoleImpl implements _Role {
  const _$RoleImpl(
      {required this.id,
      required this.code,
      required this.label,
      this.isSuper = false,
      this.priorityLevel = 0});

  factory _$RoleImpl.fromJson(Map<String, dynamic> json) =>
      _$$RoleImplFromJson(json);

  @override
  final String id;
  @override
  final String code;
  @override
  final String label;
  @override
  @JsonKey()
  final bool isSuper;
  @override
  @JsonKey()
  final int priorityLevel;

  @override
  String toString() {
    return 'Role(id: $id, code: $code, label: $label, isSuper: $isSuper, priorityLevel: $priorityLevel)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoleImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.isSuper, isSuper) || other.isSuper == isSuper) &&
            (identical(other.priorityLevel, priorityLevel) ||
                other.priorityLevel == priorityLevel));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, code, label, isSuper, priorityLevel);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RoleImplCopyWith<_$RoleImpl> get copyWith =>
      __$$RoleImplCopyWithImpl<_$RoleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RoleImplToJson(
      this,
    );
  }
}

abstract class _Role implements Role {
  const factory _Role(
      {required final String id,
      required final String code,
      required final String label,
      final bool isSuper,
      final int priorityLevel}) = _$RoleImpl;

  factory _Role.fromJson(Map<String, dynamic> json) = _$RoleImpl.fromJson;

  @override
  String get id;
  @override
  String get code;
  @override
  String get label;
  @override
  bool get isSuper;
  @override
  int get priorityLevel;
  @override
  @JsonKey(ignore: true)
  _$$RoleImplCopyWith<_$RoleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$RoleWithPermissions {
  Role get role => throw _privateConstructorUsedError;
  List<String> get permissionCodes => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $RoleWithPermissionsCopyWith<RoleWithPermissions> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoleWithPermissionsCopyWith<$Res> {
  factory $RoleWithPermissionsCopyWith(
          RoleWithPermissions value, $Res Function(RoleWithPermissions) then) =
      _$RoleWithPermissionsCopyWithImpl<$Res, RoleWithPermissions>;
  @useResult
  $Res call({Role role, List<String> permissionCodes});

  $RoleCopyWith<$Res> get role;
}

/// @nodoc
class _$RoleWithPermissionsCopyWithImpl<$Res, $Val extends RoleWithPermissions>
    implements $RoleWithPermissionsCopyWith<$Res> {
  _$RoleWithPermissionsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? role = null,
    Object? permissionCodes = null,
  }) {
    return _then(_value.copyWith(
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as Role,
      permissionCodes: null == permissionCodes
          ? _value.permissionCodes
          : permissionCodes // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $RoleCopyWith<$Res> get role {
    return $RoleCopyWith<$Res>(_value.role, (value) {
      return _then(_value.copyWith(role: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RoleWithPermissionsImplCopyWith<$Res>
    implements $RoleWithPermissionsCopyWith<$Res> {
  factory _$$RoleWithPermissionsImplCopyWith(_$RoleWithPermissionsImpl value,
          $Res Function(_$RoleWithPermissionsImpl) then) =
      __$$RoleWithPermissionsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Role role, List<String> permissionCodes});

  @override
  $RoleCopyWith<$Res> get role;
}

/// @nodoc
class __$$RoleWithPermissionsImplCopyWithImpl<$Res>
    extends _$RoleWithPermissionsCopyWithImpl<$Res, _$RoleWithPermissionsImpl>
    implements _$$RoleWithPermissionsImplCopyWith<$Res> {
  __$$RoleWithPermissionsImplCopyWithImpl(_$RoleWithPermissionsImpl _value,
      $Res Function(_$RoleWithPermissionsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? role = null,
    Object? permissionCodes = null,
  }) {
    return _then(_$RoleWithPermissionsImpl(
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as Role,
      permissionCodes: null == permissionCodes
          ? _value._permissionCodes
          : permissionCodes // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc

class _$RoleWithPermissionsImpl implements _RoleWithPermissions {
  const _$RoleWithPermissionsImpl(
      {required this.role, required final List<String> permissionCodes})
      : _permissionCodes = permissionCodes;

  @override
  final Role role;
  final List<String> _permissionCodes;
  @override
  List<String> get permissionCodes {
    if (_permissionCodes is EqualUnmodifiableListView) return _permissionCodes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_permissionCodes);
  }

  @override
  String toString() {
    return 'RoleWithPermissions(role: $role, permissionCodes: $permissionCodes)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoleWithPermissionsImpl &&
            (identical(other.role, role) || other.role == role) &&
            const DeepCollectionEquality()
                .equals(other._permissionCodes, _permissionCodes));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, role, const DeepCollectionEquality().hash(_permissionCodes));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RoleWithPermissionsImplCopyWith<_$RoleWithPermissionsImpl> get copyWith =>
      __$$RoleWithPermissionsImplCopyWithImpl<_$RoleWithPermissionsImpl>(
          this, _$identity);
}

abstract class _RoleWithPermissions implements RoleWithPermissions {
  const factory _RoleWithPermissions(
      {required final Role role,
      required final List<String> permissionCodes}) = _$RoleWithPermissionsImpl;

  @override
  Role get role;
  @override
  List<String> get permissionCodes;
  @override
  @JsonKey(ignore: true)
  _$$RoleWithPermissionsImplCopyWith<_$RoleWithPermissionsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
