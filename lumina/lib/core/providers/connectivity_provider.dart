// lib/core/providers/connectivity_provider.dart
// AMÉLIORATION: Surveillance de la connectivité et rafraîchissement automatique.

import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:lumina/features/dashboard/presentation/providers/superadmin_dashboard_provider.dart';
import 'package:lumina/features/membres/presentation/providers/member_list_provider.dart';
import 'package:lumina/features/dashboard/presentation/providers/dashboard_kpi_provider.dart';

part 'connectivity_provider.g.dart';

enum ConnectivityStatus { online, offline, checking }

@Riverpod(keepAlive: true)
class ConnectivityNotifier extends _$ConnectivityNotifier {
  late StreamSubscription<List<ConnectivityResult>> _subscription;

  @override
  ConnectivityStatus build() {
    _subscription = Connectivity().onConnectivityChanged.listen(_updateStatus);

    // Vérification initiale
    _init();

    return ConnectivityStatus.checking;
  }

  Future<void> _init() async {
    final result = await Connectivity().checkConnectivity();
    _updateStatus(result);
  }

  void _updateStatus(List<ConnectivityResult> results) {
    final isOnline = results.any((r) => r != ConnectivityResult.none);
    final nextStatus =
        isOnline ? ConnectivityStatus.online : ConnectivityStatus.offline;

    // Si on repasse en ligne, on déclenche un rafraîchissement des données critiques
    if (state == ConnectivityStatus.offline &&
        nextStatus == ConnectivityStatus.online) {
      _refreshAppData();
    }

    state = nextStatus;
  }

  void _refreshAppData() {
    // Invalidation des providers de données principaux
    // superadminRawKpisProvider est la source de vérité RPC
    // dashboardKpiProvider en dépend et sera invalide automatiquement
    ref.invalidate(superadminRawKpisProvider);
    ref.invalidate(memberListProvider);
    ref.invalidate(dashboardKpiProvider);
  }

  bool get isOnline => state == ConnectivityStatus.online;
  bool get isOffline => state == ConnectivityStatus.offline;

  void dispose() {
    _subscription.cancel();
  }
}
