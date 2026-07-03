import '../../data/models/bilan_summary.dart';
import '../../data/models/bilan_breakdown_item.dart';
import '../../data/models/bilan_period.dart';
import '../entities/bilan_entities.dart';

abstract class IBilanRepository {
  Future<BilanSummary> getBilanSummary({
    required String churchId,
    required DateTime startDate,
    required DateTime endDate,
    String? groupId,
  });

  Future<List<BilanBreakdownItem>> getBilanBreakdown({
    required String churchId,
    required DateTime startDate,
    required DateTime endDate,
    String? groupId,
    required String dimension,
  });

  Future<List<BilanGroupSummary>> getBilanPerGroup({
    required String churchId,
    required DateTime startDate,
    required DateTime endDate,
    bool includeDrafts = false,
    bool excludeInternal = true,
  });

  Future<ConsolidatedBilan> getConsolidatedBilan({
    required String churchId,
    required DateTime startDate,
    required DateTime endDate,
    List<String>? groupIds,
  });

  Future<List<TransactionAnomaly>> detectAnomalies({
    required String churchId,
    double threshold = 2.0,
  });

  Future<List<CurrencyConfig>> getCurrencies();

  Future<List<AppThemeConfig>> getThemes();

  Future<ChurchBranding> getChurchBranding();

  Future<void> updateChurchBranding(ChurchBranding branding);

  Future<List<FecLine>> getFecLines({
    required String churchId,
    required DateTime startDate,
    required DateTime endDate,
  });

  Future<BilanFinancialSettings> getFinancialSettings();

  // TODO: Implémenter la persistance des paramètres financiers
  Future<void> updateFinancialSettings(BilanFinancialSettings settings);

  Future<List<BilanHeatmapPoint>> getTransactionHeatmap({
    required DateTime startDate,
    required DateTime endDate,
    String? groupId,
  });

  Future<List<BilanTransaction>> getTransactionsForDrillDown({
    required DateTime startDate,
    required DateTime endDate,
    String? groupId,
    String? category,
    bool includeDrafts = false,
  });

  Future<List<BilanAuditLog>> getAuditLogs({String? recordId});

  Future<Map<String, dynamic>> signTransaction(
    String transactionId, {
    String? comment,
  });

  // --- Bilan Period Management ---

  /// Get all bilan periods for a given year
  Future<List<BilanPeriod>> getBilanPeriods({
    required String churchId,
    required int year,
  });

  /// Seal a period (month) — locks all transactions and computes hash
  Future<BilanPeriod> sealPeriod({
    required String churchId,
    required int year,
    required int month,
    required String sealedBy,
  });

  /// Unseal a period — requires a reason for audit trail
  Future<void> unsealPeriod({
    required String churchId,
    required int year,
    required int month,
    required String reason,
  });

  /// Get monthly totals for line chart (12 data points)
  Future<List<Map<String, dynamic>>> getMonthlyTotals({
    required String churchId,
    required int year,
  });

  /// Verify that the stored seal hash matches a freshly computed hash.
  /// Returns true if the period data is intact, false if tampered.
  Future<bool> verifySeal({
    required String churchId,
    required int year,
    required int month,
  });

  /// Initialize a new period as 'open' (no sealing, no hash).
  /// Used during onboarding/initialization when there is no authenticated user
  /// to seal with, or for months that have zero transactions.
  Future<void> initializePeriod({
    required String churchId,
    required int year,
    required int month,
  });
}
