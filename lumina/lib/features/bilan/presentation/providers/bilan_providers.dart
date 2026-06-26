/// BILAN Riverpod providers
library;

import 'package:flutter/material.dart' show DateTimeRange;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/bilan_entities.dart';
export '../../domain/entities/bilan_entities.dart';
import '../../domain/services/number_formatter_service.dart';
import '../../domain/services/fec_export_service.dart';
import '../../domain/services/bilan_csv_service.dart';
import '../../domain/services/bilan_sealing_service.dart';
import 'package:lumina/core/providers/repository_providers_finance.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/mixins/auditable_mixin.dart';
import '../../../../core/domain/entities/enums/audit_action.dart';
import 'dart:async';

// Redundant provider removed to use the split repository provider module.

/// Number formatter service provider
final numberFormatterProvider = Provider<NumberFormatterService>((ref) {
  return NumberFormatterService();
});

/// Selected period state
final bilanPeriodProvider = StateProvider<BilanPeriodType>((ref) {
  return BilanPeriodType.month;
});

/// Custom date range state
final bilanDateRangeProvider = StateProvider<DateTimeRange?>((ref) {
  return null;
});

/// Selected group IDs (null = all groups)
final bilanSelectedGroupsProvider = StateProvider<List<String>?>((ref) {
  return null;
});

/// Include drafts toggle
final bilanIncludeDraftsProvider = StateProvider<bool>((ref) {
  return false;
});

/// Exclude internal transfers toggle
final bilanExcludeInternalProvider = StateProvider<bool>((ref) {
  return true;
});

/// Computed date range based on period type
DateTimeRange _computeDateRange(BilanPeriodType type, DateTimeRange? custom) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  switch (type) {
    case BilanPeriodType.today:
      return DateTimeRange(start: today, end: today);
    case BilanPeriodType.week:
      final weekStart = today.subtract(Duration(days: today.weekday - 1));
      return DateTimeRange(start: weekStart, end: today);
    case BilanPeriodType.month:
      final monthStart = DateTime(now.year, now.month, 1);
      return DateTimeRange(start: monthStart, end: today);
    case BilanPeriodType.quarter:
      final quarterMonth = ((now.month - 1) ~/ 3) * 3 + 1;
      final quarterStart = DateTime(now.year, quarterMonth, 1);
      return DateTimeRange(start: quarterStart, end: today);
    case BilanPeriodType.ytd:
      final yearStart = DateTime(now.year, 1, 1);
      return DateTimeRange(start: yearStart, end: today);
    case BilanPeriodType.custom:
      return custom ?? DateTimeRange(start: today, end: today);
  }
}

/// Helper for N-1 comparison (Previous Period)
DateTimeRange _getPreviousRange(
  BilanPeriodType type,
  DateTimeRange currentRange,
) {
  final start = currentRange.start;
  final end = currentRange.end;
  final duration = end.difference(start).inDays + 1;

  switch (type) {
    case BilanPeriodType.ytd:
      // Year-over-Year
      return DateTimeRange(
        start: DateTime(start.year - 1, 1, 1),
        end: DateTime(end.year - 1, end.month, end.day),
      );
    default:
      // Subtract duration
      return DateTimeRange(
        start: start.subtract(Duration(days: duration)),
        end: end.subtract(Duration(days: duration)),
      );
  }
}

/// BILAN summary per group (async)
final bilanPerGroupProvider = FutureProvider<List<BilanGroupSummary>>((
  ref,
) async {
  final repo = ref.watch(bilanRepositoryProvider);
  final period = ref.watch(bilanPeriodProvider);
  final customRange = ref.watch(bilanDateRangeProvider);
  final includeDrafts = ref.watch(bilanIncludeDraftsProvider);
  final excludeInternal = ref.watch(bilanExcludeInternalProvider);

  final range = _computeDateRange(period, customRange);

  final data = await repo.getBilanPerGroup(
    startDate: range.start,
    endDate: range.end,
    includeDrafts: includeDrafts,
    excludeInternal: excludeInternal,
  );

  // Calculate percent of total
  final totalIncome = data.fold<double>(0.0, (sum, item) => sum + item.income);
  return data
      .map(
        (item) => item.copyWith(
          percentOfTotal:
              totalIncome > 0 ? (item.income / totalIncome) * 100 : 0,
        ),
      )
      .toList();
});

/// Consolidated BILAN (async)
final consolidatedBilanProvider = FutureProvider<ConsolidatedBilan>((
  ref,
) async {
  final repo = ref.watch(bilanRepositoryProvider);
  final period = ref.watch(bilanPeriodProvider);
  final customRange = ref.watch(bilanDateRangeProvider);
  final selectedGroups = ref.watch(bilanSelectedGroupsProvider);

  final range = _computeDateRange(period, customRange);

  return repo.getConsolidatedBilan(
    startDate: range.start,
    endDate: range.end,
    groupIds: selectedGroups,
  );
});

