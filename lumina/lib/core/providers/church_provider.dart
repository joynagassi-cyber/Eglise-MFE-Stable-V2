// ============================================================
// FICHIER : lib/core/providers/church_provider.dart
// DESCRIPTION : Providers pour la gestion des églises (courante, sélection multi-église)
// DÉPENDANCES : riverpod, supabase_flutter, core/models/church.dart, auth_provider.dart
// ============================================================

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lumina/core/models/church.dart';
import 'package:lumina/core/providers/auth_provider.dart';
import 'package:lumina/core/logging/app_logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'church_provider.g.dart';

// ─── Sélecteur multi-église (superadmin) ────────────────────────────────

/// StateProvider pour le church_id sélectionné par le superadmin.
/// Par défaut, utilise le church_id de l'utilisateur courant.
/// En mode superadmin, peut être changé pour voir les données d'une autre église.
final selectedChurchIdProvider = StateProvider<String?>((ref) {
  return ref.watch(activeChurchIdProvider);
});

/// Provider dérivé qui retourne le church_id effectif à utiliser pour les requêtes.
/// - Superadmin : utilise selectedChurchIdProvider (peut changer)
/// - Autres rôles : utilise toujours leur propre church_id
@riverpod
String effectiveChurchId(EffectiveChurchIdRef ref) {
  final session = ref.watch(currentSessionProvider);
  if (session == null) return '';

  if (session.isSuperAdmin) {
    return ref.watch(selectedChurchIdProvider) ?? session.activeChurchId;
  }
  return session.activeChurchId;
}

// ─── Current Church ─────────────────────────────────────────────────────

@riverpod
class CurrentChurch extends _$CurrentChurch {
  @override
  Future<Church?> build() async {
    final churchId = ref.watch(effectiveChurchIdProvider);
    if (churchId.isEmpty) return null;

    return _fetchChurch(churchId);
  }

  Future<Church?> _fetchChurch(String churchId) async {
    try {
      final supabase = Supabase.instance.client;
      final response = await supabase
          .from('churches')
          .select()
          .eq('id', churchId)
          .maybeSingle();

      if (response == null) {
        AppLogger.w('Church not found: $churchId', 'CHURCH_PROVIDER');
        return null;
      }

      return Church.fromJson(response);
    } catch (e, stack) {
      AppLogger.e('Failed to fetch church', 'CHURCH_PROVIDER', e, stack);
      rethrow;
    }
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

// ─── All Churches (Superadmin only) ──────────────────────────────────────

@riverpod
class AllChurches extends _$AllChurches {
  @override
  Future<List<Church>> build() async {
    final session = ref.watch(currentSessionProvider);
    if (session == null || !session.isSuperAdmin) {
      return [];
    }

    return _fetchAllChurches();
  }

  Future<List<Church>> _fetchAllChurches() async {
    try {
      final supabase = Supabase.instance.client;
      final response = await supabase
          .from('churches')
          .select()
          .order('name', ascending: true);

      return (response as List)
          .map((json) => Church.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e, stack) {
      AppLogger.e('Failed to fetch all churches', 'CHURCH_PROVIDER', e, stack);
      rethrow;
    }
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}
