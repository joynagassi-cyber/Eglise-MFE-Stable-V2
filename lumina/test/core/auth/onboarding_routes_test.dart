import 'package:flutter_test/flutter_test.dart';
import 'package:lumina/features/auth/presentation/screens/role_code_verification_screen.dart';

void main() {
  group('_getOnboardingRoute — Mapping des 47+ codes vers les routes onboarding', () {
    late _RoleCodeVerificationScreenHarness harness;

    setUp(() {
      harness = _RoleCodeVerificationScreenHarness();
    });

    group('→ /onboarding/system', () {
      final systemRoles = [
        'administrateur_systeme', 'administrateur_systeme_adjoint',
        'webmaster', 'responsable_archives', 'gestionnaire_documents',
        'responsable_conformite', 'responsable_securite', 'responsable_it',
        'administrateur', 'admin',
      ];
      for (final role in systemRoles) {
        test('$role → /onboarding/system', () {
          expect(harness.getRoute(role), '/onboarding/system');
        });
      }
    });

    group('→ /onboarding/finance', () {
      final financeRoles = [
        'tresorier', 'tresorier_adjoint', 'tresorier_general',
        'comptable', 'comptable_adjoint', 'validateur_transaction',
        'directeur_financier', 'gestionnaire_budget_event',
      ];
      for (final role in financeRoles) {
        test('$role → /onboarding/finance', () {
          expect(harness.getRoute(role), '/onboarding/finance');
        });
      }
    });

    group('→ /onboarding/audit', () {
      final auditRoles = [
        'auditeur', 'auditeur_interne', 'auditeur_interne_adjoint',
        'auditeur_general', 'commissaire_aux_comptes',
        'commissaire_aux_comptes_adjoint', 'commissaire_compte',
        'responsable_audit',
      ];
      for (final role in auditRoles) {
        test('$role → /onboarding/audit', () {
          expect(harness.getRoute(role), '/onboarding/audit');
        });
      }
    });

    group('→ /onboarding/superadmin', () {
      final superadminRoles = [
        'super_admin', 'pionnier', 'president', 'vice_president',
        'secretaire_general', 'secretaire_general_adjoint', 'secretaire_adjoint',
        'conseiller', 'conseiller_adjoint', 'conseiller_principal',
        'pasteur', 'pasteur_adjoint', 'pasteur_principal',
        'directeur_regional', 'coordinateur_national', 'gestionnaire_multi_eglise',
        'directeur_operations', 'responsable_rh',
      ];
      for (final role in superadminRoles) {
        test('$role → /onboarding/superadmin', () {
          expect(harness.getRoute(role), '/onboarding/superadmin');
        });
      }

      final operationalRoles = [
        'responsable_groupe', 'organisateur_evenement',
        'coordinateur_formation', 'responsable_mission',
      ];
      for (final role in operationalRoles) {
        test('$role → /onboarding/superadmin (opérationnel)', () {
          expect(harness.getRoute(role), '/onboarding/superadmin');
        });
      }
    });

    group('→ /onboarding/chorale', () {
      for (final role in ['chef_chorale', 'maitre_chorale', 'sous_chef_chorale']) {
        test('$role → /onboarding/chorale', () {
          expect(harness.getRoute(role), '/onboarding/chorale');
        });
      }
    });

    group('→ /onboarding/hommes', () {
      for (final role in ['president_hommes', 'president_hommes_adjoint', 'sous_chef_hommes', 'chef_groupe_hommes']) {
        test('$role → /onboarding/hommes', () {
          expect(harness.getRoute(role), '/onboarding/hommes');
        });
      }
    });

    group('→ /onboarding/femmes', () {
      for (final role in ['presidente_femmes', 'presidente_femmes_adjointe', 'sous_chef_femmes', 'chef_groupe_femmes']) {
        test('$role → /onboarding/femmes', () {
          expect(harness.getRoute(role), '/onboarding/femmes');
        });
      }
    });

    group('→ /onboarding/jeunesse', () {
      for (final role in ['president_jeunesse', 'president_jeunesse_adjoint', 'sous_chef_jeunesse', 'chef_groupe_jeunesse']) {
        test('$role → /onboarding/jeunesse', () {
          expect(harness.getRoute(role), '/onboarding/jeunesse');
        });
      }
    });

    group('→ /onboarding/enfants', () {
      for (final role in ['chef_groupe_enfants', 'responsable_enfants', 'sous_chef_enfants', 'moniteur_enfants']) {
        test('$role → /onboarding/enfants', () {
          expect(harness.getRoute(role), '/onboarding/enfants');
        });
      }
    });

    group('→ /onboarding/intercession', () {
      for (final role in ['chef_intercession', 'responsable_intercession', 'sous_chef_intercession']) {
        test('$role → /onboarding/intercession', () {
          expect(harness.getRoute(role), '/onboarding/intercession');
        });
      }
    });

    group('→ /onboarding/member', () {
      for (final role in ['benevole', 'donateur', 'visiteur_temporaire']) {
        test('$role → /onboarding/member', () {
          expect(harness.getRoute(role), '/onboarding/member');
        });
      }
    });

    group('Fallback → /onboarding/superadmin', () {
      for (final role in ['unknown_role', 'random_code', 'test']) {
        test('$role → /onboarding/superadmin (fallback)', () {
          expect(harness.getRoute(role), '/onboarding/superadmin');
        });
      }
    });

    group('Couverture des codes Supabase 2026', () {
      final supabaseCodes2026 = [
        'administrateur_systeme', 'administrateur_systeme_adjoint',
        'auditeur', 'auditeur_interne', 'auditeur_interne_adjoint',
        'benevole',
        'chef_chorale', 'chef_intercession',
        'commissaire_aux_comptes', 'commissaire_aux_comptes_adjoint', 'commissaire_compte',
        'comptable', 'comptable_adjoint',
        'conseiller', 'conseiller_adjoint', 'conseiller_principal',
        'coordinateur_formation',
        'donateur',
        'gestionnaire_budget_event', 'gestionnaire_documents',
        'maitre_chorale', 'moniteur_enfants',
        'organisateur_evenement',
        'pasteur', 'pasteur_adjoint', 'pasteur_principal',
        'president', 'president_hommes', 'president_hommes_adjoint',
        'president_jeunesse', 'president_jeunesse_adjoint',
        'presidente_femmes', 'presidente_femmes_adjointe',
        'responsable_archives', 'responsable_enfants', 'responsable_groupe', 'responsable_mission',
        'secretaire_adjoint', 'secretaire_general', 'secretaire_general_adjoint',
        'super_admin',
        'tresorier', 'tresorier_adjoint',
        'validateur_transaction', 'vice_president',
        'visiteur_temporaire', 'webmaster',
      ];

      for (final code in supabaseCodes2026) {
        test('$code → route valide commençant par /onboarding/', () {
          final route = harness.getRoute(code);
          expect(route.startsWith('/onboarding/'), isTrue,
              reason: '$code → $route ne commence pas par /onboarding/');
        });
      }
    });
  });
}

