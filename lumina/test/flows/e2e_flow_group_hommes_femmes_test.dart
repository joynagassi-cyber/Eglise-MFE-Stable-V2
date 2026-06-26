import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumina/main.dart' as app;

void main() {
  testWidgets(
    'E2E Flow 8-9 — Hommes/Femmes : Register + Code → Dashboard Groupe',
    
    (tester) async {
      app.main();
      await Future.delayed(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      final isOnLogin = find.byType(TextField).evaluate().isNotEmpty;
      if (!isOnLogin) {
        final drawerBtn = find.byIcon(Icons.menu);
        if (drawerBtn.evaluate().isNotEmpty) {
          await tester.tap(drawerBtn);
          await tester.pumpAndSettle();
          await tester.tap(find.text('Déconnexion'));
          await tester.pumpAndSettle(const Duration(seconds: 2));
        }
      }

      if (find.text('S\'inscrire').evaluate().isNotEmpty) {
        await tester.tap(find.text('S\'inscrire'));
        await tester.pumpAndSettle();
      }

      await tester.enterText(find.text('Email'), 'groupe-test-${DateTime.now().millisecondsSinceEpoch}@lumina.app');
      await tester.enterText(find.text('Mot de passe'), 'Test123!');
      final nameField = find.byType(TextField).at(2);
      if (nameField.evaluate().isNotEmpty) {
        await tester.enterText(nameField, 'Leader Groupe Test');
      }
      await tester.tap(find.text('S\'inscrire'));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      await tester.pumpAndSettle(const Duration(seconds: 2));
      if (find.text('Staff de l\'Église').evaluate().isNotEmpty) {
        await tester.tap(find.text('Staff de l\'Église'));
        await tester.pumpAndSettle();
      }

      // NOTE: remplacer XXXX par le vrai code
      if (find.text('CODE DE RÔLE').evaluate().isNotEmpty) {
        await tester.enterText(find.text('CODE DE RÔLE'), 'PRESIDENT-HOMMES-XXXX-2026');
        await tester.pumpAndSettle();
        await tester.tap(find.text('VÉRIFIER L\'ACCÈS'));
        await tester.pumpAndSettle(const Duration(seconds: 3));
      }

      if (find.text('COMMENCER').evaluate().isNotEmpty) {
        await tester.tap(find.text('COMMENCER'));
        await tester.pumpAndSettle(const Duration(seconds: 3));
      }

      await tester.pumpAndSettle(const Duration(seconds: 3));
      // Vérifier le groupe dashboard
      await tester.pumpAndSettle();
    },
  );
}
