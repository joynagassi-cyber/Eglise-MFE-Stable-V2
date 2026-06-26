// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'module.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Module _$ModuleFromJson(Map<String, dynamic> json) {
  return _Module.fromJson(json);
}

/// @nodoc
mixin _$Module {
  /// ID unique du module
  String get id => throw _privateConstructorUsedError;

  /// Nom lisible du module
  String get name => throw _privateConstructorUsedError;

  /// Code unique du module (ex: 'members', 'finance')
  String get code => throw _privateConstructorUsedError;

  /// Description du module
  String get description => throw _privateConstructorUsedError;

  /// Icône du module (code Flutter Icons)
  String get icon => throw _privateConstructorUsedError;

  /// Catégorie du module (pour regroupement)
  ModuleCategory get category => throw _privateConstructorUsedError;

  /// Ordre d'affichage
  int get order => throw _privateConstructorUsedError;

  /// Niveau de confidentialité
  ModuleVisibility get visibility => throw _privateConstructorUsedError;

  /// Permissions requises par défaut pour accéder à ce module
  List<String> get requiredPermissions => throw _privateConstructorUsedError;

  /// Indique si ce module est public pour toute l'équipe
  bool get isPublicTeam => throw _privateConstructorUsedError;

  /// Routes associées à ce module
  List<String> get routes => throw _privateConstructorUsedError;

  /// Date de création
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Dernière modification
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Indique si le module est actif
  bool get isActive => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ModuleCopyWith<Module> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ModuleCopyWith<$Res> {
  factory $ModuleCopyWith(Module value, $Res Function(Module) then) =
      _$ModuleCopyWithImpl<$Res, Module>;
  @useResult
  $Res call(
      {String id,
      String name,
      String code,
      String description,
      String icon,
      ModuleCategory category,
      int order,
      ModuleVisibility visibility,
      List<String> requiredPermissions,
      bool isPublicTeam,
      List<String> routes,
      DateTime createdAt,
      DateTime? updatedAt,
      bool isActive});
}

/// @nodoc
class _$ModuleCopyWithImpl<$Res, $Val extends Module>
    implements $ModuleCopyWith<$Res> {
  _$ModuleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? code = null,
    Object? description = null,
    Object? icon = null,
    Object? category = null,
    Object? order = null,
    Object? visibility = null,
    Object? requiredPermissions = null,
    Object? isPublicTeam = null,
    Object? routes = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? isActive = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as ModuleCategory,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      visibility: null == visibility
          ? _value.visibility
          : visibility // ignore: cast_nullable_to_non_nullable
              as ModuleVisibility,
      requiredPermissions: null == requiredPermissions
          ? _value.requiredPermissions
          : requiredPermissions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isPublicTeam: null == isPublicTeam
          ? _value.isPublicTeam
          : isPublicTeam // ignore: cast_nullable_to_non_nullable
              as bool,
      routes: null == routes
          ? _value.routes
          : routes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ModuleImplCopyWith<$Res> implements $ModuleCopyWith<$Res> {
  factory _$$ModuleImplCopyWith(
          _$ModuleImpl value, $Res Function(_$ModuleImpl) then) =
      __$$ModuleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String code,
      String description,
      String icon,
      ModuleCategory category,
      int order,
      ModuleVisibility visibility,
      List<String> requiredPermissions,
      bool isPublicTeam,
      List<String> routes,
      DateTime createdAt,
      DateTime? updatedAt,
      bool isActive});
}

