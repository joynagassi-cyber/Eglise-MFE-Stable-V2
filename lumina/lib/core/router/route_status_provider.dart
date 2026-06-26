// lib/core/router/route_status_provider.dart
//
// Provider natif Riverpod qui calcule l'état de routage.

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:lumina/core/providers/auth_provider.dart';
import 'package:lumina/features/profile/presentation/providers/profile_provider.dart';
import 'router_policy.dart';

part 'route_status_provider.g.dart';

@riverpod
RouteStatus routeStatus(RouteStatusRef ref) {
  final auth = ref.watch(authProvider);
  final profileAsync = ref.watch(profileStateProvider);

  return RouterPolicy.resolveStatus(auth, profileAsync);
}