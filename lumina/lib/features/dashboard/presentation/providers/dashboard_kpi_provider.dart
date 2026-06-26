import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:lumina/core/providers/auth_state_leaf.dart';
import 'package:lumina/core/logging/app_logger.dart';
import 'package:lumina/features/dashboard/presentation/providers/superadmin_dashboard_provider.dart';
import 'package:lumina/features/dashboard/presentation/providers/dashboard_providers.dart';

part 'dashboard_kpi_provider.g.dart';

/// Durée de vie du cache KPI avant auto-invalidation.
/// Les KPIs sont aussi invalidés par le RealtimeService via le
/// DashboardCacheManager, mais ce timer est le filet de sécurité
/// garantissant que les données ne restent jamais stale > 60s.
const _kpiRefreshInterval = Duration(seconds: 60);

class DashboardKpiData {
  final int membersCount;
  final double balance;
  final int upcomingEvents;
  final double growthRate;
  final int birthdaysCount;
  final int absenceAlertsCount;
  final int milestonesAlertsCount;
  const DashboardKpiData({
    required this.membersCount,
    required this.balance,
    required this.upcomingEvents,
    required this.growthRate,
    this.birthdaysCount = 0,
    this.absenceAlertsCount = 0,
    this.milestonesAlertsCount = 0,
  });
}

@riverpod
class DashboardKpi extends _$DashboardKpi {
  @override
  Future<DashboardKpiData> build() async {
    // Auto-refresh timer : invalide les KPIs toutes les 60 secondes
    final timer = Timer(_kpiRefreshInterval, () {
      ref.invalidateSelf();
    });

    // Nettoyer le timer quand le provider est disposé ou reconstruit
    ref.onDispose(() {
      timer.cancel();
    });

    // ─── STRATÉGIE HYBRIDE ───
    // Pour le SUPERADMIN (vue globale) : utiliser les RPCs performants
    // Pour le GROUP LEADER (vue groupe) : utiliser les alertes Supabase spécifiques
    final churchId = ref.watch(activeChurchIdProvider);
    final targetGroupId = ref.watch(superadminTargetGroupProvider);

    // 1. KPIs primaires via RPC (1 seul appel pour les 4 KPIs principaux)
    final rawKpis = await ref.watch(superadminRawKpisProvider.future);

    final membersCount = (rawKpis['total_members'] as num?)?.toInt() ?? 0;
    final prevMembers = (rawKpis['prev_month_members'] as num?)?.toInt() ?? 0;
    final balance = (rawKpis['balance'] as num?)?.toDouble() ?? 0.0;
    final upcomingEvents = (rawKpis['active_events'] as num?)?.toInt() ?? 0;

    // Growth rate = (total - prev) / prev * 100
    final growthRate = prevMembers > 0
        ? ((membersCount - prevMembers) / prevMembers * 100).toDouble()
        : 0.0;

    // 2. Alertes spécifiques au groupe (si un groupe est sélectionné)
    int absenceAlerts = 0;
    int milestoneAlerts = 0;
    int birthdays = 0;

    // Birthdays : requête légère via RPC ou count
    try {
      birthdays = await _fetchUpcomingBirthdays(churchId).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          AppLogger.w('Birthday fetch timeout', 'DASHBOARD_KPI');
          return 0;
        },
      );
    } catch (e) {
      AppLogger.e('Birthday fetch failed: $e', 'DASHBOARD_KPI', e);
    }

    if (targetGroupId != null) {
      try {
        absenceAlerts =
            await _fetchAbsenceAlertsFromSupabase(targetGroupId).timeout(
          const Duration(seconds: 5),
          onTimeout: () {
            AppLogger.w(
              'Absence alerts fetch timeout for group: $targetGroupId',
              'DASHBOARD_KPI',
            );
            return 0;
          },
        );
        milestoneAlerts =
            await _fetchMilestoneAlertsFromSupabase(targetGroupId).timeout(
          const Duration(seconds: 5),
          onTimeout: () {
            AppLogger.w(
              'Milestone alerts fetch timeout for group: $targetGroupId',
              'DASHBOARD_KPI',
            );
            return 0;
          },
        );
      } catch (e, st) {
        AppLogger.e(
          'KPI alerts fetch failed: $e',
          'DASHBOARD_KPI',
          e,
          st,
        );
      }
    }

    return DashboardKpiData(
      membersCount: membersCount,
      balance: balance,
      upcomingEvents: upcomingEvents,
      growthRate: growthRate,
      birthdaysCount: birthdays,
      absenceAlertsCount: absenceAlerts,
      milestonesAlertsCount: milestoneAlerts,
    );
  }

  /// Birthdays dans les 7 prochains jours — requête légère côté serveur.
  Future<int> _fetchUpcomingBirthdays(String? churchId) async {
    // TODO: Créer une RPC get_upcoming_birthdays(p_church_id, p_days) pour une solution propre
    // Pour l'instant, retourner 0 plutôt que de charger tous les membres
    return 0;
  }

  Future<int> _fetchAbsenceAlertsFromSupabase(String groupId) async {
    final supabase = Supabase.instance.client;
    final recentDates = await supabase
        .from('group_attendance')
        .select('date')
        .eq('group_id', groupId)
        .order('date', ascending: false)
        .limit(10);

    final uniqueDates = recentDates.map((r) => r['date']).toSet().toList();
    if (uniqueDates.length < 3) return 0;
    final targetDates = uniqueDates.take(3).toList();

    final absences = await supabase
        .from('group_attendance')
        .select('member_id, date')
        .eq('group_id', groupId)
        .eq('status', 'absent')
        .filter('date', 'in', targetDates);

    return _countAbsenceAlertsInIsolate(absences);
  }

  Future<int> _fetchMilestoneAlertsFromSupabase(String groupId) async {
    final supabase = Supabase.instance.client;
    final monthAgo =
        DateTime.now().subtract(const Duration(days: 30)).toIso8601String();

    final groupMembers = await supabase
        .from('group_memberships')
        .select('member_id')
        .eq('group_id', groupId)
        .eq('status', 'active');

    final ids = groupMembers.map((m) => m['member_id']).toList();
    if (ids.isEmpty) return 0;

    final response = await supabase
        .from('membre_jalons')
        .select('membre_id')
        .gte('date_realisation', monthAgo)
        .filter('membre_id', 'in', ids);

    return response.length;
  }

  Future<DashboardKpiData> refresh() async {
    ref.invalidateSelf();
    return await future;
  }
}

