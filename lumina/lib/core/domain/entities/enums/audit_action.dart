// lib/core/domain/entities/enums/audit_action.dart

/// Types d'actions pour le journal d'audit immutable (IMAGIR)
enum AuditAction {
  insert, // Création d'une entité
  update, // Modification
  delete, // Suppression
  login, // Connexion utilisateur
  logout, // Déconnexion
  register, // Inscription utilisateur (Nouv.)
  upload, // Upload de fichier
  seal, // Scellement cryptographique
  export_, // Export de rapport (export est réservé en Dart)
  backup; // Sauvegarde

  String get label {
    switch (this) {
      case AuditAction.insert:
        return 'Création';
      case AuditAction.update:
        return 'Modification';
      case AuditAction.delete:
        return 'Suppression';
      case AuditAction.login:
        return 'Connexion';
      case AuditAction.logout:
        return 'Déconnexion';
      case AuditAction.register:
        return 'Inscription';
      case AuditAction.upload:
        return 'Upload';
      case AuditAction.seal:
        return 'Scellement';
      case AuditAction.export_:
        return 'Export';
      case AuditAction.backup:
        return 'Sauvegarde';
    }
  }

  /// Conversion depuis Supabase (MAJUSCULES)
  static AuditAction fromSupabase(String? value) {
    switch (value?.toUpperCase()) {
      case 'INSERT':
        return AuditAction.insert;
      case 'UPDATE':
        return AuditAction.update;
      case 'DELETE':
        return AuditAction.delete;
      case 'LOGIN':
        return AuditAction.login;
      case 'LOGOUT':
        return AuditAction.logout;
      case 'REGISTER':
        return AuditAction.register;
      case 'UPLOAD':
        return AuditAction.upload;
      case 'SEAL':
        return AuditAction.seal;
      case 'EXPORT':
        return AuditAction.export_;
      case 'BACKUP':
        return AuditAction.backup;
      default:
        return AuditAction.update;
    }
  }

  String toSupabase() {
    if (this == AuditAction.export_) return 'EXPORT';
    return name.toUpperCase();
  }
}
