import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../providers/auth_state_leaf.dart';

/// Mixin pour appliquer automatiquement les filtres church_id
///
/// Garantit l'isolation des données multi-églises
mixin ChurchFilterMixin {
  /// Récupère l'ID de l'église active depuis le provider
  String? getActiveChurchId(Ref ref) {
    return ref.read(activeChurchIdStateProvider);
  }

  /// Applique le filtre church_id à une requête Supabase
  ///
  /// - Si churchId == null ou 'pending' → Exception
  /// - Si churchId == '*' → Pas de filtre (superadmin)
  /// Applique un filtre church_id à une requête Supabase
  PostgrestFilterBuilder<T> applyChurchFilter<T>(
    PostgrestFilterBuilder<T> query,
    String? churchId, {
    String columnName = 'church_id',
    bool allowEmpty = false,
  }) {
    if ((churchId == null || churchId == 'pending') && !allowEmpty) {
      throw Exception('SÉCURITÉ: Church ID requis pour isoler les données.');
    }

    // Superadmin: accès à toutes les églises
    if (churchId == '*') return query;
    if (churchId == null) return query; // Si allowEmpty=true

    // Filtre standard
    return query.eq(columnName, churchId);
  }
}
