// lib/core/mixins/syncable_mixin.dart
// Mixin pour normaliser les métadonnées de synchronisation
// À appliquer sur TOUS les modèles Isar qui nécessitent une synchronisation


/// Mixin pour les métadonnées de synchronisation
/// 
/// Fournit les champs nécessaires pour :
/// - Delta sync (lastSyncedAt)
/// - Résolution de conflits LWW (version, updatedAt)
/// - Traçabilité (deviceId, createdBy, updatedBy)
/// - État de synchronisation (isSynced)
/// 
/// Usage :
/// ```dart
/// @collection
/// class MyModel with SyncableMixin {
///   Id isarId = Isar.autoIncrement;
///   late String id;
///   // ... autres champs
/// }
/// ```
mixin SyncableMixin {
  /// Version du document pour résolution de conflits LWW
  /// Incrémenté à chaque modification
  int version = 1;

  /// Identifiant unique de l'appareil ayant créé/modifié l'enregistrement
  /// Utilisé pour traçabilité et debug
  String deviceId = 'unknown';

  /// ID de l'utilisateur ayant créé l'enregistrement
  /// Format : UUID Supabase Auth
  String createdBy = 'unknown';

  /// ID de l'utilisateur ayant modifié l'enregistrement en dernier
  /// Format : UUID Supabase Auth
  String updatedBy = 'unknown';

  /// Timestamp de la dernière synchronisation réussie avec Supabase
  /// Utilisé pour delta sync (récupérer seulement les changements depuis ce timestamp)
  DateTime? lastSyncedAt;

  /// Flag indiquant si l'enregistrement est synchronisé avec Supabase
  /// - true : enregistrement à jour sur Supabase
  /// - false : modifications locales en attente de sync
  bool isSynced = true;

  /// Date de création de l'enregistrement
  /// Immutable après création
  late DateTime createdAt;

  /// Date de dernière modification de l'enregistrement
  /// Utilisé pour résolution de conflits LWW (Last Write Wins)
  DateTime? updatedAt;

  /// Marque l'enregistrement comme modifié localement (en attente de sync)
  void markAsDirty() {
    isSynced = false;
    updatedAt = DateTime.now();
    version++;
  }

  /// Marque l'enregistrement comme synchronisé
  void markAsSynced() {
    isSynced = true;
    lastSyncedAt = DateTime.now();
  }

  /// Met à jour les métadonnées lors d'une modification
  void updateMetadata({
    required String userId,
    required String deviceId,
  }) {
    updatedBy = userId;
    deviceId = deviceId;
    markAsDirty();
  }

  /// Initialise les métadonnées lors de la création
  void initializeMetadata({
    required String userId,
    required String deviceId,
  }) {
    createdBy = userId;
    updatedBy = userId;
    deviceId = deviceId;
    createdAt = DateTime.now();
    updatedAt = DateTime.now();
    version = 1;
    isSynced = false;
  }
}
