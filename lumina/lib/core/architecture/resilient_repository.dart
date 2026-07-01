import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/local/isar_service.dart';
import '../providers/auth_provider.dart';
import '../utils/supabase_extensions.dart';

/// Base pour tous les repositories résilients de Lumina
///
/// Pattern : Security Decorator + Multi-tenant Injection
/// Utilise SupabaseScopedFilter (scoped) pour garantir l'isolation
/// des données par église.
abstract class ResilientRepository {
  final Ref ref;
  final SupabaseClient supabase;
  final IsarService isar;

  ResilientRepository(this.ref)
      : supabase = Supabase.instance.client,
        isar = ref.read(isarServiceProvider);

  /// Récupère l'ID d'église de manière sécurisée
  String get churchId {
    final id = ref.read(activeChurchIdProvider);
    if (id.isEmpty || id == 'global') {
      throw Exception(
        'SÉCURITÉ: Tentative d\'accès aux données sans ID d\'église',
      );
    }
    return id;
  }

  /// Prépare une requête SELECT Supabase sécurisée (auto-filtrée par church_id)
  ///
  /// Utilise l'extension `.scoped(ref)` pour injecter automatiquement
  /// le filtre church_id.
  ///
  /// Usage :
  ///   final data = await secure('members').select('*').order('name');
  PostgrestFilterBuilder<T> secure<T>(String table) {
    final query = supabase.from(table).select() as PostgrestFilterBuilder<T>;
    return query.scoped(ref);
  }
}