/// Bilan Variation (N vs N-1)
final bilanVariationProvider = FutureProvider<Map<String, BilanVariation>>((
  ref,
) async {
  final repo = ref.watch(bilanRepositoryProvider);
  final period = ref.watch(bilanPeriodProvider);
  final customRange = ref.watch(bilanDateRangeProvider);
  final selectedGroups = ref.watch(bilanSelectedGroupsProvider);

  final currentRange = _computeDateRange(period, customRange);
  final previousRange = _getPreviousRange(period, currentRange);

  final current = await ref.watch(consolidatedBilanProvider.future);
  final previous = await repo.getConsolidatedBilan(
    startDate: previousRange.start,
    endDate: previousRange.end,
    groupIds: selectedGroups,
  );

  double calculatePercent(num cur, num prev) {
    if (prev == 0) return cur > 0 ? 100.0 : 0.0;
    return ((cur - prev) / prev.abs()) * 100.0;
  }

  return {
    'income': BilanVariation(
      current: current.totalIncome,
      previous: previous.totalIncome,
      percentage: calculatePercent(current.totalIncome, previous.totalIncome),
    ),
    'expense': BilanVariation(
      current: current.totalExpense,
      previous: previous.totalExpense,
      percentage: calculatePercent(current.totalExpense, previous.totalExpense),
    ),
    'net': BilanVariation(
      current: current.netBalance,
      previous: previous.netBalance,
      percentage: calculatePercent(current.netBalance, previous.netBalance),
    ),
  };
});

/// Anomalies detection (async)
final bilanAnomaliesProvider = FutureProvider<List<TransactionAnomaly>>((
  ref,
) async {
  final repo = ref.watch(bilanRepositoryProvider);
  final settings = await ref.watch(financialSettingsProvider.future);

  return repo.detectAnomalies(threshold: settings.anomalySigmaThreshold);
});

/// Available currencies (async)
final currenciesProvider = FutureProvider<List<CurrencyConfig>>((ref) async {
  final repo = ref.watch(bilanRepositoryProvider);
  return repo.getCurrencies();
});

/// Available themes (async)
final appThemesProvider = FutureProvider<List<AppThemeConfig>>((ref) async {
  final repo = ref.watch(bilanRepositoryProvider);
  return repo.getThemes();
});

/// Church branding (async)
final churchBrandingProvider = FutureProvider<ChurchBranding>((ref) async {
  final repo = ref.watch(bilanRepositoryProvider);
  return repo.getChurchBranding();
});

/// FEC Export service provider
final fecExportServiceProvider = Provider((ref) => FecExportService());

/// CSV Export service provider
final bilanCsvServiceProvider = Provider((ref) => BilanCsvService());

/// FEC Lines provider (async)
final bilanFecLinesProvider = FutureProvider<List<FecLine>>((ref) async {
  final repo = ref.watch(bilanRepositoryProvider);
  final period = ref.watch(bilanPeriodProvider);
  final customRange = ref.watch(bilanDateRangeProvider);

  final range = _computeDateRange(period, customRange);

  return repo.getFecLines(startDate: range.start, endDate: range.end);
});

/// Sealing Service provider
final bilanSealingServiceProvider = Provider<BilanSealingService>((ref) {
  return BilanSealingService();
});

/// Financial Settings provider (async)
final financialSettingsProvider = FutureProvider<BilanFinancialSettings>((
  ref,
) async {
  final repo = ref.watch(bilanRepositoryProvider);
  return repo.getFinancialSettings();
});

/// Heatmap Data provider (async)
final bilanHeatmapProvider = FutureProvider<List<BilanHeatmapPoint>>((
  ref,
) async {
  final repo = ref.watch(bilanRepositoryProvider);
  final period = ref.watch(bilanPeriodProvider);
  final customRange = ref.watch(bilanDateRangeProvider);
  final selectedGroups = ref.watch(bilanSelectedGroupsProvider);

  final range = _computeDateRange(period, customRange);

  // For heatmap, we usually only care about the first selected group or global
  final groupId =
      (selectedGroups?.isNotEmpty ?? false) ? selectedGroups!.first : null;

  return repo.getTransactionHeatmap(
    startDate: range.start,
    endDate: range.end,
    groupId: groupId,
  );
});

/// Period Snapshot provider (async)
final bilanSnapshotProvider = FutureProvider<ReportSnapshot?>((ref) async {
  final repo = ref.watch(bilanRepositoryProvider);
  final period = ref.watch(bilanPeriodProvider);
  final customRange = ref.watch(bilanDateRangeProvider);

  final range = _computeDateRange(period, customRange);

  return repo.getPeriodSnapshot(startDate: range.start, endDate: range.end);
});

