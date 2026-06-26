import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/providers/supabase_provider.dart';
import '../../../../core/logging/app_logger.dart';

import '../../../../core/auth/domain/entities/enums/user_category.dart';

part 'role_detector_provider.g.dart';

@riverpod
class RoleDetector extends _$RoleDetector {
  @override
  UserCategory build() => UserCategory.member;

  /// Détecte la catégorie depuis la DB (source de vérité unique)
  Future<UserCategory> detectFromDB(String roleCode) async {
    try {
      final supabase = ref.read(supabaseProvider);

      final role = await supabase
          .from('roles')
          .select('is_super, scope')
          .eq('code', roleCode)
          .single();

      if (role['is_super'] == true) {
        return UserCategory.superadmin;
      }

      if (role['scope'] == 'group') {
        return UserCategory.groupLeader;
      }

      return UserCategory.member;
    } catch (e, st) {
      AppLogger.e('Erreur détection catégorie', 'ROLE_DETECTOR', e, st);
      return UserCategory.member; // Fallback sécurisé
    }
  }

  /// Détection locale (fallback si DB inaccessible)
  UserCategory detectCategory(String roleCode) {
    // Utiliser les données du roleData si disponibles
    // Sinon fallback vers détection basique

    // Superadmin: contient 'super' ou roles spécifiques
    if (roleCode.contains('super') ||
        roleCode == 'president' ||
        roleCode == 'pasteur' ||
        roleCode == 'tresorier' ||
        roleCode == 'secretaire_general') {
      return UserCategory.superadmin;
    }

    // Group leader: commence par 'chef_' ou 'president_' ou 'responsable_'
    if (roleCode.startsWith('chef_') ||
        roleCode.startsWith('president_') ||
        roleCode.startsWith('presidente_') ||
        roleCode.startsWith('responsable_')) {
      return UserCategory.groupLeader;
    }

    return UserCategory.member;
  }
}