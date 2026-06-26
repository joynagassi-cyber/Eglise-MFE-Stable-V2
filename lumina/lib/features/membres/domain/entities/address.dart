// lib/features/membres/domain/entities/address.dart
// Classe pour les adresses

import 'package:freezed_annotation/freezed_annotation.dart';

part 'address.freezed.dart';
part 'address.g.dart';

/// Type d'adresse
enum AddressType {
  home, // Domicile
  work, // Travail
  postal, // Postale
  secondary, // Secondaire
  village, // Village d'origine
  temporary; // Temporaire

  String get label {
    switch (this) {
      case AddressType.home:
        return 'Domicile';
      case AddressType.work:
        return 'Travail';
      case AddressType.postal:
        return 'Postale';
      case AddressType.secondary:
        return 'Secondaire';
      case AddressType.village:
        return 'Village d\'origine';
      case AddressType.temporary:
        return 'Temporaire';
    }
  }
}

@freezed
class Address with _$Address {
  const Address._();

  const factory Address({
    // Ligne d'adresse
    String? streetNumber,
    String? streetName,
    String? streetLine1,
    String? streetLine2,
    String? building,
    String? apartment,
    String? floor,

    // Localisation
    String? neighborhood, // Quartier
    String? district, // Arrondissement/Commune
    required String city,
    String? region, // Région/Département
    String? postalCode,
    String? poBox, // Boîte postale
    @Default('Côte d\'Ivoire') String country,

    // Repères (très important en Afrique)
    String? landmark, // Point de repère principal
    String? nearbyLandmark,
    String? directions,

    // Coordonnées GPS
    double? latitude,
    double? longitude,

    // Métadonnées
    @Default(AddressType.home) AddressType type,
    @Default(false) bool isVerified,
    DateTime? verifiedAt,
  }) = _Address;

  /// Adresse courte (quartier, ville)
  String get shortAddress {
    final parts = <String>[];
    if (neighborhood != null && neighborhood!.isNotEmpty) {
      parts.add(neighborhood!);
    }
    parts.add(city);
    return parts.join(', ');
  }

  /// Adresse complète formatée
  String get fullAddress {
    final parts = <String>[];
    if (streetLine1 != null && streetLine1!.isNotEmpty) {
      parts.add(streetLine1!);
    }
    if (streetLine2 != null && streetLine2!.isNotEmpty) {
      parts.add(streetLine2!);
    }
    if (neighborhood != null && neighborhood!.isNotEmpty) {
      parts.add(neighborhood!);
    }
    parts.add(city);
    if (postalCode != null && postalCode!.isNotEmpty) {
      parts.add(postalCode!);
    }
    if (region != null && region!.isNotEmpty) {
      parts.add(region!);
    }
    parts.add(country);
    return parts.join(', ');
  }

  /// Vérifie si l'adresse a des coordonnées GPS
  bool get hasCoordinates => latitude != null && longitude != null;

  /// Vérifie si l'adresse est vide
  bool get isEmpty =>
      city.isEmpty &&
      (streetLine1 == null || streetLine1!.isEmpty) &&
      (neighborhood == null || neighborhood!.isEmpty);

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);
}