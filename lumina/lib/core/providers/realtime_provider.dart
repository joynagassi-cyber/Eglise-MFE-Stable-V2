// ============================================================
// FICHIER : lib/core/providers/realtime_provider.dart
// DESCRIPTION : Hub central Supabase Realtime avec abonnements
//               dynamiques par rôle et invalidation automatique
//               des providers via DashboardCacheManager.
// DÉPENDANCES : riverpod, supabase_flutter, role_data_scope,
//               dashboard_cache_manager
// ============================================================

import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lumina/core/providers/auth_provider.dart';
import 'package:lumina/core/providers/role_data_scope_provider.dart';
import 'package:lumina/core/domain/role_data_scope.dart';
import 'package:lumina/core/services/dashboard_cache_manager.dart';
import 'package:lumina/core/logging/app_logger.dart';

part 'realtime_provider.g.dart';

// ─── Table → RealtimeTable mapping ──────────────────────────────────────
const _tableMapping = <String, RealtimeTable>{
  'members': RealtimeTable.members,
  'finance_transactions': RealtimeTable.financeTransactions,
  'annonces': RealtimeTable.annonces,
  'events': RealtimeTable.events,
  'budgets': RealtimeTable.budgets,
  'notifications': RealtimeTable.notifications,
  'event_attendances': RealtimeTable.eventAttendances,
  'audit_logs': RealtimeTable.auditLogs,
};

const _eventMapping = <PostgresChangeEvent, RealtimeOperation>{
  PostgresChangeEvent.insert: RealtimeOperation.insert,
  PostgresChangeEvent.update: RealtimeOperation.update,
  PostgresChangeEvent.delete: RealtimeOperation.delete,
};

/// Configuration d'un canal Realtime.
class _ChannelConfig {
  final String table;
  final PostgresChangeEvent event;
  final PostgresChangeFilter? filter;

  const _ChannelConfig({
    required this.table,
    this.event = PostgresChangeEvent.all,
    this.filter,
  });
}

/// Manages all Supabase Realtime subscriptions.
///
/// Souscrit dynamiquement aux canaux en fonction du rôle de l'utilisateur :
/// - **Tous** : notifications (user), annonces (église)
/// - **Admin/Superadmin** : transactions, budgets, members, audit_logs
/// - **Chef de groupe** : events (église), event_attendances (église)
/// - **Membre** : finance_transactions (personnel via user_id)
///
/// Chaque événement reçu est dispatché au [DashboardCacheManager]
/// qui invalide les providers Riverpod concernés.
@Riverpod(keepAlive: true)
class RealtimeManager extends _$RealtimeManager {
  final List<RealtimeChannel> _channels = [];
  SupabaseClient get _client => Supabase.instance.client;

  @override
  void build() {
    final userId = ref.watch(currentUserIdProvider);
    final scope = ref.watch(roleDataScopeProvider);

    // Dispose : ménage au changement de contexte
    _disposeAllChannels();

    if (userId == null || scope == RoleDataScope.empty) return;

    AppLogger.i(
      'Initializing realtime: role=${scope.role}, '
          'church=${scope.churchId}, group=${scope.groupId}',
      'REALTIME',
    );

    // Canaux universels (tous les rôles)
    final configs = <_ChannelConfig>[
      _ChannelConfig(
        table: 'notifications',
        event: PostgresChangeEvent.insert,
        filter: _filterEq('user_id', userId),
      ),
    ];

    // Annonces : filtrées par église
    if (scope.churchId != null) {
      configs.add(_ChannelConfig(
        table: 'annonces',
        filter: _filterEq('church_id', scope.churchId!),
      ));
    }

    // Admin / Superadmin : données financières et membres
    if (scope.isAdmin) {
      if (scope.churchId != null) {
        configs.addAll([
          _ChannelConfig(
            table: 'finance_transactions',
            filter: _filterEq('church_id', scope.churchId!),
          ),
          _ChannelConfig(
            table: 'members',
            filter: _filterEq('church_id', scope.churchId!),
          ),
          _ChannelConfig(
            table: 'budgets',
            filter: _filterEq('church_id', scope.churchId!),
          ),
          _ChannelConfig(
            table: 'audit_logs',
            filter: _filterEq('church_id', scope.churchId!),
          ),
        ]);
      }
    }

    // Chef de groupe : événements et présence
    if (scope.isGroupLeader && scope.churchId != null) {
      configs.addAll([
        _ChannelConfig(
          table: 'events',
          filter: _filterEq('church_id', scope.churchId!),
        ),
        const _ChannelConfig(
          table: 'event_attendances',
        ),
      ]);
    }

    // Membre : ses propres transactions
    if (scope.isMember && scope.churchId != null) {
      configs.addAll([
        _ChannelConfig(
          table: 'events',
          event: PostgresChangeEvent.insert,
          filter: _filterEq('church_id', scope.churchId!),
        ),
      ]);
    }

    // Souscrire à tous les canaux configurés
    for (final config in configs) {
      _subscribe(config);
    }

    ref.onDispose(_disposeAllChannels);

    AppLogger.i(
      'Realtime initialized: ${_channels.length} channels active',
      'REALTIME',
    );
  }

