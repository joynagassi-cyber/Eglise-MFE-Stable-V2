// ============================================================
// FICHIER : lib/core/services/dashboard_cache_manager.dart
// DESCRIPTION : Coordinateur central d'invalidation de cache.
//               Mappe chaque action métier aux providers Riverpod
//               à invalider, éliminant les ref.invalidate() dispersés.
// ============================================================

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumina/features/dashboard/presentation/providers/dashboard_kpi_provider.dart';
import 'package:lumina/features/dashboard/presentation/providers/superadmin_dashboard_provider.dart';
import 'package:lumina/features/finance/presentation/providers/finance_providers.dart';
import 'package:lumina/features/finance/presentation/providers/budget_providers.dart';
import 'package:lumina/features/membres/presentation/providers/member_list_provider.dart';
import 'package:lumina/features/annonces/presentation/providers/annonce_providers.dart';
import 'package:lumina/features/events/presentation/providers/event_providers.dart';
import 'package:lumina/core/providers/notifications_provider.dart';
import 'package:logger/logger.dart';

final _log = Logger(printer: PrettyPrinter(methodCount: 0));

/// Tables Supabase supportées par le cache manager.
enum RealtimeTable {
  members,
  financeTransactions,
  annonces,
  events,
  budgets,
  notifications,
  eventAttendances,
  auditLogs,
}

/// Type d'opération Realtime.
enum RealtimeOperation { insert, update, delete }

/// Événement Realtime normalisé, diffusé via le bus d'événements.
class RealtimeEvent {
  final RealtimeTable table;
  final RealtimeOperation operation;
  final Map<String, dynamic>? newRecord;
  final Map<String, dynamic>? oldRecord;
  final DateTime receivedAt;

  RealtimeEvent({
    required this.table,
    required this.operation,
    this.newRecord,
    this.oldRecord,
  }) : receivedAt = DateTime.now();

  @override
  String toString() => 'RealtimeEvent($table, $operation, at=$receivedAt)';
}

/// Stream controller global pour le bus d'événements Realtime.
final _realtimeEventController = StreamController<RealtimeEvent>.broadcast();

/// Provider exposant le stream d'événements Realtime.
///
/// Permet aux features d'écouter les événements sans couplage direct
/// avec le RealtimeService :
/// ```dart
/// ref.listen(realtimeEventBusProvider, (_, event) {
///   if (event.table == RealtimeTable.annonces) { ... }
/// });
/// ```
final realtimeEventBusProvider = StreamProvider<RealtimeEvent>((ref) {
  return _realtimeEventController.stream;
});

/// Coordinateur central d'invalidation de cache.
///
/// Au lieu de disperser des `ref.invalidate()` dans chaque widget/provider,
/// ce manager centralise la logique d'invalidation par action métier.
///
/// Usage depuis le RealtimeService :
/// ```dart
/// DashboardCacheManager.onRealtimeEvent(ref, event);
/// ```
///
/// Usage depuis une action utilisateur locale :
/// ```dart
/// DashboardCacheManager.onMemberAdded(ref);
/// ```
class DashboardCacheManager {
  const DashboardCacheManager._();

  /// Émet un événement sur le bus global.
  static void emit(RealtimeEvent event) {
    _realtimeEventController.add(event);
  }

  // ===========================================================================
  // DISPATCH DEPUIS REALTIME
  // ===========================================================================

  /// Point d'entrée principal pour les événements Realtime.
  /// Invalide les providers concernés ET émet sur le bus.
  static void onRealtimeEvent(dynamic ref, RealtimeEvent event) {
    _log.d('Cache invalidation: ${event.table} ${event.operation}');

    switch (event.table) {
      case RealtimeTable.members:
        _invalidateMemberProviders(ref);
        break;
      case RealtimeTable.financeTransactions:
        _invalidateFinanceProviders(ref);
        break;
      case RealtimeTable.annonces:
        _invalidateAnnouncementProviders(ref);
        break;
      case RealtimeTable.events:
        _invalidateEventProviders(ref);
        break;
      case RealtimeTable.budgets:
        _invalidateBudgetProviders(ref);
        break;
      case RealtimeTable.notifications:
        _invalidateNotificationProviders(ref);
        break;
      case RealtimeTable.eventAttendances:
        _invalidateAttendanceProviders(ref);
        break;
      case RealtimeTable.auditLogs:
        _invalidateAuditProviders(ref);
        break;
    }

    // Émettre sur le bus pour les listeners externes
    emit(event);
  }

