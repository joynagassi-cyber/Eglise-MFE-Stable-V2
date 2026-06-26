import 'package:isar/isar.dart';
import '../../domain/entities/church.dart';

part 'church_model.g.dart';

/// Modèle Isar pour la persistance locale de Church
@collection
class ChurchModel {
  /// ID Isar auto-incrémenté
  Id isarId = Isar.autoIncrement;

  /// Identifiant unique de l'église (depuis Supabase)
  @Index(unique: true)
  late String id;

  /// Nom de l'église
  @Index()
  late String name;

  /// Type d'église (stocké comme string)
  @Enumerated(EnumType.name)
  late ChurchType type;

  /// Description
  String? description;

  /// Adresse complète
  String? address;

  /// Ville
  @Index()
  String? city;

  /// Code postal
  String? postalCode;

  /// Pays
  late String country;

  /// Téléphone
  String? phone;

  /// Email
  String? email;

  /// Site web
  String? website;

  /// ID de l'église mère
  @Index()
  String? parentChurchId;

  /// ID de la fédération
  @Index()
  String? federationId;

  /// Nombre de membres
  late int memberCount;

  /// Date de fondation
  DateTime? foundedDate;

  /// ID du pasteur principal
  String? leadPastorId;

  /// URL du logo
  String? logoUrl;

  /// URL de l'image de couverture
  String? coverImageUrl;

  /// Métadonnées de synchronisation
  late bool isSynced;
  DateTime? lastSyncedAt;

  int version = 1;
  String deviceId = 'unknown';
  String churchId = ''; // Usually churchId is its own id, but keeping it consistent
  String createdBy = 'unknown';
  String updatedBy = 'unknown';

  bool isDeleted = false;
  DateTime? deletedAt;
  String? deletedBy;

  /// Timestamps
  late DateTime createdAt;
  DateTime? updatedAt;

  // ==================== Conversions ====================

  /// Convertit le modèle Isar vers l'entité domain
  Church toDomain() {
    return Church(
      id: id,
      name: name,
      type: type,
      description: description,
      address: address,
      city: city,
      postalCode: postalCode,
      country: country,
      phone: phone,
      email: email,
      website: website,
      parentChurchId: parentChurchId,
      federationId: federationId,
      memberCount: memberCount,
      foundedDate: foundedDate,
      leadPastorId: leadPastorId,
      logoUrl: logoUrl,
      coverImageUrl: coverImageUrl,
      isSynced: isSynced,
      lastSyncedAt: lastSyncedAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Crée un modèle Isar depuis une entité domain
  static ChurchModel fromDomain(Church church) {
    return ChurchModel()
      ..id = church.id
      ..name = church.name
      ..type = church.type
      ..description = church.description
      ..address = church.address
      ..city = church.city
      ..postalCode = church.postalCode
      ..country = church.country
      ..phone = church.phone
      ..email = church.email ?? ''
      ..website = church.website
      ..parentChurchId = church.parentChurchId
      ..federationId = church.federationId
      ..memberCount = church.memberCount
      ..foundedDate = church.foundedDate
      ..leadPastorId = church.leadPastorId
      ..logoUrl = church.logoUrl
      ..coverImageUrl = church.coverImageUrl
      ..isSynced = church.isSynced
      ..lastSyncedAt = church.lastSyncedAt
      ..createdAt = church.createdAt
      ..updatedAt = church.updatedAt;
  }

  /// Crée un modèle depuis JSON Supabase
  static ChurchModel fromSupabase(Map<String, dynamic> json) {
    return ChurchModel()
      ..id = json['id'] as String
      ..name = json['name'] as String
      ..type = ChurchType.values.byName(json['type'] as String)
      ..description = json['description'] as String?
      ..address = json['address'] as String?
      ..city = json['city'] as String?
      ..postalCode = json['postal_code'] as String?
      ..country = json['country'] as String? ?? 'RDC'
      ..phone = json['phone'] as String?
      ..email = json['email'] as String?
      ..website = json['website'] as String?
      ..parentChurchId = json['parent_church_id'] as String?
      ..federationId = json['federation_id'] as String?
      ..memberCount = json['member_count'] as int? ?? 0
      ..foundedDate = json['founded_date'] != null
          ? DateTime.parse(json['founded_date'] as String)
          : null
      ..leadPastorId = json['lead_pastor_id'] as String?
      ..logoUrl = json['logo_url'] as String?
      ..coverImageUrl = json['cover_image_url'] as String?
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
      'address': address,
      'city': city,
      'postal_code': postalCode,
      'country': country,
      'phone': phone,
      'email': email,
      'website': website,
      'parent_church_id': parentChurchId,
      'federation_id': federationId,
      'member_count': memberCount,
      'founded_date': foundedDate?.toIso8601String(),
      'lead_pastor_id': leadPastorId,
      'logo_url': logoUrl,
      'cover_image_url': coverImageUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}