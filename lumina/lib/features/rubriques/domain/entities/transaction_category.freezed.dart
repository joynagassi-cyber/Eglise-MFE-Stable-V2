// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_category.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

TransactionCategory _$TransactionCategoryFromJson(Map<String, dynamic> json) {
  return _TransactionCategory.fromJson(json);
}

/// @nodoc
mixin _$TransactionCategory {
  /// Identifiant unique de la catégorie
  String get id => throw _privateConstructorUsedError;

  /// ID de l'église propriétaire (multi-église support)
  String get churchId => throw _privateConstructorUsedError;

  /// Nom de la catégorie (ex: "Dîmes", "Salaires Pasteurs")
  String get name => throw _privateConstructorUsedError;

  /// Type de catégorie (revenu ou dépense)
  CategoryType get type => throw _privateConstructorUsedError;

  /// ID de la catégorie parente (null si catégorie racine)
  String? get parentId => throw _privateConstructorUsedError;

  /// Nom de l'icône Material (ex: "payments", "church", "volunteer_activism")
  String get iconName => throw _privateConstructorUsedError;

  /// Couleur en format hex (ex: "#4CAF50" pour vert)
  String get color => throw _privateConstructorUsedError;

  /// Indique si cette catégorie peut avoir un budget associé
  bool get isBudgetable => throw _privateConstructorUsedError;

  /// Ordre d'affichage (pour tri personnalisé)
  int get sortOrder => throw _privateConstructorUsedError;

  /// Indique si la catégorie est active (soft delete)
  bool get isActive => throw _privateConstructorUsedError;

  /// Date de création
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Date de dernière modification
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TransactionCategoryCopyWith<TransactionCategory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionCategoryCopyWith<$Res> {
  factory $TransactionCategoryCopyWith(
          TransactionCategory value, $Res Function(TransactionCategory) then) =
      _$TransactionCategoryCopyWithImpl<$Res, TransactionCategory>;
  @useResult
  $Res call(
      {String id,
      String churchId,
      String name,
      CategoryType type,
      String? parentId,
      String iconName,
      String color,
      bool isBudgetable,
      int sortOrder,
      bool isActive,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$TransactionCategoryCopyWithImpl<$Res, $Val extends TransactionCategory>
    implements $TransactionCategoryCopyWith<$Res> {
  _$TransactionCategoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? churchId = null,
    Object? name = null,
    Object? type = null,
    Object? parentId = freezed,
    Object? iconName = null,
    Object? color = null,
    Object? isBudgetable = null,
    Object? sortOrder = null,
    Object? isActive = null,
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
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as CategoryType,
      parentId: freezed == parentId
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String?,
      iconName: null == iconName
          ? _value.iconName
          : iconName // ignore: cast_nullable_to_non_nullable
              as String,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String,
      isBudgetable: null == isBudgetable
          ? _value.isBudgetable
          : isBudgetable // ignore: cast_nullable_to_non_nullable
              as bool,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
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
abstract class _$$TransactionCategoryImplCopyWith<$Res>
    implements $TransactionCategoryCopyWith<$Res> {
  factory _$$TransactionCategoryImplCopyWith(_$TransactionCategoryImpl value,
          $Res Function(_$TransactionCategoryImpl) then) =
      __$$TransactionCategoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String churchId,
      String name,
      CategoryType type,
      String? parentId,
      String iconName,
      String color,
      bool isBudgetable,
      int sortOrder,
      bool isActive,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$TransactionCategoryImplCopyWithImpl<$Res>
    extends _$TransactionCategoryCopyWithImpl<$Res, _$TransactionCategoryImpl>
    implements _$$TransactionCategoryImplCopyWith<$Res> {
  __$$TransactionCategoryImplCopyWithImpl(_$TransactionCategoryImpl _value,
      $Res Function(_$TransactionCategoryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? churchId = null,
    Object? name = null,
    Object? type = null,
    Object? parentId = freezed,
    Object? iconName = null,
    Object? color = null,
    Object? isBudgetable = null,
    Object? sortOrder = null,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$TransactionCategoryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      churchId: null == churchId
          ? _value.churchId
          : churchId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as CategoryType,
      parentId: freezed == parentId
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String?,
      iconName: null == iconName
          ? _value.iconName
          : iconName // ignore: cast_nullable_to_non_nullable
              as String,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String,
      isBudgetable: null == isBudgetable
          ? _value.isBudgetable
          : isBudgetable // ignore: cast_nullable_to_non_nullable
              as bool,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
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
class _$TransactionCategoryImpl extends _TransactionCategory {
  const _$TransactionCategoryImpl(
      {required this.id,
      required this.churchId,
      required this.name,
      required this.type,
      this.parentId,
      this.iconName = 'category',
      this.color = '#9E9E9E',
      this.isBudgetable = true,
      this.sortOrder = 0,
      this.isActive = true,
      this.createdAt,
      this.updatedAt})
      : super._();

  factory _$TransactionCategoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransactionCategoryImplFromJson(json);

  /// Identifiant unique de la catégorie
  @override
  final String id;

  /// ID de l'église propriétaire (multi-église support)
  @override
  final String churchId;

  /// Nom de la catégorie (ex: "Dîmes", "Salaires Pasteurs")
  @override
  final String name;

  /// Type de catégorie (revenu ou dépense)
  @override
  final CategoryType type;

  /// ID de la catégorie parente (null si catégorie racine)
  @override
  final String? parentId;

  /// Nom de l'icône Material (ex: "payments", "church", "volunteer_activism")
  @override
  @JsonKey()
  final String iconName;

  /// Couleur en format hex (ex: "#4CAF50" pour vert)
  @override
  @JsonKey()
  final String color;

  /// Indique si cette catégorie peut avoir un budget associé
  @override
  @JsonKey()
  final bool isBudgetable;

  /// Ordre d'affichage (pour tri personnalisé)
  @override
  @JsonKey()
  final int sortOrder;

  /// Indique si la catégorie est active (soft delete)
  @override
  @JsonKey()
  final bool isActive;

  /// Date de création
  @override
  final DateTime? createdAt;

  /// Date de dernière modification
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'TransactionCategory(id: $id, churchId: $churchId, name: $name, type: $type, parentId: $parentId, iconName: $iconName, color: $color, isBudgetable: $isBudgetable, sortOrder: $sortOrder, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionCategoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.churchId, churchId) ||
                other.churchId == churchId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId) &&
            (identical(other.iconName, iconName) ||
                other.iconName == iconName) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.isBudgetable, isBudgetable) ||
                other.isBudgetable == isBudgetable) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
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
      name,
      type,
      parentId,
      iconName,
      color,
      isBudgetable,
      sortOrder,
      isActive,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionCategoryImplCopyWith<_$TransactionCategoryImpl> get copyWith =>
      __$$TransactionCategoryImplCopyWithImpl<_$TransactionCategoryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransactionCategoryImplToJson(
      this,
    );
  }
}

abstract class _TransactionCategory extends TransactionCategory {
  const factory _TransactionCategory(
      {required final String id,
      required final String churchId,
      required final String name,
      required final CategoryType type,
      final String? parentId,
      final String iconName,
      final String color,
      final bool isBudgetable,
      final int sortOrder,
      final bool isActive,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$TransactionCategoryImpl;
  const _TransactionCategory._() : super._();

  factory _TransactionCategory.fromJson(Map<String, dynamic> json) =
      _$TransactionCategoryImpl.fromJson;

  @override

  /// Identifiant unique de la catégorie
  String get id;
  @override

  /// ID de l'église propriétaire (multi-église support)
  String get churchId;
  @override

  /// Nom de la catégorie (ex: "Dîmes", "Salaires Pasteurs")
  String get name;
  @override

  /// Type de catégorie (revenu ou dépense)
  CategoryType get type;
  @override

  /// ID de la catégorie parente (null si catégorie racine)
  String? get parentId;
  @override

  /// Nom de l'icône Material (ex: "payments", "church", "volunteer_activism")
  String get iconName;
  @override

  /// Couleur en format hex (ex: "#4CAF50" pour vert)
  String get color;
  @override

  /// Indique si cette catégorie peut avoir un budget associé
  bool get isBudgetable;
  @override

  /// Ordre d'affichage (pour tri personnalisé)
  int get sortOrder;
  @override

  /// Indique si la catégorie est active (soft delete)
  bool get isActive;
  @override

  /// Date de création
  DateTime? get createdAt;
  @override

  /// Date de dernière modification
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$TransactionCategoryImplCopyWith<_$TransactionCategoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