  // ===========================================================================
  // ACTIONS MÉTIER NOMMÉES (pour usage direct depuis les notifiers)
  // ===========================================================================

  /// Un nouveau membre a été ajouté.
  static void onMemberAdded(dynamic ref) => _invalidateMemberProviders(ref);

  /// Un membre a été modifié.
  static void onMemberUpdated(dynamic ref) => _invalidateMemberProviders(ref);

  /// Une transaction a été créée ou approuvée.
  static void onTransactionChanged(dynamic ref) =>
      _invalidateFinanceProviders(ref);

  /// Une annonce a été publiée ou modifiée.
  static void onAnnouncementPublished(dynamic ref) =>
      _invalidateAnnouncementProviders(ref);

  /// Un événement a été créé ou modifié.
  static void onEventChanged(dynamic ref) => _invalidateEventProviders(ref);

  /// Un budget a été mis à jour (montant utilisé, approbation).
  static void onBudgetUpdated(dynamic ref) => _invalidateBudgetProviders(ref);

  /// La présence à un événement a été enregistrée.
  static void onAttendanceRecorded(dynamic ref) =>
      _invalidateAttendanceProviders(ref);

  // ===========================================================================
  // INVALIDATION GROUPÉES (privées)
  // ===========================================================================

  static void _invalidateMemberProviders(dynamic ref) {
    _safeInvalidate(ref, memberListProvider);
    _safeInvalidate(ref, dashboardKpiProvider);
    _safeInvalidate(ref, totalMembersKpiProvider);
  }

  static void _invalidateFinanceProviders(dynamic ref) {
    _safeInvalidate(ref, transactionsProvider);
    _safeInvalidate(ref, totalBalanceProvider);
    _safeInvalidate(ref, dashboardKpiProvider);
    _safeInvalidate(ref, globalFinanceKpiProvider);
    _safeInvalidate(ref, superadminRawKpisProvider);
    _safeInvalidate(ref, overBudgetsProvider);
  }

  static void _invalidateAnnouncementProviders(dynamic ref) {
    _safeInvalidate(ref, annoncesProvider);
    _safeInvalidate(ref, realNavigationBadgesProvider);
  }

  static void _invalidateEventProviders(dynamic ref) {
    _safeInvalidate(ref, allEventsProvider);
    _safeInvalidate(ref, dashboardKpiProvider);
    _safeInvalidate(ref, activeEventsKpiProvider);
  }

  static void _invalidateBudgetProviders(dynamic ref) {
    _safeInvalidate(ref, overBudgetsProvider);
    _safeInvalidate(ref, nearLimitBudgetsProvider);
    _safeInvalidate(ref, globalFinanceKpiProvider);
    _safeInvalidate(ref, superadminRawKpisProvider);
  }

  static void _invalidateNotificationProviders(dynamic ref) {
    _safeInvalidate(ref, realNavigationBadgesProvider);
  }

  static void _invalidateAttendanceProviders(dynamic ref) {
    _safeInvalidate(ref, dashboardKpiProvider);
  }

  static void _invalidateAuditProviders(dynamic ref) {
    _safeInvalidate(ref, recentActivitiesProvider);
  }

  /// Wrapper sûr pour l'invalidation, empêche les erreurs si
  /// le provider n'est pas encore initialisé ou le ref est disposed.
  static void _safeInvalidate(dynamic ref, ProviderOrFamily provider) {
    try {
      if (ref is Ref) {
        ref.invalidate(provider);
      } else if (ref is WidgetRef) {
        ref.invalidate(provider);
      }
    } catch (e) {
      _log.w('Failed to invalidate $provider: $e');
    }
  }
}
