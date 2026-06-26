// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'member.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Member _$MemberFromJson(Map<String, dynamic> json) {
  return _Member.fromJson(json);
}

/// @nodoc
mixin _$Member {
// ==========================================
// IDENTIFICATION SYSTÈME
// ==========================================
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String? get userId =>
      throw _privateConstructorUsedError; // Lien vers le compte utilisateur Auth
  String get churchId =>
      throw _privateConstructorUsedError; // ID de l'église (Multi-Églises)
  String? get memberNumber =>
      throw _privateConstructorUsedError; // Numéro de membre
  String? get qrCode => throw _privateConstructorUsedError; // Code QR unique
// ==========================================
// IDENTITÉ
// ==========================================
  String get lastName => throw _privateConstructorUsedError; // Nom de famille
  String get firstName => throw _privateConstructorUsedError; // Prénom
  String? get middleName =>
      throw _privateConstructorUsedError; // Autres prénoms
  String? get maidenName =>
      throw _privateConstructorUsedError; // Nom de jeune fille
  String? get nickname =>
      throw _privateConstructorUsedError; // Appellation courante (ex: "Frère Jean")
  String? get title =>
      throw _privateConstructorUsedError; // Titre (Dr., Ing., etc.)
  String? get suffix =>
      throw _privateConstructorUsedError; // Suffixe (Jr., Sr., etc.)
// Genre et dates clés
  Gender get gender => throw _privateConstructorUsedError;
  DateTime? get birthDate => throw _privateConstructorUsedError;
  String? get birthCity => throw _privateConstructorUsedError;
  String? get birthCountry => throw _privateConstructorUsedError;
  DateTime? get deathDate => throw _privateConstructorUsedError; // Photo
  String? get photoUrl => throw _privateConstructorUsedError;
  String? get thumbnailUrl =>
      throw _privateConstructorUsedError; // ==========================================
// STATUT
// ==========================================
  MemberStatus get status => throw _privateConstructorUsedError;
  MembershipType get membershipType => throw _privateConstructorUsedError;
  DateTime? get joiningDate =>
      throw _privateConstructorUsedError; // Date d'arrivée
  DateTime? get membershipDate =>
      throw _privateConstructorUsedError; // Date d'adhésion officielle
  DateTime? get lastActiveDate => throw _privateConstructorUsedError;
  String? get statusNote =>
      throw _privateConstructorUsedError; // ==========================================
// CONTACT (version simplifiée pour Isar)
// Utiliser contactInfo pour version complète en JSON Supabase
// ==========================================
  String? get email => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get whatsapp => throw _privateConstructorUsedError;
  bool get acceptsWhatsApp => throw _privateConstructorUsedError;
  bool get acceptsSms => throw _privateConstructorUsedError;
  bool get acceptsEmail =>
      throw _privateConstructorUsedError; // Contact d'urgence
  String? get emergencyContactName => throw _privateConstructorUsedError;
  String? get emergencyContactPhone => throw _privateConstructorUsedError;
  String? get emergencyContactRelation =>
      throw _privateConstructorUsedError; // ==========================================
// ADRESSE (version simplifiée pour Isar)
// ==========================================
  String? get addressLine1 => throw _privateConstructorUsedError;
  String? get neighborhood => throw _privateConstructorUsedError; // Quartier
  String? get city => throw _privateConstructorUsedError;
  String? get region => throw _privateConstructorUsedError;
  String? get postalCode => throw _privateConstructorUsedError;
  String get country => throw _privateConstructorUsedError;
  String? get landmark => throw _privateConstructorUsedError; // Point de repère
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude =>
      throw _privateConstructorUsedError; // ==========================================
// FAMILLE (infos de base pour Isar)
// ==========================================
  MaritalStatus get maritalStatus => throw _privateConstructorUsedError;
  String? get spouseMemberId =>
      throw _privateConstructorUsedError; // ID du conjoint si membre
  String? get spouseName =>
      throw _privateConstructorUsedError; // Nom du conjoint
  int get numberOfChildren => throw _privateConstructorUsedError;
  DateTime? get weddingDate =>
      throw _privateConstructorUsedError; // ==========================================
// SPIRITUALITÉ (infos essentielles pour Isar)
// ==========================================
  bool get isBaptized => throw _privateConstructorUsedError;
  DateTime? get baptismDate => throw _privateConstructorUsedError;
  String? get baptismLocation => throw _privateConstructorUsedError;
  bool get isConverted => throw _privateConstructorUsedError;
  DateTime? get conversionDate => throw _privateConstructorUsedError;
  bool get hasCompletedMembershipClass => throw _privateConstructorUsedError;
  bool get hasCompletedMaturityClass =>
      throw _privateConstructorUsedError; // ==========================================
// ENGAGEMENT (essentiel pour Isar)
// ==========================================
  String? get primaryRoleType =>
      throw _privateConstructorUsedError; // ChurchRoleType.name
  String? get primaryRoleTitle => throw _privateConstructorUsedError;
  String? get cellId => throw _privateConstructorUsedError;
  String? get cellName => throw _privateConstructorUsedError;
  List<String> get ministryIds => throw _privateConstructorUsedError;
  AttendanceLevel get attendanceLevel => throw _privateConstructorUsedError;
  bool get isLeader =>
      throw _privateConstructorUsedError; // ==========================================
// PROFESSIONNEL (essentiel)
// ==========================================
  EmploymentStatus get employmentStatus => throw _privateConstructorUsedError;
  String? get profession => throw _privateConstructorUsedError;
  String? get employer => throw _privateConstructorUsedError;
  EducationLevel get educationLevel =>
      throw _privateConstructorUsedError; // ==========================================
// CONTRIBUTIONS
// ==========================================
  bool get isRegularTither => throw _privateConstructorUsedError;
  DateTime? get lastContributionDate => throw _privateConstructorUsedError;
  double get totalContributionsThisYear =>
      throw _privateConstructorUsedError; // ==========================================
// DATES SYSTÈME
// ==========================================
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  String? get createdBy => throw _privateConstructorUsedError;
  String? get updatedBy => throw _privateConstructorUsedError;
  bool get isDeleted => throw _privateConstructorUsedError;
  DateTime? get deletedAt => throw _privateConstructorUsedError; // Audit Trail
  String? get lastModifiedBy =>
      throw _privateConstructorUsedError; // Profile UUID
  DateTime? get lastModifiedAt => throw _privateConstructorUsedError;
  String? get lastModifiedByName =>
      throw _privateConstructorUsedError; // Joined from profiles
  String? get lastModifiedByRole =>
      throw _privateConstructorUsedError; // Joined from profiles.role
// ==========================================
// MÉTADONNÉES SUPPLÉMENTAIRES
// Pour stocker les objets complexes en JSON
// ==========================================
  String? get contactInfoJson =>
      throw _privateConstructorUsedError; // ContactInfo sérialisé
  String? get familyInfoJson =>
      throw _privateConstructorUsedError; // FamilyInfo sérialisé
  String? get spiritualInfoJson =>
      throw _privateConstructorUsedError; // SpiritualInfo sérialisé
  String? get engagementInfoJson =>
      throw _privateConstructorUsedError; // EngagementInfo sérialisé
  String? get professionalInfoJson =>
      throw _privateConstructorUsedError; // ProfessionalInfo sérialisé
  String? get addressesJson =>
      throw _privateConstructorUsedError; // List<Address> sérialisé
  String? get customFieldsJson => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MemberCopyWith<Member> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MemberCopyWith<$Res> {
  factory $MemberCopyWith(Member value, $Res Function(Member) then) =
      _$MemberCopyWithImpl<$Res, Member>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String? userId,
      String churchId,
      String? memberNumber,
      String? qrCode,
      String lastName,
      String firstName,
      String? middleName,
      String? maidenName,
      String? nickname,
      String? title,
      String? suffix,
      Gender gender,
      DateTime? birthDate,
      String? birthCity,
      String? birthCountry,
      DateTime? deathDate,
      String? photoUrl,
      String? thumbnailUrl,
      MemberStatus status,
      MembershipType membershipType,
      DateTime? joiningDate,
      DateTime? membershipDate,
      DateTime? lastActiveDate,
      String? statusNote,
      String? email,
      String? phone,
      String? whatsapp,
      bool acceptsWhatsApp,
      bool acceptsSms,
      bool acceptsEmail,
      String? emergencyContactName,
      String? emergencyContactPhone,
      String? emergencyContactRelation,
      String? addressLine1,
      String? neighborhood,
      String? city,
      String? region,
      String? postalCode,
      String country,
      String? landmark,
      double? latitude,
      double? longitude,
      MaritalStatus maritalStatus,
      String? spouseMemberId,
      String? spouseName,
      int numberOfChildren,
      DateTime? weddingDate,
      bool isBaptized,
      DateTime? baptismDate,
      String? baptismLocation,
      bool isConverted,
      DateTime? conversionDate,
      bool hasCompletedMembershipClass,
      bool hasCompletedMaturityClass,
      String? primaryRoleType,
      String? primaryRoleTitle,
      String? cellId,
      String? cellName,
      List<String> ministryIds,
      AttendanceLevel attendanceLevel,
      bool isLeader,
      EmploymentStatus employmentStatus,
      String? profession,
      String? employer,
      EducationLevel educationLevel,
      bool isRegularTither,
      DateTime? lastContributionDate,
      double totalContributionsThisYear,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? createdBy,
      String? updatedBy,
      bool isDeleted,
      DateTime? deletedAt,
      String? lastModifiedBy,
      DateTime? lastModifiedAt,
      String? lastModifiedByName,
      String? lastModifiedByRole,
      String? contactInfoJson,
      String? familyInfoJson,
      String? spiritualInfoJson,
      String? engagementInfoJson,
      String? professionalInfoJson,
      String? addressesJson,
      String? customFieldsJson});
}

