// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'federation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$Federation {
  /// Identifiant unique de la fédération
  String get id => throw _privateConstructorUsedError;

  /// Nom de la fédération
  String get name => throw _privateConstructorUsedError;

  /// Type de fédération
  FederationType get type => throw _privateConstructorUsedError;

  /// Description/vision de la fédération
  String? get description => throw _privateConstructorUsedError;

  /// Siège administratif
  String? get headquarters => throw _privateConstructorUsedError;

  /// Liste des IDs des églises membres
  List<String> get memberChurchIds => throw _privateConstructorUsedError;

  /// ID de l'église principale/siège (si applicable)
  String? get leadChurchId => throw _privateConstructorUsedError;

  /// Responsable de la fédération (ID utilisateur)
  String? get leaderId => throw _privateConstructorUsedError;

  /// Email de contact de la fédération
  String? get email => throw _privateConstructorUsedError;

  /// Téléphone de contact
  String? get phone => throw _privateConstructorUsedError;

  /// Site web de la fédération
  String? get website => throw _privateConstructorUsedError;

  /// Logo de la fédération (URL)
  String? get logoUrl => throw _privateConstructorUsedError;

  /// Nombre total de membres (agrégé de toutes les églises)
  int get totalMembers => throw _privateConstructorUsedError;

  /// Date de création de la fédération
  DateTime? get establishedDate => throw _privateConstructorUsedError;

  /// Métadonnées de synchronisation
  bool get isSynced => throw _privateConstructorUsedError;
  DateTime? get lastSyncedAt => throw _privateConstructorUsedError;

  /// Timestamps
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $FederationCopyWith<Federation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FederationCopyWith<$Res> {
  factory $FederationCopyWith(
          Federation value, $Res Function(Federation) then) =
      _$FederationCopyWithImpl<$Res, Federation>;
  @useResult
  $Res call(
      {String id,
      String name,
      FederationType type,
      String? description,
      String? headquarters,
      List<String> memberChurchIds,
      String? leadChurchId,
      String? leaderId,
      String? email,
      String? phone,
      String? website,
      String? logoUrl,
      int totalMembers,
      DateTime? establishedDate,
      bool isSynced,
      DateTime? lastSyncedAt,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$FederationCopyWithImpl<$Res, $Val extends Federation>
    implements $FederationCopyWith<$Res> {
  _$FederationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? description = freezed,
    Object? headquarters = freezed,
    Object? memberChurchIds = null,
    Object? leadChurchId = freezed,
    Object? leaderId = freezed,
    Object? email = freezed,
    Object? phone = freezed,
    Object? website = freezed,
    Object? logoUrl = freezed,
    Object? totalMembers = null,
    Object? establishedDate = freezed,
    Object? isSynced = null,
    Object? lastSyncedAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
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
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as FederationType,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      headquarters: freezed == headquarters
          ? _value.headquarters
          : headquarters // ignore: cast_nullable_to_non_nullable
              as String?,
      memberChurchIds: null == memberChurchIds
          ? _value.memberChurchIds
          : memberChurchIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      leadChurchId: freezed == leadChurchId
          ? _value.leadChurchId
          : leadChurchId // ignore: cast_nullable_to_non_nullable
              as String?,
      leaderId: freezed == leaderId
          ? _value.leaderId
          : leaderId // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      website: freezed == website
          ? _value.website
          : website // ignore: cast_nullable_to_non_nullable
              as String?,
      logoUrl: freezed == logoUrl
          ? _value.logoUrl
          : logoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      totalMembers: null == totalMembers
          ? _value.totalMembers
          : totalMembers // ignore: cast_nullable_to_non_nullable
              as int,
      establishedDate: freezed == establishedDate
          ? _value.establishedDate
          : establishedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isSynced: null == isSynced
          ? _value.isSynced
          : isSynced // ignore: cast_nullable_to_non_nullable
              as bool,
      lastSyncedAt: freezed == lastSyncedAt
          ? _value.lastSyncedAt
          : lastSyncedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FederationImplCopyWith<$Res>
    implements $FederationCopyWith<$Res> {
  factory _$$FederationImplCopyWith(
          _$FederationImpl value, $Res Function(_$FederationImpl) then) =
      __$$FederationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      FederationType type,
      String? description,
      String? headquarters,
      List<String> memberChurchIds,
      String? leadChurchId,
      String? leaderId,
      String? email,
      String? phone,
      String? website,
      String? logoUrl,
      int totalMembers,
      DateTime? establishedDate,
      bool isSynced,
      DateTime? lastSyncedAt,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$FederationImplCopyWithImpl<$Res>
    extends _$FederationCopyWithImpl<$Res, _$FederationImpl>
    implements _$$FederationImplCopyWith<$Res> {
  __$$FederationImplCopyWithImpl(
      _$FederationImpl _value, $Res Function(_$FederationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? description = freezed,
    Object? headquarters = freezed,
    Object? memberChurchIds = null,
    Object? leadChurchId = freezed,
    Object? leaderId = freezed,
    Object? email = freezed,
    Object? phone = freezed,
    Object? website = freezed,
    Object? logoUrl = freezed,
    Object? totalMembers = null,
    Object? establishedDate = freezed,
    Object? isSynced = null,
    Object? lastSyncedAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_$FederationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as FederationType,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      headquarters: freezed == headquarters
          ? _value.headquarters
          : headquarters // ignore: cast_nullable_to_non_nullable
              as String?,
      memberChurchIds: null == memberChurchIds
          ? _value._memberChurchIds
          : memberChurchIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      leadChurchId: freezed == leadChurchId
          ? _value.leadChurchId
          : leadChurchId // ignore: cast_nullable_to_non_nullable
              as String?,
      leaderId: freezed == leaderId
          ? _value.leaderId
          : leaderId // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      website: freezed == website
          ? _value.website
          : website // ignore: cast_nullable_to_non_nullable
              as String?,
      logoUrl: freezed == logoUrl
          ? _value.logoUrl
          : logoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      totalMembers: null == totalMembers
          ? _value.totalMembers
          : totalMembers // ignore: cast_nullable_to_non_nullable
              as int,
      establishedDate: freezed == establishedDate
          ? _value.establishedDate
          : establishedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isSynced: null == isSynced
          ? _value.isSynced
          : isSynced // ignore: cast_nullable_to_non_nullable
              as bool,
      lastSyncedAt: freezed == lastSyncedAt
          ? _value.lastSyncedAt
          : lastSyncedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$FederationImpl extends _Federation {
  const _$FederationImpl(
      {required this.id,
      required this.name,
      required this.type,
      this.description,
      this.headquarters,
      final List<String> memberChurchIds = const [],
      this.leadChurchId,
      this.leaderId,
      this.email,
      this.phone,
      this.website,
      this.logoUrl,
      this.totalMembers = 0,
      this.establishedDate,
      this.isSynced = false,
      this.lastSyncedAt,
      required this.createdAt,
      this.updatedAt})
      : _memberChurchIds = memberChurchIds,
        super._();

  /// Identifiant unique de la fédération
  @override
  final String id;

  /// Nom de la fédération
  @override
  final String name;

  /// Type de fédération
  @override
  final FederationType type;

  /// Description/vision de la fédération
  @override
  final String? description;

  /// Siège administratif
  @override
  final String? headquarters;

  /// Liste des IDs des églises membres
  final List<String> _memberChurchIds;

  /// Liste des IDs des églises membres
  @override
  @JsonKey()
  List<String> get memberChurchIds {
    if (_memberChurchIds is EqualUnmodifiableListView) return _memberChurchIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_memberChurchIds);
  }

  /// ID de l'église principale/siège (si applicable)
  @override
  final String? leadChurchId;

  /// Responsable de la fédération (ID utilisateur)
  @override
  final String? leaderId;

  /// Email de contact de la fédération
  @override
  final String? email;

  /// Téléphone de contact
  @override
  final String? phone;

  /// Site web de la fédération
  @override
  final String? website;

  /// Logo de la fédération (URL)
  @override
  final String? logoUrl;

  /// Nombre total de membres (agrégé de toutes les églises)
  @override
  @JsonKey()
  final int totalMembers;

  /// Date de création de la fédération
  @override
  final DateTime? establishedDate;

  /// Métadonnées de synchronisation
  @override
  @JsonKey()
  final bool isSynced;
  @override
  final DateTime? lastSyncedAt;

  /// Timestamps
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Federation(id: $id, name: $name, type: $type, description: $description, headquarters: $headquarters, memberChurchIds: $memberChurchIds, leadChurchId: $leadChurchId, leaderId: $leaderId, email: $email, phone: $phone, website: $website, logoUrl: $logoUrl, totalMembers: $totalMembers, establishedDate: $establishedDate, isSynced: $isSynced, lastSyncedAt: $lastSyncedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FederationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.headquarters, headquarters) ||
                other.headquarters == headquarters) &&
            const DeepCollectionEquality()
                .equals(other._memberChurchIds, _memberChurchIds) &&
            (identical(other.leadChurchId, leadChurchId) ||
                other.leadChurchId == leadChurchId) &&
            (identical(other.leaderId, leaderId) ||
                other.leaderId == leaderId) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.website, website) || other.website == website) &&
            (identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl) &&
            (identical(other.totalMembers, totalMembers) ||
                other.totalMembers == totalMembers) &&
            (identical(other.establishedDate, establishedDate) ||
                other.establishedDate == establishedDate) &&
            (identical(other.isSynced, isSynced) ||
                other.isSynced == isSynced) &&
            (identical(other.lastSyncedAt, lastSyncedAt) ||
                other.lastSyncedAt == lastSyncedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      type,
      description,
      headquarters,
      const DeepCollectionEquality().hash(_memberChurchIds),
      leadChurchId,
      leaderId,
      email,
      phone,
      website,
      logoUrl,
      totalMembers,
      establishedDate,
      isSynced,
      lastSyncedAt,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FederationImplCopyWith<_$FederationImpl> get copyWith =>
      __$$FederationImplCopyWithImpl<_$FederationImpl>(this, _$identity);
}

abstract class _Federation extends Federation {
  const factory _Federation(
      {required final String id,
      required final String name,
      required final FederationType type,
      final String? description,
      final String? headquarters,
      final List<String> memberChurchIds,
      final String? leadChurchId,
      final String? leaderId,
      final String? email,
      final String? phone,
      final String? website,
      final String? logoUrl,
      final int totalMembers,
      final DateTime? establishedDate,
      final bool isSynced,
      final DateTime? lastSyncedAt,
      required final DateTime createdAt,
      final DateTime? updatedAt}) = _$FederationImpl;
  const _Federation._() : super._();

  @override

  /// Identifiant unique de la fédération
  String get id;
  @override

  /// Nom de la fédération
  String get name;
  @override

  /// Type de fédération
  FederationType get type;
  @override

  /// Description/vision de la fédération
  String? get description;
  @override

  /// Siège administratif
  String? get headquarters;
  @override

  /// Liste des IDs des églises membres
  List<String> get memberChurchIds;
  @override

  /// ID de l'église principale/siège (si applicable)
  String? get leadChurchId;
  @override

  /// Responsable de la fédération (ID utilisateur)
  String? get leaderId;
  @override

  /// Email de contact de la fédération
  String? get email;
  @override

  /// Téléphone de contact
  String? get phone;
  @override

  /// Site web de la fédération
  String? get website;
  @override

  /// Logo de la fédération (URL)
  String? get logoUrl;
  @override

  /// Nombre total de membres (agrégé de toutes les églises)
  int get totalMembers;
  @override

  /// Date de création de la fédération
  DateTime? get establishedDate;
  @override

  /// Métadonnées de synchronisation
  bool get isSynced;
  @override
  DateTime? get lastSyncedAt;
  @override

  /// Timestamps
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$FederationImplCopyWith<_$FederationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
