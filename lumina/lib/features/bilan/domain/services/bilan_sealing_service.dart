/// Service for sealing and signing BILAN reports
library;

import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../../domain/entities/bilan_entities.dart';

class BilanSealingService {
  /// Generate a digital signature/hash for the BILAN data
  String generateSignature(
    DateTime start,
    DateTime end,
    ConsolidatedBilan summary,
    List<BilanGroupSummary> groups,
  ) {
    final dataToSign = {
      'period': '${start.toIso8601String()}_${end.toIso8601String()}',
      'summary': {
        'income': summary.totalIncome,
        'expense': summary.totalExpense,
        'net': summary.netBalance,
      },
      'groups': groups.map((g) => {'id': g.groupId, 'net': g.net}).toList(),
      'salt': 'LUMINA_MFEJC_COMPTA_2026', // Internal salt
    };

    final bytes = utf8.encode(jsonEncode(dataToSign));
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}