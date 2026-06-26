import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider "Feuille" (Leaf) pour l'ID de l'église active.
final activeChurchIdStateProvider = StateProvider<String?>((ref) => null);

/// Provider pour l'ID de l'utilisateur actuel.
final currentUserIdStateProvider = StateProvider<String?>((ref) => null);

// --- Aliases pour compatibilité legacy ---
final activeChurchIdProvider = activeChurchIdStateProvider;
final currentUserIdProvider = currentUserIdStateProvider;
// Note: currentSessionProvider est désormais généré dans auth_provider.dart