/// @nodoc
class _$MemberCopyWithImpl<$Res, $Val extends Member>
    implements $MemberCopyWith<$Res> {
  _$MemberCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = freezed,
    Object? churchId = null,
    Object? memberNumber = freezed,
    Object? qrCode = freezed,
    Object? lastName = null,
    Object? firstName = null,
    Object? middleName = freezed,
    Object? maidenName = freezed,
    Object? nickname = freezed,
    Object? title = freezed,
    Object? suffix = freezed,
    Object? gender = null,
    Object? birthDate = freezed,
    Object? birthCity = freezed,
    Object? birthCountry = freezed,
    Object? deathDate = freezed,
    Object? photoUrl = freezed,
    Object? thumbnailUrl = freezed,
    Object? status = null,
    Object? membershipType = null,
    Object? joiningDate = freezed,
    Object? membershipDate = freezed,
    Object? lastActiveDate = freezed,
    Object? statusNote = freezed,
    Object? email = freezed,
    Object? phone = freezed,
    Object? whatsapp = freezed,
    Object? acceptsWhatsApp = null,
    Object? acceptsSms = null,
    Object? acceptsEmail = null,
    Object? emergencyContactName = freezed,
    Object? emergencyContactPhone = freezed,
    Object? emergencyContactRelation = freezed,
    Object? addressLine1 = freezed,
    Object? neighborhood = freezed,
    Object? city = freezed,
    Object? region = freezed,
    Object? postalCode = freezed,
    Object? country = null,
    Object? landmark = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? maritalStatus = null,
    Object? spouseMemberId = freezed,
    Object? spouseName = freezed,
    Object? numberOfChildren = null,
    Object? weddingDate = freezed,
    Object? isBaptized = null,
    Object? baptismDate = freezed,
    Object? baptismLocation = freezed,
    Object? isConverted = null,
    Object? conversionDate = freezed,
    Object? hasCompletedMembershipClass = null,
    Object? hasCompletedMaturityClass = null,
    Object? primaryRoleType = freezed,
    Object? primaryRoleTitle = freezed,
    Object? cellId = freezed,
    Object? cellName = freezed,
    Object? ministryIds = null,
    Object? attendanceLevel = null,
    Object? isLeader = null,
    Object? employmentStatus = null,
    Object? profession = freezed,
    Object? employer = freezed,
    Object? educationLevel = null,
    Object? isRegularTither = null,
    Object? lastContributionDate = freezed,
    Object? totalContributionsThisYear = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? createdBy = freezed,
    Object? updatedBy = freezed,
    Object? isDeleted = null,
    Object? deletedAt = freezed,
    Object? lastModifiedBy = freezed,
    Object? lastModifiedAt = freezed,
    Object? lastModifiedByName = freezed,
    Object? lastModifiedByRole = freezed,
    Object? contactInfoJson = freezed,
    Object? familyInfoJson = freezed,
    Object? spiritualInfoJson = freezed,
    Object? engagementInfoJson = freezed,
    Object? professionalInfoJson = freezed,
    Object? addressesJson = freezed,
    Object? customFieldsJson = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      churchId: null == churchId
          ? _value.churchId
          : churchId // ignore: cast_nullable_to_non_nullable
              as String,
      memberNumber: freezed == memberNumber
          ? _value.memberNumber
          : memberNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      qrCode: freezed == qrCode
          ? _value.qrCode
          : qrCode // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      middleName: freezed == middleName
          ? _value.middleName
          : middleName // ignore: cast_nullable_to_non_nullable
              as String?,
      maidenName: freezed == maidenName
          ? _value.maidenName
          : maidenName // ignore: cast_nullable_to_non_nullable
              as String?,
      nickname: freezed == nickname
          ? _value.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      suffix: freezed == suffix
          ? _value.suffix
          : suffix // ignore: cast_nullable_to_non_nullable
              as String?,
      gender: null == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as Gender,
      birthDate: freezed == birthDate
          ? _value.birthDate
          : birthDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      birthCity: freezed == birthCity
          ? _value.birthCity
          : birthCity // ignore: cast_nullable_to_non_nullable
              as String?,
      birthCountry: freezed == birthCountry
          ? _value.birthCountry
          : birthCountry // ignore: cast_nullable_to_non_nullable
              as String?,
      deathDate: freezed == deathDate
          ? _value.deathDate
          : deathDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      thumbnailUrl: freezed == thumbnailUrl
          ? _value.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as MemberStatus,
      membershipType: null == membershipType
          ? _value.membershipType
          : membershipType // ignore: cast_nullable_to_non_nullable
              as MembershipType,
      joiningDate: freezed == joiningDate
          ? _value.joiningDate
          : joiningDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      membershipDate: freezed == membershipDate
          ? _value.membershipDate
          : membershipDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastActiveDate: freezed == lastActiveDate
          ? _value.lastActiveDate
          : lastActiveDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      statusNote: freezed == statusNote
          ? _value.statusNote
          : statusNote // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      whatsapp: freezed == whatsapp
          ? _value.whatsapp
          : whatsapp // ignore: cast_nullable_to_non_nullable
              as String?,
      acceptsWhatsApp: null == acceptsWhatsApp
          ? _value.acceptsWhatsApp
          : acceptsWhatsApp // ignore: cast_nullable_to_non_nullable
              as bool,
      acceptsSms: null == acceptsSms
          ? _value.acceptsSms
          : acceptsSms // ignore: cast_nullable_to_non_nullable
              as bool,
      acceptsEmail: null == acceptsEmail
          ? _value.acceptsEmail
          : acceptsEmail // ignore: cast_nullable_to_non_nullable
              as bool,
      emergencyContactName: freezed == emergencyContactName
          ? _value.emergencyContactName
          : emergencyContactName // ignore: cast_nullable_to_non_nullable
              as String?,
      emergencyContactPhone: freezed == emergencyContactPhone
          ? _value.emergencyContactPhone
          : emergencyContactPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      emergencyContactRelation: freezed == emergencyContactRelation
          ? _value.emergencyContactRelation
          : emergencyContactRelation // ignore: cast_nullable_to_non_nullable
              as String?,
      addressLine1: freezed == addressLine1
          ? _value.addressLine1
          : addressLine1 // ignore: cast_nullable_to_non_nullable
              as String?,
      neighborhood: freezed == neighborhood
          ? _value.neighborhood
          : neighborhood // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      region: freezed == region
          ? _value.region
          : region // ignore: cast_nullable_to_non_nullable
              as String?,
      postalCode: freezed == postalCode
          ? _value.postalCode
          : postalCode // ignore: cast_nullable_to_non_nullable
              as String?,
      country: null == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String,
      landmark: freezed == landmark
          ? _value.landmark
          : landmark // ignore: cast_nullable_to_non_nullable
              as String?,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      maritalStatus: null == maritalStatus
          ? _value.maritalStatus
          : maritalStatus // ignore: cast_nullable_to_non_nullable
              as MaritalStatus,
      spouseMemberId: freezed == spouseMemberId
          ? _value.spouseMemberId
          : spouseMemberId // ignore: cast_nullable_to_non_nullable
              as String?,
      spouseName: freezed == spouseName
          ? _value.spouseName
          : spouseName // ignore: cast_nullable_to_non_nullable
              as String?,
      numberOfChildren: null == numberOfChildren
          ? _value.numberOfChildren
          : numberOfChildren // ignore: cast_nullable_to_non_nullable
              as int,
      weddingDate: freezed == weddingDate
          ? _value.weddingDate
          : weddingDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isBaptized: null == isBaptized
          ? _value.isBaptized
          : isBaptized // ignore: cast_nullable_to_non_nullable
              as bool,
      baptismDate: freezed == baptismDate
          ? _value.baptismDate
          : baptismDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      baptismLocation: freezed == baptismLocation
          ? _value.baptismLocation
          : baptismLocation // ignore: cast_nullable_to_non_nullable
              as String?,
      isConverted: null == isConverted
          ? _value.isConverted
          : isConverted // ignore: cast_nullable_to_non_nullable
              as bool,
      conversionDate: freezed == conversionDate
          ? _value.conversionDate
          : conversionDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      hasCompletedMembershipClass: null == hasCompletedMembershipClass
          ? _value.hasCompletedMembershipClass
          : hasCompletedMembershipClass // ignore: cast_nullable_to_non_nullable
              as bool,
      hasCompletedMaturityClass: null == hasCompletedMaturityClass
          ? _value.hasCompletedMaturityClass
          : hasCompletedMaturityClass // ignore: cast_nullable_to_non_nullable
              as bool,
      primaryRoleType: freezed == primaryRoleType
          ? _value.primaryRoleType
          : primaryRoleType // ignore: cast_nullable_to_non_nullable
              as String?,
      primaryRoleTitle: freezed == primaryRoleTitle
          ? _value.primaryRoleTitle
          : primaryRoleTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      cellId: freezed == cellId
          ? _value.cellId
          : cellId // ignore: cast_nullable_to_non_nullable
              as String?,
      cellName: freezed == cellName
          ? _value.cellName
          : cellName // ignore: cast_nullable_to_non_nullable
              as String?,
      ministryIds: null == ministryIds
          ? _value.ministryIds
          : ministryIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      attendanceLevel: null == attendanceLevel
          ? _value.attendanceLevel
          : attendanceLevel // ignore: cast_nullable_to_non_nullable
              as AttendanceLevel,
      isLeader: null == isLeader
          ? _value.isLeader
          : isLeader // ignore: cast_nullable_to_non_nullable
              as bool,
      employmentStatus: null == employmentStatus
          ? _value.employmentStatus
          : employmentStatus // ignore: cast_nullable_to_non_nullable
              as EmploymentStatus,
      profession: freezed == profession
          ? _value.profession
          : profession // ignore: cast_nullable_to_non_nullable
              as String?,
      employer: freezed == employer
          ? _value.employer
          : employer // ignore: cast_nullable_to_non_nullable
              as String?,
      educationLevel: null == educationLevel
          ? _value.educationLevel
          : educationLevel // ignore: cast_nullable_to_non_nullable
              as EducationLevel,
      isRegularTither: null == isRegularTither
          ? _value.isRegularTither
          : isRegularTither // ignore: cast_nullable_to_non_nullable
              as bool,
      lastContributionDate: freezed == lastContributionDate
          ? _value.lastContributionDate
          : lastContributionDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      totalContributionsThisYear: null == totalContributionsThisYear
          ? _value.totalContributionsThisYear
          : totalContributionsThisYear // ignore: cast_nullable_to_non_nullable
              as double,
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
      isDeleted: null == isDeleted
          ? _value.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastModifiedBy: freezed == lastModifiedBy
          ? _value.lastModifiedBy
          : lastModifiedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      lastModifiedAt: freezed == lastModifiedAt
          ? _value.lastModifiedAt
          : lastModifiedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastModifiedByName: freezed == lastModifiedByName
          ? _value.lastModifiedByName
          : lastModifiedByName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastModifiedByRole: freezed == lastModifiedByRole
          ? _value.lastModifiedByRole
          : lastModifiedByRole // ignore: cast_nullable_to_non_nullable
              as String?,
      contactInfoJson: freezed == contactInfoJson
          ? _value.contactInfoJson
          : contactInfoJson // ignore: cast_nullable_to_non_nullable
              as String?,
      familyInfoJson: freezed == familyInfoJson
          ? _value.familyInfoJson
          : familyInfoJson // ignore: cast_nullable_to_non_nullable
              as String?,
      spiritualInfoJson: freezed == spiritualInfoJson
          ? _value.spiritualInfoJson
          : spiritualInfoJson // ignore: cast_nullable_to_non_nullable
              as String?,
      engagementInfoJson: freezed == engagementInfoJson
          ? _value.engagementInfoJson
          : engagementInfoJson // ignore: cast_nullable_to_non_nullable
              as String?,
      professionalInfoJson: freezed == professionalInfoJson
          ? _value.professionalInfoJson
          : professionalInfoJson // ignore: cast_nullable_to_non_nullable
              as String?,
      addressesJson: freezed == addressesJson
          ? _value.addressesJson
          : addressesJson // ignore: cast_nullable_to_non_nullable
              as String?,
      customFieldsJson: freezed == customFieldsJson
          ? _value.customFieldsJson
          : customFieldsJson // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MemberImplCopyWith<$Res> implements $MemberCopyWith<$Res> {
  factory _$$MemberImplCopyWith(
          _$MemberImpl value, $Res Function(_$MemberImpl) then) =
      __$$MemberImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String? userId,
      String churchId,
      String? memberNumber,
      String? qrCode,
      String lastName,
      String firstName,
      String? middleName,
      String? maidenName,
      String? nickname,
      String? title,
      String? suffix,
      Gender gender,
      DateTime? birthDate,
      String? birthCity,
      String? birthCountry,
      DateTime? deathDate,
      String? photoUrl,
      String? thumbnailUrl,
      MemberStatus status,
      MembershipType membershipType,
      DateTime? joiningDate,
      DateTime? membershipDate,
      DateTime? lastActiveDate,
      String? statusNote,
      String? email,
      String? phone,
      String? whatsapp,
      bool acceptsWhatsApp,
      bool acceptsSms,
      bool acceptsEmail,
      String? emergencyContactName,
      String? emergencyContactPhone,
      String? emergencyContactRelation,
      String? addressLine1,
      String? neighborhood,
      String? city,
      String? region,
      String? postalCode,
      String country,
      String? landmark,
      double? latitude,
      double? longitude,
      MaritalStatus maritalStatus,
      String? spouseMemberId,
      String? spouseName,
      int numberOfChildren,
      DateTime? weddingDate,
      bool isBaptized,
      DateTime? baptismDate,
      String? baptismLocation,
      bool isConverted,
      DateTime? conversionDate,
      bool hasCompletedMembershipClass,
      bool hasCompletedMaturityClass,
      String? primaryRoleType,
      String? primaryRoleTitle,
      String? cellId,
      String? cellName,
      List<String> ministryIds,
      AttendanceLevel attendanceLevel,
      bool isLeader,
      EmploymentStatus employmentStatus,
      String? profession,
      String? employer,
      EducationLevel educationLevel,
      bool isRegularTither,
      DateTime? lastContributionDate,
      double totalContributionsThisYear,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? createdBy,
      String? updatedBy,
      bool isDeleted,
      DateTime? deletedAt,
      String? lastModifiedBy,
      DateTime? lastModifiedAt,
      String? lastModifiedByName,
      String? lastModifiedByRole,
      String? contactInfoJson,
      String? familyInfoJson,
      String? spiritualInfoJson,
      String? engagementInfoJson,
      String? professionalInfoJson,
      String? addressesJson,
      String? customFieldsJson});
}

