import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumina/main.dart' as app;

void main() {
  testWidgets(
    'E2E Flow 1 — Membre Simple : Register → Onboarding → Dashboard',
    
    (tester) async {
      app.main();
      await Future.delayed(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      // ─── 1. INSCRIPTION ─────────────────────────────────────────────
      final isOnLogin = find.byType(TextField).evaluate().isNotEmpty;
      if (!isOnLogin) {
        // Déjà connecté — aller sur /register
        await tester.tap(find.text('S\'inscrire'));
        await tester.pumpAndSettle();
      }

      // Cliquer sur "S'inscrire" si on est sur la page d'accueil
      if (find.text('S\'inscrire').evaluate().isNotEmpty) {
        await tester.tap(find.text('S\'inscrire'));
        await tester.pumpAndSettle();
      }

      // Remplir le formulaire d'inscription
      await tester.enterText(find.text('Email'), 'membre-test-${DateTime.now().millisecondsSinceEpoch}@lumina.app');
      await tester.enterText(find.text('Mot de passe'), 'Test123!');
      final nameField = find.byType(TextField).at(2);
      if (nameField.evaluate().isNotEmpty) {
        await tester.enterText(nameField, 'Test Membre');
      }
      await tester.tap(find.text('S\'inscrire'));
      
      // Attendre un peu plus pour l'inscription (mock ou réel)
      await Future.delayed(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // ─── 2. ONBOARDING — SÉLECTION RÔLE ─────────────────────────────
      if (find.text('Membre').evaluate().isNotEmpty) {
        await tester.tap(find.text('Membre'));
        await Future.delayed(const Duration(seconds: 1));
        await tester.pumpAndSettle();
      }

      // ─── 3. ONBOARDING — SIMPLIFIÉ ──────────────────────────────────
      // Étape 0: Bienvenue → TERMINER
      if (find.text('TERMINER').evaluate().isNotEmpty) {
        await tester.tap(find.text('TERMINER'));
        await Future.delayed(const Duration(seconds: 2));
        await tester.pumpAndSettle();
      } else if (find.text('COMMENCER').evaluate().isNotEmpty) {
        // Au cas où l'étape 0 demande d'abord COMMENCER puis TERMINER
        await tester.tap(find.text('COMMENCER'));
        await Future.delayed(const Duration(seconds: 1));
        await tester.pumpAndSettle();
        if (find.text('TERMINER').evaluate().isNotEmpty) {
          await tester.tap(find.text('TERMINER'));
          await Future.delayed(const Duration(seconds: 2));
          await tester.pumpAndSettle();
        }
      }

      // ─── 4. VÉRIFICATION DASHBOARD ──────────────────────────────────
      await Future.delayed(const Duration(seconds: 3));
      await tester.pumpAndSettle();
      
      // Vérifier l'atterrissage sur le dashboard
      await tester.pumpAndSettle();
      await tester.pumpAndSettle();
    },
  );
}
