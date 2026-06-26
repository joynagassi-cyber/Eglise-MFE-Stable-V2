// lib/features/membres/domain/entities/contact_info.dart
// Informations de contact détaillées

import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_info.freezed.dart';
part 'contact_info.g.dart';

/// Type de téléphone
enum PhoneType {
  mobile,
  home,
  work,
  fax,
  other;

  String get label {
    switch (this) {
      case PhoneType.mobile:
        return 'Mobile';
      case PhoneType.home:
        return 'Domicile';
      case PhoneType.work:
        return 'Travail';
      case PhoneType.fax:
        return 'Fax';
      case PhoneType.other:
        return 'Autre';
    }
  }
}

/// Numéro de téléphone avec métadonnées
@freezed
class PhoneNumber with _$PhoneNumber {
  const PhoneNumber._();

  const factory PhoneNumber({
    required String number,
    @Default('+225') String countryCode,
    @Default(PhoneType.mobile) PhoneType type,
    @Default(false) bool hasWhatsApp,
    @Default(false) bool hasTelegram,
    @Default(true) bool isPrimary,
    @Default(true) bool isVerified,
    @Default(true) bool canReceiveSms,
  }) = _PhoneNumber;

  /// Numéro complet avec indicatif
  String get fullNumber => '$countryCode $number';

  /// Numéro formaté pour affichage
  String get displayNumber {
    if (number.length == 10) {
      return '${number.substring(0, 2)} ${number.substring(2, 4)} ${number.substring(4, 6)} ${number.substring(6, 8)} ${number.substring(8)}';
    }
    return number;
  }

  factory PhoneNumber.fromJson(Map<String, dynamic> json) =>
      _$PhoneNumberFromJson(json);
}

/// Informations de contact complètes
@freezed
class ContactInfo with _$ContactInfo {
  const ContactInfo._();

  const factory ContactInfo({
    // Téléphones
    @Default([]) List<PhoneNumber> phones,
    String? whatsappNumber,
    String? telegramUsername,

    // Emails
    String? primaryEmail,
    String? secondaryEmail,
    @Default(false) bool emailVerified,

    // Réseaux sociaux
    String? facebookUrl,
    String? instagramHandle,
    String? twitterHandle,
    String? linkedInUrl,

    // Contact d'urgence
    String? emergencyContactName,
    String? emergencyContactPhone,
    String? emergencyContactRelation,

    // Préférences de contact
    @Default(true) bool acceptsWhatsApp,
    @Default(true) bool acceptsSms,
    @Default(true) bool acceptsEmail,
    @Default(true) bool acceptsPhoneCall,
    String? preferredContactMethod,
    String? preferredContactTime,
  }) = _ContactInfo;

  /// Téléphone principal
  PhoneNumber? get primaryPhone {
    if (phones.isEmpty) return null;
    try {
      return phones.firstWhere((p) => p.isPrimary);
    } catch (_) {
      return phones.first;
    }
  }

  /// Numéro WhatsApp principal
  String? get mainWhatsApp {
    if (whatsappNumber != null) return whatsappNumber;
    final whatsAppPhones = phones.where((p) => p.hasWhatsApp);
    if (whatsAppPhones.isNotEmpty) {
      return whatsAppPhones.first.fullNumber;
    }
    return null;
  }

  /// Vérifie si le contact a au moins un moyen de communication
  bool get hasContact =>
      phones.isNotEmpty ||
      (primaryEmail != null && primaryEmail!.isNotEmpty) ||
      (whatsappNumber != null && whatsappNumber!.isNotEmpty);

  factory ContactInfo.fromJson(Map<String, dynamic> json) =>
      _$ContactInfoFromJson(json);
}