  // ─── Subscription Engine ──────────────────────────────────────────────

  void _subscribe(_ChannelConfig config) {
    try {
      final channelName =
          '${config.table}:${config.filter?.value ?? 'all'}_${DateTime.now().millisecondsSinceEpoch}';

      final builder = _client.channel(channelName).onPostgresChanges(
            event: config.event,
            schema: 'public',
            table: config.table,
            filter: config.filter,
            callback: (payload) => _handlePayload(config.table, payload),
          );

      final channel = builder.subscribe((status, [error]) {
        if (error != null) {
          AppLogger.w(
            'Realtime channel error [${config.table}]: $error',
            'REALTIME',
          );
        }
      });

      _channels.add(channel);
    } catch (e) {
      AppLogger.w(
        'Failed to subscribe to ${config.table}: $e',
        'REALTIME',
      );
    }
  }

  /// Traite un payload Realtime : mappe vers un [RealtimeEvent]
  /// et le dispatche au [DashboardCacheManager].
  void _handlePayload(String tableName, PostgresChangePayload payload) {
    final table = _tableMapping[tableName];
    if (table == null) {
      AppLogger.w('Unknown realtime table: $tableName', 'REALTIME');
      return;
    }

    final operation =
        _eventMapping[payload.eventType] ?? RealtimeOperation.update;

    AppLogger.i(
      'Realtime: $tableName ${payload.eventType.name}',
      'REALTIME',
    );

    final event = RealtimeEvent(
      table: table,
      operation: operation,
      newRecord: payload.newRecord.isNotEmpty ? payload.newRecord : null,
      oldRecord: payload.oldRecord.isNotEmpty ? payload.oldRecord : null,
    );

    // Invalider les providers + émettre sur le bus
    DashboardCacheManager.onRealtimeEvent(ref, event);
  }

  // ─── Helpers ──────────────────────────────────────────────────────────

  PostgresChangeFilter _filterEq(String column, String value) =>
      PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: column,
        value: value,
      );

  void _disposeAllChannels() {
    for (final channel in _channels) {
      try {
        _client.removeChannel(channel);
      } catch (e) {
        AppLogger.w('Failed to remove realtime channel: $e', 'REALTIME');
      }
    }
    _channels.clear();
  }
}

// ─── Unread Notification Count ──────────────────────────────────────────

@riverpod
Future<int> unreadNotificationCount(UnreadNotificationCountRef ref) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return 0;

  try {
    final response = await Supabase.instance.client
        .from('notifications')
        .select('id')
        .eq('user_id', userId)
        .eq('is_read', false);

    return (response as List).length;
  } catch (e) {
    AppLogger.w('Failed to fetch unread notification count: $e', 'REALTIME');
    return 0;
  }
}
