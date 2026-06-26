// lib/features/auth/presentation/providers/role_codes_admin_provider.dart
// Provider Riverpod pour la gestion des codes admin — Clean Architecture
// Accès aux données via SupabaseClient injecté, jamais directement dans l'UI.

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../../core/providers/supabase_provider.dart';

part 'role_codes_admin_provider.g.dart';

/// Modèle immutable pour un code de rôle.
class RoleCodeEntry {
  final String roleCode;
  final String rawCode;
  final bool isUsed;
  final String? usedAt;

  const RoleCodeEntry({
    required this.roleCode,
    required this.rawCode,
    required this.isUsed,
    this.usedAt,
  });

  factory RoleCodeEntry.fromMap(Map<String, dynamic> map) {
    return RoleCodeEntry(
      roleCode: map['role_code'] as String? ?? 'Inconnu',
      rawCode: map['raw_code'] as String? ?? 'N/A',
      isUsed: map['is_used'] as bool? ?? false,
      usedAt: map['used_at'] as String?,
    );
  }
}

@riverpod
class RoleCodesAdminNotifier extends _$RoleCodesAdminNotifier {
  @override
  Future<List<RoleCodeEntry>> build() async {
    final supabase = ref.watch(supabaseClientProvider);
    return _fetchCodes(supabase);
  }

  Future<List<RoleCodeEntry>> _fetchCodes(SupabaseClient supabase) async {
    try {
      final data = await supabase
          .from('role_secret_codes')
          .select('role_code, raw_code, is_used, used_at')
          .order('role_code')
          .timeout(const Duration(seconds: 10));

      return List<Map<String, dynamic>>.from(data)
          .map((e) => RoleCodeEntry.fromMap(e))
          .toList();
    } catch (e, st) {
      AppLogger.e('Erreur chargement codes admin', 'ROLE_CODES_ADMIN', e, st);
      throw Exception('Impossible de charger les codes: $e');
    }
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}