/// Service for sealing and signing BILAN reports
///
/// ⚠️ DEPRECATED: The canonical sealing hash is now computed in [BilanRepository.sealPeriod]
/// using a unified deterministic algorithm (SHA-256 of church_id||year||month||totals||breakdown)
/// that matches the SQL RPC seal_period(). This service's generateSignature() used a different
/// format and is NOT compatible with the server-side hash.
///
/// Kept only for backward-compatibility reference. Will be removed in next major version.
library;

import 'dart:convert';
import 'package:crypto/crypto.dart';

class BilanSealingService {
  /// ⚠️ DEPRECATED — Use [BilanRepository.sealPeriod] instead.
  ///
  /// Previously generated a signature incompatible with the SQL RPC seal_period().
  /// The canonical hash is now produced server-side (or via the unified fallback)
  /// and is verifiable by both client and server.
  @Deprecated('Use BilanRepository.sealPeriod which produces the canonical hash')
  String generateSignature({
    required String churchId,
    required int year,
    required int month,
    required double totalIncome,
    required double totalExpense,
    required double netBalance,
    required Map<String, dynamic> categoryBreakdown,
  }) {
    // Unified deterministic algorithm matching SQL RPC seal_period()
    // Format: church_id||year||month||income||expense||net||cat1:amt1,cat2:amt2
    final sortedKeys = categoryBreakdown.keys.toList()..sort();
    final breakdownStr =
        sortedKeys.map((k) => '$k:${(categoryBreakdown[k] as num).toStringAsFixed(2)}').join(',');
    final contentToHash = '$churchId$year$month'
        '${totalIncome.toStringAsFixed(2)}'
        '${totalExpense.toStringAsFixed(2)}'
        '${netBalance.toStringAsFixed(2)}'
        '$breakdownStr';
    final sealHash = sha256.convert(utf8.encode(contentToHash)).toString();
    return sealHash;
  }
}