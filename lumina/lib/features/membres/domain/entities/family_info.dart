// lib/features/membres/domain/entities/family_info.dart
// Informations familiales complètes

import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums/enums.dart';
import 'spouse_info.dart';
import 'child_info.dart';

part 'family_info.freezed.dart';
part 'family_info.g.dart';

/// Informations sur le mariage
@freezed
class WeddingInfo with _$WeddingInfo {
  const WeddingInfo._();

  const factory WeddingInfo({
    // Type et dates
    @Default(WeddingType.churchAndCivil) WeddingType type,
    DateTime? civilWeddingDate,
    String? civilWeddingLocation,
    DateTime? churchWeddingDate,
    String? churchWeddingLocation,
    String? churchWeddingOfficiant,
    DateTime? traditionalWeddingDate,
    String? traditionalWeddingLocation,

    // Détails
    String? weddingCertificateNumber,
    @Default(false) bool hasWeddingCertificate,

    // Témoins
    @Default([]) List<String> witnesses,
  }) = _WeddingInfo;

  /// Date principale du mariage (religieux si disponible)
  DateTime? get mainWeddingDate =>
      churchWeddingDate ?? civilWeddingDate ?? traditionalWeddingDate;

  /// Années de mariage
  int? get yearsMarried {
    final date = mainWeddingDate;
    if (date == null) return null;
    return DateTime.now().difference(date).inDays ~/ 365;
  }

  /// Prochain anniversaire de mariage
  DateTime? get nextAnniversary {
    final date = mainWeddingDate;
    if (date == null) return null;
    final now = DateTime.now();
    var anniversary = DateTime(now.year, date.month, date.day);
    if (anniversary.isBefore(now)) {
      anniversary = DateTime(now.year + 1, date.month, date.day);
    }
    return anniversary;
  }

  /// Jours jusqu'au prochain anniversaire
  int? get daysUntilAnniversary {
    final next = nextAnniversary;
    if (next == null) return null;
    return next.difference(DateTime.now()).inDays;
  }

  factory WeddingInfo.fromJson(Map<String, dynamic> json) =>
      _$WeddingInfoFromJson(json);
}

/// Informations familiales complètes
@freezed
class FamilyInfo with _$FamilyInfo {
  const FamilyInfo._();

  const factory FamilyInfo({
    // Situation matrimoniale
    @Default(MaritalStatus.single) MaritalStatus maritalStatus,

    // Si marié(e)
    SpouseInfo? spouse,
    WeddingInfo? wedding,

    // Enfants
    @Default([]) List<ChildInfo> children,
    @Default(0) int numberOfChildren,
    @Default(0) int numberOfChildrenLiving,
    @Default(0) int numberOfDependents,

    // Famille élargie dans l'église
    @Default([]) List<String> familyMemberIds,
    String? fatherMemberId,
    String? motherMemberId,
    @Default([]) List<String> siblingMemberIds,

    // Origine ethnique/tribale (contextuel Afrique)
    String? ethnicity,
    String? tribe,
    String? clan,
    String? villageOfOrigin,
    String? regionOfOrigin,

    // Lieu d'origine
    String? countryOfOrigin,
    String? hometownCity,
  }) = _FamilyInfo;

  /// A des enfants
  bool get hasChildren => children.isNotEmpty;

  /// Nombre d'enfants à l'école du dimanche
  int get childrenInSundaySchool =>
      children.where((c) => c.attendsSundaySchool).length;

  /// Enfants baptisés
  int get baptizedChildren => children.where((c) => c.isBaptized).length;

  /// Famille nucléaire complète dans l'église
  bool get hasSpouseInChurch => spouse?.isMember ?? false;

  /// Résumé de la situation familiale
  String get familySummary {
    final parts = <String>[];
    parts.add(maritalStatus.label);
    if (hasChildren) {
      parts.add('${children.length} enfant(s)');
    }
    return parts.join(' • ');
  }

  factory FamilyInfo.fromJson(Map<String, dynamic> json) =>
      _$FamilyInfoFromJson(json);
}