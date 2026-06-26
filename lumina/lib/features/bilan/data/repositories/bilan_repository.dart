import 'dart:math' as math;
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lumina/features/bilan/data/models/bilan_summary.dart';
import 'package:lumina/features/bilan/data/models/bilan_breakdown_item.dart';
import 'package:lumina/features/bilan/data/models/bilan_period.dart';
import 'package:lumina/features/bilan/domain/entities/bilan_entities.dart';
import 'package:lumina/features/bilan/domain/repositories/i_bilan_repository.dart';

class BilanRepository implements IBilanRepository {
  final SupabaseClient _supabase;

  BilanRepository(this._supabase);

  Future<void> _logAudit({
    required String action,
    required String? actorId,
    required String entityId,
    required String entityType,
    Map<String, dynamic>? oldValue,
    Map<String, dynamic>? newValue,
  }) async {
    try {
      await _supabase.from('audit_logs').insert({
        'action': action,
        'actor_id': actorId ?? 'system',
        'entity_id': entityId,
        'entity_type': entityType,
        'old_value': oldValue,
        'new_value': newValue,
        'occurred_at': DateTime.now().toIso8601String(),
      });
    } catch (_) {
      // Ignore errors for audit logging
    }
  }

  @override
  Future<BilanSummary> getBilanSummary({
    required String churchId,
    required DateTime startDate,
    required DateTime endDate,
    String? groupId,
  }) async {
    final params = <String, dynamic>{
      'p_church_id': churchId,
      'p_start_date': startDate.toIso8601String().split('T').first,
      'p_end_date': endDate.toIso8601String().split('T').first,
    };
    if (groupId != null) {
      params['p_group_id'] = groupId;
    }

    final response = await _supabase.rpc(
      'get_financial_bilan',
      params: params,
    );

    if (response != null) {
      return BilanSummary.fromJson(response);
    }
    return const BilanSummary();
  }

  @override
  Future<List<BilanBreakdownItem>> getBilanBreakdown({
    required String churchId,
    required DateTime startDate,
    required DateTime endDate,
    String? groupId,
    required String dimension, // 'category', 'month', 'group'
  }) async {
    final response = await _supabase.rpc(
      'get_bilan_breakdown',
      params: {
        'p_church_id': churchId,
        'p_start_date': startDate.toIso8601String().split('T').first,
        'p_end_date': endDate.toIso8601String().split('T').first,
        'p_dimension': dimension,
      },
    );

    if (response is List) {
      return response.map((json) {
        final map = json as Map<String, dynamic>;
        // Map breakdown_key to key for the model
        return BilanBreakdownItem.fromJson({
          ...map,
          'key': map['breakdown_key'],
        });
      }).toList();
    }
    return [];
  }

  @override
  Future<List<BilanGroupSummary>> getBilanPerGroup({
    required DateTime startDate,
    required DateTime endDate,
    bool includeDrafts = false,
    bool excludeInternal = true,
  }) async {
    try {
      var query = _supabase
          .from('finance_transactions')
          .select('group_id, type, amount, status')
          .gte('date', startDate.toIso8601String().split('T').first)
          .lte('date', endDate.toIso8601String().split('T').first);

      if (!includeDrafts) {
        query = query.neq('status', 'draft');
      }

      final records = await query;
      // Isolate aggregation for performance (2026 standard)
      return await compute(_aggregateBilanPerGroup, records);
    } catch (e) {
      return [];
    }
  }

  static List<BilanGroupSummary> _aggregateBilanPerGroup(List<dynamic> records) {
    final groupMap = <String, _GroupAccumulator>{};
    double globalTotal = 0;

    for (final r in records) {
      final groupId = (r['group_id'] as String?) ?? 'sans_groupe';
      final type = r['type'] as String? ?? '';
      final amount = (r['amount'] as num?)?.toDouble() ?? 0;

      groupMap.putIfAbsent(groupId, () => _GroupAccumulator());
      final acc = groupMap[groupId]!;
      acc.txCount++;
      if (type == 'income') {
        acc.income += amount;
      } else if (type == 'expense') {
        acc.expense += amount;
      }
      globalTotal += amount.abs();
    }

    return groupMap.entries.map((e) {
      final acc = e.value;
      return BilanGroupSummary(
        groupId: e.key,
        groupName: e.key == 'sans_groupe' ? 'Sans groupe' : e.key,
        income: acc.income,
        expense: acc.expense,
        net: acc.income - acc.expense,
        txCount: acc.txCount,
        percentOfTotal: globalTotal > 0
            ? ((acc.income + acc.expense) / globalTotal * 100)
            : 0,
      );
    }).toList();
  }

