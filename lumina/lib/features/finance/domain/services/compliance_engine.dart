// lib/features/finance/domain/services/compliance_engine.dart
import '../entities/finance_transaction.dart';
import '../entities/enums/transaction_type.dart';

/// Moteur de validation de conformité OHADA (IMAGIR)
/// Évalue les transactions par rapport aux règles de conformité
class ComplianceEngine {
  // Seuils de conformité (en FCFA)
  static const int highAmountThreshold = 500000; // 500k FCFA
  static const int foreignDeclarationThreshold = 1000000; // 1M FCFA

  /// Évalue une transaction et retourne les tags de conformité
  List<String> evaluateTransaction(FinanceTransaction transaction) {
    final tags = <String>[];

    // Règle 1: Montant élevé
    if (transaction.amount >= highAmountThreshold) {
      tags.add('high_amount');
    }

    // Règle 2: Don étranger (vérifier si la catégorie indique un don étranger)
    if (_isForeignDonation(transaction)) {
      tags.add('foreign_declaration_required');
      if (transaction.amount >= foreignDeclarationThreshold) {
        tags.add('requires_nif');
      }
    }

    // Règle 3: Dépense sans preuve
    if (transaction.isExpense && transaction.proofImages.isEmpty) {
      tags.add('proof_required');
    }

    // Règle 4: Transaction de transfert interne
    if (transaction.type == TransactionType.transfer &&
        transaction.toAccountId == null) {
      tags.add('missing_destination_account');
    }

    return tags;
  }

  /// Vérifie si une transaction est conforme (pas de tags bloquants)
  bool isCompliant(FinanceTransaction transaction) {
    final tags = evaluateTransaction(transaction);
    final blockingTags = ['proof_required', 'missing_destination_account'];
    return !tags.any(blockingTags.contains);
  }

  /// Génère un résumé de conformité pour l'UI
  ComplianceSummary getSummary(FinanceTransaction transaction) {
    final tags = evaluateTransaction(transaction);

    final warnings = <String>[];
    final errors = <String>[];

    for (final tag in tags) {
      switch (tag) {
        case 'high_amount':
          warnings.add(
            'Montant élevé (> ${_formatAmount(highAmountThreshold)} FCFA)',
          );
          break;
        case 'foreign_declaration_required':
          warnings.add('Déclaration étrangère requise');
          break;
        case 'requires_nif':
          warnings.add('NIF du donateur requis');
          break;
        case 'proof_required':
          errors.add('Photo de justificatif obligatoire');
          break;
        case 'missing_destination_account':
          errors.add('Compte de destination manquant');
          break;
      }
    }

    return ComplianceSummary(
      tags: tags,
      warnings: warnings,
      errors: errors,
      isCompliant: errors.isEmpty,
    );
  }

  bool _isForeignDonation(FinanceTransaction transaction) {
    if (!transaction.isIncome) return false;
    final category = transaction.category?.toLowerCase() ?? '';
    return category.contains('étranger') ||
        category.contains('diaspora') ||
        category.contains('foreign');
  }

  String _formatAmount(int amount) {
    return amount.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]} ',
        );
  }
}

/// Résultat de l'évaluation de conformité
class ComplianceSummary {
  final List<String> tags;
  final List<String> warnings;
  final List<String> errors;
  final bool isCompliant;

  ComplianceSummary({
    required this.tags,
    required this.warnings,
    required this.errors,
    required this.isCompliant,
  });

  bool get hasWarnings => warnings.isNotEmpty;
  bool get hasErrors => errors.isNotEmpty;
}