/// @nodoc
class __$$MemberImplCopyWithImpl<$Res>
    extends _$MemberCopyWithImpl<$Res, _$MemberImpl>
    implements _$$MemberImplCopyWith<$Res> {
  __$$MemberImplCopyWithImpl(
      _$MemberImpl _value, $Res Function(_$MemberImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = freezed,
    Object? churchId = null,
    Object? memberNumber = freezed,
    Object? qrCode = freezed,
    Object? lastName = null,
    Object? firstName = null,
    Object? middleName = freezed,
    Object? maidenName = freezed,
    Object? nickname = freezed,
    Object? title = freezed,
    Object? suffix = freezed,
    Object? gender = null,
    Object? birthDate = freezed,
    Object? birthCity = freezed,
    Object? birthCountry = freezed,
    Object? deathDate = freezed,
    Object? photoUrl = freezed,
    Object? thumbnailUrl = freezed,
    Object? status = null,
    Object? membershipType = null,
    Object? joiningDate = freezed,
    Object? membershipDate = freezed,
    Object? lastActiveDate = freezed,
    Object? statusNote = freezed,
    Object? email = freezed,
    Object? phone = freezed,
    Object? whatsapp = freezed,
    Object? acceptsWhatsApp = null,
    Object? acceptsSms = null,
    Object? acceptsEmail = null,
    Object? emergencyContactName = freezed,
    Object? emergencyContactPhone = freezed,
    Object? emergencyContactRelation = freezed,
    Object? addressLine1 = freezed,
    Object? neighborhood = freezed,
    Object? city = freezed,
    Object? region = freezed,
    Object? postalCode = freezed,
    Object? country = null,
    Object? landmark = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? maritalStatus = null,
    Object? spouseMemberId = freezed,
    Object? spouseName = freezed,
    Object? numberOfChildren = null,
    Object? weddingDate = freezed,
    Object? isBaptized = null,
    Object? baptismDate = freezed,
    Object? baptismLocation = freezed,
    Object? isConverted = null,
    Object? conversionDate = freezed,
    Object? hasCompletedMembershipClass = null,
    Object? hasCompletedMaturityClass = null,
    Object? primaryRoleType = freezed,
    Object? primaryRoleTitle = freezed,
    Object? cellId = freezed,
    Object? cellName = freezed,
    Object? ministryIds = null,
    Object? attendanceLevel = null,
    Object? isLeader = null,
    Object? employmentStatus = null,
    Object? profession = freezed,
    Object? employer = freezed,
    Object? educationLevel = null,
    Object? isRegularTither = null,
    Object? lastContributionDate = freezed,
    Object? totalContributionsThisYear = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? createdBy = freezed,
    Object? updatedBy = freezed,
    Object? isDeleted = null,
    Object? deletedAt = freezed,
    Object? lastModifiedBy = freezed,
    Object? lastModifiedAt = freezed,
    Object? lastModifiedByName = freezed,
    Object? lastModifiedByRole = freezed,
    Object? contactInfoJson = freezed,
    Object? familyInfoJson = freezed,
    Object? spiritualInfoJson = freezed,
    Object? engagementInfoJson = freezed,
    Object? professionalInfoJson = freezed,
    Object? addressesJson = freezed,
    Object? customFieldsJson = freezed,
  }) {
    return _then(_$MemberImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      churchId: null == churchId
          ? _value.churchId
          : churchId // ignore: cast_nullable_to_non_nullable
              as String,
      memberNumber: freezed == memberNumber
          ? _value.memberNumber
          : memberNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      qrCode: freezed == qrCode
          ? _value.qrCode
          : qrCode // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      middleName: freezed == middleName
          ? _value.middleName
          : middleName // ignore: cast_nullable_to_non_nullable
              as String?,
      maidenName: freezed == maidenName
          ? _value.maidenName
          : maidenName // ignore: cast_nullable_to_non_nullable
              as String?,
      nickname: freezed == nickname
          ? _value.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      suffix: freezed == suffix
          ? _value.suffix
          : suffix // ignore: cast_nullable_to_non_nullable
              as String?,
      gender: null == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as Gender,
      birthDate: freezed == birthDate
          ? _value.birthDate
          : birthDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      birthCity: freezed == birthCity
          ? _value.birthCity
          : birthCity // ignore: cast_nullable_to_non_nullable
              as String?,
      birthCountry: freezed == birthCountry
          ? _value.birthCountry
          : birthCountry // ignore: cast_nullable_to_non_nullable
              as String?,
      deathDate: freezed == deathDate
          ? _value.deathDate
          : deathDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      thumbnailUrl: freezed == thumbnailUrl
          ? _value.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as MemberStatus,
      membershipType: null == membershipType
          ? _value.membershipType
          : membershipType // ignore: cast_nullable_to_non_nullable
              as MembershipType,
      joiningDate: freezed == joiningDate
          ? _value.joiningDate
          : joiningDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      membershipDate: freezed == membershipDate
          ? _value.membershipDate
          : membershipDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastActiveDate: freezed == lastActiveDate
          ? _value.lastActiveDate
          : lastActiveDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      statusNote: freezed == statusNote
          ? _value.statusNote
          : statusNote // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      whatsapp: freezed == whatsapp
          ? _value.whatsapp
          : whatsapp // ignore: cast_nullable_to_non_nullable
              as String?,
      acceptsWhatsApp: null == acceptsWhatsApp
          ? _value.acceptsWhatsApp
          : acceptsWhatsApp // ignore: cast_nullable_to_non_nullable
              as bool,
      acceptsSms: null == acceptsSms
          ? _value.acceptsSms
          : acceptsSms // ignore: cast_nullable_to_non_nullable
              as bool,
      acceptsEmail: null == acceptsEmail
          ? _value.acceptsEmail
          : acceptsEmail // ignore: cast_nullable_to_non_nullable
              as bool,
      emergencyContactName: freezed == emergencyContactName
          ? _value.emergencyContactName
          : emergencyContactName // ignore: cast_nullable_to_non_nullable
              as String?,
      emergencyContactPhone: freezed == emergencyContactPhone
          ? _value.emergencyContactPhone
          : emergencyContactPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      emergencyContactRelation: freezed == emergencyContactRelation
          ? _value.emergencyContactRelation
          : emergencyContactRelation // ignore: cast_nullable_to_non_nullable
              as String?,
      addressLine1: freezed == addressLine1
          ? _value.addressLine1
          : addressLine1 // ignore: cast_nullable_to_non_nullable
              as String?,
      neighborhood: freezed == neighborhood
          ? _value.neighborhood
          : neighborhood // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      region: freezed == region
          ? _value.region
          : region // ignore: cast_nullable_to_non_nullable
              as String?,
      postalCode: freezed == postalCode
          ? _value.postalCode
          : postalCode // ignore: cast_nullable_to_non_nullable
              as String?,
      country: null == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String,
      landmark: freezed == landmark
          ? _value.landmark
          : landmark // ignore: cast_nullable_to_non_nullable
              as String?,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      maritalStatus: null == maritalStatus
          ? _value.maritalStatus
          : maritalStatus // ignore: cast_nullable_to_non_nullable
              as MaritalStatus,
      spouseMemberId: freezed == spouseMemberId
          ? _value.spouseMemberId
          : spouseMemberId // ignore: cast_nullable_to_non_nullable
              as String?,
      spouseName: freezed == spouseName
          ? _value.spouseName
          : spouseName // ignore: cast_nullable_to_non_nullable
              as String?,
      numberOfChildren: null == numberOfChildren
          ? _value.numberOfChildren
          : numberOfChildren // ignore: cast_nullable_to_non_nullable
              as int,
      weddingDate: freezed == weddingDate
          ? _value.weddingDate
          : weddingDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isBaptized: null == isBaptized
          ? _value.isBaptized
          : isBaptized // ignore: cast_nullable_to_non_nullable
              as bool,
      baptismDate: freezed == baptismDate
          ? _value.baptismDate
          : baptismDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      baptismLocation: freezed == baptismLocation
          ? _value.baptismLocation
          : baptismLocation // ignore: cast_nullable_to_non_nullable
              as String?,
      isConverted: null == isConverted
          ? _value.isConverted
          : isConverted // ignore: cast_nullable_to_non_nullable
              as bool,
      conversionDate: freezed == conversionDate
          ? _value.conversionDate
          : conversionDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      hasCompletedMembershipClass: null == hasCompletedMembershipClass
          ? _value.hasCompletedMembershipClass
          : hasCompletedMembershipClass // ignore: cast_nullable_to_non_nullable
              as bool,
      hasCompletedMaturityClass: null == hasCompletedMaturityClass
          ? _value.hasCompletedMaturityClass
          : hasCompletedMaturityClass // ignore: cast_nullable_to_non_nullable
              as bool,
      primaryRoleType: freezed == primaryRoleType
          ? _value.primaryRoleType
          : primaryRoleType // ignore: cast_nullable_to_non_nullable
              as String?,
      primaryRoleTitle: freezed == primaryRoleTitle
          ? _value.primaryRoleTitle
          : primaryRoleTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      cellId: freezed == cellId
          ? _value.cellId
          : cellId // ignore: cast_nullable_to_non_nullable
              as String?,
      cellName: freezed == cellName
          ? _value.cellName
          : cellName // ignore: cast_nullable_to_non_nullable
              as String?,
      ministryIds: null == ministryIds
          ? _value._ministryIds
          : ministryIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      attendanceLevel: null == attendanceLevel
          ? _value.attendanceLevel
          : attendanceLevel // ignore: cast_nullable_to_non_nullable
              as AttendanceLevel,
      isLeader: null == isLeader
          ? _value.isLeader
          : isLeader // ignore: cast_nullable_to_non_nullable
              as bool,
      employmentStatus: null == employmentStatus
          ? _value.employmentStatus
          : employmentStatus // ignore: cast_nullable_to_non_nullable
              as EmploymentStatus,
      profession: freezed == profession
          ? _value.profession
          : profession // ignore: cast_nullable_to_non_nullable
              as String?,
      employer: freezed == employer
          ? _value.employer
          : employer // ignore: cast_nullable_to_non_nullable
              as String?,
      educationLevel: null == educationLevel
          ? _value.educationLevel
          : educationLevel // ignore: cast_nullable_to_non_nullable
              as EducationLevel,
      isRegularTither: null == isRegularTither
          ? _value.isRegularTither
          : isRegularTither // ignore: cast_nullable_to_non_nullable
              as bool,
      lastContributionDate: freezed == lastContributionDate
          ? _value.lastContributionDate
          : lastContributionDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      totalContributionsThisYear: null == totalContributionsThisYear
          ? _value.totalContributionsThisYear
          : totalContributionsThisYear // ignore: cast_nullable_to_non_nullable
              as double,
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
      isDeleted: null == isDeleted
          ? _value.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastModifiedBy: freezed == lastModifiedBy
          ? _value.lastModifiedBy
          : lastModifiedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      lastModifiedAt: freezed == lastModifiedAt
          ? _value.lastModifiedAt
          : lastModifiedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastModifiedByName: freezed == lastModifiedByName
          ? _value.lastModifiedByName
          : lastModifiedByName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastModifiedByRole: freezed == lastModifiedByRole
          ? _value.lastModifiedByRole
          : lastModifiedByRole // ignore: cast_nullable_to_non_nullable
              as String?,
      contactInfoJson: freezed == contactInfoJson
          ? _value.contactInfoJson
          : contactInfoJson // ignore: cast_nullable_to_non_nullable
              as String?,
      familyInfoJson: freezed == familyInfoJson
          ? _value.familyInfoJson
          : familyInfoJson // ignore: cast_nullable_to_non_nullable
              as String?,
      spiritualInfoJson: freezed == spiritualInfoJson
          ? _value.spiritualInfoJson
          : spiritualInfoJson // ignore: cast_nullable_to_non_nullable
              as String?,
      engagementInfoJson: freezed == engagementInfoJson
          ? _value.engagementInfoJson
          : engagementInfoJson // ignore: cast_nullable_to_non_nullable
              as String?,
      professionalInfoJson: freezed == professionalInfoJson
          ? _value.professionalInfoJson
          : professionalInfoJson // ignore: cast_nullable_to_non_nullable
              as String?,
      addressesJson: freezed == addressesJson
          ? _value.addressesJson
          : addressesJson // ignore: cast_nullable_to_non_nullable
              as String?,
      customFieldsJson: freezed == customFieldsJson
          ? _value.customFieldsJson
          : customFieldsJson // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MemberImpl extends _Member {
  const _$MemberImpl(
      {required this.id,
      @JsonKey(name: 'user_id') this.userId,
      required this.churchId,
      this.memberNumber,
      this.qrCode,
      required this.lastName,
      required this.firstName,
      this.middleName,
      this.maidenName,
      this.nickname,
      this.title,
      this.suffix,
      this.gender = Gender.male,
      this.birthDate,
      this.birthCity,
      this.birthCountry,
      this.deathDate,
      this.photoUrl,
      this.thumbnailUrl,
      this.status = MemberStatus.active,
      this.membershipType = MembershipType.visitor,
      this.joiningDate,
      this.membershipDate,
      this.lastActiveDate,
      this.statusNote,
      this.email,
      this.phone,
      this.whatsapp,
      this.acceptsWhatsApp = false,
      this.acceptsSms = false,
      this.acceptsEmail = false,
      this.emergencyContactName,
      this.emergencyContactPhone,
      this.emergencyContactRelation,
      this.addressLine1,
      this.neighborhood,
      this.city,
      this.region,
      this.postalCode,
      this.country = 'Côte d\'Ivoire',
      this.landmark,
      this.latitude,
      this.longitude,
      this.maritalStatus = MaritalStatus.single,
      this.spouseMemberId,
      this.spouseName,
      this.numberOfChildren = 0,
      this.weddingDate,
      this.isBaptized = false,
      this.baptismDate,
      this.baptismLocation,
      this.isConverted = false,
      this.conversionDate,
      this.hasCompletedMembershipClass = false,
      this.hasCompletedMaturityClass = false,
      this.primaryRoleType,
      this.primaryRoleTitle,
      this.cellId,
      this.cellName,
      final List<String> ministryIds = const [],
      this.attendanceLevel = AttendanceLevel.regular,
      this.isLeader = false,
      this.employmentStatus = EmploymentStatus.employed,
      this.profession,
      this.employer,
      this.educationLevel = EducationLevel.highSchool,
      this.isRegularTither = false,
      this.lastContributionDate,
      this.totalContributionsThisYear = 0.0,
      this.createdAt,
      this.updatedAt,
      this.createdBy,
      this.updatedBy,
      this.isDeleted = false,
      this.deletedAt,
      this.lastModifiedBy,
      this.lastModifiedAt,
      this.lastModifiedByName,
      this.lastModifiedByRole,
      this.contactInfoJson,
      this.familyInfoJson,
      this.spiritualInfoJson,
      this.engagementInfoJson,
      this.professionalInfoJson,
      this.addressesJson,
      this.customFieldsJson})
      : _ministryIds = ministryIds,
        super._();

  factory _$MemberImpl.fromJson(Map<String, dynamic> json) =>
      _$$MemberImplFromJson(json);

// ==========================================
// IDENTIFICATION SYSTÈME
// ==========================================
  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String? userId;
// Lien vers le compte utilisateur Auth
  @override
  final String churchId;
// ID de l'église (Multi-Églises)
  @override
  final String? memberNumber;
// Numéro de membre
  @override
  final String? qrCode;
// Code QR unique
// ==========================================
// IDENTITÉ
// ==========================================
  @override
  final String lastName;
// Nom de famille
  @override
  final String firstName;
// Prénom
  @override
  final String? middleName;
// Autres prénoms
  @override
  final String? maidenName;
// Nom de jeune fille
  @override
  final String? nickname;
// Appellation courante (ex: "Frère Jean")
  @override
  final String? title;
// Titre (Dr., Ing., etc.)
  @override
  final String? suffix;
// Suffixe (Jr., Sr., etc.)
// Genre et dates clés
  @override
  @JsonKey()
  final Gender gender;
  @override
  final DateTime? birthDate;
  @override
  final String? birthCity;
  @override
  final String? birthCountry;
  @override
  final DateTime? deathDate;
// Photo
  @override
  final String? photoUrl;
  @override
  final String? thumbnailUrl;
// ==========================================
// STATUT
// ==========================================
  @override
  @JsonKey()
  final MemberStatus status;
  @override
  @JsonKey()
  final MembershipType membershipType;
  @override
  final DateTime? joiningDate;
// Date d'arrivée
  @override
  final DateTime? membershipDate;
// Date d'adhésion officielle
  @override
  final DateTime? lastActiveDate;
  @override
  final String? statusNote;
// ==========================================
// CONTACT (version simplifiée pour Isar)
// Utiliser contactInfo pour version complète en JSON Supabase
// ==========================================
  @override
  final String? email;
  @override
  final String? phone;
  @override
  final String? whatsapp;
  @override
  @JsonKey()
  final bool acceptsWhatsApp;
  @override
  @JsonKey()
  final bool acceptsSms;
  @override
  @JsonKey()
  final bool acceptsEmail;
// Contact d'urgence
  @override
  final String? emergencyContactName;
  @override
  final String? emergencyContactPhone;
  @override
  final String? emergencyContactRelation;
// ==========================================
// ADRESSE (version simplifiée pour Isar)
// ==========================================
  @override
  final String? addressLine1;
  @override
  final String? neighborhood;
// Quartier
  @override
  final String? city;
  @override
  final String? region;
  @override
  final String? postalCode;
  @override
  @JsonKey()
  final String country;
  @override
  final String? landmark;
// Point de repère
  @override
  final double? latitude;
  @override
  final double? longitude;
// ==========================================
// FAMILLE (infos de base pour Isar)
// ==========================================
  @override
  @JsonKey()
  final MaritalStatus maritalStatus;
  @override
  final String? spouseMemberId;
// ID du conjoint si membre
  @override
  final String? spouseName;
// Nom du conjoint
  @override
  @JsonKey()
  final int numberOfChildren;
  @override
  final DateTime? weddingDate;
// ==========================================
// SPIRITUALITÉ (infos essentielles pour Isar)
// ==========================================
  @override
  @JsonKey()
  final bool isBaptized;
  @override
  final DateTime? baptismDate;
  @override
  final String? baptismLocation;
  @override
  @JsonKey()
  final bool isConverted;
  @override
  final DateTime? conversionDate;
  @override
  @JsonKey()
  final bool hasCompletedMembershipClass;
  @override
  @JsonKey()
  final bool hasCompletedMaturityClass;
// ==========================================
// ENGAGEMENT (essentiel pour Isar)
// ==========================================
  @override
  final String? primaryRoleType;
// ChurchRoleType.name
  @override
  final String? primaryRoleTitle;
  @override
  final String? cellId;
  @override
  final String? cellName;
  final List<String> _ministryIds;
  @override
  @JsonKey()
  List<String> get ministryIds {
    if (_ministryIds is EqualUnmodifiableListView) return _ministryIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ministryIds);
  }

  @override
  @JsonKey()
  final AttendanceLevel attendanceLevel;
  @override
  @JsonKey()
  final bool isLeader;
// ==========================================
// PROFESSIONNEL (essentiel)
// ==========================================
  @override
  @JsonKey()
  final EmploymentStatus employmentStatus;
  @override
  final String? profession;
  @override
  final String? employer;
  @override
  @JsonKey()
  final EducationLevel educationLevel;
// ==========================================
// CONTRIBUTIONS
// ==========================================
  @override
  @JsonKey()
  final bool isRegularTither;
  @override
  final DateTime? lastContributionDate;
  @override
  @JsonKey()
  final double totalContributionsThisYear;
// ==========================================
// DATES SYSTÈME
// ==========================================
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final String? createdBy;
  @override
  final String? updatedBy;
  @override
  @JsonKey()
  final bool isDeleted;
  @override
  final DateTime? deletedAt;
// Audit Trail
  @override
  final String? lastModifiedBy;
// Profile UUID
  @override
  final DateTime? lastModifiedAt;
  @override
  final String? lastModifiedByName;
// Joined from profiles
  @override
  final String? lastModifiedByRole;
// Joined from profiles.role
// ==========================================
// MÉTADONNÉES SUPPLÉMENTAIRES
// Pour stocker les objets complexes en JSON
// ==========================================
  @override
  final String? contactInfoJson;
// ContactInfo sérialisé
  @override
  final String? familyInfoJson;
// FamilyInfo sérialisé
  @override
  final String? spiritualInfoJson;
// SpiritualInfo sérialisé
  @override
  final String? engagementInfoJson;
// EngagementInfo sérialisé
  @override
  final String? professionalInfoJson;
// ProfessionalInfo sérialisé
  @override
  final String? addressesJson;
// List<Address> sérialisé
  @override
  final String? customFieldsJson;

  @override
  String toString() {
    return 'Member(id: $id, userId: $userId, churchId: $churchId, memberNumber: $memberNumber, qrCode: $qrCode, lastName: $lastName, firstName: $firstName, middleName: $middleName, maidenName: $maidenName, nickname: $nickname, title: $title, suffix: $suffix, gender: $gender, birthDate: $birthDate, birthCity: $birthCity, birthCountry: $birthCountry, deathDate: $deathDate, photoUrl: $photoUrl, thumbnailUrl: $thumbnailUrl, status: $status, membershipType: $membershipType, joiningDate: $joiningDate, membershipDate: $membershipDate, lastActiveDate: $lastActiveDate, statusNote: $statusNote, email: $email, phone: $phone, whatsapp: $whatsapp, acceptsWhatsApp: $acceptsWhatsApp, acceptsSms: $acceptsSms, acceptsEmail: $acceptsEmail, emergencyContactName: $emergencyContactName, emergencyContactPhone: $emergencyContactPhone, emergencyContactRelation: $emergencyContactRelation, addressLine1: $addressLine1, neighborhood: $neighborhood, city: $city, region: $region, postalCode: $postalCode, country: $country, landmark: $landmark, latitude: $latitude, longitude: $longitude, maritalStatus: $maritalStatus, spouseMemberId: $spouseMemberId, spouseName: $spouseName, numberOfChildren: $numberOfChildren, weddingDate: $weddingDate, isBaptized: $isBaptized, baptismDate: $baptismDate, baptismLocation: $baptismLocation, isConverted: $isConverted, conversionDate: $conversionDate, hasCompletedMembershipClass: $hasCompletedMembershipClass, hasCompletedMaturityClass: $hasCompletedMaturityClass, primaryRoleType: $primaryRoleType, primaryRoleTitle: $primaryRoleTitle, cellId: $cellId, cellName: $cellName, ministryIds: $ministryIds, attendanceLevel: $attendanceLevel, isLeader: $isLeader, employmentStatus: $employmentStatus, profession: $profession, employer: $employer, educationLevel: $educationLevel, isRegularTither: $isRegularTither, lastContributionDate: $lastContributionDate, totalContributionsThisYear: $totalContributionsThisYear, createdAt: $createdAt, updatedAt: $updatedAt, createdBy: $createdBy, updatedBy: $updatedBy, isDeleted: $isDeleted, deletedAt: $deletedAt, lastModifiedBy: $lastModifiedBy, lastModifiedAt: $lastModifiedAt, lastModifiedByName: $lastModifiedByName, lastModifiedByRole: $lastModifiedByRole, contactInfoJson: $contactInfoJson, familyInfoJson: $familyInfoJson, spiritualInfoJson: $spiritualInfoJson, engagementInfoJson: $engagementInfoJson, professionalInfoJson: $professionalInfoJson, addressesJson: $addressesJson, customFieldsJson: $customFieldsJson)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MemberImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.churchId, churchId) ||
                other.churchId == churchId) &&
            (identical(other.memberNumber, memberNumber) ||
                other.memberNumber == memberNumber) &&
            (identical(other.qrCode, qrCode) || other.qrCode == qrCode) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.middleName, middleName) ||
                other.middleName == middleName) &&
            (identical(other.maidenName, maidenName) ||
                other.maidenName == maidenName) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.suffix, suffix) || other.suffix == suffix) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.birthDate, birthDate) ||
                other.birthDate == birthDate) &&
            (identical(other.birthCity, birthCity) ||
                other.birthCity == birthCity) &&
            (identical(other.birthCountry, birthCountry) ||
                other.birthCountry == birthCountry) &&
            (identical(other.deathDate, deathDate) ||
                other.deathDate == deathDate) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl) &&
            (identical(other.thumbnailUrl, thumbnailUrl) ||
                other.thumbnailUrl == thumbnailUrl) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.membershipType, membershipType) ||
                other.membershipType == membershipType) &&
            (identical(other.joiningDate, joiningDate) ||
                other.joiningDate == joiningDate) &&
            (identical(other.membershipDate, membershipDate) ||
                other.membershipDate == membershipDate) &&
            (identical(other.lastActiveDate, lastActiveDate) ||
                other.lastActiveDate == lastActiveDate) &&
            (identical(other.statusNote, statusNote) ||
                other.statusNote == statusNote) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.whatsapp, whatsapp) ||
                other.whatsapp == whatsapp) &&
            (identical(other.acceptsWhatsApp, acceptsWhatsApp) ||
                other.acceptsWhatsApp == acceptsWhatsApp) &&
            (identical(other.acceptsSms, acceptsSms) ||
                other.acceptsSms == acceptsSms) &&
            (identical(other.acceptsEmail, acceptsEmail) ||
                other.acceptsEmail == acceptsEmail) &&
            (identical(other.emergencyContactName, emergencyContactName) ||
                other.emergencyContactName == emergencyContactName) &&
            (identical(other.emergencyContactPhone, emergencyContactPhone) ||
                other.emergencyContactPhone == emergencyContactPhone) &&
            (identical(other.emergencyContactRelation, emergencyContactRelation) ||
                other.emergencyContactRelation == emergencyContactRelation) &&
            (identical(other.addressLine1, addressLine1) ||
                other.addressLine1 == addressLine1) &&
            (identical(other.neighborhood, neighborhood) ||
                other.neighborhood == neighborhood) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.region, region) || other.region == region) &&
            (identical(other.postalCode, postalCode) ||
                other.postalCode == postalCode) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.landmark, landmark) ||
                other.landmark == landmark) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.maritalStatus, maritalStatus) ||
                other.maritalStatus == maritalStatus) &&
            (identical(other.spouseMemberId, spouseMemberId) ||
                other.spouseMemberId == spouseMemberId) &&
            (identical(other.spouseName, spouseName) ||
                other.spouseName == spouseName) &&
            (identical(other.numberOfChildren, numberOfChildren) ||
                other.numberOfChildren == numberOfChildren) &&
            (identical(other.weddingDate, weddingDate) ||
                other.weddingDate == weddingDate) &&
            (identical(other.isBaptized, isBaptized) ||
                other.isBaptized == isBaptized) &&
            (identical(other.baptismDate, baptismDate) ||
                other.baptismDate == baptismDate) &&
            (identical(other.baptismLocation, baptismLocation) ||
                other.baptismLocation == baptismLocation) &&
            (identical(other.isConverted, isConverted) ||
                other.isConverted == isConverted) &&
            (identical(other.conversionDate, conversionDate) ||
                other.conversionDate == conversionDate) &&
            (identical(other.hasCompletedMembershipClass, hasCompletedMembershipClass) || other.hasCompletedMembershipClass == hasCompletedMembershipClass) &&
            (identical(other.hasCompletedMaturityClass, hasCompletedMaturityClass) || other.hasCompletedMaturityClass == hasCompletedMaturityClass) &&
            (identical(other.primaryRoleType, primaryRoleType) || other.primaryRoleType == primaryRoleType) &&
            (identical(other.primaryRoleTitle, primaryRoleTitle) || other.primaryRoleTitle == primaryRoleTitle) &&
            (identical(other.cellId, cellId) || other.cellId == cellId) &&
            (identical(other.cellName, cellName) || other.cellName == cellName) &&
            const DeepCollectionEquality().equals(other._ministryIds, _ministryIds) &&
            (identical(other.attendanceLevel, attendanceLevel) || other.attendanceLevel == attendanceLevel) &&
            (identical(other.isLeader, isLeader) || other.isLeader == isLeader) &&
            (identical(other.employmentStatus, employmentStatus) || other.employmentStatus == employmentStatus) &&
            (identical(other.profession, profession) || other.profession == profession) &&
            (identical(other.employer, employer) || other.employer == employer) &&
            (identical(other.educationLevel, educationLevel) || other.educationLevel == educationLevel) &&
            (identical(other.isRegularTither, isRegularTither) || other.isRegularTither == isRegularTither) &&
            (identical(other.lastContributionDate, lastContributionDate) || other.lastContributionDate == lastContributionDate) &&
            (identical(other.totalContributionsThisYear, totalContributionsThisYear) || other.totalContributionsThisYear == totalContributionsThisYear) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt) &&
            (identical(other.createdBy, createdBy) || other.createdBy == createdBy) &&
            (identical(other.updatedBy, updatedBy) || other.updatedBy == updatedBy) &&
            (identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted) &&
            (identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt) &&
            (identical(other.lastModifiedBy, lastModifiedBy) || other.lastModifiedBy == lastModifiedBy) &&
            (identical(other.lastModifiedAt, lastModifiedAt) || other.lastModifiedAt == lastModifiedAt) &&
            (identical(other.lastModifiedByName, lastModifiedByName) || other.lastModifiedByName == lastModifiedByName) &&
            (identical(other.lastModifiedByRole, lastModifiedByRole) || other.lastModifiedByRole == lastModifiedByRole) &&
            (identical(other.contactInfoJson, contactInfoJson) || other.contactInfoJson == contactInfoJson) &&
            (identical(other.familyInfoJson, familyInfoJson) || other.familyInfoJson == familyInfoJson) &&
            (identical(other.spiritualInfoJson, spiritualInfoJson) || other.spiritualInfoJson == spiritualInfoJson) &&
            (identical(other.engagementInfoJson, engagementInfoJson) || other.engagementInfoJson == engagementInfoJson) &&
            (identical(other.professionalInfoJson, professionalInfoJson) || other.professionalInfoJson == professionalInfoJson) &&
            (identical(other.addressesJson, addressesJson) || other.addressesJson == addressesJson) &&
            (identical(other.customFieldsJson, customFieldsJson) || other.customFieldsJson == customFieldsJson));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        userId,
        churchId,
        memberNumber,
        qrCode,
        lastName,
        firstName,
        middleName,
        maidenName,
        nickname,
        title,
        suffix,
        gender,
        birthDate,
        birthCity,
        birthCountry,
        deathDate,
        photoUrl,
        thumbnailUrl,
        status,
        membershipType,
        joiningDate,
        membershipDate,
        lastActiveDate,
        statusNote,
        email,
        phone,
        whatsapp,
        acceptsWhatsApp,
        acceptsSms,
        acceptsEmail,
        emergencyContactName,
        emergencyContactPhone,
        emergencyContactRelation,
        addressLine1,
        neighborhood,
        city,
        region,
        postalCode,
        country,
        landmark,
        latitude,
        longitude,
        maritalStatus,
        spouseMemberId,
        spouseName,
        numberOfChildren,
        weddingDate,
        isBaptized,
        baptismDate,
        baptismLocation,
        isConverted,
        conversionDate,
        hasCompletedMembershipClass,
        hasCompletedMaturityClass,
        primaryRoleType,
        primaryRoleTitle,
        cellId,
        cellName,
        const DeepCollectionEquality().hash(_ministryIds),
        attendanceLevel,
        isLeader,
        employmentStatus,
        profession,
        employer,
        educationLevel,
        isRegularTither,
        lastContributionDate,
        totalContributionsThisYear,
        createdAt,
        updatedAt,
        createdBy,
        updatedBy,
        isDeleted,
        deletedAt,
        lastModifiedBy,
        lastModifiedAt,
        lastModifiedByName,
        lastModifiedByRole,
        contactInfoJson,
        familyInfoJson,
        spiritualInfoJson,
        engagementInfoJson,
        professionalInfoJson,
        addressesJson,
        customFieldsJson
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MemberImplCopyWith<_$MemberImpl> get copyWith =>
      __$$MemberImplCopyWithImpl<_$MemberImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MemberImplToJson(
      this,
    );
  }
}

