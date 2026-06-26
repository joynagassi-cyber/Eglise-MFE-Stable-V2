import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/local/isar_service.dart';
import '../providers/auth_state_leaf.dart';

/// Base pour tous les repositories résilients de Lumina
/// 
/// Pattern : Security Decorator + Multi-tenant Injection
abstract class ResilientRepository {
  final Ref ref;
  final SupabaseClient supabase;
  final IsarService isar;

  ResilientRepository(this.ref)
      : supabase = Supabase.instance.client,
        isar = ref.read(isarServiceProvider);

  /// Récupère l'ID d'église de manière sécurisée
  String get churchId {
    final id = ref.read(activeChurchIdStateProvider);
    if (id == null) {
      throw Exception('SÉCURITÉ: Tentative d\'accès aux données sans ID d\'église');
    }
    return id;
  }

  /// Prépare une requête Supabase sécurisée (auto-filtrée)
  PostgrestFilterBuilder<T> secure<T>(String table) {
    final id = churchId;
    final query = supabase.from(table).select();
    
    // Bypass filtre pour superadmin
    if (id == '*') return query as PostgrestFilterBuilder<T>;
    
    return query.eq('church_id', id) as PostgrestFilterBuilder<T>;
  }
}
