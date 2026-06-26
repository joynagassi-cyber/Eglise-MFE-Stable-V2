// lib/features/finance/domain/entities/enums/validation_status.dart

/// Statut de validation d'une preuve (photo de justificatif)
enum ValidationStatus {
  pending, // En attente de validation
  validated, // Validé par un responsable
  rejected; // Rejeté (qualité insuffisante, document illisible, etc.)

  String get label {
    switch (this) {
      case ValidationStatus.pending:
        return 'En attente';
      case ValidationStatus.validated:
        return 'Validé';
      case ValidationStatus.rejected:
        return 'Rejeté';
    }
  }


  /// Conversion depuis/vers Supabase
  static ValidationStatus fromSupabase(String? value) {
    switch (value) {
      case 'pending':
        return ValidationStatus.pending;
      case 'validated':
        return ValidationStatus.validated;
      case 'rejected':
        return ValidationStatus.rejected;
      default:
        return ValidationStatus.pending;
    }
  }

  String toSupabase() => name;
}