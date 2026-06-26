// lib/features/finance/domain/services/fec_export_service.dart
import 'dart:convert';
import '../entities/finance_transaction.dart';

/// Service d'export FEC (Fichier des Écritures Comptables) conforme OHADA
/// Génère un fichier CSV/TXT compatible avec les exigences légales africaines
class FECExportService {
  static const String separator = '\t'; // Tabulation pour FEC standard

  /// Génère le contenu FEC pour une liste de transactions
  String generateFEC(
    List<FinanceTransaction> transactions, {
    required String journalCode,
    required String journalLib,
    required String companyName,
    required String fiscalYear,
  }) {
    final buffer = StringBuffer();

    // En-tête FEC (norme OHADA/DGI)
    buffer.writeln(_generateHeader());

    // Trier par date
    final sortedTransactions = List<FinanceTransaction>.from(transactions)
      ..sort((a, b) => a.date.compareTo(b.date));

    // Générer les écritures
    int ecritureNum = 1;

    for (final tx in sortedTransactions) {
      buffer.writeln(
        _generateLine(
          journalCode: journalCode,
          journalLib: journalLib,
          ecritureNum: ecritureNum.toString().padLeft(6, '0'),
          ecritureDate: _formatDate(tx.date),
          compteNum: _getCompteNum(tx),
          compteLib: tx.category ?? tx.description,
          pieceRef: tx.referenceNumber ?? 'N/A',
          pieceDate: _formatDate(tx.date),
          debit: tx.isExpense ? tx.amount : 0,
          credit: tx.isIncome ? tx.amount : 0,
          lettrageDate: '',
          validDate: tx.validatedAt != null ? _formatDate(tx.validatedAt!) : '',
          montantDevise: tx.amount,
          idevise: 'XOF',
        ),
      );

      ecritureNum++;
    }

    return buffer.toString();
  }

  /// Génère l'en-tête du fichier FEC
  String _generateHeader() {
    return [
      'JournalCode',
      'JournalLib',
      'EcritureNum',
      'EcritureDate',
      'CompteNum',
      'CompteLib',
      'CompAuxNum',
      'CompAuxLib',
      'PieceRef',
      'PieceDate',
      'EcritureLib',
      'Debit',
      'Credit',
      'EcritureLet',
      'DateLet',
      'ValidDate',
      'Montantdevise',
      'Idevise',
    ].join(separator);
  }

  /// Génère une ligne d'écriture FEC
  String _generateLine({
    required String journalCode,
    required String journalLib,
    required String ecritureNum,
    required String ecritureDate,
    required String compteNum,
    required String compteLib,
    required String pieceRef,
    required String pieceDate,
    required double debit,
    required double credit,
    required String lettrageDate,
    required String validDate,
    required double montantDevise,
    required String idevise,
  }) {
    return [
      journalCode,
      journalLib,
      ecritureNum,
      ecritureDate,
      compteNum,
      compteLib,
      '', // CompAuxNum
      '', // CompAuxLib
      pieceRef,
      pieceDate,
      compteLib, // EcritureLib
      _formatAmount(debit),
      _formatAmount(credit),
      '', // EcritureLet
      lettrageDate,
      validDate,
      _formatAmount(montantDevise),
      idevise,
    ].join(separator);
  }

  /// Détermine le numéro de compte comptable
  String _getCompteNum(FinanceTransaction tx) {
    // Plan comptable OHADA simplifié
    final category = tx.category?.toLowerCase() ?? '';

    if (tx.isIncome) {
      if (category.contains('dîme') || category.contains('dime')) {
        return '706100'; // Dîmes
      }
      if (category.contains('offrande')) {
        return '706200'; // Offrandes
      }
      if (category.contains('don')) {
        return '706300'; // Dons
      }
      return '706000'; // Autres produits
    } else {
      if (category.contains('salaire')) {
        return '641000'; // Charges de personnel
      }
      if (category.contains('loyer')) {
        return '613000'; // Locations
      }
      if (category.contains('électricité') || category.contains('eau')) {
        return '605000'; // Fournitures
      }
      return '600000'; // Autres charges
    }
  }

  /// Formate une date au format FEC (YYYYMMDD)
  String _formatDate(DateTime date) {
    return '${date.year}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}';
  }

  /// Formate un montant (2 décimales, point comme séparateur)
  String _formatAmount(double amount) {
    if (amount == 0) return '0.00';
    return amount.toStringAsFixed(2);
  }

  /// Encode le contenu en bytes pour téléchargement
  List<int> toBytes(String content) {
    return utf8.encode(content);
  }

  /// Génère le nom de fichier FEC standard
  String generateFilename(String siren, String fiscalYear) {
    return '${siren}FEC$fiscalYear.txt';
  }
}