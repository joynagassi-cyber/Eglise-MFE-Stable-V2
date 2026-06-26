// lib/features/finance/data/repositories/audit_log_repository.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../audit/domain/models/audit_log.dart';
import '../../../../core/utils/app_date_time.dart';

/// Repository pour la consultation des logs d'audit (lecture seule)
class AuditLogRepository {
  final SupabaseClient _supabase;

  AuditLogRepository(this._supabase);

  /// Récupère les logs d'audit pour une table spécifique
  Future<List<AuditLog>> getLogsForTable(
    String tableName, {
    int limit = 50,
    int offset = 0,
  }) async {
    final response = await _supabase
        .from('audit_logs')
        .select()
        .eq('table_name', tableName)
        .order('created_at', ascending: false)
        .range(offset, offset + limit - 1);

    return (response as List)
        .map((json) => AuditLog.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Récupère les logs d'audit pour un enregistrement spécifique
  Future<List<AuditLog>> getLogsForRecord(
    String tableName,
    String recordId,
  ) async {
    final response = await _supabase
        .from('audit_logs')
        .select()
        .eq('table_name', tableName)
        .eq('record_id', recordId)
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => AuditLog.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Récupère les logs d'audit pour un utilisateur spécifique
  Future<List<AuditLog>> getLogsForUser(
    String userId, {
    int limit = 50,
    int offset = 0,
  }) async {
    final response = await _supabase
        .from('audit_logs')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .range(offset, offset + limit - 1);

    return (response as List)
        .map((json) => AuditLog.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Récupère les logs récents (dernières 24h) pour le tableau de bord admin
  Future<List<AuditLog>> getRecentLogs({int limit = 100}) async {
    final yesterday = AppDateTime.nowUtc().subtract(const Duration(hours: 24));

    final response = await _supabase
        .from('audit_logs')
        .select()
        .gte('created_at', yesterday.toIso8601String())
        .order('created_at', ascending: false)
        .limit(limit);

    return (response as List)
        .map((json) => AuditLog.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Compte le nombre total de logs pour une table
  Future<int> countLogsForTable(String tableName) async {
    final response = await _supabase
        .from('audit_logs')
        .select()
        .eq('table_name', tableName)
        .count(CountOption.exact);

    return response.count;
  }
}