import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumina/main.dart' as app;

void main() {
  testWidgets(
    'E2E Flow 4 — Finance : Login + Code Trésorier → Dashboard Finance',
    
    (tester) async {
      app.main();
      await Future.delayed(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      // ─── 1. INSCRIPTION ─────────────────────────────────────────────
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

      await tester.enterText(find.text('Email'), 'finance-test-${DateTime.now().millisecondsSinceEpoch}@lumina.app');
      await tester.enterText(find.text('Mot de passe'), 'Test123!');
      final nameField = find.byType(TextField).at(2);
      if (nameField.evaluate().isNotEmpty) {
        await tester.enterText(nameField, 'Test Finance');
      }
      await tester.tap(find.text('S\'inscrire'));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // ─── 2. ONBOARDING — STAFF → CODE ───────────────────────────────
      await tester.pumpAndSettle(const Duration(seconds: 2));
      if (find.text('Staff de l\'Église').evaluate().isNotEmpty) {
        await tester.tap(find.text('Staff de l\'Église'));
        await tester.pumpAndSettle();
      }

      // ─── 3. CODE COMPTABLE (doit être généré en DB d'abord) ────────
      // NOTE: Ce test nécessite un code COMPTABLE valide en base.
      // À exécuter après avoir récupéré le code via Supabase CLI:
      // npx supabase db query "SELECT raw_code FROM role_secret_codes WHERE role_code='comptable' LIMIT 1;"
      if (find.text('CODE DE RÔLE').evaluate().isNotEmpty) {
        await tester.enterText(find.text('CODE DE RÔLE'), 'COMPTABLE-XXXX-2026');
        await tester.pumpAndSettle();
        await tester.tap(find.text('VÉRIFIER L\'ACCÈS'));
        await tester.pumpAndSettle(const Duration(seconds: 3));
      }

      // ─── 4. ONBOARDING FINANCE ─────────────────────────────────────
      if (find.text('COMMENCER').evaluate().isNotEmpty) {
        await tester.tap(find.text('COMMENCER'));
        await tester.pumpAndSettle(const Duration(seconds: 3));
      }

      // ─── 5. VÉRIFICATION DASHBOARD FINANCE ──────────────────────────
      await tester.pumpAndSettle(const Duration(seconds: 3));
      // Le dashboard finance doit être visible
      expect(find.text('Finance'), findsWidgets);
    },
  );
}