// ============================================================================
// TOP-LEVEL FUNCTIONS FOR ISOLATES (REQUIRED BY compute)
// ============================================================================

int _countAbsenceAlertsInIsolate(List<dynamic> absences) {
  final memberAbsenceMap = <String, Set<String>>{};
  for (final a in absences) {
    final mId = a['member_id'] as String;
    final d = a['date'] as String;
    memberAbsenceMap.putIfAbsent(mId, () => {}).add(d);
  }

  return memberAbsenceMap.values.where((dates) => dates.length >= 3).length;
}

// ============================================================================
// FINANCE CHART PROVIDER (RPC)
// ============================================================================

/// Provider pour récupérer l'historique financier via RPC (12 mois max)
/// et le tronquer à 3 mois comme validé par l'utilisateur.
@riverpod
Future<List<double>> superadminFinanceChart(SuperadminFinanceChartRef ref) async {
  final supabase = Supabase.instance.client;
  final churchId = ref.watch(activeChurchIdProvider);

  try {
    final response = await supabase.rpc(
      'get_finance_evolution_12m',
      params: churchId != null ? {'p_church_id': churchId} : {},
    );

    final List<dynamic> data = response as List<dynamic>;

    // Convert input json to a list of { date, revenue }
    final parsedList = data.map((item) {
      return {
        'date': DateTime.parse(item['month'] as String),
        'revenue': (item['revenue'] as num).toDouble(),
      };
    }).toList();

    // Sort by date ASC (oldest first)
    parsedList.sort((a, b) => (a['date'] as DateTime).compareTo(b['date'] as DateTime));

    // Keep only the last 3 months
    final recent = parsedList.length > 3 
        ? parsedList.sublist(parsedList.length - 3) 
        : parsedList;

    return recent.map((e) => e['revenue'] as double).toList();

  } catch (e) {
    debugPrint('Erreur RPC get_finance_evolution_12m: $e');
    // Return dummy empty list instead of crashing, standard error handling is applied
    return [];
  }
}
