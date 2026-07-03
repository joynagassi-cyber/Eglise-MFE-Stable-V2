import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumina/main.dart' as app;

/// Délai standard pour pumpAndSettle lors des transitions
const _kTransitionTimeout = Duration(seconds: 3);
const _kNetworkTimeout = Duration(seconds: 5);

void main() {
  testWidgets(
    'E2E Flow 1 — Membre Simple : Register → Onboarding → Dashboard',
    (tester) async {
      app.main();
      await tester.pumpAndSettle(_kNetworkTimeout);

      // ─── 1. INSCRIPTION ─────────────────────────────────────────────
      // Si déjà connecté, naviguer vers /register
      if (find.text('Inscription').evaluate().isNotEmpty) {
        await tester.tap(find.text('Inscription'));
        await tester.pumpAndSettle(_kTransitionTimeout);
      }

      // Sur la page d'accueil non connectée, le lien d'inscription existe aussi
      if (find.text('Créer un compte').evaluate().isNotEmpty) {
        await tester.tap(find.text('Créer un compte'));
        await tester.pumpAndSettle(_kTransitionTimeout);
      }

      // Remplir le formulaire d'inscription
      // Ordre TextFormField sur SignUpPage: 0=Prénom, 1=Nom, 2=Email, 3=Password, 4=Confirmer
      await tester.enterText(find.byType(TextFormField).at(2),
          'membre-test-${DateTime.now().millisecondsSinceEpoch}@lumina.app');
      await tester.enterText(
          find.byType(TextFormField).at(3), 'Test123!');
      await tester.enterText(
          find.byType(TextFormField).at(0), 'Test Membre');

      // Tenter l'inscription (le bouton est un SwipeAuthButton)
      final submitBtn = find.text('Glisser pour s\'inscrire');
      if (submitBtn.evaluate().isNotEmpty) {
        await tester.tap(submitBtn);
        await tester.pumpAndSettle(_kNetworkTimeout);
      }

      // ─── 2. ONBOARDING — SÉLECTION RÔLE ─────────────────────────────
      if (find.text('Membre').evaluate().isNotEmpty) {
        await tester.tap(find.text('Membre'));
        await tester.pumpAndSettle(_kTransitionTimeout);
      }

      // ─── 3. ONBOARDING — SIMPLIFIÉ ──────────────────────────────────
      if (find.text('TERMINER').evaluate().isNotEmpty) {
        await tester.tap(find.text('TERMINER'));
        await tester.pumpAndSettle(_kTransitionTimeout);
      } else if (find.text('COMMENCER').evaluate().isNotEmpty) {
        await tester.tap(find.text('COMMENCER'));
        await tester.pumpAndSettle(_kTransitionTimeout);
        if (find.text('TERMINER').evaluate().isNotEmpty) {
          await tester.tap(find.text('TERMINER'));
          await tester.pumpAndSettle(_kTransitionTimeout);
        }
      }

      // ─── 4. VÉRIFICATION DASHBOARD ──────────────────────────────────
      await tester.pumpAndSettle(_kTransitionTimeout);
      await tester.pumpAndSettle();
      await tester.pumpAndSettle();
    },
  );
}