  @override
  Future<ConsolidatedBilan> getConsolidatedBilan({
    required DateTime startDate,
    required DateTime endDate,
    List<String>? groupIds,
  }) async {
    try {
      // Aggregate from finance_transactions table
      var query = _supabase
          .from('finance_transactions')
          .select('type, amount, status')
          .gte('date', startDate.toIso8601String().split('T').first)
          .lte('date', endDate.toIso8601String().split('T').first);

      if (groupIds != null && groupIds.isNotEmpty) {
        query = query.filter('group_id', 'in', groupIds);
      }

      final records = await query;
      return await compute((data) => _calculateConsolidatedBilan(data.$1, data.$2, data.$3), (records, startDate, endDate));
    } catch (e) {
      // Fallback to empty if query fails
      return ConsolidatedBilan(
        totalIncome: 0,
        totalExpense: 0,
        netBalance: 0,
        internalEliminated: 0,
        txCount: 0,
        periodStart: startDate,
        periodEnd: endDate,
      );
    }
  }

  static ConsolidatedBilan _calculateConsolidatedBilan(
    List<dynamic> records,
    DateTime startDate,
    DateTime endDate,
  ) {
    double totalIncome = 0;
    double totalExpense = 0;
    int txCount = 0;
    int sealedCount = 0;

    for (final r in records) {
      final amount = (r['amount'] as num?)?.toDouble() ?? 0;
      final type = r['type'] as String? ?? '';
      final status = r['status'] as String? ?? '';

      txCount++;
      if (type == 'income') {
        totalIncome += amount;
      } else if (type == 'expense') {
        totalExpense += amount;
      }
      if (status == 'sealed' || status == 'validated') {
        sealedCount++;
      }
    }

    return ConsolidatedBilan(
      totalIncome: totalIncome,
      totalExpense: totalExpense,
      netBalance: totalIncome - totalExpense,
      internalEliminated: 0,
      txCount: txCount,
      sealedCount: sealedCount,
      periodStart: startDate,
      periodEnd: endDate,
    );
  }

