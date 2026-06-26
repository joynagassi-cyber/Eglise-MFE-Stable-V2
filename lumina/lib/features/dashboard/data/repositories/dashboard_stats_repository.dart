// lib/features/dashboard/data/repositories/dashboard_stats_repository.dart
// Repository Clean Architecture pour les statistiques du dashboard.
// Isole l'accès Supabase de la couche présentation.

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/logging/app_logger.dart';

class DashboardStatsData {
  final int totalMembers;
  final int activeMembers;
  final int newThisMonth;
  final int upcomingEvents;

  const DashboardStatsData({
    required this.totalMembers,
    required this.activeMembers,
    required this.newThisMonth,
    required this.upcomingEvents,
  });
}

class DashboardStatsRepository {
  final SupabaseClient _supabase;

  DashboardStatsRepository(this._supabase);

  Future<DashboardStatsData> fetchStats(String? churchId) async {
    try {
      // Fetch total members
      var totalMembersQuery = _supabase.from('members').select();
      if (churchId != null) {
        totalMembersQuery = totalMembersQuery.eq('church_id', churchId);
      }
      final totalMembersResponse =
          await totalMembersQuery.count(CountOption.exact);
      final totalMembers = totalMembersResponse.count;

      // Fetch active members (last 30 days activity)
      final thirtyDaysAgo =
          DateTime.now().subtract(const Duration(days: 30)).toIso8601String();
      var activeMembersQuery = _supabase
          .from('members')
          .select()
          .gte('last_activity_at', thirtyDaysAgo);
      if (churchId != null) {
        activeMembersQuery = activeMembersQuery.eq('church_id', churchId);
      }
      final activeMembersResponse =
          await activeMembersQuery.count(CountOption.exact);
      final activeMembers = activeMembersResponse.count;

      // Fetch new members this month
      final firstDayOfMonth = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        1,
      ).toIso8601String();
      var newMembersQuery = _supabase
          .from('members')
          .select()
          .gte('created_at', firstDayOfMonth);
      if (churchId != null) {
        newMembersQuery = newMembersQuery.eq('church_id', churchId);
      }
      final newMembersResponse =
          await newMembersQuery.count(CountOption.exact);
      final newThisMonth = newMembersResponse.count;

      // Fetch upcoming events
      final now = DateTime.now().toIso8601String();
      var eventsQuery = _supabase
          .from('events')
          .select()
          .gte('date', now);
      if (churchId != null) {
        eventsQuery = eventsQuery.eq('church_id', churchId);
      }
      final eventsResponse = await eventsQuery.count(CountOption.exact);
      final upcomingEvents = eventsResponse.count;

      return DashboardStatsData(
        totalMembers: totalMembers,
        activeMembers: activeMembers,
        newThisMonth: newThisMonth,
        upcomingEvents: upcomingEvents,
      );
    } catch (e, st) {
      AppLogger.e('Erreur chargement stats dashboard', 'DASHBOARD_STATS_REPO', e, st);
      rethrow;
    }
  }
}