import 'package:flutter_test/flutter_test.dart';

import 'package:lumina/core/auth/role_resolver.dart';
import 'package:lumina/core/auth/domain/entities/user_role.dart';
import 'package:lumina/core/router/app_routes.dart';

void main() {
  group('RoleResolver', () {
    group('isGroupRole', () {
      for (final role in ['chorale', 'chef_chorale', 'maitre_chorale']) {
        test('$role → true (groupe)', () {
          expect(RoleResolver.isGroupRole(role), isTrue);
        });
      }
      for (final role in ['hommes', 'president_hommes']) {
        test('$role → true (groupe)', () {
          expect(RoleResolver.isGroupRole(role), isTrue);
        });
      }
      for (final role in ['femmes', 'presidente_femmes']) {
        test('$role → true (groupe)', () {
          expect(RoleResolver.isGroupRole(role), isTrue);
        });
      }
      for (final role in ['jeunesse', 'president_jeunesse']) {
        test('$role → true (groupe)', () {
          expect(RoleResolver.isGroupRole(role), isTrue);
        });
      }
      for (final role in ['enfants', 'responsable_enfants', 'moniteur_enfants']) {
        test('$role → true (groupe)', () {
          expect(RoleResolver.isGroupRole(role), isTrue);
        });
      }
      test('intercession → true (groupe)', () {
        expect(RoleResolver.isGroupRole('intercession'), isTrue);
        expect(RoleResolver.isGroupRole('chef_intercession'), isTrue);
      });
      test('evenement → true (groupe)', () {
        expect(RoleResolver.isGroupRole('organisateur_evenement'), isTrue);
      });
      test('mission → true (groupe)', () {
        expect(RoleResolver.isGroupRole('responsable_mission'), isTrue);
      });
      test('super_admin → false (pas groupe)', () {
        expect(RoleResolver.isGroupRole('super_admin'), isFalse);
      });
      test('membre → false (pas groupe)', () {
        expect(RoleResolver.isGroupRole('membre'), isFalse);
      });
      test('pasteur → false (pas groupe)', () {
        expect(RoleResolver.isGroupRole('pasteur'), isFalse);
      });
      test('tresorier → false (pas groupe)', () {
        expect(RoleResolver.isGroupRole('tresorier'), isFalse);
      });
    });

    group('isAdjoint', () {
      test('adjoint → true', () {
        expect(RoleResolver.isAdjoint('pasteur_adjoint'), isTrue);
      });
      test('adjointe → true', () {
        expect(RoleResolver.isAdjoint('presidente_femmes_adjointe'), isTrue);
      });
      test('non-adjoint → false', () {
        expect(RoleResolver.isAdjoint('pasteur'), isFalse);
      });
    });

    group('getGroupLabel', () {
      test('chorale → Chorale', () {
        expect(RoleResolver.getGroupLabel('chef_chorale'), 'Chorale');
      });
      test('intercession → Intercession', () {
        expect(RoleResolver.getGroupLabel('chef_intercession'), 'Intercession');
      });
      test('hommes → Groupe Hommes', () {
        expect(RoleResolver.getGroupLabel('president_hommes'), 'Groupe Hommes');
      });
      test('femmes → Groupe Femmes', () {
        expect(RoleResolver.getGroupLabel('presidente_femmes'), 'Groupe Femmes');
      });
    });

    group('resolvePrimaryRole', () {
    test('retourne le rôle avec la plus haute priorité', () {
      const roles = [
        UserRole(roleId: '1', roleCode: 'membre', roleLabel: 'Membre', priorityLevel: 100, isSuper: false),
        UserRole(roleId: '2', roleCode: 'responsable_groupe', roleLabel: 'Responsable', priorityLevel: 50, isSuper: false),
      ];
      final primary = RoleResolver.resolvePrimaryRole(roles);
      expect(primary?.roleCode, 'membre');
    });
      test('retourne null si liste vide', () {
        expect(RoleResolver.resolvePrimaryRole([]), isNull);
      });
    });
  });

  group('AppRoutes — dashboard route helpers', () {
    test('groupDashboardPath construit /dashboard/group/<id>', () {
      expect(AppRoutes.groupDashboardPath('chorale-id'), '/dashboard/group/chorale-id');
    });
    test('groupFinancePath construit /dashboard/group/<id>/finance', () {
      expect(AppRoutes.groupFinancePath('chorale-id'), '/dashboard/group/chorale-id/finance');
    });
    test('groupDashboardWithType construit /dashboard/<type>', () {
      expect(AppRoutes.groupDashboardWithType('chorale'), '/dashboard/chorale');
    });
  });
}
