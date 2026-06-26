// lib/features/membres/domain/entities/spiritual_info.dart
// Informations spirituelles du membre

import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums/enums.dart';

part 'spiritual_info.freezed.dart';
part 'spiritual_info.g.dart';

/// Historique d'une étape spirituelle
@freezed
class SpiritualMilestone with _$SpiritualMilestone {
  const factory SpiritualMilestone({
    required String name,
    DateTime? date,
    String? location,
    String? officiant, // Pasteur/Officiant
    String? witnesses, // Témoins
    String? notes,
  }) = _SpiritualMilestone;

  factory SpiritualMilestone.fromJson(Map<String, dynamic> json) =>
      _$SpiritualMilestoneFromJson(json);
}

/// Informations spirituelles complètes
@freezed
class SpiritualInfo with _$SpiritualInfo {
  const SpiritualInfo._();

  const factory SpiritualInfo({
    // Conversion
    @Default(true) bool isConverted,
    DateTime? conversionDate,
    String? conversionStory,
    String? conversionPlace,

    // Baptême
    @Default(false) bool isBaptized,
    DateTime? baptismDate,
    String? baptismPlace,
    String? baptismOfficiant, // Qui a baptisé
    @Default(BaptismType.immersion) BaptismType baptismType,
    String? godfather, // Parrain spirituel
    String? godmother, // Marraine spirituelle
    // Formation biblique
    @Default(false) bool hasCompletedBibleStudy,
    @Default(false) bool hasCompletedMembershipClass,
    @Default(false) bool isCurrentlyInFormation,
    String? currentFormation,
    @Default([]) List<String> completedFormations,

    // Engagement
    @Default(false) bool hasSignedMembershipCovenent, // Pacte d'adhésion
    DateTime? membershipDate,
    String? previousChurch,
    String? reasonForTransfer,
    DateTime? transferDate,
    String? transferCertificate,

    // Discipline (si applicable)
    @Default(false) bool isUnderDiscipline,
    DateTime? disciplineStartDate,
    String? disciplineReason,
    DateTime? restorationDate,

    // Étapes importantes
    @Default([]) List<SpiritualMilestone> milestones,

    // Dons spirituels identifiés
    @Default([]) List<String> spiritualGifts,

    // Croissance
    String? discipleshipLevel,
    String? mentor, // Mentor spirituel
    @Default([]) List<String> mentees, // Disciples
    // Témoignage
    String? shortTestimony,
    String? fullTestimony,

    // Notes pastorales (accès restreint)
    String? pastoralNotes,
  }) = _SpiritualInfo;

  /// Années depuis le baptême
  int? get yearsSinceBaptism {
    if (baptismDate == null) return null;
    return DateTime.now().difference(baptismDate!).inDays ~/ 365;
  }

  /// Années depuis la conversion
  int? get yearAsChristian {
    if (conversionDate == null) return null;
    return DateTime.now().difference(conversionDate!).inDays ~/ 365;
  }

  /// Résumé du parcours spirituel
  String get spiritualSummary {
    final parts = <String>[];
    if (isBaptized && baptismDate != null) {
      parts.add('Baptisé(e) le ${_formatDate(baptismDate!)}');
    }
    if (isConverted && conversionDate != null) {
      parts.add('Converti(e) depuis ${yearAsChristian ?? "?"} ans');
    }
    if (spiritualGifts.isNotEmpty) {
      parts.add('Dons : ${spiritualGifts.take(3).join(", ")}');
    }
    return parts.isEmpty ? 'Aucune information' : parts.join(' • ');
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  factory SpiritualInfo.fromJson(Map<String, dynamic> json) =>
      _$SpiritualInfoFromJson(json);
}