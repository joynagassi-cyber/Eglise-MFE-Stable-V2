import 'package:isar/isar.dart';

part 'local_profile_model.g.dart';

/// Modele de profil local persiste dans Isar.
/// Copie legere du profil Supabase pour acces offline.
@collection
class LocalProfileModel {
  LocalProfileModel();

  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value)
  late String userId;

  late String? firstName;
  late String? lastName;
  late String? phone;
  late String? email;
  late String? avatarUrl;
  late String? churchId;
  late DateTime? updatedAt;
  late DateTime createdAt;
  late DateTime lastSyncedAt;

  factory LocalProfileModel.fromMap(Map<String, dynamic> map) {
    return LocalProfileModel()
      ..userId = map['id'] ?? ''
      ..firstName = map['first_name']
      ..lastName = map['last_name']
      ..phone = map['phone']
      ..email = map['email']
      ..avatarUrl = map['photo_url']
      ..churchId = map['church_id']
      ..updatedAt = map['updated_at'] != null
          ? DateTime.tryParse(map['updated_at'])
          : null
      ..createdAt = DateTime.now()
      ..lastSyncedAt = DateTime.now();
  }

  Map<String, dynamic> toMap() {
    return {
      'id': userId,
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
      'email': email,
      'photo_url': avatarUrl,
      'church_id': churchId,
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
