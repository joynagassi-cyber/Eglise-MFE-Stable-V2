// ============================================================
// FICHIER : lib/features/events/presentation/providers/event_registration_notifier.dart
// DESCRIPTION : Notifier pour l'inscription aux événements avec
//               optimistic update et rollback automatique.
//               Exemple concret du pattern OptimisticUpdateMixin.
// ============================================================

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lumina/core/providers/auth_provider.dart';
import 'package:lumina/core/services/dashboard_cache_manager.dart';
import 'package:lumina/core/logging/app_logger.dart';

part 'event_registration_notifier.g.dart';

/// État d'inscription d'un utilisateur à un événement.
class EventRegistrationState {
  final bool isRegistered;
  final int totalAttendees;
  final DateTime? registeredAt;

  const EventRegistrationState({
    this.isRegistered = false,
    this.totalAttendees = 0,
    this.registeredAt,
  });

  EventRegistrationState copyWith({
    bool? isRegistered,
    int? totalAttendees,
    DateTime? registeredAt,
  }) =>
      EventRegistrationState(
        isRegistered: isRegistered ?? this.isRegistered,
        totalAttendees: totalAttendees ?? this.totalAttendees,
        registeredAt: registeredAt ?? this.registeredAt,
      );
}

/// Gère l'inscription d'un utilisateur à un événement spécifique.
///
/// Implémente le pattern optimistic update :
/// 1. L'UI affiche "Inscrit ✓" immédiatement
/// 2. L'insertion en DB est lancée en arrière-plan
/// 3. En cas d'erreur → rollback + notification d'erreur
@riverpod
class EventRegistration extends _$EventRegistration {
  SupabaseClient get _client => Supabase.instance.client;

  @override
  Future<EventRegistrationState> build(String eventId) async {
    final userId = ref.watch(currentUserIdProvider);
    if (userId == null) {
      return const EventRegistrationState();
    }

    try {
      // Vérifier si l'utilisateur est déjà inscrit
      final existing = await _client
          .from('event_attendances')
          .select('id, created_at')
          .eq('event_id', eventId)
          .eq('member_id', userId)
          .maybeSingle();

      // Compter le total des inscrits
      final countResponse = await _client
          .from('event_attendances')
          .select('id')
          .eq('event_id', eventId);

      return EventRegistrationState(
        isRegistered: existing != null,
        totalAttendees: (countResponse as List).length,
        registeredAt: existing != null
            ? DateTime.tryParse(existing['created_at'] ?? '')
            : null,
      );
    } catch (e) {
      AppLogger.w('Failed to check registration: $e', 'EVENT_REG');
      return const EventRegistrationState();
    }
  }

  /// Inscrit l'utilisateur à l'événement avec optimistic update.
  ///
  /// L'UI affiche instantanément "Inscrit" même avant la confirmation DB.
  /// En cas d'échec, l'état est restauré automatiquement.
  Future<bool> register({
    void Function(Object error)? onError,
  }) async {
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) return false;

    final currentState = state.valueOrNull ?? const EventRegistrationState();

    // Appliquer l'état optimiste immédiatement
    state = AsyncData(currentState.copyWith(
      isRegistered: true,
      totalAttendees: currentState.totalAttendees + 1,
      registeredAt: DateTime.now(),
    ));

    try {
      await _client.from('event_attendances').insert({
        'event_id': eventId,
        'member_id': userId,
        'status': 'registered',
      });

      AppLogger.i('Registered to event $eventId', 'EVENT_REG');

      // Invalider les caches liés
      DashboardCacheManager.onAttendanceRecorded(ref);

      return true;
    } catch (error) {
      // Rollback à l'état précédent
      state = AsyncData(currentState);

      AppLogger.w(
          'Registration rollback for event $eventId: $error', 'EVENT_REG');
      onError?.call(error);

      return false;
    }
  }

  /// Désinscrit l'utilisateur avec optimistic update.
  Future<bool> unregister({
    void Function(Object error)? onError,
  }) async {
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) return false;

    final currentState = state.valueOrNull ?? const EventRegistrationState();

    // Optimistic : retirer immédiatement
    state = AsyncData(currentState.copyWith(
      isRegistered: false,
      totalAttendees: (currentState.totalAttendees - 1).clamp(0, 999999),
      registeredAt: null,
    ));

    try {
      await _client
          .from('event_attendances')
          .delete()
          .eq('event_id', eventId)
          .eq('member_id', userId);

      AppLogger.i('Unregistered from event $eventId', 'EVENT_REG');

      DashboardCacheManager.onAttendanceRecorded(ref);

      return true;
    } catch (error) {
      // Rollback
      state = AsyncData(currentState);

      AppLogger.w(
          'Unregistration rollback for event $eventId: $error', 'EVENT_REG');
      onError?.call(error);

      return false;
    }
  }

  /// Bascule l'inscription (toggle).
  Future<bool> toggle({
    void Function(Object error)? onError,
  }) async {
    final isCurrentlyRegistered = state.valueOrNull?.isRegistered ?? false;

    if (isCurrentlyRegistered) {
      return await unregister(onError: onError);
    } else {
      return await register(onError: onError);
    }
  }
}