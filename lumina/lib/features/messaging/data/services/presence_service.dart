// lib/features/messaging/data/services/presence_service.dart
// Real-time Presence Service using Supabase Realtime

import 'dart:async';
import 'package:lumina/core/logging/app_logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logger/logger.dart';
import 'package:lumina/core/utils/app_date_time.dart';

/// Tracks online/offline status of users using Supabase Realtime Presence.
class PresenceService {
  final SupabaseClient _supabase;
  final Logger _logger = Logger();

  RealtimeChannel? _presenceChannel;
  Timer? _heartbeatTimer;

  final _onlineUsersController = StreamController<Set<String>>.broadcast();

  /// Stream of currently online user IDs.
  Stream<Set<String>> get onlineUsers => _onlineUsersController.stream;

  /// Current set of online user IDs.
  Set<String> _currentOnlineUsers = {};
  Set<String> get currentOnlineUsers => _currentOnlineUsers;

  PresenceService(this._supabase);

  /// Start tracking presence for the current user.
  Future<void> connect() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    _presenceChannel = _supabase.channel('presence:messaging');

    _presenceChannel!.onPresenceSync((payload) {
      final presences = _presenceChannel!.presenceState();
      final onlineIds = <String>{};

      for (final state in presences) {
        for (final presence in state.presences) {
          final id = presence.payload['user_id'] as String?;
          if (id != null) onlineIds.add(id);
        }
      }

      _currentOnlineUsers = onlineIds;
      _onlineUsersController.add(onlineIds);
      _logger.d('Presence: ${onlineIds.length} users online');
    }).onPresenceJoin((payload) {
      final newPresences = payload.newPresences;
      for (final p in newPresences) {
        final id = p.payload['user_id'] as String?;
        if (id != null) {
          _currentOnlineUsers.add(id);
        }
      }
      _onlineUsersController.add(Set.from(_currentOnlineUsers));
    }).onPresenceLeave((payload) {
      final leftPresences = payload.leftPresences;
      for (final p in leftPresences) {
        final id = p.payload['user_id'] as String?;
        if (id != null) {
          _currentOnlineUsers.remove(id);
        }
      }
      _onlineUsersController.add(Set.from(_currentOnlineUsers));
    }).subscribe((status, [error]) async {
      if (status == RealtimeSubscribeStatus.subscribed) {
        await _presenceChannel!.track({
          'user_id': userId,
          'online_at': AppDateTime.nowIso(),
        });
        _logger.i('Presence: Connected and tracking');
      }
    });

    // Heartbeat: update presence in DB every 60s for offline detection
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 60), (_) async {
      try {
        await _supabase
            .rpc('update_user_presence', params: {'p_status': 'online'});
      } catch (e, stack) {
        AppLogger.e(
            'Error cleaning up voice notes', 'VOICE_NOTE_SERVICE', e, stack);
        _logger.w('Presence heartbeat failed', error: e);
      }
    });

    // Initial heartbeat
    try {
      await _supabase
          .rpc('update_user_presence', params: {'p_status': 'online'});
    } catch (e, stack) {
      AppLogger.e(
          'Error starting presence heartbeats', 'PRESENCE_SERVICE', e, stack);
    }
  }

  /// Check if a specific user is online.
  bool isUserOnline(String userId) => _currentOnlineUsers.contains(userId);

  /// Disconnect and mark as offline.
  Future<void> disconnect() async {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;

    try {
      await _supabase
          .rpc('update_user_presence', params: {'p_status': 'offline'});
    } catch (e, stack) {
      AppLogger.e(
          'Error stopping presence heartbeats', 'PRESENCE_SERVICE', e, stack);
    }

    await _presenceChannel?.unsubscribe();
    _presenceChannel = null;
    _currentOnlineUsers.clear();
    _onlineUsersController.add({});
  }

  /// Clean up resources.
  void dispose() {
    _heartbeatTimer?.cancel();
    _onlineUsersController.close();
    _presenceChannel?.unsubscribe();
  }
}