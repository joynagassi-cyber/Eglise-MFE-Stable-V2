import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:lumina/core/providers/supabase_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import './navigation_badges_provider.dart';

part 'notifications_provider.g.dart';

/// Provider pour surveiller les changements de notifications
@riverpod
void notificationsMonitor(NotificationsMonitorRef ref) {
  // Démarrer le monitoring des notifications
  ref.onDispose(() {
    // Nettoyer les listeners
  });
}

/// Service pour récupérer les compteurs de notifications réels
class RealNotificationsService {
  final SupabaseClient supabase;

  RealNotificationsService(this.supabase);

  /// Récupérer tous les compteurs de notifications
  Future<Map<NavigationBadgeType, int>> fetchAllNotificationCounts() async {
    final counts = <NavigationBadgeType, int>{};

    try {
      for (final type in NavigationBadgeType.values) {
        counts[type] = await _fetchNotificationCount(type);
      }
    } catch (e) {
      // Retourner des compteurs vides en cas d'erreur
    }

    return counts;
  }

  /// Récupérer le compteur pour un type spécifique
  Future<int> _fetchNotificationCount(NavigationBadgeType type) async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return 0;

      switch (type) {
        case NavigationBadgeType.membres:
          return await _getNewMembersCount();
        case NavigationBadgeType.sacrements:
          return await _getNewSacramentsCount();
        case NavigationBadgeType.events:
          return await _getNewEventsCount();
        case NavigationBadgeType.annonces:
          return await _getNewAnnoncesCount();
        case NavigationBadgeType.messages:
          return await _getNewMessagesCount();
        case NavigationBadgeType.finance:
          return await _getNewFinanceCount();
      }
    } catch (e) {
      return 0;
    }
  }

  /// Récupérer le nombre de nouveaux membres (derniers 24h)
  Future<int> _getNewMembersCount() async {
    try {
      final churchId =
          supabase.auth.currentUser?.userMetadata?['active_church_id'];
      if (churchId == null) return 0;

      final yesterday =
          DateTime.now().subtract(const Duration(days: 1)).toIso8601String();

      final response = await supabase
          .from('members')
          .select('*')
          .eq('church_id', churchId)
          .gt('created_at', yesterday);

      // Note: count is often returned as a separate property in the response object
      // if using .select('*', FetchOptions(count: CountOption.exact))
      // but if not working, we can use the length of the list for now if head is not true
      return (response as List).length;
    } catch (e) {
      return 0;
    }
  }

  /// Récupérer le nombre de nouveaux sacrements
  Future<int> _getNewSacramentsCount() async {
    try {
      final churchId =
          supabase.auth.currentUser?.userMetadata?['active_church_id'];
      if (churchId == null) return 0;

      final yesterday =
          DateTime.now().subtract(const Duration(days: 1)).toIso8601String();

      final response = await supabase
          .from('sacraments')
          .select('*')
          .eq('church_id', churchId)
          .gt('created_at', yesterday);

      return (response as List).length;
    } catch (e) {
      return 0;
    }
  }

  /// Récupérer le nombre de nouveaux événements
  Future<int> _getNewEventsCount() async {
    try {
      final churchId =
          supabase.auth.currentUser?.userMetadata?['active_church_id'];
      if (churchId == null) return 0;

      final now = DateTime.now().toIso8601String();

      final response = await supabase
          .from('events')
          .select('id')
          .eq('church_id', churchId)
          .gt('start_date', now);

      return (response as List).length;
    } catch (e) {
      return 0;
    }
  }

  /// Récupérer le nombre de nouvelles annonces
  Future<int> _getNewAnnoncesCount() async {
    try {
      final churchId =
          supabase.auth.currentUser?.userMetadata?['active_church_id'];
      if (churchId == null) return 0;

      final yesterday =
          DateTime.now().subtract(const Duration(days: 1)).toIso8601String();

      final response = await supabase
          .from('annonces')
          .select('*')
          .eq('church_id', churchId)
          .eq('is_active', true)
          .gt('created_at', yesterday);

      return (response as List).length;
    } catch (e) {
      return 0;
    }
  }

  /// Récupérer le nombre de nouveaux messages unread
  Future<int> _getNewMessagesCount() async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return 0;

      // Compter les messages où l'utilisateur n'est pas dans 'read_by'
      // Note: La structure de read_by est attendue comme un tableau d'IDs ou d'objets
      // Pour faire simple et performant sans SQL complexe RPC, on prend les messages récents non envoyés par l'utilisateur
      final yesterday =
          DateTime.now().subtract(const Duration(days: 1)).toIso8601String();

      final response = await supabase
          .from('chat_messages')
          .select('*')
          .neq('sender_id', userId)
          .gt('created_at', yesterday);

      return (response as List).length;
    } catch (e) {
      return 0;
    }
  }

  /// Récupérer le nombre de nouvelles transactions financières
  Future<int> _getNewFinanceCount() async {
    try {
      final churchId =
          supabase.auth.currentUser?.userMetadata?['active_church_id'];
      if (churchId == null) return 0;

      // Transactions en attente d'approbation
      final response = await supabase
          .from('finance_transactions')
          .select('*')
          .eq('church_id', churchId)
          .eq('status', 'pending');

      return (response as List).length;
    } catch (e) {
      return 0;
    }
  }
}

/// Provider pour le service de notifications réelles
@riverpod
RealNotificationsService realNotificationsService(
    RealNotificationsServiceRef ref) {
  final supabase = ref.watch(supabaseProvider);
  return RealNotificationsService(supabase);
}

/// Provider qui met à jour les badges avec les données réelles

/// Provider qui expose les badges avec les données réelles
@riverpod
Future<Map<NavigationBadgeType, int>> realNavigationBadges(
    RealNavigationBadgesRef ref) async {
  final service = ref.watch(realNotificationsServiceProvider);
  final counts = await service.fetchAllNotificationCounts();
  return counts;
}
