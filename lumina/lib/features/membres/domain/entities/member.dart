// lib/features/membres/domain/entities/member.dart
// Modèle Brebis (Membre) enrichi - ~180 champs

import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'enums/enums.dart';
import 'engagement_info.dart';
import 'spiritual_info.dart';

part 'member.freezed.dart';
part 'member.g.dart';
// ignore_for_file: invalid_annotation_target

/// Modèle principal du membre de l'église (Brebis)
/// Structure complète inspirée du contexte Baptiste Évangélique africain
@freezed
class Member with _$Member {
  const Member._();

  const factory Member({
    // ==========================================
    // IDENTIFICATION SYSTÈME
    // ==========================================
    required String id,
    @JsonKey(name: 'user_id')
    String? userId, // Lien vers le compte utilisateur Auth
    required String churchId, // ID de l'église (Multi-Églises)
    String? memberNumber, // Numéro de membre
    String? qrCode, // Code QR unique
    // ==========================================
    // IDENTITÉ
    // ==========================================
    required String lastName, // Nom de famille
    required String firstName, // Prénom
    String? middleName, // Autres prénoms
    String? maidenName, // Nom de jeune fille
    String? nickname, // Appellation courante (ex: "Frère Jean")
    String? title, // Titre (Dr., Ing., etc.)
    String? suffix, // Suffixe (Jr., Sr., etc.)
    // Genre et dates clés
    @Default(Gender.male) Gender gender,
    DateTime? birthDate,
    String? birthCity,
    String? birthCountry,
    DateTime? deathDate,

    // Photo
    String? photoUrl,
    String? thumbnailUrl,

    // ==========================================
    // STATUT
    // ==========================================
    @Default(MemberStatus.active) MemberStatus status,
    @Default(MembershipType.visitor) MembershipType membershipType,
    DateTime? joiningDate, // Date d'arrivée
    DateTime? membershipDate, // Date d'adhésion officielle
    DateTime? lastActiveDate,
    String? statusNote,

    // ==========================================
    // CONTACT (version simplifiée pour Isar)
    // Utiliser contactInfo pour version complète en JSON Supabase
    // ==========================================
    String? email,
    String? phone,
    String? whatsapp,
    @Default(false) bool acceptsWhatsApp,
    @Default(false) bool acceptsSms,
    @Default(false) bool acceptsEmail,

    // Contact d'urgence
    String? emergencyContactName,
    String? emergencyContactPhone,
    String? emergencyContactRelation,

    // ==========================================
    // ADRESSE (version simplifiée pour Isar)
    // ==========================================
    String? addressLine1,
    String? neighborhood, // Quartier
    String? city,
    String? region,
    String? postalCode,
    @Default('Côte d\'Ivoire') String country,
    String? landmark, // Point de repère
    double? latitude,
    double? longitude,

    // ==========================================
    // FAMILLE (infos de base pour Isar)
    // ==========================================
    @Default(MaritalStatus.single) MaritalStatus maritalStatus,
    String? spouseMemberId, // ID du conjoint si membre
    String? spouseName, // Nom du conjoint
    @Default(0) int numberOfChildren,
    DateTime? weddingDate,

    // ==========================================
    // SPIRITUALITÉ (infos essentielles pour Isar)
    // ==========================================
    @Default(false) bool isBaptized,
    DateTime? baptismDate,
    String? baptismLocation,
    @Default(false) bool isConverted,
    DateTime? conversionDate,
    @Default(false) bool hasCompletedMembershipClass,
    @Default(false) bool hasCompletedMaturityClass,

    // ==========================================
    // ENGAGEMENT (essentiel pour Isar)
    // ==========================================
    String? primaryRoleType, // ChurchRoleType.name
    String? primaryRoleTitle,
    String? cellId,
    String? cellName,
    @Default([]) List<String> ministryIds,
    @Default(AttendanceLevel.regular) AttendanceLevel attendanceLevel,
    @Default(false) bool isLeader,

    // ==========================================
    // PROFESSIONNEL (essentiel)
    // ==========================================
    @Default(EmploymentStatus.employed) EmploymentStatus employmentStatus,
    String? profession,
    String? employer,
    @Default(EducationLevel.highSchool) EducationLevel educationLevel,

    // ==========================================
    // CONTRIBUTIONS
    // ==========================================
    @Default(false) bool isRegularTither,
    DateTime? lastContributionDate,
    @Default(0.0) double totalContributionsThisYear,

    // ==========================================
    // DATES SYSTÈME
    // ==========================================
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
    String? updatedBy,
    @Default(false) bool isDeleted,
    DateTime? deletedAt,

    // Audit Trail
    String? lastModifiedBy, // Profile UUID
    DateTime? lastModifiedAt,
    String? lastModifiedByName, // Joined from profiles
    String? lastModifiedByRole, // Joined from profiles.role
    // ==========================================
    // MÉTADONNÉES SUPPLÉMENTAIRES
    // Pour stocker les objets complexes en JSON
    // ==========================================
    String? contactInfoJson, // ContactInfo sérialisé
    String? familyInfoJson, // FamilyInfo sérialisé
    String? spiritualInfoJson, // SpiritualInfo sérialisé
    String? engagementInfoJson, // EngagementInfo sérialisé
    String? professionalInfoJson, // ProfessionalInfo sérialisé
    String? addressesJson, // List<Address> sérialisé
    String? customFieldsJson, // Champs personnalisés
  }) = _Member;

  // ==========================================
  // PROPRIÉTÉS CALCULÉES
  // ==========================================

