// lib/features/membres/domain/entities/child_info.dart
// Informations sur les enfants

import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums/enums.dart';

part 'child_info.freezed.dart';
part 'child_info.g.dart';

/// Statut de l'enfant
enum ChildStatus {
  living, // Vivant
  deceased, // Décédé
  adopted, // Adopté
  fosterChild, // Enfant placé
  stepChild; // Beau-fils/belle-fille

  String get label {
    switch (this) {
      case ChildStatus.living:
        return 'Vivant';
      case ChildStatus.deceased:
        return 'Décédé';
      case ChildStatus.adopted:
        return 'Adopté';
      case ChildStatus.fosterChild:
        return 'Enfant placé';
      case ChildStatus.stepChild:
        return 'Beau-fils/fille';
    }
  }
}

@freezed
class ChildInfo with _$ChildInfo {
  const ChildInfo._();

  const factory ChildInfo({
    // Lien si l'enfant est aussi membre
    String? memberId,
    @Default(false) bool isMember,

    // Identité
    required String lastName,
    required String firstName,
    String? middleName,
    required Gender gender,
    String? photoUrl,

    // Naissance
    DateTime? birthDate,
    String? birthPlace,

    // Statut
    @Default(ChildStatus.living) ChildStatus status,
    @Default(true) bool isDependent, // À charge
    @Default(false) bool isAdopted,
    @Default(false) bool isStepChild,
    @Default(1) int birthOrder, // Rang de naissance
    // Si décédé
    DateTime? deathDate,

    // Éducation
    String? schoolName,
    String? gradeLevel,

    // Spiritualité
    @Default(false) bool isConverted,
    @Default(false) bool isBaptized,
    DateTime? baptismDate,
    @Default(false) bool attendsSundaySchool,
    String? sundaySchoolClass,

    // Contact (si adulte)
    String? phone,
    String? email,
    String? address,
  }) = _ChildInfo;

  /// Nom complet
  String get fullName {
    final parts = <String>[firstName];
    if (middleName != null && middleName!.isNotEmpty) {
      parts.add(middleName!);
    }
    parts.add(lastName);
    return parts.join(' ');
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

  /// Est mineur (<18 ans)
  bool get isMinor => age != null && age! < 18;

  /// Est adulte (>=18 ans)
  bool get isAdult => age != null && age! >= 18;

  /// Icône selon le genre et l'âge
  String get icon {
    return ''; // Emojis banned (Zero Emoji Policy 2026)
  }

  factory ChildInfo.fromJson(Map<String, dynamic> json) =>
      _$ChildInfoFromJson(json);
}