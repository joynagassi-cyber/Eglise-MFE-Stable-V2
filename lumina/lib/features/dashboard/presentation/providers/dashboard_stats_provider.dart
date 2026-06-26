// lib/features/dashboard/presentation/providers/dashboard_stats_provider.dart
// Provider Riverpod pour les stats dashboard — Clean Architecture
// Délègue l'accès Supabase au DashboardStatsRepository.

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:lumina/core/providers/auth_state_leaf.dart';
import 'package:lumina/core/providers/supabase_provider.dart';
import '../../data/repositories/dashboard_stats_repository.dart';

part 'dashboard_stats_provider.g.dart';

class DashboardStats {
  final int totalMembers;
  final int activeMembers;
  final int newThisMonth;
  final int upcomingEvents;
  final double memberGrowth;
  final double activeRate;

  const DashboardStats({
    required this.totalMembers,
    required this.activeMembers,
    required this.newThisMonth,
    required this.upcomingEvents,
    required this.memberGrowth,
    required this.activeRate,
  });
}

@Riverpod(keepAlive: true)
class DashboardStatsNotifier extends _$DashboardStatsNotifier {
  @override
  Future<DashboardStats> build() async {
    final supabase = ref.watch(supabaseClientProvider);
    final churchId = ref.watch(activeChurchIdProvider);
    final repository = DashboardStatsRepository(supabase);

    try {
      final data = await repository.fetchStats(churchId);

      // Calculate growth rate
      final memberGrowth = data.totalMembers > 0
          ? ((data.newThisMonth / data.totalMembers) * 100).toDouble()
          : 0.0;

      // Calculate active rate
      final activeRate = data.totalMembers > 0
          ? ((data.activeMembers / data.totalMembers) * 100).toDouble()
          : 0.0;

      return DashboardStats(
        totalMembers: data.totalMembers,
        activeMembers: data.activeMembers,
        newThisMonth: data.newThisMonth,
        upcomingEvents: data.upcomingEvents,
        memberGrowth: memberGrowth,
        activeRate: activeRate,
      );
    } catch (e) {
      throw Exception('Erreur lors du chargement des statistiques: $e');
    }
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}

// Legacy provider for backward compatibility
final dashboardStatsProvider = FutureProvider<DashboardStats>((ref) async {
  return ref.watch(dashboardStatsNotifierProvider.future);
});