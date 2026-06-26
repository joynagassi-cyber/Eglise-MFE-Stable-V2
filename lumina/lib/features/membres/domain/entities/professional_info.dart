// lib/features/membres/domain/entities/professional_info.dart
// Informations professionnelles du membre

import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums/enums.dart';

part 'professional_info.freezed.dart';
part 'professional_info.g.dart';

/// Historique d'emploi
@freezed
class EmploymentHistory with _$EmploymentHistory {
  const EmploymentHistory._();

  const factory EmploymentHistory({
    required String jobTitle,
    required String company,
    String? industry,
    DateTime? startDate,
    DateTime? endDate,
    @Default(true) bool isCurrent,
    String? description,
  }) = _EmploymentHistory;

  /// Durée dans ce poste
  String get duration {
    if (startDate == null) return 'Durée inconnue';
    final end = endDate ?? DateTime.now();
    final years = end.difference(startDate!).inDays ~/ 365;
    final months = (end.difference(startDate!).inDays % 365) ~/ 30;
    if (years > 0) {
      return '$years an${years > 1 ? 's' : ''}${months > 0 ? ' $months mois' : ''}';
    }
    return '$months mois';
  }

  factory EmploymentHistory.fromJson(Map<String, dynamic> json) =>
      _$EmploymentHistoryFromJson(json);
}

/// Informations professionnelles complètes
@freezed
class ProfessionalInfo with _$ProfessionalInfo {
  const ProfessionalInfo._();

  const factory ProfessionalInfo({
    // Situation actuelle
    @Default(EmploymentStatus.employed) EmploymentStatus status,
    String? currentJobTitle,
    String? currentCompany,
    String? industry,
    String? department,
    String? workAddress,
    String? workPhone,
    String? workEmail,

    // Historique
    @Default([]) List<EmploymentHistory> employmentHistory,

    // Formation
    @Default(EducationLevel.highSchool) EducationLevel educationLevel,
    String? highestDegree,
    String? university,
    String? fieldOfStudy,
    int? graduationYear,
    @Default([]) List<String> certifications,
    @Default([]) List<String> specializations,

    // Compétences
    @Default([]) List<String> skills,
    @Default([]) List<String> languages,

    // Revenus (sensible - accès restreint)
    String? incomeRange,
    @Default(false) bool isFinanciallyStable,

    // Disponibilité pour aider
    @Default([]) List<String> canHelpWith,
    @Default([]) List<String> professionalGifts,
  }) = _ProfessionalInfo;

  /// Résumé du profil professionnel
  String get professionalSummary {
    final parts = <String>[];
    if (currentJobTitle != null && currentJobTitle!.isNotEmpty) {
      if (currentCompany != null && currentCompany!.isNotEmpty) {
        parts.add('$currentJobTitle chez $currentCompany');
      } else {
        parts.add(currentJobTitle!);
      }
    } else {
      parts.add(status.label);
    }
    if (educationLevel.index > EducationLevel.highSchool.index) {
      parts.add(educationLevel.label);
    }
    return parts.join(' • ');
  }

  factory ProfessionalInfo.fromJson(Map<String, dynamic> json) =>
      _$ProfessionalInfoFromJson(json);
}