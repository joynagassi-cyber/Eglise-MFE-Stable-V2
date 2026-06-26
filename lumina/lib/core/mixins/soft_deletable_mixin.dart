// lib/core/mixins/soft_deletable_mixin.dart
// Mixin pour normaliser les suppressions logiques (soft delete)
// À appliquer sur TOUS les modèles Isar qui nécessitent une corbeille

/// Mixin pour les suppressions logiques (soft delete)
/// 
/// Fournit les champs nécessaires pour :
/// - Suppression logique (isDeleted)
/// - Traçabilité des suppressions (deletedAt, deletedBy)
/// - Gestion de corbeille (restauration possible)
/// 
/// Usage :
/// ```dart
/// @collection
/// class MyModel with SyncableMixin, SoftDeletableMixin {
///   Id isarId = Isar.autoIncrement;
///   late String id;
///   // ... autres champs
/// }
/// ```
/// 
/// Note : Ce mixin est souvent utilisé avec SyncableMixin
mixin SoftDeletableMixin {
  /// Flag indiquant si l'enregistrement est supprimé logiquement
  /// - true : enregistrement dans la corbeille
  /// - false : enregistrement actif
  bool isDeleted = false;

  /// Timestamp de la suppression logique
  /// null si l'enregistrement n'est pas supprimé
  DateTime? deletedAt;

  /// ID de l'utilisateur ayant supprimé l'enregistrement
  /// Format : UUID Supabase Auth
  /// null si l'enregistrement n'est pas supprimé
  String? deletedBy;

  /// Marque l'enregistrement comme supprimé logiquement
  /// 
  /// [userId] : ID de l'utilisateur effectuant la suppression
  void softDelete(String userId) {
    isDeleted = true;
    deletedAt = DateTime.now();
    deletedBy = userId;
  }

  /// Restaure l'enregistrement depuis la corbeille
  void restore() {
    isDeleted = false;
    deletedAt = null;
    deletedBy = null;
  }

  /// Vérifie si l'enregistrement est actif (non supprimé)
  bool get isActive => !isDeleted;

  /// Vérifie si l'enregistrement est dans la corbeille
  bool get isInTrash => isDeleted;

  /// Retourne le nombre de jours depuis la suppression
  /// null si l'enregistrement n'est pas supprimé
  int? get daysSinceDeletion {
    if (deletedAt == null) return null;
    return DateTime.now().difference(deletedAt!).inDays;
  }

  /// Vérifie si l'enregistrement peut être supprimé définitivement
  /// (par exemple, après 30 jours dans la corbeille)
  /// 
  /// [retentionDays] : Nombre de jours de rétention (défaut: 30)
  bool canBePermanentlyDeleted({int retentionDays = 30}) {
    final days = daysSinceDeletion;
    if (days == null) return false;
    return days >= retentionDays;
  }
}
