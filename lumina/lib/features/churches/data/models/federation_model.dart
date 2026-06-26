import 'package:isar/isar.dart';
import '../../domain/entities/federation.dart';

part 'federation_model.g.dart';

/// Modèle Isar pour la persistance locale de Federation
@collection
class FederationModel {
  /// ID Isar auto-incrémenté
  Id isarId = Isar.autoIncrement;

  /// Identifiant unique de la fédération
  @Index(unique: true)
  late String id;

  /// Nom de la fédération
  @Index()
  late String name;

  /// Type de fédération
  @Enumerated(EnumType.name)
  late FederationType type;

  /// Description
  String? description;

  /// Siège administratif
  String? headquarters;

  /// IDs des églises membres (stockés comme liste de strings)
  late List<String> memberChurchIds;

  /// ID de l'église leader
  String? leadChurchId;

  /// ID du responsable
  String? leaderId;

  /// Email de contact
  String? email;

  /// Téléphone
  String? phone;

  /// Site web
  String? website;

  /// URL du logo
  String? logoUrl;

  /// Nombre total de membres
  late int totalMembers;

  /// Date de création
  DateTime? establishedDate;

  /// Métadonnées de synchronisation
  late bool isSynced;
  DateTime? lastSyncedAt;

  /// Timestamps
  late DateTime createdAt;
  DateTime? updatedAt;

  // ==================== Conversions ====================

  /// Convertit le modèle Isar vers l'entité domain
  Federation toDomain() {
    return Federation(
      id: id,
      name: name,
      type: type,
      description: description,
      headquarters: headquarters,
      memberChurchIds: memberChurchIds,
      leadChurchId: leadChurchId,
      leaderId: leaderId,
      email: email,
      phone: phone,
      website: website,
      logoUrl: logoUrl,
      totalMembers: totalMembers,
      establishedDate: establishedDate,
      isSynced: isSynced,
      lastSyncedAt: lastSyncedAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Crée un modèle Isar depuis une entité domain
  static FederationModel fromDomain(Federation federation) {
    return FederationModel()
      ..id = federation.id
      ..name = federation.name
      ..type = federation.type
      ..description = federation.description
      ..headquarters = federation.headquarters
      ..memberChurchIds = federation.memberChurchIds
      ..leadChurchId = federation.leadChurchId
      ..leaderId = federation.leaderId
      ..email = federation.email ?? ''
      ..phone = federation.phone
      ..website = federation.website
      ..logoUrl = federation.logoUrl
      ..totalMembers = federation.totalMembers
      ..establishedDate = federation.establishedDate
      ..isSynced = federation.isSynced
      ..lastSyncedAt = federation.lastSyncedAt
      ..createdAt = federation.createdAt
      ..updatedAt = federation.updatedAt;
  }

  /// Crée un modèle depuis JSON Supabase
  static FederationModel fromSupabase(Map<String, dynamic> json) {
    return FederationModel()
      ..id = json['id'] as String
      ..name = json['name'] as String
      ..type = FederationType.values.byName(json['type'] as String)
      ..description = json['description'] as String?
      ..headquarters = json['headquarters'] as String?
      ..memberChurchIds = (json['member_church_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          []
      ..leadChurchId = json['lead_church_id'] as String?
      ..leaderId = json['leader_id'] as String?
      ..email = json['email'] as String?
      ..phone = json['phone'] as String?
      ..website = json['website'] as String?
      ..logoUrl = json['logo_url'] as String?
      ..totalMembers = json['total_members'] as int? ?? 0
      ..establishedDate = json['established_date'] != null
          ? DateTime.parse(json['established_date'] as String)
          : null
      ..isSynced = true
      ..lastSyncedAt = DateTime.now()
      ..createdAt = DateTime.parse(json['created_at'] as String)
      ..updatedAt = json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null;
  }

  /// Convertit le modèle vers JSON Supabase
  Map<String, dynamic> toSupabase() {
    return {
      'id': id,
      'name': name,
      'type': type.name,
      'description': description,
      'headquarters': headquarters,
      'member_church_ids': memberChurchIds,
      'lead_church_id': leadChurchId,
      'leader_id': leaderId,
      'email': email,
      'phone': phone,
      'website': website,
      'logo_url': logoUrl,
      'total_members': totalMembers,
      'established_date': establishedDate?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}