  /// Nom complet formaté
  String get fullName {
    final parts = <String>[];
    if (title != null && title!.isNotEmpty) {
      parts.add(title!);
    }
    parts.add(firstName);
    if (middleName != null && middleName!.isNotEmpty) {
      parts.add(middleName!);
    }
    parts.add(lastName);
    if (suffix != null && suffix!.isNotEmpty) {
      parts.add(suffix!);
    }
    return parts.join(' ');
  }

  /// Nom court (Prénom Nom)
  String get shortName => '$firstName $lastName';

  /// Nom d'affichage avec appellation
  String get displayName => nickname ?? shortName;

  /// Initiales
  String get initials {
    final f = firstName.isNotEmpty ? firstName[0].toUpperCase() : '';
    final l = lastName.isNotEmpty ? lastName[0].toUpperCase() : '';
    return '$f$l';
  }

  /// Âge calculé
  int? get age {
    if (birthDate == null) return null;
    final now = DateTime.now();
    int calculatedAge = now.year - birthDate!.year;
    if (now.month < birthDate!.month ||
        (now.month == birthDate!.month && now.day < birthDate!.day)) {
      calculatedAge--;
    }
    return calculatedAge;
  }

  /// Catégorie d'âge
  String get ageCategory {
    final a = age;
    if (a == null) return 'Inconnu';
    if (a < 13) return 'Enfant';
    if (a < 18) return 'Adolescent';
    if (a < 26) return 'Jeune';
    if (a < 36) return 'Jeune adulte';
    if (a < 50) return 'Adulte';
    if (a < 65) return 'Senior';
    return 'Aîné';
  }

  /// Prochain anniversaire
  DateTime? get nextBirthday {
    if (birthDate == null) return null;
    final now = DateTime.now();
    var birthday = DateTime(now.year, birthDate!.month, birthDate!.day);
    if (birthday.isBefore(now)) {
      birthday = DateTime(now.year + 1, birthDate!.month, birthDate!.day);
    }
    return birthday;
  }

  /// Jours jusqu'à l'anniversaire
  int? get daysUntilBirthday {
    final next = nextBirthday;
    if (next == null) return null;
    return next.difference(DateTime.now()).inDays;
  }

  /// Années comme membre
  int? get yearsAsMember {
    if (membershipDate == null) return null;
    return DateTime.now().difference(membershipDate!).inDays ~/ 365;
  }

  /// Est un visiteur
  bool get isVisitor => membershipType == MembershipType.visitor;

  /// Est un membre à plein droit
  bool get isFullMember => membershipType == MembershipType.fullMember;

  /// Adresse courte
  String get shortAddress {
    final parts = <String>[];
    if (neighborhood != null && neighborhood!.isNotEmpty) {
      parts.add(neighborhood!);
    }
    if (city != null && city!.isNotEmpty) {
      parts.add(city!);
    }
    return parts.isEmpty ? 'Adresse non renseignée' : parts.join(', ');
  }

  /// Alias for address
  String get address => shortAddress;

  /// Sous-titre pour l'affichage
  String get subtitle => primaryRoleTitle ?? status.label;

  /// Numéro de téléphone principal
  String? get primaryPhone => phone ?? whatsapp;

  /// Rôle principal comme ChurchRoleType
  ChurchRoleType get primaryRole {
    if (primaryRoleType == null) return ChurchRoleType.member;
    return ChurchRoleType.fromString(primaryRoleType);
  }

  /// Désérialisation de EngagementInfo
  EngagementInfo? get engagement {
    if (engagementInfoJson == null) return null;
    try {
      return EngagementInfo.fromJson(jsonDecode(engagementInfoJson!));
    } catch (_) {
      return null;
    }
  }

  /// Désérialisation de SpiritualInfo
  SpiritualInfo? get spiritual {
    if (spiritualInfoJson == null) return null;
    try {
      return SpiritualInfo.fromJson(jsonDecode(spiritualInfoJson!));
    } catch (_) {
      return null;
    }
  }

  /// Ministères actifs
  List<MinistryMembership> get ministries => engagement?.ministries ?? [];

  /// Résumé du statut
  String get statusSummary {
    final parts = <String>[];
    parts.add(status.label);
    if (isBaptized) parts.add('Baptisé(e)');
    if (isLeader) parts.add('Leader');
    return parts.join(' • ');
  }

  /// Résumé complet du profil
  String get profileSummary {
    final parts = <String>[];
    if (primaryRoleTitle != null) {
      parts.add(primaryRoleTitle!);
    }
    if (profession != null) {
      parts.add(profession!);
    }
    parts.add(maritalStatus.label);
    if (age != null) {
      parts.add('$age ans');
    }
    return parts.join(' • ');
  }

  // ==========================================
  // FACTORY CONSTRUCTORS
  // ==========================================

  factory Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);

  /// Créer un nouveau membre avec les valeurs par défaut
  factory Member.create({
    required String id,
    String? userId,
    required String churchId,
    required String lastName,
    required String firstName,
    Gender gender = Gender.male,
    MemberStatus status = MemberStatus.visitor,
    MembershipType membershipType = MembershipType.visitor,
    String? email,
    String? phone,
    String? city,
    String country = 'Côte d\'Ivoire',
  }) {
    return Member(
      id: id,
      userId: userId,
      churchId: churchId,
      lastName: lastName,
      firstName: firstName,
      gender: gender,
      status: status,
      membershipType: membershipType,
      email: email,
      phone: phone,
      city: city,
      country: country,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}