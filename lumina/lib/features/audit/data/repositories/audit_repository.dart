import 'package:isar/isar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/models/audit_log.dart';
import '../../../../core/data/local/isar_service.dart';
import '../../../../core/domain/entities/enums/audit_action.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/utils/app_date_time.dart';
import '../models/audit_log_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuditRepository {
  final SupabaseClient _supabase;
  final IsarService _isar;
  final Ref _ref;

  AuditRepository(this._supabase, this._isar, this._ref);

  String get _churchId => _ref.read(activeChurchIdProvider);

  Future<List<AuditLog>> getFilteredLogs({
    required String churchId,
    DateTime? startDate,
    DateTime? endDate,
    String? actorId,
    String? entityType,
    String? action,
    String? dashboardSource,
    int limit = 50,
    int offset = 0,
  }) async {
    // Local-First Query
    if (_isar.isReady) {
      final query = _isar.auditLogModels.where()
          .filter()
          .optional(churchId != '*', (q) => q.churchIdEqualTo(churchId))
          .sortByOccurredAtDesc();
      
      final localLogs = await query.offset(offset).limit(limit).findAll();
      if (localLogs.isNotEmpty) return localLogs.map((m) => m.toDomain()).toList();
    }

    // Remote Fallback & Sync
    final response = await _supabase.rpc(
      'get_audit_logs_filtered',
      params: {
        'p_church_id': churchId,
        'p_start_date': startDate?.toIso8601String(),
        'p_end_date': endDate?.toIso8601String(),
        'p_actor_id': actorId,
        'p_entity_type': entityType,
        'p_action': action,
        'p_dashboard_source': dashboardSource,
        'p_limit': limit,
        'p_offset': offset,
      },
    );

    if (response is List) {
      final logs = response.map((json) => AuditLog.fromJson(json as Map<String, dynamic>)).toList();
      
      if (_isar.isReady) {
        await _isar.db.writeTxn(() async {
          for (final log in logs) {
            await _isar.db.auditLogModels.put(AuditLogModel.fromDomain(log, churchId));
          }
        });
      }
      return logs;
    }
    return [];
  }

  Future<void> logAction({
    required AuditAction action,
    required String entityType,
    required String entityId,
    Map<String, dynamic>? oldData,
    Map<String, dynamic>? newData,
    String? actorId,
    Map<String, dynamic>? metadata,
  }) async {
    final churchId = _churchId;
    final body = {
      'church_id': churchId,
      'action': action.name,
      'entity_type': entityType,
      'entity_id': entityId,
      'old_value': oldData,
      'new_value': newData,
      'actor_id': actorId,
      'metadata': metadata,
      'occurred_at': AppDateTime.nowIso(),
    };

    // Robust offline logging
    if (_isar.isReady) {
       final log = AuditLog(
         id: AppDateTime.tempId(),
         entityType: entityType,
         entityId: entityId,
         action: action,
         oldData: oldData,
         newData: newData,
         actorId: actorId,
         metadata: metadata,
         occurredAt: DateTime.now(),
       );
       await _isar.db.writeTxn(() async {
         await _isar.db.auditLogModels.put(AuditLogModel.fromDomain(log, churchId));
       });
    }

    await _supabase.from('audit_logs').insert(body);
  }
}