abstract class _Member extends Member {
  const factory _Member(
      {required final String id,
      @JsonKey(name: 'user_id') final String? userId,
      required final String churchId,
      final String? memberNumber,
      final String? qrCode,
      required final String lastName,
      required final String firstName,
      final String? middleName,
      final String? maidenName,
      final String? nickname,
      final String? title,
      final String? suffix,
      final Gender gender,
      final DateTime? birthDate,
      final String? birthCity,
      final String? birthCountry,
      final DateTime? deathDate,
      final String? photoUrl,
      final String? thumbnailUrl,
      final MemberStatus status,
      final MembershipType membershipType,
      final DateTime? joiningDate,
      final DateTime? membershipDate,
      final DateTime? lastActiveDate,
      final String? statusNote,
      final String? email,
      final String? phone,
      final String? whatsapp,
      final bool acceptsWhatsApp,
      final bool acceptsSms,
      final bool acceptsEmail,
      final String? emergencyContactName,
      final String? emergencyContactPhone,
      final String? emergencyContactRelation,
      final String? addressLine1,
      final String? neighborhood,
      final String? city,
      final String? region,
      final String? postalCode,
      final String country,
      final String? landmark,
      final double? latitude,
      final double? longitude,
      final MaritalStatus maritalStatus,
      final String? spouseMemberId,
      final String? spouseName,
      final int numberOfChildren,
      final DateTime? weddingDate,
      final bool isBaptized,
      final DateTime? baptismDate,
      final String? baptismLocation,
      final bool isConverted,
      final DateTime? conversionDate,
      final bool hasCompletedMembershipClass,
      final bool hasCompletedMaturityClass,
      final String? primaryRoleType,
      final String? primaryRoleTitle,
      final String? cellId,
      final String? cellName,
      final List<String> ministryIds,
      final AttendanceLevel attendanceLevel,
      final bool isLeader,
      final EmploymentStatus employmentStatus,
      final String? profession,
      final String? employer,
      final EducationLevel educationLevel,
      final bool isRegularTither,
      final DateTime? lastContributionDate,
      final double totalContributionsThisYear,
      final DateTime? createdAt,
      final DateTime? updatedAt,
      final String? createdBy,
      final String? updatedBy,
      final bool isDeleted,
      final DateTime? deletedAt,
      final String? lastModifiedBy,
      final DateTime? lastModifiedAt,
      final String? lastModifiedByName,
      final String? lastModifiedByRole,
      final String? contactInfoJson,
      final String? familyInfoJson,
      final String? spiritualInfoJson,
      final String? engagementInfoJson,
      final String? professionalInfoJson,
      final String? addressesJson,
      final String? customFieldsJson}) = _$MemberImpl;
  const _Member._() : super._();

