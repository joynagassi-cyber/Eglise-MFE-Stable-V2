// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'church_role.dart';

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
  /// Identifiant unique du rôle
  String get id => throw _privateConstructorUsedError;

  /// Église à laquelle appartient ce rôle
  String get churchId => throw _privateConstructorUsedError;

  /// Niveau du rôle (prédéfini ou custom)
  RoleLevel get level => throw _privateConstructorUsedError;

  /// Nom du rôle (peut être personnalisé)
  String get name => throw _privateConstructorUsedError;

  /// Description du rôle
  String? get description => throw _privateConstructorUsedError;

  /// Ensemble des permissions accordées à ce rôle
  Set<Permission> get permissions => throw _privateConstructorUsedError;

  /// Indique si ce rôle est actif
  bool get isActive => throw _privateConstructorUsedError;

  /// Indique si ce rôle est un rôle système (non modifiable)
  bool get isSystemRole => throw _privateConstructorUsedError;

  /// Date de création
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Route initiale de redirection (ex: /dashboard/group/chorale)
  String get initialRoute => throw _privateConstructorUsedError;

  /// Date de dernière modification
  DateTime? get updatedAt => throw _privateConstructorUsedError;

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
      {String id,
      String churchId,
      RoleLevel level,
      String name,
      String? description,
      Set<Permission> permissions,
      bool isActive,
      bool isSystemRole,
      DateTime createdAt,
      String initialRoute,
      DateTime? updatedAt});
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
    Object? id = null,
    Object? churchId = null,
    Object? level = null,
    Object? name = null,
    Object? description = freezed,
    Object? permissions = null,
    Object? isActive = null,
    Object? isSystemRole = null,
    Object? createdAt = null,
    Object? initialRoute = null,
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
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as RoleLevel,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      permissions: null == permissions
          ? _value.permissions
          : permissions // ignore: cast_nullable_to_non_nullable
              as Set<Permission>,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isSystemRole: null == isSystemRole
          ? _value.isSystemRole
          : isSystemRole // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      initialRoute: null == initialRoute
          ? _value.initialRoute
          : initialRoute // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
      {String id,
      String churchId,
      RoleLevel level,
      String name,
      String? description,
      Set<Permission> permissions,
      bool isActive,
      bool isSystemRole,
      DateTime createdAt,
      String initialRoute,
      DateTime? updatedAt});
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
    Object? id = null,
    Object? churchId = null,
    Object? level = null,
    Object? name = null,
    Object? description = freezed,
    Object? permissions = null,
    Object? isActive = null,
    Object? isSystemRole = null,
    Object? createdAt = null,
    Object? initialRoute = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_$ChurchRoleImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      churchId: null == churchId
          ? _value.churchId
          : churchId // ignore: cast_nullable_to_non_nullable
              as String,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as RoleLevel,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      permissions: null == permissions
          ? _value._permissions
          : permissions // ignore: cast_nullable_to_non_nullable
              as Set<Permission>,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isSystemRole: null == isSystemRole
          ? _value.isSystemRole
          : isSystemRole // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      initialRoute: null == initialRoute
          ? _value.initialRoute
          : initialRoute // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChurchRoleImpl extends _ChurchRole {
  const _$ChurchRoleImpl(
      {required this.id,
      required this.churchId,
      required this.level,
      required this.name,
      this.description,
      required final Set<Permission> permissions,
      this.isActive = true,
      this.isSystemRole = false,
      required this.createdAt,
      required this.initialRoute,
      this.updatedAt})
      : _permissions = permissions,
        super._();

  factory _$ChurchRoleImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChurchRoleImplFromJson(json);

  /// Identifiant unique du rôle
  @override
  final String id;

  /// Église à laquelle appartient ce rôle
  @override
  final String churchId;

  /// Niveau du rôle (prédéfini ou custom)
  @override
  final RoleLevel level;

  /// Nom du rôle (peut être personnalisé)
  @override
  final String name;

  /// Description du rôle
  @override
  final String? description;

  /// Ensemble des permissions accordées à ce rôle
  final Set<Permission> _permissions;

  /// Ensemble des permissions accordées à ce rôle
  @override
  Set<Permission> get permissions {
    if (_permissions is EqualUnmodifiableSetView) return _permissions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_permissions);
  }

  /// Indique si ce rôle est actif
  @override
  @JsonKey()
  final bool isActive;

  /// Indique si ce rôle est un rôle système (non modifiable)
  @override
  @JsonKey()
  final bool isSystemRole;

  /// Date de création
  @override
  final DateTime createdAt;

  /// Route initiale de redirection (ex: /dashboard/group/chorale)
  @override
  final String initialRoute;

  /// Date de dernière modification
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'ChurchRole(id: $id, churchId: $churchId, level: $level, name: $name, description: $description, permissions: $permissions, isActive: $isActive, isSystemRole: $isSystemRole, createdAt: $createdAt, initialRoute: $initialRoute, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChurchRoleImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.churchId, churchId) ||
                other.churchId == churchId) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality()
                .equals(other._permissions, _permissions) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isSystemRole, isSystemRole) ||
                other.isSystemRole == isSystemRole) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.initialRoute, initialRoute) ||
                other.initialRoute == initialRoute) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      churchId,
      level,
      name,
      description,
      const DeepCollectionEquality().hash(_permissions),
      isActive,
      isSystemRole,
      createdAt,
      initialRoute,
      updatedAt);

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
      {required final String id,
      required final String churchId,
      required final RoleLevel level,
      required final String name,
      final String? description,
      required final Set<Permission> permissions,
      final bool isActive,
      final bool isSystemRole,
      required final DateTime createdAt,
      required final String initialRoute,
      final DateTime? updatedAt}) = _$ChurchRoleImpl;
  const _ChurchRole._() : super._();

  factory _ChurchRole.fromJson(Map<String, dynamic> json) =
      _$ChurchRoleImpl.fromJson;

  @override

  /// Identifiant unique du rôle
  String get id;
  @override

  /// Église à laquelle appartient ce rôle
  String get churchId;
  @override

  /// Niveau du rôle (prédéfini ou custom)
  RoleLevel get level;
  @override

  /// Nom du rôle (peut être personnalisé)
  String get name;
  @override

  /// Description du rôle
  String? get description;
  @override

  /// Ensemble des permissions accordées à ce rôle
  Set<Permission> get permissions;
  @override

  /// Indique si ce rôle est actif
  bool get isActive;
  @override

  /// Indique si ce rôle est un rôle système (non modifiable)
  bool get isSystemRole;
  @override

  /// Date de création
  DateTime get createdAt;
  @override

  /// Route initiale de redirection (ex: /dashboard/group/chorale)
  String get initialRoute;
  @override

  /// Date de dernière modification
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$ChurchRoleImplCopyWith<_$ChurchRoleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
