// lib/core/mixins/church_scoped_mixin.dart
// Mixin pour normaliser l'isolation multi-tenant par église
// À appliquer sur TOUS les modèles TYPE A (données église)

import 'package:isar/isar.dart';

/// Mixin pour l'isolation multi-tenant par église
/// 
/// Fournit le champ churchId nécessaire pour :
/// - Isolation des données par église (RLS Supabase)
/// - Filtrage des requêtes Isar par église
/// - Sécurité multi-tenant
/// 
/// Usage :
/// ```dart
/// @collection
/// class MyModel with ChurchScopedMixin, SyncableMixin, SoftDeletableMixin {
///   Id isarId = Isar.autoIncrement;
///   late String id;
///   // ... autres champs
/// }
/// ```
/// 
/// IMPORTANT : Ce mixin est OBLIGATOIRE pour tous les modèles TYPE A
/// (données église : membres, groupes, événements, finances, etc.)
mixin ChurchScopedMixin {
  /// Identifiant unique de l'église propriétaire de l'enregistrement
  /// Format : UUID Supabase
  /// 
  /// CRITIQUE pour l'isolation multi-tenant :
  /// - Utilisé par RLS Supabase pour filtrer les données
  /// - Utilisé par les requêtes Isar pour filtrer localement
  /// - DOIT être présent sur tous les modèles TYPE A
  @Index()
  late String churchId;

  /// Vérifie si l'enregistrement appartient à une église spécifique
  bool belongsToChurch(String churchId) {
    return this.churchId == churchId;
  }

  /// Initialise le churchId lors de la création
  /// 
  /// [churchId] : ID de l'église active
  /// 
  /// IMPORTANT : Doit être appelé AVANT toute sauvegarde
  void setChurchId(String churchId) {
    assert(churchId.isNotEmpty, 'churchId cannot be empty');
    this.churchId = churchId;
  }
}

/// Mixin pour l'isolation multi-tenant par utilisateur
/// 
/// Fournit le champ userId nécessaire pour :
/// - Isolation des données par utilisateur
/// - Données personnelles (annotations Bible, favoris, etc.)
/// 
/// Usage :
/// ```dart
/// @collection
/// class MyModel with UserScopedMixin, SyncableMixin {
///   Id isarId = Isar.autoIncrement;
///   late String id;
///   // ... autres champs
/// }
/// ```
/// 
/// IMPORTANT : Ce mixin est OBLIGATOIRE pour tous les modèles TYPE B
/// (données utilisateur : annotations, favoris, préférences, etc.)
mixin UserScopedMixin {
  /// Identifiant unique de l'utilisateur propriétaire de l'enregistrement
  /// Format : UUID Supabase Auth
  @Index()
  late String userId;

  /// Vérifie si l'enregistrement appartient à un utilisateur spécifique
  bool belongsToUser(String userId) {
    return this.userId == userId;
  }

  /// Initialise le userId lors de la création
  void setUserId(String userId) {
    assert(userId.isNotEmpty, 'userId cannot be empty');
    this.userId = userId;
  }
}
