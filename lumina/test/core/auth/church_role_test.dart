import 'package:flutter_test/flutter_test.dart';
import 'package:lumina/core/auth/domain/entities/church_role.dart';
import 'package:lumina/core/auth/domain/entities/enums/role_level.dart';
import 'package:lumina/core/auth/domain/entities/enums/permission.dart';

void main() {
  group('ChurchRole Deterministic Mapping Tests', () {
    test(
        'Admin Total (ADM-001) should have superadmin level and full permissions',
        () {
      final role =
          ChurchRole.fromLabel(label: 'ADM-001', churchId: 'test-church');
      expect(role.level, RoleLevel.superadmin);
      expect(role.permissions.contains(Permission.adminManageRoles), true);
      expect(role.name, 'Admin Total');
    });

    test('Pasteur Responsable (PST-001) should have coordinator level', () {
      final role =
          ChurchRole.fromLabel(label: 'PST-001', churchId: 'test-church');
      expect(role.level, RoleLevel.staff);
      expect(role.name, 'Pasteur Responsable');
    });

    test('Trésorier (STF-001) should have staff level and finance permissions',
        () {
      final role =
          ChurchRole.fromLabel(label: 'STF-001', churchId: 'test-church');
      expect(role.level, RoleLevel.staff);
      expect(role.permissions.contains(Permission.financeView), true);
      expect(role.name, 'Trésorier');
    });

    test('Chef Chorale (GRP-001) should have groupLeader level', () {
      final role =
          ChurchRole.fromLabel(label: 'GRP-001', churchId: 'test-church');
      expect(role.level, RoleLevel.groupLeader);
      expect(role.name, 'Chef Chorale');
    });

    test('Membre (MBR-001) should have consultation level', () {
      final role =
          ChurchRole.fromLabel(label: 'MBR-001', churchId: 'test-church');
      expect(role.level, RoleLevel.consultation);
      expect(role.name, 'Membre');
    });

    test('Unknown label should fallback to Member/Consultation', () {
      final role =
          ChurchRole.fromLabel(label: 'UNKNOWN-999', churchId: 'test-church');
      expect(role.level, RoleLevel.consultation);
      expect(role.name, 'Membre');
    });

    test('Empty label should fallback to Member/Consultation', () {
      final role = ChurchRole.fromLabel(label: '', churchId: 'test-church');
      expect(role.level, RoleLevel.consultation);
      expect(role.name, 'Membre');
    });
  });
}