/// @nodoc
class __$$ModuleImplCopyWithImpl<$Res>
    extends _$ModuleCopyWithImpl<$Res, _$ModuleImpl>
    implements _$$ModuleImplCopyWith<$Res> {
  __$$ModuleImplCopyWithImpl(
      _$ModuleImpl _value, $Res Function(_$ModuleImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? code = null,
    Object? description = null,
    Object? icon = null,
    Object? category = null,
    Object? order = null,
    Object? visibility = null,
    Object? requiredPermissions = null,
    Object? isPublicTeam = null,
    Object? routes = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? isActive = null,
  }) {
    return _then(_$ModuleImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as ModuleCategory,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      visibility: null == visibility
          ? _value.visibility
          : visibility // ignore: cast_nullable_to_non_nullable
              as ModuleVisibility,
      requiredPermissions: null == requiredPermissions
          ? _value._requiredPermissions
          : requiredPermissions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isPublicTeam: null == isPublicTeam
          ? _value.isPublicTeam
          : isPublicTeam // ignore: cast_nullable_to_non_nullable
              as bool,
      routes: null == routes
          ? _value._routes
          : routes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ModuleImpl implements _Module {
  const _$ModuleImpl(
      {required this.id,
      required this.name,
      this.code = '',
      required this.description,
      required this.icon,
      required this.category,
      required this.order,
      required this.visibility,
      final List<String> requiredPermissions = const [],
      this.isPublicTeam = false,
      final List<String> routes = const [],
      required this.createdAt,
      this.updatedAt,
      this.isActive = true})
      : _requiredPermissions = requiredPermissions,
        _routes = routes;

  factory _$ModuleImpl.fromJson(Map<String, dynamic> json) =>
      _$$ModuleImplFromJson(json);

  /// ID unique du module
  @override
  final String id;

  /// Nom lisible du module
  @override
  final String name;

  /// Code unique du module (ex: 'members', 'finance')
  @override
  @JsonKey()
  final String code;

  /// Description du module
  @override
  final String description;

  /// Icône du module (code Flutter Icons)
  @override
  final String icon;

  /// Catégorie du module (pour regroupement)
  @override
  final ModuleCategory category;

  /// Ordre d'affichage
  @override
  final int order;

  /// Niveau de confidentialité
  @override
  final ModuleVisibility visibility;

  /// Permissions requises par défaut pour accéder à ce module
  final List<String> _requiredPermissions;

  /// Permissions requises par défaut pour accéder à ce module
  @override
  @JsonKey()
  List<String> get requiredPermissions {
    if (_requiredPermissions is EqualUnmodifiableListView)
      return _requiredPermissions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_requiredPermissions);
  }

  /// Indique si ce module est public pour toute l'équipe
  @override
  @JsonKey()
  final bool isPublicTeam;

  /// Routes associées à ce module
  final List<String> _routes;

  /// Routes associées à ce module
  @override
  @JsonKey()
  List<String> get routes {
    if (_routes is EqualUnmodifiableListView) return _routes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_routes);
  }

  /// Date de création
  @override
  final DateTime createdAt;

  /// Dernière modification
  @override
  final DateTime? updatedAt;

  /// Indique si le module est actif
  @override
  @JsonKey()
  final bool isActive;

  @override
  String toString() {
    return 'Module(id: $id, name: $name, code: $code, description: $description, icon: $icon, category: $category, order: $order, visibility: $visibility, requiredPermissions: $requiredPermissions, isPublicTeam: $isPublicTeam, routes: $routes, createdAt: $createdAt, updatedAt: $updatedAt, isActive: $isActive)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ModuleImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.visibility, visibility) ||
                other.visibility == visibility) &&
            const DeepCollectionEquality()
                .equals(other._requiredPermissions, _requiredPermissions) &&
            (identical(other.isPublicTeam, isPublicTeam) ||
                other.isPublicTeam == isPublicTeam) &&
            const DeepCollectionEquality().equals(other._routes, _routes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      code,
      description,
      icon,
      category,
      order,
      visibility,
      const DeepCollectionEquality().hash(_requiredPermissions),
      isPublicTeam,
      const DeepCollectionEquality().hash(_routes),
      createdAt,
      updatedAt,
      isActive);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ModuleImplCopyWith<_$ModuleImpl> get copyWith =>
      __$$ModuleImplCopyWithImpl<_$ModuleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ModuleImplToJson(
      this,
    );
  }
}

abstract class _Module implements Module {
  const factory _Module(
      {required final String id,
      required final String name,
      final String code,
      required final String description,
      required final String icon,
      required final ModuleCategory category,
      required final int order,
      required final ModuleVisibility visibility,
      final List<String> requiredPermissions,
      final bool isPublicTeam,
      final List<String> routes,
      required final DateTime createdAt,
      final DateTime? updatedAt,
      final bool isActive}) = _$ModuleImpl;

  factory _Module.fromJson(Map<String, dynamic> json) = _$ModuleImpl.fromJson;

  @override

  /// ID unique du module
  String get id;
  @override

  /// Nom lisible du module
  String get name;
  @override

  /// Code unique du module (ex: 'members', 'finance')
  String get code;
  @override

  /// Description du module
  String get description;
  @override

  /// Icône du module (code Flutter Icons)
  String get icon;
  @override

  /// Catégorie du module (pour regroupement)
  ModuleCategory get category;
  @override

  /// Ordre d'affichage
  int get order;
  @override

  /// Niveau de confidentialité
  ModuleVisibility get visibility;
  @override

  /// Permissions requises par défaut pour accéder à ce module
  List<String> get requiredPermissions;
  @override

  /// Indique si ce module est public pour toute l'équipe
  bool get isPublicTeam;
  @override

  /// Routes associées à ce module
  List<String> get routes;
  @override

  /// Date de création
  DateTime get createdAt;
  @override

  /// Dernière modification
  DateTime? get updatedAt;
  @override

  /// Indique si le module est actif
  bool get isActive;
  @override
  @JsonKey(ignore: true)
  _$$ModuleImplCopyWith<_$ModuleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