  factory _Member.fromJson(Map<String, dynamic> json) = _$MemberImpl.fromJson;

  @override // ==========================================
// IDENTIFICATION SYSTÈME
// ==========================================
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String? get userId;
  @override // Lien vers le compte utilisateur Auth
  String get churchId;
  @override // ID de l'église (Multi-Églises)
  String? get memberNumber;
  @override // Numéro de membre
  String? get qrCode;
  @override // Code QR unique
// ==========================================
// IDENTITÉ
// ==========================================
  String get lastName;
  @override // Nom de famille
  String get firstName;
  @override // Prénom
  String? get middleName;
  @override // Autres prénoms
  String? get maidenName;
  @override // Nom de jeune fille
  String? get nickname;
  @override // Appellation courante (ex: "Frère Jean")
  String? get title;
  @override // Titre (Dr., Ing., etc.)
  String? get suffix;
  @override // Suffixe (Jr., Sr., etc.)
// Genre et dates clés
  Gender get gender;
  @override
  DateTime? get birthDate;
  @override
  String? get birthCity;
  @override
  String? get birthCountry;
  @override
  DateTime? get deathDate;
  @override // Photo
  String? get photoUrl;
  @override
  String? get thumbnailUrl;
  @override // ==========================================
// STATUT
// ==========================================
  MemberStatus get status;
  @override
  MembershipType get membershipType;
  @override
  DateTime? get joiningDate;
  @override // Date d'arrivée
  DateTime? get membershipDate;
  @override // Date d'adhésion officielle
  DateTime? get lastActiveDate;
  @override
  String? get statusNote;
  @override // ==========================================
// CONTACT (version simplifiée pour Isar)
// Utiliser contactInfo pour version complète en JSON Supabase
// ==========================================
  String? get email;
  @override
  String? get phone;
  @override
  String? get whatsapp;
  @override
  bool get acceptsWhatsApp;
  @override
  bool get acceptsSms;
  @override
  bool get acceptsEmail;
  @override // Contact d'urgence
  String? get emergencyContactName;
  @override
  String? get emergencyContactPhone;
  @override
  String? get emergencyContactRelation;
  @override // ==========================================
// ADRESSE (version simplifiée pour Isar)
// ==========================================
  String? get addressLine1;
  @override
  String? get neighborhood;
  @override // Quartier
  String? get city;
  @override
  String? get region;
  @override
  String? get postalCode;
  @override
  String get country;
  @override
  String? get landmark;
  @override // Point de repère
  double? get latitude;
  @override
  double? get longitude;
  @override // ==========================================
// FAMILLE (infos de base pour Isar)
// ==========================================
  MaritalStatus get maritalStatus;
  @override
  String? get spouseMemberId;
  @override // ID du conjoint si membre
  String? get spouseName;
  @override // Nom du conjoint
  int get numberOfChildren;
  @override
  DateTime? get weddingDate;
  @override // ==========================================
// SPIRITUALITÉ (infos essentielles pour Isar)
// ==========================================
  bool get isBaptized;
  @override
  DateTime? get baptismDate;
  @override
  String? get baptismLocation;
  @override
  bool get isConverted;
  @override
  DateTime? get conversionDate;
  @override
  bool get hasCompletedMembershipClass;
  @override
  bool get hasCompletedMaturityClass;
  @override // ==========================================
// ENGAGEMENT (essentiel pour Isar)
// ==========================================
  String? get primaryRoleType;
  @override // ChurchRoleType.name
  String? get primaryRoleTitle;
  @override
  String? get cellId;
  @override
  String? get cellName;
  @override
  List<String> get ministryIds;
  @override
  AttendanceLevel get attendanceLevel;
  @override
  bool get isLeader;
  @override // ==========================================
// PROFESSIONNEL (essentiel)
// ==========================================
  EmploymentStatus get employmentStatus;
  @override
  String? get profession;
  @override
  String? get employer;
  @override
  EducationLevel get educationLevel;
  @override // ==========================================
// CONTRIBUTIONS
// ==========================================
  bool get isRegularTither;
  @override
  DateTime? get lastContributionDate;
  @override
  double get totalContributionsThisYear;
  @override // ==========================================
// DATES SYSTÈME
// ==========================================
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  String? get createdBy;
  @override
  String? get updatedBy;
  @override
  bool get isDeleted;
  @override
  DateTime? get deletedAt;
  @override // Audit Trail
  String? get lastModifiedBy;
  @override // Profile UUID
  DateTime? get lastModifiedAt;
  @override
  String? get lastModifiedByName;
  @override // Joined from profiles
  String? get lastModifiedByRole;
  @override // Joined from profiles.role
// ==========================================
// MÉTADONNÉES SUPPLÉMENTAIRES
// Pour stocker les objets complexes en JSON
// ==========================================
  String? get contactInfoJson;
  @override // ContactInfo sérialisé
  String? get familyInfoJson;
  @override // FamilyInfo sérialisé
  String? get spiritualInfoJson;
  @override // SpiritualInfo sérialisé
  String? get engagementInfoJson;
  @override // EngagementInfo sérialisé
  String? get professionalInfoJson;
  @override // ProfessionalInfo sérialisé
  String? get addressesJson;
  @override // List<Address> sérialisé
  String? get customFieldsJson;
  @override
  @JsonKey(ignore: true)
  _$$MemberImplCopyWith<_$MemberImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