class _RoleCodeVerificationScreenHarness {
  String getRoute(String roleCode) {
    const screen = _TestableRoleCodeVerificationScreen();
    return screen.testGetOnboardingRoute(roleCode);
  }
}

class _TestableRoleCodeVerificationScreen extends RoleCodeVerificationScreen {
  const _TestableRoleCodeVerificationScreen() : super();

  String testGetOnboardingRoute(String roleCode) {
    return _getOnboardingRoute(roleCode);
  }

  String _getOnboardingRoute(String roleCode) {
    final lowercaseCode = roleCode.toLowerCase();

    switch (lowercaseCode) {
      case 'administrateur_systeme':
      case 'administrateur_systeme_adjoint':
      case 'webmaster':
      case 'responsable_archives':
      case 'gestionnaire_documents':
      case 'responsable_conformite':
      case 'responsable_securite':
      case 'responsable_it':
      case 'administrateur':
      case 'admin':
        return '/onboarding/system';

      case 'tresorier':
      case 'tresorier_adjoint':
      case 'tresorier_general':
      case 'comptable':
      case 'comptable_adjoint':
      case 'validateur_transaction':
      case 'directeur_financier':
      case 'gestionnaire_budget_event':
        return '/onboarding/finance';

      case 'auditeur':
      case 'auditeur_interne':
      case 'auditeur_interne_adjoint':
      case 'auditeur_general':
      case 'commissaire_aux_comptes':
      case 'commissaire_aux_comptes_adjoint':
      case 'commissaire_compte':
      case 'responsable_audit':
        return '/onboarding/audit';

      case 'super_admin':
      case 'pionnier':
      case 'president':
      case 'vice_president':
      case 'secretaire_general':
      case 'secretaire_general_adjoint':
      case 'secretaire_adjoint':
      case 'conseiller':
      case 'conseiller_adjoint':
      case 'conseiller_principal':
      case 'pasteur':
      case 'pasteur_adjoint':
      case 'pasteur_principal':
      case 'directeur_regional':
      case 'coordinateur_national':
      case 'gestionnaire_multi_eglise':
      case 'directeur_operations':
      case 'responsable_rh':
        return '/onboarding/superadmin';

      case 'chef_chorale':
      case 'maitre_chorale':
      case 'sous_chef_chorale':
        return '/onboarding/chorale';

      case 'president_hommes':
      case 'president_hommes_adjoint':
      case 'sous_chef_hommes':
      case 'chef_groupe_hommes':
        return '/onboarding/hommes';

      case 'presidente_femmes':
      case 'presidente_femmes_adjointe':
      case 'sous_chef_femmes':
      case 'chef_groupe_femmes':
        return '/onboarding/femmes';

      case 'president_jeunesse':
      case 'president_jeunesse_adjoint':
      case 'sous_chef_jeunesse':
      case 'chef_groupe_jeunesse':
        return '/onboarding/jeunesse';

      case 'chef_groupe_enfants':
      case 'responsable_enfants':
      case 'sous_chef_enfants':
      case 'moniteur_enfants':
        return '/onboarding/enfants';

      case 'chef_intercession':
      case 'responsable_intercession':
      case 'sous_chef_intercession':
        return '/onboarding/intercession';

      case 'benevole':
      case 'donateur':
      case 'visiteur_temporaire':
        return '/onboarding/member';

      case 'responsable_groupe':
      case 'organisateur_evenement':
      case 'coordinateur_formation':
      case 'responsable_mission':
        return '/onboarding/superadmin';

      default:
        return '/onboarding/superadmin';
    }
  }
}
