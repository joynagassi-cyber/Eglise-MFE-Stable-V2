// lib/features/communaute/presentation/providers/communaute_stats_provider.dart
// Provider Riverpod pour les stats de la communauté — Clean Architecture
// Remplace l'appel Supabase direct dans communaute_home_screen.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../../core/providers/supabase_provider.dart';
import '../../../../core/providers/auth_provider.dart';

part 'communaute_stats_provider.g.dart';

@riverpod
Future<int> communauteMemberCount(CommunauteMemberCountRef ref) async {
  final supabase = ref.watch(supabaseClientProvider);
  final churchId = ref.watch(activeChurchIdProvider);

  try {
    final response = await supabase
        .from('members')
        .select('id')
        .eq('church_id', churchId)
        .count()
        .timeout(const Duration(seconds: 10));

    return response.count;
  } catch (e, st) {
    AppLogger.e(
      'Erreur chargement nombre de membres',
      'COMMUNAUTE_STATS',
      e,
      st,
    );
    throw Exception('Impossible de charger le nombre de membres: $e');
  }
}