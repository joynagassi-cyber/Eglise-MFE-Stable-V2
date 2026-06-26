// ============================================================
// FICHIER : lib/features/dashboard/presentation/providers/superadmin_dashboard_provider.dart
// DESCRIPTION : Providers RPC pour le dashboard Superadmin.
//               Source de vérité unique : les RPCs Supabase.
//               Utilise `activeChurchIdProvider` pour le filtre multi-église.
// ============================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/models/activity_item.dart';
import '../../../../core/providers/auth_state_leaf.dart';
import '../../../dashboard/domain/entities/superadmin_models.dart';

// -----------------------------------------------------------------------------
// DATA PROVIDERS (RPC KPI)
// -----------------------------------------------------------------------------

/// KPIs brutes du dashboard superadmin via RPC Supabase.
/// Watchs `activeChurchIdProvider` pour le filtre multi-église.
final superadminRawKpisProvider =
    FutureProvider<Map<String, dynamic>>((ref) async {
  final supabase = Supabase.instance.client;
  final churchId = ref.watch(activeChurchIdProvider);

  try {
    final response = await supabase.rpc(
      'get_superadmin_kpis',
      params: {'p_church_id': churchId},
    );

    if (response == null) {
      return {};
    }
    return response as Map<String, dynamic>;
  } catch (e) {
    throw Exception('Erreur lors du chargement des KPIs globaux: $e');
  }
});

// 1. KPI : Total membres
final totalMembersKpiProvider = Provider<AsyncValue<KpiData>>((ref) {
  return ref.watch(superadminRawKpisProvider).whenData((data) {
    final total = data['total_members'] ?? 0;
    final prev = data['prev_month_members'] ?? 0;

    return KpiData(
      value: total,
      previousValue: prev,
    );
  });
});

// 2. KPI : Balance financière globale
final globalFinanceKpiProvider = Provider<AsyncValue<KpiData>>((ref) {
  return ref.watch(superadminRawKpisProvider).whenData((data) {
    final balance = data['balance'] ?? 0;
    return KpiData(
      value: balance,
      unit: 'FCFA',
    );
  });
});

// 3. KPI : Événements actifs
final activeEventsKpiProvider = Provider<AsyncValue<KpiData>>((ref) {
  return ref.watch(superadminRawKpisProvider).whenData((data) {
    final active = data['active_events'] ?? 0;
    return KpiData(value: active);
  });
});

// -----------------------------------------------------------------------------
// RECENT ACTIVITIES
// -----------------------------------------------------------------------------

/// Activités récentes depuis audit_logs, filtrées par church.
final recentActivitiesProvider =
    FutureProvider<List<ActivityItem>>((ref) async {
  final supabase = Supabase.instance.client;
  final churchId = ref.watch(activeChurchIdProvider);

  var query = supabase
      .from('audit_logs')
      .select('*, profiles(first_name, last_name, avatar_url)');

  if (churchId != null) {
    query = query.eq('church_id', churchId);
  }

  // MUST call transforms (order, limit) AFTER all filters (eq)
  final response = await query.order('created_at', ascending: false).limit(5);

  return (response as List).map((row) {
    final profile = row['profiles'] as Map<String, dynamic>?;
    final name = profile != null
        ? "${profile['first_name']} ${profile['last_name']}"
        : 'Système';
    final avatar = profile?['avatar_url'] as String?;

    return ActivityItem(
      id: row['id'] as String,
      title: 'Action Superadmin',
      type: _mapAuditActionToActivityType(row['action']),
      description: "Action sur ${row['entity_type']}",
      timestamp: DateTime.parse(row['created_at']),
      actorName: name,
      actorAvatarUrl: avatar,
    );
  }).toList();
});

// Helper
ActivityType _mapAuditActionToActivityType(String? action) {
  switch (action) {
    case 'insert':
    case 'create':
      return ActivityType.memberJoined;
    case 'delete':
    case 'remove':
      return ActivityType.eventUpdated;
    case 'update':
      return ActivityType.general;
    default:
      return ActivityType.general;
  }
}