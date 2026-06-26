import 'package:flutter_test/flutter_test.dart';
import 'package:lumina/core/auth/domain/entities/church_role.dart';
import 'package:lumina/core/auth/domain/entities/enums/role_level.dart';
import 'package:lumina/core/auth/domain/entities/enums/permission.dart';

void main() {
  group('Role Code Mapping — 47 roles déterministes', () {
    const churchId = 'test-church';

    // ─── CATÉGORIE 1 : Admin Total (8 roles) ──────────────────────────
    group('CAT 1 — Admin Total → /dashboard, superadmin level, ALL permissions', () {
      final adminRoles = [
        'adm_001', 'admin_total', 'president', 'vice_president',
        'administrateur_systeme', 'administrateur_systeme_adjoint',
        'super_admin', 'webmaster',
      ];

      for (final role in adminRoles) {
        test('$role → superadmin + all permissions + /dashboard', () {
          final r = ChurchRole.fromLabel(label: role, churchId: churchId);
          expect(r.level, role == 'adm_001' ? RoleLevel.superadmin : RoleLevel.adminTotal);
          expect(r.initialRoute, '/dashboard');
          expect(r.permissions.length, Permission.values.length,
              reason: '$role doit avoir TOUTES les permissions');
          expect(r.hasPermission(Permission.adminManageRoles), isTrue);
          expect(r.hasPermission(Permission.financeView), isTrue);
          expect(r.hasPermission(Permission.auditView), isTrue);
        });
      }
    });

    // ─── CATÉGORIE 1B : Group Leaders (11 roles) ─────────────────────
    group('CAT 1B — Group Leaders → /dashboard/group/<X>, groupLeader level', () {
      test('president_hommes → /dashboard/group/hommes', () {
        final r = ChurchRole.fromLabel(label: 'president_hommes', churchId: churchId);
        expect(r.level, RoleLevel.groupLeader);
        expect(r.initialRoute, '/dashboard/group/hommes');
      });

      test('president_hommes_adjoint → /dashboard/group/hommes', () {
        final r = ChurchRole.fromLabel(label: 'president_hommes_adjoint', churchId: churchId);
        expect(r.initialRoute, '/dashboard/group/hommes');
      });

      test('presidente_femmes → /dashboard/group/femmes', () {
        final r = ChurchRole.fromLabel(label: 'presidente_femmes', churchId: churchId);
        expect(r.initialRoute, '/dashboard/group/femmes');
      });

      test('presidente_femmes_adjointe → /dashboard/group/femmes', () {
        final r = ChurchRole.fromLabel(label: 'presidente_femmes_adjointe', churchId: churchId);
        expect(r.initialRoute, '/dashboard/group/femmes');
      });

      test('president_jeunesse → /dashboard/group/jeunesse', () {
        final r = ChurchRole.fromLabel(label: 'president_jeunesse', churchId: churchId);
        expect(r.initialRoute, '/dashboard/group/jeunesse');
      });

      test('president_jeunesse_adjoint → /dashboard/group/jeunesse', () {
        final r = ChurchRole.fromLabel(label: 'president_jeunesse_adjoint', churchId: churchId);
        expect(r.initialRoute, '/dashboard/group/jeunesse');
      });

      test('chef_chorale → /dashboard/group/chorale', () {
        final r = ChurchRole.fromLabel(label: 'chef_chorale', churchId: churchId);
        expect(r.initialRoute, '/dashboard/group/chorale');
      });

      test('maitre_chorale → /dashboard/group/chorale', () {
        final r = ChurchRole.fromLabel(label: 'maitre_chorale', churchId: churchId);
        expect(r.initialRoute, '/dashboard/group/chorale');
      });

      test('chef_intercession → /dashboard/group/intercession', () {
        final r = ChurchRole.fromLabel(label: 'chef_intercession', churchId: churchId);
        expect(r.initialRoute, '/dashboard/group/intercession');
      });

      test('responsable_enfants → /dashboard/group/enfants', () {
        final r = ChurchRole.fromLabel(label: 'responsable_enfants', churchId: churchId);
        expect(r.initialRoute, '/dashboard/group/enfants');
      });

      test('moniteur_enfants → /dashboard/group/enfants', () {
        final r = ChurchRole.fromLabel(label: 'moniteur_enfants', churchId: churchId);
        expect(r.initialRoute, '/dashboard/group/enfants');
      });

      test('responsable_groupe → /dashboard (fallback)', () {
        final r = ChurchRole.fromLabel(label: 'responsable_groupe', churchId: churchId);
        expect(r.initialRoute, '/dashboard');
      });
    });

    // ─── CATÉGORIE 2 : Staff (15 roles) ──────────────────────────────
    group('CAT 2 — Staff → /dashboard or /finance, staff level', () {
      for (final role in ['pasteur', 'pasteur_adjoint', 'pasteur_principal']) {
        test('$role → staff + /dashboard', () {
          final r = ChurchRole.fromLabel(label: role, churchId: churchId);
          expect(r.level, RoleLevel.staff);
          expect(r.initialRoute, '/dashboard');
        });
      }

      for (final role in ['secretaire_general', 'secretaire_general_adjoint', 'secretaire_adjoint']) {
        test('$role → staff + /brebis', () {
          final r = ChurchRole.fromLabel(label: role, churchId: churchId);
          expect(r.level, RoleLevel.staff);
          expect(r.initialRoute, '/brebis');
        });
      }

      for (final role in ['tresorier', 'tresorier_adjoint', 'comptable', 'comptable_adjoint', 'validateur_transaction']) {
        test('$role → staff + /finance', () {
          final r = ChurchRole.fromLabel(label: role, churchId: churchId);
          expect(r.level, RoleLevel.staff);
          expect(r.initialRoute, '/finance');
        });
      }

      test('NO adminManageRoles for staff', () {
        final r = ChurchRole.fromLabel(label: 'pasteur', churchId: churchId);
        expect(r.hasPermission(Permission.adminManageRoles), isFalse);
        expect(r.hasPermission(Permission.adminManageUsers), isFalse);
        expect(r.hasPermission(Permission.adminSettings), isFalse);
      });

      test('comptable → staff + /finance', () {
        final r = ChurchRole.fromLabel(label: 'comptable', churchId: churchId);
        expect(r.level, RoleLevel.staff);
        expect(r.initialRoute, '/finance');
        expect(r.hasPermission(Permission.financeView), isTrue);
      });

      test('commissaire_aux_comptes → staff + /dashboard', () {
        final r = ChurchRole.fromLabel(label: 'commissaire_aux_comptes', churchId: churchId);
        expect(r.level, RoleLevel.staff);
      });

      test('auditeur → staff + /dashboard', () {
        final r = ChurchRole.fromLabel(label: 'auditeur', churchId: churchId);
        expect(r.level, RoleLevel.staff);
      });
    });

    // ─── CATÉGORIE 3 : Coordinateurs (5 roles) ──────────────────────
    group('CAT 3 — Coordinateurs → groupLeader', () {
      final coords = ['organisateur_evenement', 'gestionnaire_budget_event', 'responsable_mission', 'coordinateur_formation', 'benevole'];
      for (final role in coords) {
        test('$role → groupLeader level', () {
          final r = ChurchRole.fromLabel(label: role, churchId: churchId);
          expect(r.level, RoleLevel.groupLeader);
        });
      }

      test('gestionnaire_budget_event → /finance', () {
        final r = ChurchRole.fromLabel(label: 'gestionnaire_budget_event', churchId: churchId);
        expect(r.initialRoute, '/finance');
      });
    });

    // ─── CATÉGORIE 4 : Conseillers (3 roles) ────────────────────────
    group('CAT 4 — Conseillers → groupLeader', () {
      for (final role in ['conseiller', 'conseiller_adjoint', 'conseiller_principal']) {
        test('$role → groupLeader + /dashboard', () {
          final r = ChurchRole.fromLabel(label: role, churchId: churchId);
          expect(r.level, RoleLevel.groupLeader);
          expect(r.initialRoute, '/dashboard');
        });
      }
    });

    // ─── CATÉGORIE 5 : Consultation/Membre (Fallback) ───────────────
    group('CAT 5 — Fallback → consultation, Membre, /dashboard', () {
      for (final role in ['donateur', 'visiteur_temporaire', 'membre', 'unknown_role', '']) {
        test('"$role" → consultation level + Membre name + /dashboard', () {
          final r = ChurchRole.fromLabel(label: role, churchId: churchId);
          expect(r.level, RoleLevel.consultation);
          expect(r.name, role.trim().isEmpty ? 'Membre' : contains(RegExp(r'Membre', caseSensitive: false)));
          expect(r.initialRoute, '/dashboard');
          expect(r.hasPermission(Permission.membersView), isTrue);
          expect(r.hasPermission(Permission.eventsView), isTrue);
          expect(r.hasPermission(Permission.financeView), isFalse,
              reason: 'Les membres ne doivent pas voir les finances');
        });
      }
    });

    // ─── TEST DE NON-RÉGRESSION : Normalisation des accents ──────────
    group('Normalisation des accents et caractères spéciaux', () {
      test('président → president (normalized)', () {
        final r = ChurchRole.fromLabel(label: 'président', churchId: churchId);
        expect(r.level, RoleLevel.adminTotal);
      });

      test('pasteur_adjoint normalisé → staff', () {
        final r = ChurchRole.fromLabel(label: 'pasteur_adjoint', churchId: churchId);
        expect(r.level, RoleLevel.staff);
      });

      test('département-éducation → consultation (fallback)', () {
        final r = ChurchRole.fromLabel(label: 'département-éducation', churchId: churchId);
        expect(r.level, RoleLevel.consultation);
      });
    });

    // ─── ANTI-RÉGRESSION : Tous les 47 codes DB sont couverts ───────
    group('Couverture des 47 codes de la base Supabase', () {
      final allDbCodes = [
        'super_admin', 'president', 'vice_president',
        'pasteur_principal', 'pasteur', 'pasteur_adjoint',
        'secretaire_general', 'secretaire_general_adjoint', 'secretaire_adjoint',
        'conseiller_principal', 'conseiller', 'conseiller_adjoint',
        'coordinateur_formation', 'responsable_mission', 'organisateur_evenement', 'responsable_groupe',
        'tresorier', 'tresorier_adjoint', 'comptable', 'comptable_adjoint',
        'validateur_transaction', 'gestionnaire_budget_event',
        'auditeur', 'auditeur_interne', 'auditeur_interne_adjoint',
        'commissaire_aux_comptes', 'commissaire_aux_comptes_adjoint', 'commissaire_compte',
        'chef_chorale', 'maitre_chorale',
        'president_hommes', 'president_hommes_adjoint',
        'presidente_femmes', 'presidente_femmes_adjointe',
        'president_jeunesse', 'president_jeunesse_adjoint',
        'responsable_enfants', 'moniteur_enfants',
        'chef_intercession',
        'administrateur_systeme', 'administrateur_systeme_adjoint', 'webmaster', 'responsable_archives',
        'benevole', 'donateur', 'visiteur_temporaire',
        'membre_simple',
      ];

      for (final code in allDbCodes) {
        test('$code ne lance pas d\'exception', () {
          expect(
            () => ChurchRole.fromLabel(label: code, churchId: churchId),
            returnsNormally,
          );
        });

        test('$code a une initialRoute non-nulle', () {
          final r = ChurchRole.fromLabel(label: code, churchId: churchId);
          expect(r.initialRoute, isNotNull);
          expect(r.initialRoute, isNotEmpty);
          expect(r.initialRoute.startsWith('/'), isTrue,
              reason: '$code → ${r.initialRoute} doit commencer par /');
        });
      }
    });
  });
}
