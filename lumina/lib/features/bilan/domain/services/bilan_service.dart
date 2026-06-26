import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/bilan_summary.dart';
import '../../data/models/bilan_breakdown_item.dart';
import '../../../../core/providers/auth_provider.dart';
import 'package:lumina/core/providers/repository_providers_finance.dart';

// --- Shared Providers ---
final bilanFilterPeriodProvider = StateProvider<DateTimeRange>((ref) {
  final now = DateTime.now();
  final startOfMonth = DateTime(now.year, now.month, 1);
  final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
  return DateTimeRange(start: startOfMonth, end: endOfMonth);
});

final bilanFilterGroupProvider = StateProvider<String?>((ref) => null);

// NOTE: bilanRepositoryProvider is provided by the finance repository module.
// Do NOT re-declare it here to avoid duplicate provider conflicts.

// --- Data Providers ---

final bilanSummaryProvider = FutureProvider.autoDispose<BilanSummary>((
  ref,
) async {
  final repo = ref.watch(bilanRepositoryProvider);
  final churchId = ref.watch(activeChurchIdProvider);

  final period = ref.watch(bilanFilterPeriodProvider);
  final groupId = ref.watch(bilanFilterGroupProvider);

  return repo.getBilanSummary(
    churchId: churchId,
    startDate: period.start,
    endDate: period.end,
    groupId: groupId,
  );
});

final bilanBreakdownProvider = FutureProvider.family
    .autoDispose<List<BilanBreakdownItem>, String>((ref, dimension) async {
  final repo = ref.watch(bilanRepositoryProvider);
  final churchId = ref.watch(activeChurchIdProvider);

  final period = ref.watch(bilanFilterPeriodProvider);
  final groupId = ref.watch(bilanFilterGroupProvider);

  return repo.getBilanBreakdown(
    churchId: churchId,
    startDate: period.start,
    endDate: period.end,
    groupId: groupId,
    dimension: dimension,
  );
});
