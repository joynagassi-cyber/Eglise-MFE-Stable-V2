// lib/core/router/router_refresh_listenable.dart
//
// Bridge simple pour convertir un Provider Riverpod en Listenable pour GoRouter.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'route_status_provider.dart';

class RouterRefreshListenable extends ChangeNotifier {
  final Ref ref;

  RouterRefreshListenable(this.ref) {
    // On écoute le provider de status. À chaque changement, on notifie GoRouter.
    ref.listen(routeStatusProvider, (_, __) {
      notifyListeners();
    });
  }
}