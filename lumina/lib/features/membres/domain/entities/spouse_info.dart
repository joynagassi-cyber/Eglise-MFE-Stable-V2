// lib/features/membres/domain/entities/spouse_info.dart
// Informations sur le conjoint

import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums/enums.dart';

part 'spouse_info.freezed.dart';
part 'spouse_info.g.dart';

@freezed
class SpouseInfo with _$SpouseInfo {
  const SpouseInfo._();

  const factory SpouseInfo({
    // Lien avec membre si le conjoint est dans l'église
    String? memberId,
    @Default(false) bool isMember,

    // Identité
    required String lastName,
    required String firstName,
    String? middleName,
    String? maidenName, // Nom de jeune fille
    String? title,
    required Gender gender,
    String? photoUrl,

    // Naissance
    DateTime? birthDate,
    String? birthPlace,

    // Contact
    String? phone,
    String? email,
    String? whatsapp,

    // Profession
    String? profession,
    String? employer,

    // Spiritualité
    @Default(true) bool isChristian,
    String? denomination, // Si dans autre confession
    String? churchName, // Si dans autre église
    @Default(false) bool isBaptized,
  }) = _SpouseInfo;

  /// Nom complet du conjoint
  String get fullName {
    final parts = <String>[firstName];
    if (middleName != null && middleName!.isNotEmpty) {
      parts.add(middleName!);
    }
    parts.add(lastName);
    if (maidenName != null && maidenName!.isNotEmpty) {
      parts.add('née $maidenName');
    }
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

  factory SpouseInfo.fromJson(Map<String, dynamic> json) =>
      _$SpouseInfoFromJson(json);
}