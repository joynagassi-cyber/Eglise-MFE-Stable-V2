import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/logging/app_logger.dart';

class GroupDashboardService {
  final SupabaseClient _client;

  GroupDashboardService(this._client);

  /// Charge les données synthétisées pour un groupe spécifique
  Future<Map<String, dynamic>> getDashboardData(String groupId) async {
    try {
      // Execute all 4 queries in parallel
      final results = await Future.wait<dynamic>([
        // 1. RPC for stats
        _client.rpc(
          'get_group_dashboard_stats',
          params: {'p_group_id': groupId},
        ),

        // 2. Fetch Recent Transactions
        _client
            .from('finance_transactions')
            .select()
            .eq('group_id', groupId)
            .order('date', ascending: false)
            .limit(5),

        // 3. Fetch Recent Events
        _client
            .from('events')
            .select()
            .eq('group_id', groupId)
            .gte('date', DateTime.now().toIso8601String())
            .order('date', ascending: true)
            .limit(3),

        // 4. Fetch Group Members
        _client
            .from('group_memberships')
            .select('*, members(first_name, last_name, avatar_url)')
            .eq('group_id', groupId)
            .eq('status', 'active')
            .limit(10),
      ]);

      return {
        'stats': results[0],
        'transactions': results[1],
        'events': results[2],
        'members': results[3],
      };
    } catch (e) {
      AppLogger.e(
        'Erreur chargement dashboard groupe: $e',
        'DASHBOARD_SERVICE',
      );
      rethrow;
    }
  }
}