/// Internal Transfers provider (async) - for consolidation detail
final internalTransfersProvider = FutureProvider<List<BilanTransaction>>((
  ref,
) async {
  final repo = ref.watch(bilanRepositoryProvider);
  final period = ref.watch(bilanPeriodProvider);
  final customRange = ref.watch(bilanDateRangeProvider);

  final range = _computeDateRange(period, customRange);

  return repo.getInternalTransfers(startDate: range.start, endDate: range.end);
});

/// Drill down transactions provider (async) - Item #02
final bilanDrillDownTransactionsProvider = FutureProvider.family<
    List<BilanTransaction>,
    ({String? groupId, String? category})>((ref, params) async {
  final repo = ref.watch(bilanRepositoryProvider);
  final range = ref.watch(bilanDateRangeProvider);
  final includeDrafts = ref.watch(bilanIncludeDraftsProvider);

  final now = DateTime.now();
  return repo.getTransactionsForDrillDown(
    startDate: range?.start ?? DateTime(now.year, now.month, 1),
    endDate: range?.end ?? DateTime(now.year, now.month + 1, 0, 23, 59, 59),
    groupId: params.groupId,
    category: params.category,
    includeDrafts: includeDrafts,
  );
});

// ──────────────────────────────────────────────
// Pro Max Additions (Phase 4)
// ──────────────────────────────────────────────

/// Active tab index in BilanDashboardScreen
final bilanActiveTabProvider = StateProvider<int>((ref) => 0);

/// Selected year for period grid
final bilanSelectedYearProvider = StateProvider<int>((ref) => DateTime.now().year);

/// Oil Mode (Presentation mode)
final bilanOilModeProvider = StateProvider<bool>((ref) => false);

/// List of periods for the selected year
final bilanPeriodsProvider = FutureProvider.family<List<dynamic>, int>((ref, year) async {
  final repo = ref.watch(bilanRepositoryProvider);
  final churchId = ref.watch(activeChurchIdProvider);
  
  // Note: Cast as dynamic because the model import might not be explicit here, 
  // but it's guaranteed to be BilanPeriod from the repository.
  return repo.getBilanPeriods(churchId: churchId, year: year);
});

/// 12 data points for the monthly evolution chart
final bilanMonthlyTotalsProvider = FutureProvider.family<List<Map<String, dynamic>>, int>((ref, year) async {
  final repo = ref.watch(bilanRepositoryProvider);
  final churchId = ref.watch(activeChurchIdProvider);
  
  return repo.getMonthlyTotals(churchId: churchId, year: year);
});

/// Seal actions notifier
final bilanSealActionsNotifierProvider = StateNotifierProvider<BilanSealActionsNotifier, AsyncValue<void>>((ref) {
  return BilanSealActionsNotifier(ref);
});

class BilanSealActionsNotifier extends StateNotifier<AsyncValue<void>> with AuditableMixin {
  final Ref _ref;

  BilanSealActionsNotifier(this._ref) : super(const AsyncData(null));

  Future<void> sealPeriod(int year, int month, String sealedBy) async {
    try {
      state = const AsyncLoading();
      final repo = _ref.read(bilanRepositoryProvider);
      final churchId = _ref.read(activeChurchIdProvider);
      
      await repo.sealPeriod(
        churchId: churchId,
        year: year,
        month: month,
        sealedBy: sealedBy,
      );
      
      // Audit Log: Seal Period
      unawaited(logAuditAction(
        _ref,
        action: AuditAction.update,
        entityType: 'bilan_periods',
        entityId: '${churchId}_${year}_$month',
        newData: {
          'year': year,
          'month': month,
          'sealed_by': sealedBy,
          'status': 'sealed',
        },
      ));

      // Refresh periods
      _ref.invalidate(bilanPeriodsProvider(year));
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> unsealPeriod(int year, int month, String reason) async {
    try {
      state = const AsyncLoading();
      final repo = _ref.read(bilanRepositoryProvider);
      final churchId = _ref.read(activeChurchIdProvider);
      
      await repo.unsealPeriod(
        churchId: churchId,
        year: year,
        month: month,
        reason: reason,
      );
      
      // Audit Log: Unseal Period
      unawaited(logAuditAction(
        _ref,
        action: AuditAction.update,
        entityType: 'bilan_periods',
        entityId: '${churchId}_${year}_$month',
        newData: {
          'year': year,
          'month': month,
          'unseal_reason': reason,
          'status': 'open',
        },
      ));

      // Refresh periods
      _ref.invalidate(bilanPeriodsProvider(year));
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