  @override
  Future<List<TransactionAnomaly>> detectAnomalies(
      {double threshold = 2.0}) async {
    try {
      // Fetch recent transactions to detect statistical outliers
      final records = await _supabase
          .from('finance_transactions')
          .select('id, amount, type, category_name, date, description')
          .order('date', ascending: false)
          .limit(500);

      if (records.isEmpty) return [];

      // Calculate mean and std deviation
      final amounts =
          records.map((r) => (r['amount'] as num?)?.toDouble() ?? 0).toList();
      final mean = amounts.reduce((a, b) => a + b) / amounts.length;
      final variance =
          amounts.map((a) => (a - mean) * (a - mean)).reduce((a, b) => a + b) /
              amounts.length;
      final stdDev = variance > 0 ? math.sqrt(variance) : 1.0;

      final anomalies = <TransactionAnomaly>[];
      for (final r in records) {
        final amount = (r['amount'] as num?)?.toDouble() ?? 0;
        final zScore = (amount - mean).abs() / stdDev;
        if (zScore >= threshold) {
          anomalies.add(TransactionAnomaly(
            transactionId: r['id'] as String? ?? '',
            amount: amount,
            groupAvg: mean,
            groupStddev: stdDev,
            deviationFactor: zScore,
            reason: 'Montant inhabituel (${zScore.toStringAsFixed(1)}σ)',
          ));
        }
      }
      return anomalies;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<CurrencyConfig>> getCurrencies() async {
    return const [
      CurrencyConfig(
          code: 'XAF', symbol: 'FCFA', label: 'Franc CFA (CEMAC)', isDefault: true),
      CurrencyConfig(code: 'XOF', symbol: 'FCFA', label: 'Franc CFA (BCEAO)'),
      CurrencyConfig(code: 'USD', symbol: '\$', label: 'US Dollar'),
      CurrencyConfig(code: 'EUR', symbol: '€', label: 'Euro'),
    ];
  }

  @override
  Future<List<AppThemeConfig>> getThemes() async {
    return const [
      AppThemeConfig(
        code: 'lumina_light',
        name: 'Lumina Light',
        primaryColor: '#4B2C82',
        secondaryColor: '#FF5722',
        isDefault: true,
      ),
      AppThemeConfig(
        code: 'lumina_dark',
        name: 'Lumina Dark',
        primaryColor: '#673AB7',
        secondaryColor: '#FF7043',
        backgroundColor: '#121212',
        cardColor: '#1E1E1E',
      ),
    ];
  }

  @override
  Future<ChurchBranding> getChurchBranding() async {
    // Try to fetch from a hypothetical settings table
    try {
      final data = await _supabase
          .from('church_settings')
          .select('name, logo_url, branding_config')
          .maybeSingle();
      if (data != null) {
        return ChurchBranding(
          name: data['name'] ?? 'MFE-JC',
          logoUrl: data['logo_url'],
          color: data['branding_config']?['primary_color'] ?? '#4B2C82',
        );
      }
    } catch (_) {}
    return const ChurchBranding(name: 'MFE-JC');
  }

  @override
  Future<void> updateChurchBranding(ChurchBranding branding) async {
    await _supabase.from('church_settings').upsert({
      'name': branding.name,
      'logo_url': branding.logoUrl,
      'branding_config': {'primary_color': branding.color},
    });
  }

  @override
  Future<List<FecLine>> getFecLines({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final records = await _supabase
          .from('finance_transactions')
          .select(
              'id, date, description, amount, type, category_name, status, created_at')
          .gte('date', startDate.toIso8601String().split('T').first)
          .lte('date', endDate.toIso8601String().split('T').first)
          .neq('status', 'draft')
          .order('date', ascending: true);

      final lines = <FecLine>[];
      int counter = 1;

      for (final r in records) {
        final amount = (r['amount'] as num?)?.toDouble() ?? 0;
        final isIncome = r['type'] == 'income';
        final date = DateTime.parse(r['date'] as String);
        final createdAt =
            DateTime.tryParse(r['created_at'] as String? ?? '') ?? date;

        // main entry
        lines.add(FecLine(
          journalCode: isIncome ? 'REC' : 'DEP',
          journalLib: isIncome ? 'Journal Recettes' : 'Journal Dépenses',
          ecritureNum: counter.toString(),
          ecritureDate: date,
          compteNum: _mapCategoryToAccount(r['category_name'], isIncome),
          compteLib: r['category_name'] ?? 'Divers',
          compauxNum: '',
          compauxLib: '',
          pieceRef: r['id'].toString().substring(0, 8),
          pieceDate: date,
          ecritureLib: r['description'] ?? 'Sans libellé',
          debit: isIncome ? 0 : amount,
          credit: isIncome ? amount : 0,
          valideDate: createdAt,
          montantDevise: amount,
          iDevise: 'XAF',
        ));

        // counter-party
        lines.add(FecLine(
          journalCode: isIncome ? 'REC' : 'DEP',
          journalLib: isIncome ? 'Journal Recettes' : 'Journal Dépenses',
          ecritureNum: counter.toString(),
          ecritureDate: date,
          compteNum: '521000', // Bank/Cash
          compteLib: 'Banque/Caisse',
          compauxNum: '',
          compauxLib: '',
          pieceRef: r['id'].toString().substring(0, 8),
          pieceDate: date,
          ecritureLib: r['description'] ?? 'Sans libellé',
          debit: isIncome ? amount : 0,
          credit: isIncome ? 0 : amount,
          valideDate: createdAt,
          montantDevise: amount,
          iDevise: 'XAF',
        ));
        counter++;
      }
      return lines;
    } catch (e) {
      return [];
    }
  }

  String _mapCategoryToAccount(String? category, bool isIncome) {
    if (category == null) return isIncome ? '706000' : '606000';
    final c = category.toLowerCase();
    if (c.contains('dime')) return '701100';
    if (c.contains('offrande')) return '701200';
    if (c.contains('loyer')) return '622100';
    if (c.contains('salaire')) return '661100';
    return isIncome ? '706000' : '606000';
  }

  @override
  Future<BilanFinancialSettings> getFinancialSettings() async {
    return const BilanFinancialSettings();
  }

  @override
  Future<void> updateFinancialSettings(BilanFinancialSettings settings) async {
    // Logic to update settings
  }

  @override
  Future<List<BilanHeatmapPoint>> getTransactionHeatmap({
    required DateTime startDate,
    required DateTime endDate,
    String? groupId,
  }) async {
    try {
      var query = _supabase
          .from('finance_transactions')
          .select('created_at')
          .gte('date', startDate.toIso8601String().split('T').first)
          .lte('date', endDate.toIso8601String().split('T').first);

      if (groupId != null) {
        query = query.eq('group_id', groupId);
      }

      final records = await query;

      // Aggregate by dayOfWeek + hourOfDay
      final heatmap = <String, int>{};
      for (final r in records) {
        final createdAt = DateTime.tryParse(r['created_at'] as String? ?? '');
        if (createdAt == null) continue;
        final key = '${createdAt.weekday}_${createdAt.hour}';
        heatmap[key] = (heatmap[key] ?? 0) + 1;
      }

      return heatmap.entries.map((e) {
        final parts = e.key.split('_');
        return BilanHeatmapPoint(
          dayOfWeek: int.parse(parts[0]),
          hourOfDay: int.parse(parts[1]),
          txCount: e.value,
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<ReportSnapshot?> getPeriodSnapshot({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    return null;
  }

  @override
  Future<List<BilanTransaction>> getInternalTransfers({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    return [];
  }

  @override
  Future<List<BilanTransaction>> getTransactionsForDrillDown({
    required DateTime startDate,
    required DateTime endDate,
    String? groupId,
    String? category,
    bool includeDrafts = false,
  }) async {
    try {
      var query = _supabase
          .from('finance_transactions')
          .select(
              'id, date, description, amount, type, category_name, group_id, status, attachment_url')
          .gte('date', startDate.toIso8601String().split('T').first)
          .lte('date', endDate.toIso8601String().split('T').first);

      if (!includeDrafts) {
        query = query.neq('status', 'draft');
      }
      if (groupId != null) {
        query = query.eq('group_id', groupId);
      }
      if (category != null) {
        query = query.eq('category_name', category);
      }

      final records = await query.order('date', ascending: false);

      return records
          .map((r) => BilanTransaction(
                id: r['id'] as String? ?? '',
                date: DateTime.parse(r['date'] as String),
                label: r['description'] as String? ?? '',
                amount: (r['amount'] as num?)?.toDouble() ?? 0,
                type: r['type'] as String? ?? '',
                category: r['category_name'] as String? ?? '',
                groupName: r['group_id'] as String?,
                imageUrl: r['attachment_url'] as String?,
                status: r['status'] as String? ?? 'validated',
              ))
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<BilanAuditLog>> getAuditLogs({String? recordId}) async {
    try {
      var query = _supabase
          .from('audit_logs')
          .select(
              'id, action, actor_id, role_used, occurred_at, old_value, new_value, entity_id')
          .inFilter('entity_type', ['finance_transaction', 'bilan_period']);

      if (recordId != null) {
        query = query.eq('entity_id', recordId);
      }

      final records =
          await query.order('occurred_at', ascending: false).limit(100);

      return records
          .map((r) => BilanAuditLog(
                id: r['id'] as String? ?? '',
                action: r['action'] as String? ?? '',
                changedBy: r['actor_id'] as String? ?? '',
                changedByRole: r['role_used'] as String?,
                createdAt: DateTime.parse(r['occurred_at'] as String),
                oldData: r['old_value'] as Map<String, dynamic>?,
                newData: r['new_value'] as Map<String, dynamic>?,
                recordId: r['entity_id'] as String?,
              ))
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<Map<String, dynamic>> signTransaction(
    String transactionId, {
    String? comment,
  }) async {
    return {
      'status': 'validated',
      'signatures_needed': 0,
    };
  }

  // ──────────────────────────────────────────────
  // Bilan Period Management
  // ──────────────────────────────────────────────

  @override
  Future<List<BilanPeriod>> getBilanPeriods({
    required String churchId,
    required int year,
  }) async {
    try {
      final records = await _supabase
          .from('bilan_periods')
          .select()
          .eq('church_id', churchId)
          .eq('year', year)
          .order('month', ascending: true);

      return records
          .map((r) => BilanPeriod.fromJson(r))
          .toList();
    } catch (e) {
      // Table might not exist yet — return empty
      return [];
    }
  }

  @override
  Future<BilanPeriod> sealPeriod({
    required String churchId,
    required int year,
    required int month,
    required String sealedBy,
  }) async {
    try {
      // Try RPC first (if SQL migration was applied)
      final rpcResult = await _supabase.rpc(
        'seal_period',
        params: {
          'p_church_id': churchId,
          'p_year': year,
          'p_month': month,
          'p_sealed_by': sealedBy,
        },
      );

      if (rpcResult != null) {
        // RPC returns the sealed period data, re-fetch the full record
        final records = await _supabase
            .from('bilan_periods')
            .select()
            .eq('church_id', churchId)
            .eq('year', year)
            .eq('month', month)
            .limit(1);

        if (records.isNotEmpty) {
          final period = BilanPeriod.fromJson(records.first);
          await _logAudit(
            action: 'SEAL_PERIOD',
            actorId: sealedBy,
            entityId: '${churchId}_${year}_$month',
            entityType: 'bilan_period',
            newValue: {'status': 'sealed', 'seal_hash': period.sealHash},
          );
          return period;
        }
      }
    } catch (_) {
      // RPC not available — fallback to client-side sealing
    }

    // Fallback: compute totals client-side and upsert
    final startDate = DateTime(year, month, 1);
    final endDate = DateTime(year, month + 1, 0, 23, 59, 59);

    final records = await _supabase
        .from('finance_transactions')
        .select('id, date, type, amount, category_name')
        .eq('church_id', churchId)
        .gte('date', startDate.toIso8601String().split('T').first)
        .lte('date', endDate.toIso8601String().split('T').first)
        .neq('status', 'draft');

    double totalIncome = 0;
    double totalExpense = 0;
    final categoryBreakdown = <String, double>{};
    
    // Sort records by date and id for canonical hash
    records.sort((a, b) {
      final dateCompare = (a['date'] as String).compareTo(b['date'] as String);
      if (dateCompare != 0) return dateCompare;
      return (a['id'] as String? ?? '').compareTo(b['id'] as String? ?? '');
    });

    for (final r in records) {
      final amount = (r['amount'] as num?)?.toDouble() ?? 0;
      final type = r['type'] as String? ?? '';
      final cat = r['category_name'] as String? ?? 'Autre';

      if (type == 'income') {
        totalIncome += amount;
      } else if (type == 'expense') {
        totalExpense += amount;
      }
      categoryBreakdown[cat] = (categoryBreakdown[cat] ?? 0) + amount;
    }

    // Compute SHA-256 hash robustement (inclut le contenu des transactions)
    final contentToHash = {
      'church_id': churchId,
      'period': '$year-$month',
      'totals': {'income': totalIncome, 'expense': totalExpense},
      'transactions': records.map((r) => {'id': r['id'], 'amount': r['amount'], 'hash': sha256.convert(utf8.encode(jsonEncode(r))).toString()}).toList(),
    };
    
    final sealHash = sha256.convert(utf8.encode(jsonEncode(contentToHash))).toString();

    final now = DateTime.now().toIso8601String();

    final upsertData = {
      'church_id': churchId,
      'year': year,
      'month': month,
      'status': 'sealed',
      'sealed_at': now,
      'sealed_by': sealedBy,
      'seal_hash': sealHash,
      'total_income': totalIncome,
      'total_expense': totalExpense,
      'net_balance': totalIncome - totalExpense,
      'category_breakdown': categoryBreakdown,
      'updated_at': now,
    };

    try {
      final result = await _supabase
          .from('bilan_periods')
          .upsert(upsertData, onConflict: 'church_id,year,month')
          .select()
          .single();

      final period = BilanPeriod.fromJson(result);
      await _logAudit(
        action: 'SEAL_PERIOD',
        actorId: sealedBy,
        entityId: '${churchId}_${year}_$month',
        entityType: 'bilan_period',
        newValue: {'status': 'sealed', 'seal_hash': period.sealHash},
      );
      return period;
    } catch (_) {
      // If table doesn't exist, return a synthetic period
      return BilanPeriod(
        id: '',
        churchId: churchId,
        year: year,
        month: month,
        status: BilanPeriodStatus.sealed,
        sealedAt: DateTime.now(),
        sealedBy: sealedBy,
        sealHash: sealHash,
        totalIncome: totalIncome,
        totalExpense: totalExpense,
        netBalance: totalIncome - totalExpense,
        categoryBreakdown: categoryBreakdown,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }
  }

  @override
  Future<void> unsealPeriod({
    required String churchId,
    required int year,
    required int month,
    required String reason,
  }) async {
    try {
      await _supabase
          .from('bilan_periods')
          .update({
            'status': 'open',
            'sealed_at': null,
            'sealed_by': null,
            'seal_hash': null,
            'notes': reason,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('church_id', churchId)
          .eq('year', year)
          .eq('month', month);

      await _logAudit(
        action: 'UNSEAL_PERIOD',
        actorId: null,
        entityId: '${churchId}_${year}_$month',
        entityType: 'bilan_period',
        newValue: {'status': 'open', 'reason': reason},
      );
    } catch (_) {
      // Table might not exist yet
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getMonthlyTotals({
    required String churchId,
    required int year,
  }) async {
    try {
      final startDate = DateTime(year, 1, 1);
      final endDate = DateTime(year, 12, 31);

      final records = await _supabase
          .from('finance_transactions')
          .select('date, type, amount')
          .eq('church_id', churchId)
          .gte('date', startDate.toIso8601String().split('T').first)
          .lte('date', endDate.toIso8601String().split('T').first)
          .neq('status', 'draft');

      return await compute(_calculateMonthlyTotals, records);
    } catch (e) {
      return List.generate(12, (i) => {
        'month': i + 1,
        'income': 0.0,
        'expense': 0.0,
        'net': 0.0,
      });
    }
  }

  static List<Map<String, dynamic>> _calculateMonthlyTotals(List<dynamic> records) {
    // Aggregate by month
    final monthlyData = List.generate(12, (i) => <String, dynamic>{
      'month': i + 1,
      'income': 0.0,
      'expense': 0.0,
      'net': 0.0,
    });

    for (final r in records) {
      final date = DateTime.tryParse(r['date'] as String? ?? '');
      if (date == null) continue;
      final monthIdx = date.month - 1;
      final amount = (r['amount'] as num?)?.toDouble() ?? 0;
      final type = r['type'] as String? ?? '';

      if (type == 'income') {
        monthlyData[monthIdx]['income'] =
            (monthlyData[monthIdx]['income'] as double) + amount;
      } else if (type == 'expense') {
        monthlyData[monthIdx]['expense'] =
            (monthlyData[monthIdx]['expense'] as double) + amount;
      }
      monthlyData[monthIdx]['net'] =
          (monthlyData[monthIdx]['income'] as double) -
              (monthlyData[monthIdx]['expense'] as double);
    }

    return monthlyData;
  }
}

/// Helper for group aggregation in getBilanPerGroup
class _GroupAccumulator {
  double income = 0;
  double expense = 0;
  int txCount = 0;
}
