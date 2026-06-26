import 'package:freezed_annotation/freezed_annotation.dart';

part 'church.freezed.dart';
part 'church.g.dart';

/// Type d'église dans la fédération
enum ChurchType {
  /// Église principale/mère
  main,

  /// Église annexe (rattachée à une église mère)
  branch,

  /// Église filiale (partenaire dans la fédération)
  affiliate,
}

/// Entité représentant une église dans le système
@freezed
class Church with _$Church {
  const factory Church({
    /// Identifiant unique de l'église
    required String id,

    /// Nom de l'église
    required String name,

    /// Type d'église
    required ChurchType type,

    /// Description/mission de l'église
    String? description,

    /// Adresse physique complète
    String? address,

    /// Ville
    String? city,

    /// Code postal
    String? postalCode,

    /// Pays
    @Default('RDC') String country,

    /// Numéro de téléphone principal
    String? phone,

    /// Email de contact
    String? email,

    /// Site web
    String? website,

    /// ID de l'église mère (si type = branch ou affiliate)
    String? parentChurchId,

    /// ID de la fédération (si membre d'une fédération)
    String? federationId,

    /// Nombre de membres actifs
    @Default(0) int memberCount,

    /// Date de fondation
    DateTime? foundedDate,

    /// Pasteur principal (ID utilisateur)
    String? leadPastorId,

    /// Logo de l'église (URL)
    String? logoUrl,

    /// Photo de couverture (URL)
    String? coverImageUrl,

    /// Métadonnées de synchronisation
    @Default(false) bool isSynced,
    DateTime? lastSyncedAt,

    /// Timestamps
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _Church;

  factory Church.fromJson(Map<String, dynamic> json) => _$ChurchFromJson(json);

  const Church._();

  /// Vérifie si l'église est une église principale
  bool get isMainChurch => type == ChurchType.main;

  /// Vérifie si l'église est rattachée à une autre
  bool get hasParent => parentChurchId != null;

  /// Vérifie si l'église fait partie d'une fédération
  bool get isInFederation => federationId != null;

  /// Retourne le nom complet avec le type
  String get displayName {
    final typeLabel = switch (type) {
      ChurchType.main => 'Église Principale',
      ChurchType.branch => 'Annexe',
      ChurchType.affiliate => 'Filiale',
    };
    return '$name ($typeLabel)';
  }

  /// Retourne l'adresse complète formatée
  String? get fullAddress {
    if (address == null) return null;
    final parts = <String>[
      address!,
      if (city != null) city!,
      if (postalCode != null) postalCode!,
      country,
    ];
    return parts.join(', ');
  }
}