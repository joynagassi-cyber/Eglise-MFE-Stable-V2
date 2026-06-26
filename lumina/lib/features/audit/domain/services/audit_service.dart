import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/audit_log.dart';
import '../models/audit_anomaly.dart';
import '../../data/repositories/audit_repository.dart';
import '../../../../core/domain/entities/enums/audit_action.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/user_context_provider.dart';

import '../../../../core/data/local/isar_service.dart';

// --- Shared Providers ---
final auditFilterStartDateProvider = StateProvider<DateTime?>((ref) => null);
final auditFilterEndDateProvider = StateProvider<DateTime?>((ref) => null);
final auditFilterActorProvider = StateProvider<String?>((ref) => null);
final auditFilterActionProvider = StateProvider<String?>((ref) => null);
final auditFilterEntityTypeProvider = StateProvider<String?>((ref) => null);

// --- Repository Provider ---
final auditRepositoryProvider = Provider<AuditRepository>((ref) {
  final isar = ref.watch(isarServiceProvider);
  return AuditRepository(Supabase.instance.client, isar, ref);
});

// --- Data Providers ---
final auditLogsProvider = FutureProvider.autoDispose<List<AuditLog>>((
  ref,
) async {
  final repo = ref.watch(auditRepositoryProvider);
  final churchId = ref.watch(activeChurchIdProvider);
  final userContext = ref.watch(userContextNotifierProvider).valueOrNull;

  if (userContext == null) return [];

  final start = ref.watch(auditFilterStartDateProvider);
  final end = ref.watch(auditFilterEndDateProvider);
  final actorId = ref.watch(auditFilterActorProvider);
  final action = ref.watch(auditFilterActionProvider);
  final entityType = ref.watch(auditFilterEntityTypeProvider);

  // RBAC Filter: A Group Leader only sees "Group" dashboard logs
  String? dashboardSourceFilter;
  if (userContext.role.code == 'leader') {
    dashboardSourceFilter = 'Group';
  }

  final logs = await repo.getFilteredLogs(
    churchId: churchId,
    startDate: start,
    endDate: end,
    actorId: actorId,
    entityType: entityType,
    action: action,
    dashboardSource:
        dashboardSourceFilter, // Note: This parameter might not be used by the RPC yet if migration failed, but we handle it here
  );

  // Second pass filtering in Dart for extra safety if the RPC doesn't support dashboardSource yet
  if (userContext.role.code == 'leader') {
    return logs.where((log) => log.dashboardSource == 'Group').toList();
  }

  return logs;
});

final auditLogByIdProvider =
    FutureProvider.autoDispose.family<AuditLog?, String>((ref, id) async {
  // On pourrait avoir un appel RPC spécifique, mais ici on réutilise la liste 
  // ou on fait un fetch direct Supabase si nécessaire. 
  // Pour la performance, un select direct est préférable.
  final response = await Supabase.instance.client
      .from('audit_logs')
      .select()
      .eq('id', id)
      .maybeSingle();

  if (response != null) {
    return AuditLog.fromJson(response);
  }
  return null;
});

// --- Anomaly Detector Service ---
class AnomalyDetector {
  List<AuditAnomaly> detectAnomalies(List<AuditLog> logs) {
    final anomalies = <AuditAnomaly>[];

    for (final log in logs) {
      // Rule 1: Sealed Transaction Modification
      if (log.action == AuditAction.update &&
          log.entityType == 'finance_transactions') {
        final oldStatus = log.oldData?['status'];
        if (oldStatus == 'sealed' || oldStatus == 'validated') {
          anomalies.add(
            AuditAnomaly(
              logId: log.id,
              severity: AnomalySeverity.critical,
              description: 'Modification d\'une transaction scellée/approuvée',
              detectedAt: DateTime.now(),
            ),
          );
        }
      }

      // Rule 2: Deletion of critical data
      if (log.action == AuditAction.delete) {
        if ([
          'finance_transactions',
          'members',
          'donors',
        ].contains(log.entityType)) {
          anomalies.add(
            AuditAnomaly(
              logId: log.id,
              severity: AnomalySeverity.critical,
              description:
                  'Suppression de données critiques (${log.entityType})',
              detectedAt: DateTime.now(),
            ),
          );
        }
      }

      // Rule 3: Off-hours access (01h - 05h)
      final hour = log.occurredAt.hour;
      if (hour >= 1 && hour < 5) {
        anomalies.add(
          AuditAnomaly(
            logId: log.id,
            severity: AnomalySeverity.warning,
            description: 'Action effectuée hors horaires (01h-05h)',
            detectedAt: DateTime.now(),
          ),
        );
      }

      // Rule 4: User modifying their own role
      if (log.entityType == 'user_roles' && log.action == AuditAction.update) {
        final targetUserId = log.newData?['user_id'] ?? log.oldData?['user_id'];
        if (targetUserId == log.actorId) {
          anomalies.add(
            AuditAnomaly(
              logId: log.id,
              severity: AnomalySeverity.warning,
              description: 'Auto-attribution de droits',
              detectedAt: DateTime.now(),
            ),
          );
        }
      }
    }
    return anomalies;
  }
}

final anomalyDetectorProvider = Provider((ref) => AnomalyDetector());

final auditAnomaliesProvider = Provider.autoDispose<List<AuditAnomaly>>((ref) {
  final logsAsync = ref.watch(auditLogsProvider);
  return logsAsync.when(
    data: (logs) => ref.read(anomalyDetectorProvider).detectAnomalies(logs),
    loading: () => [],
    error: (_, __) => [],
  );
});