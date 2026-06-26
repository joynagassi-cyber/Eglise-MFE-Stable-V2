// lib/features/finance/presentation/providers/audit_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/repositories/audit_log_repository.dart';
import '../../../audit/domain/models/audit_log.dart';

/// Provider pour le repository d'audit
final auditLogRepositoryProvider = Provider<AuditLogRepository>((ref) {
  return AuditLogRepository(Supabase.instance.client);
});

/// Provider pour les logs récents (Dashboard Admin)
final recentAuditLogsProvider = FutureProvider<List<AuditLog>>((ref) async {
  final repository = ref.watch(auditLogRepositoryProvider);
  return repository.getRecentLogs(limit: 50);
});

/// Provider pour les logs d'une table spécifique
final tableAuditLogsProvider = FutureProvider.family<List<AuditLog>, String>((
  ref,
  tableName,
) async {
  final repository = ref.watch(auditLogRepositoryProvider);
  return repository.getLogsForTable(tableName);
});

/// Provider pour les logs d'un enregistrement spécifique
final recordAuditLogsProvider = FutureProvider.family<List<AuditLog>,
    ({String tableName, String recordId})>((ref, params) async {
  final repository = ref.watch(auditLogRepositoryProvider);
  return repository.getLogsForRecord(params.tableName, params.recordId);
});

/// Provider pour les logs d'un utilisateur
final userAuditLogsProvider = FutureProvider.family<List<AuditLog>, String>((
  ref,
  userId,
) async {
  final repository = ref.watch(auditLogRepositoryProvider);
  return repository.getLogsForUser(userId);
});