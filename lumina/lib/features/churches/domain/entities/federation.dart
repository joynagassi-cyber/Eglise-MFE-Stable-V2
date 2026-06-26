import 'package:freezed_annotation/freezed_annotation.dart';

part 'federation.freezed.dart';

/// Type de structure fédérative
enum FederationType {
  /// Réseau d'églises (structure horizontale)
  network,

  /// Dénomination (structure hiérarchique)
  denomination,

  /// Alliance stratégique (partenariat souple)
  alliance,
}

/// Entité représentant une fédération d'églises
@freezed
class Federation with _$Federation {
  const factory Federation({
    /// Identifiant unique de la fédération
    required String id,

    /// Nom de la fédération
    required String name,

    /// Type de fédération
    required FederationType type,

    /// Description/vision de la fédération
    String? description,

    /// Siège administratif
    String? headquarters,

    /// Liste des IDs des églises membres
    @Default([]) List<String> memberChurchIds,

    /// ID de l'église principale/siège (si applicable)
    String? leadChurchId,

    /// Responsable de la fédération (ID utilisateur)
    String? leaderId,

    /// Email de contact de la fédération
    String? email,

    /// Téléphone de contact
    String? phone,

    /// Site web de la fédération
    String? website,

    /// Logo de la fédération (URL)
    String? logoUrl,

    /// Nombre total de membres (agrégé de toutes les églises)
    @Default(0) int totalMembers,

    /// Date de création de la fédération
    DateTime? establishedDate,

    /// Métadonnées de synchronisation
    @Default(false) bool isSynced,
    DateTime? lastSyncedAt,

    /// Timestamps
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _Federation;

  const Federation._();

  /// Nombre d'églises dans la fédération
  int get churchCount => memberChurchIds.length;

  /// Vérifie si la fédération a au moins une église
  bool get hasChurches => memberChurchIds.isNotEmpty;

  /// Vérifie si la fédération a une église leader désignée
  bool get hasLeadChurch => leadChurchId != null;

  /// Retourne le type formaté pour l'affichage
  String get typeDisplayName => switch (type) {
        FederationType.network => 'Réseau',
        FederationType.denomination => 'Dénomination',
        FederationType.alliance => 'Alliance',
      };

  /// Vérifie si une église est membre de cette fédération
  bool containsChurch(String churchId) => memberChurchIds.contains(churchId);
}