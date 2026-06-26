// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'church.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Church _$ChurchFromJson(Map<String, dynamic> json) {
  return _Church.fromJson(json);
}

/// @nodoc
mixin _$Church {
  /// Identifiant unique de l'église
  String get id => throw _privateConstructorUsedError;

  /// Nom de l'église
  String get name => throw _privateConstructorUsedError;

  /// Type d'église
  ChurchType get type => throw _privateConstructorUsedError;

  /// Description/mission de l'église
  String? get description => throw _privateConstructorUsedError;

  /// Adresse physique complète
  String? get address => throw _privateConstructorUsedError;

  /// Ville
  String? get city => throw _privateConstructorUsedError;

  /// Code postal
  String? get postalCode => throw _privateConstructorUsedError;

  /// Pays
  String get country => throw _privateConstructorUsedError;

  /// Numéro de téléphone principal
  String? get phone => throw _privateConstructorUsedError;

  /// Email de contact
  String? get email => throw _privateConstructorUsedError;

  /// Site web
  String? get website => throw _privateConstructorUsedError;

  /// ID de l'église mère (si type = branch ou affiliate)
  String? get parentChurchId => throw _privateConstructorUsedError;

  /// ID de la fédération (si membre d'une fédération)
  String? get federationId => throw _privateConstructorUsedError;

  /// Nombre de membres actifs
  int get memberCount => throw _privateConstructorUsedError;

  /// Date de fondation
  DateTime? get foundedDate => throw _privateConstructorUsedError;

  /// Pasteur principal (ID utilisateur)
  String? get leadPastorId => throw _privateConstructorUsedError;

  /// Logo de l'église (URL)
  String? get logoUrl => throw _privateConstructorUsedError;

  /// Photo de couverture (URL)
  String? get coverImageUrl => throw _privateConstructorUsedError;

  /// Métadonnées de synchronisation
  bool get isSynced => throw _privateConstructorUsedError;
  DateTime? get lastSyncedAt => throw _privateConstructorUsedError;

  /// Timestamps
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChurchCopyWith<Church> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChurchCopyWith<$Res> {
  factory $ChurchCopyWith(Church value, $Res Function(Church) then) =
      _$ChurchCopyWithImpl<$Res, Church>;
  @useResult
  $Res call(
      {String id,
      String name,
      ChurchType type,
      String? description,
      String? address,
      String? city,
      String? postalCode,
      String country,
      String? phone,
      String? email,
      String? website,
      String? parentChurchId,
      String? federationId,
      int memberCount,
      DateTime? foundedDate,
      String? leadPastorId,
      String? logoUrl,
      String? coverImageUrl,
      bool isSynced,
      DateTime? lastSyncedAt,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$ChurchCopyWithImpl<$Res, $Val extends Church>
    implements $ChurchCopyWith<$Res> {
  _$ChurchCopyWithImpl(this._value, this._then);

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
    Object? address = freezed,
    Object? city = freezed,
    Object? postalCode = freezed,
    Object? country = null,
    Object? phone = freezed,
    Object? email = freezed,
    Object? website = freezed,
    Object? parentChurchId = freezed,
    Object? federationId = freezed,
    Object? memberCount = null,
    Object? foundedDate = freezed,
    Object? leadPastorId = freezed,
    Object? logoUrl = freezed,
    Object? coverImageUrl = freezed,
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
              as ChurchType,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      postalCode: freezed == postalCode
          ? _value.postalCode
          : postalCode // ignore: cast_nullable_to_non_nullable
              as String?,
      country: null == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      website: freezed == website
          ? _value.website
          : website // ignore: cast_nullable_to_non_nullable
              as String?,
      parentChurchId: freezed == parentChurchId
          ? _value.parentChurchId
          : parentChurchId // ignore: cast_nullable_to_non_nullable
              as String?,
      federationId: freezed == federationId
          ? _value.federationId
          : federationId // ignore: cast_nullable_to_non_nullable
              as String?,
      memberCount: null == memberCount
          ? _value.memberCount
          : memberCount // ignore: cast_nullable_to_non_nullable
              as int,
      foundedDate: freezed == foundedDate
          ? _value.foundedDate
          : foundedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      leadPastorId: freezed == leadPastorId
          ? _value.leadPastorId
          : leadPastorId // ignore: cast_nullable_to_non_nullable
              as String?,
      logoUrl: freezed == logoUrl
          ? _value.logoUrl
          : logoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      coverImageUrl: freezed == coverImageUrl
          ? _value.coverImageUrl
          : coverImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
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
abstract class _$$ChurchImplCopyWith<$Res> implements $ChurchCopyWith<$Res> {
  factory _$$ChurchImplCopyWith(
          _$ChurchImpl value, $Res Function(_$ChurchImpl) then) =
      __$$ChurchImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      ChurchType type,
      String? description,
      String? address,
      String? city,
      String? postalCode,
      String country,
      String? phone,
      String? email,
      String? website,
      String? parentChurchId,
      String? federationId,
      int memberCount,
      DateTime? foundedDate,
      String? leadPastorId,
      String? logoUrl,
      String? coverImageUrl,
      bool isSynced,
      DateTime? lastSyncedAt,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$ChurchImplCopyWithImpl<$Res>
    extends _$ChurchCopyWithImpl<$Res, _$ChurchImpl>
    implements _$$ChurchImplCopyWith<$Res> {
  __$$ChurchImplCopyWithImpl(
      _$ChurchImpl _value, $Res Function(_$ChurchImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? description = freezed,
    Object? address = freezed,
    Object? city = freezed,
    Object? postalCode = freezed,
    Object? country = null,
    Object? phone = freezed,
    Object? email = freezed,
    Object? website = freezed,
    Object? parentChurchId = freezed,
    Object? federationId = freezed,
    Object? memberCount = null,
    Object? foundedDate = freezed,
    Object? leadPastorId = freezed,
    Object? logoUrl = freezed,
    Object? coverImageUrl = freezed,
    Object? isSynced = null,
    Object? lastSyncedAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_$ChurchImpl(
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
              as ChurchType,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      postalCode: freezed == postalCode
          ? _value.postalCode
          : postalCode // ignore: cast_nullable_to_non_nullable
              as String?,
      country: null == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      website: freezed == website
          ? _value.website
          : website // ignore: cast_nullable_to_non_nullable
              as String?,
      parentChurchId: freezed == parentChurchId
          ? _value.parentChurchId
          : parentChurchId // ignore: cast_nullable_to_non_nullable
              as String?,
      federationId: freezed == federationId
          ? _value.federationId
          : federationId // ignore: cast_nullable_to_non_nullable
              as String?,
      memberCount: null == memberCount
          ? _value.memberCount
          : memberCount // ignore: cast_nullable_to_non_nullable
              as int,
      foundedDate: freezed == foundedDate
          ? _value.foundedDate
          : foundedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      leadPastorId: freezed == leadPastorId
          ? _value.leadPastorId
          : leadPastorId // ignore: cast_nullable_to_non_nullable
              as String?,
      logoUrl: freezed == logoUrl
          ? _value.logoUrl
          : logoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      coverImageUrl: freezed == coverImageUrl
          ? _value.coverImageUrl
          : coverImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
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
@JsonSerializable()
class _$ChurchImpl extends _Church {
  const _$ChurchImpl(
      {required this.id,
      required this.name,
      required this.type,
      this.description,
      this.address,
      this.city,
      this.postalCode,
      this.country = 'RDC',
      this.phone,
      this.email,
      this.website,
      this.parentChurchId,
      this.federationId,
      this.memberCount = 0,
      this.foundedDate,
      this.leadPastorId,
      this.logoUrl,
      this.coverImageUrl,
      this.isSynced = false,
      this.lastSyncedAt,
      required this.createdAt,
      this.updatedAt})
      : super._();

  factory _$ChurchImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChurchImplFromJson(json);

  /// Identifiant unique de l'église
  @override
  final String id;

  /// Nom de l'église
  @override
  final String name;

  /// Type d'église
  @override
  final ChurchType type;

  /// Description/mission de l'église
  @override
  final String? description;

  /// Adresse physique complète
  @override
  final String? address;

  /// Ville
  @override
  final String? city;

  /// Code postal
  @override
  final String? postalCode;

  /// Pays
  @override
  @JsonKey()
  final String country;

  /// Numéro de téléphone principal
  @override
  final String? phone;

  /// Email de contact
  @override
  final String? email;

  /// Site web
  @override
  final String? website;

  /// ID de l'église mère (si type = branch ou affiliate)
  @override
  final String? parentChurchId;

  /// ID de la fédération (si membre d'une fédération)
  @override
  final String? federationId;

  /// Nombre de membres actifs
  @override
  @JsonKey()
  final int memberCount;

  /// Date de fondation
  @override
  final DateTime? foundedDate;

  /// Pasteur principal (ID utilisateur)
  @override
  final String? leadPastorId;

  /// Logo de l'église (URL)
  @override
  final String? logoUrl;

  /// Photo de couverture (URL)
  @override
  final String? coverImageUrl;

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
    return 'Church(id: $id, name: $name, type: $type, description: $description, address: $address, city: $city, postalCode: $postalCode, country: $country, phone: $phone, email: $email, website: $website, parentChurchId: $parentChurchId, federationId: $federationId, memberCount: $memberCount, foundedDate: $foundedDate, leadPastorId: $leadPastorId, logoUrl: $logoUrl, coverImageUrl: $coverImageUrl, isSynced: $isSynced, lastSyncedAt: $lastSyncedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChurchImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.postalCode, postalCode) ||
                other.postalCode == postalCode) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.website, website) || other.website == website) &&
            (identical(other.parentChurchId, parentChurchId) ||
                other.parentChurchId == parentChurchId) &&
            (identical(other.federationId, federationId) ||
                other.federationId == federationId) &&
            (identical(other.memberCount, memberCount) ||
                other.memberCount == memberCount) &&
            (identical(other.foundedDate, foundedDate) ||
                other.foundedDate == foundedDate) &&
            (identical(other.leadPastorId, leadPastorId) ||
                other.leadPastorId == leadPastorId) &&
            (identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl) &&
            (identical(other.coverImageUrl, coverImageUrl) ||
                other.coverImageUrl == coverImageUrl) &&
            (identical(other.isSynced, isSynced) ||
                other.isSynced == isSynced) &&
            (identical(other.lastSyncedAt, lastSyncedAt) ||
                other.lastSyncedAt == lastSyncedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        name,
        type,
        description,
        address,
        city,
        postalCode,
        country,
        phone,
        email,
        website,
        parentChurchId,
        federationId,
        memberCount,
        foundedDate,
        leadPastorId,
        logoUrl,
        coverImageUrl,
        isSynced,
        lastSyncedAt,
        createdAt,
        updatedAt
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChurchImplCopyWith<_$ChurchImpl> get copyWith =>
      __$$ChurchImplCopyWithImpl<_$ChurchImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChurchImplToJson(
      this,
    );
  }
}

abstract class _Church extends Church {
  const factory _Church(
      {required final String id,
      required final String name,
      required final ChurchType type,
      final String? description,
      final String? address,
      final String? city,
      final String? postalCode,
      final String country,
      final String? phone,
      final String? email,
      final String? website,
      final String? parentChurchId,
      final String? federationId,
      final int memberCount,
      final DateTime? foundedDate,
      final String? leadPastorId,
      final String? logoUrl,
      final String? coverImageUrl,
      final bool isSynced,
      final DateTime? lastSyncedAt,
      required final DateTime createdAt,
      final DateTime? updatedAt}) = _$ChurchImpl;
  const _Church._() : super._();

  factory _Church.fromJson(Map<String, dynamic> json) = _$ChurchImpl.fromJson;

  @override

  /// Identifiant unique de l'église
  String get id;
  @override

  /// Nom de l'église
  String get name;
  @override

  /// Type d'église
  ChurchType get type;
  @override

  /// Description/mission de l'église
  String? get description;
  @override

  /// Adresse physique complète
  String? get address;
  @override

  /// Ville
  String? get city;
  @override

  /// Code postal
  String? get postalCode;
  @override

  /// Pays
  String get country;
  @override

  /// Numéro de téléphone principal
  String? get phone;
  @override

  /// Email de contact
  String? get email;
  @override

  /// Site web
  String? get website;
  @override

  /// ID de l'église mère (si type = branch ou affiliate)
  String? get parentChurchId;
  @override

  /// ID de la fédération (si membre d'une fédération)
  String? get federationId;
  @override

  /// Nombre de membres actifs
  int get memberCount;
  @override

  /// Date de fondation
  DateTime? get foundedDate;
  @override

  /// Pasteur principal (ID utilisateur)
  String? get leadPastorId;
  @override

  /// Logo de l'église (URL)
  String? get logoUrl;
  @override

  /// Photo de couverture (URL)
  String? get coverImageUrl;
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
  _$$ChurchImplCopyWith<_$ChurchImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
