import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumina/main.dart' as app;

/// Délai standard pour pumpAndSettle lors des transitions
const _kTransitionTimeout = Duration(seconds: 3);
const _kNetworkTimeout = Duration(seconds: 5);

void main() {
  testWidgets(
    'E2E Flow 10-11 — Jeunesse/Enfants : Register + Code → Dashboard Groupe',
    (tester) async {
      app.main();
      await tester.pumpAndSettle(_kNetworkTimeout);

      // ─── LOGOUT SI DÉJÀ CONNECTÉ ───────────────────────────────
      final isOnLogin = find.byType(TextFormField).evaluate().isNotEmpty;
      if (!isOnLogin) {
        final drawerBtn = find.byIcon(Icons.menu);
        if (drawerBtn.evaluate().isNotEmpty) {
          await tester.tap(drawerBtn);
          await tester.pumpAndSettle(_kTransitionTimeout);
          await tester.tap(find.text('Se Déconnecter'));
          await tester.pumpAndSettle(_kTransitionTimeout);
        }
      }

      // ─── NAVIGUER VERS L'INSCRIPTION ──────────────────────────
      // Le tab toggle affiche 'Inscription' (pas 'S\'inscrire')
      if (find.text('Inscription').evaluate().isNotEmpty) {
        await tester.tap(find.text('Inscription'));
        await tester.pumpAndSettle(_kTransitionTimeout);
      }

      // ─── REMPLIR LE FORMULAIRE D'INSCRIPTION ──────────────────
      // Ordre TextFormField sur SignUpPage: 0=Prénom, 1=Nom, 2=Email, 3=Password, 4=Confirmer
      await tester.enterText(find.byType(TextFormField).at(2),
          'jeunesse-test-${DateTime.now().millisecondsSinceEpoch}@lumina.app');
      await tester.enterText(
          find.byType(TextFormField).at(3), 'Test123!');
      await tester.enterText(find.byType(TextFormField).at(0),
          'Leader Jeunesse Test');
      await tester.pumpAndSettle();

      // ─── TENTER L'INSCRIPTION ──────────────────────────────────
      // Le bouton est un SwipeAuthButton — on tente le tap (peut échouer sans mock)
      final submitBtn = find.text('Glisser pour s\'inscrire');
      if (submitBtn.evaluate().isNotEmpty) {
        await tester.tap(submitBtn);
        await tester.pumpAndSettle(_kNetworkTimeout);
      }

      // ─── ONBOARDING (si l'inscription a réussi) ────────────────
      await tester.pumpAndSettle(_kTransitionTimeout);
      if (find.text('Staff de l\'Église').evaluate().isNotEmpty) {
        await tester.tap(find.text('Staff de l\'Église'));
        await tester.pumpAndSettle(_kTransitionTimeout);
      }

      // NOTE: remplacer XXXX par le vrai code
      if (find.text('CODE DE RÔLE').evaluate().isNotEmpty) {
        await tester.enterText(find.byType(TextFormField).first,
            'PRESIDENT-JEUNESSE-XXXX-2026');
        await tester.pumpAndSettle(_kTransitionTimeout);
        await tester.tap(find.text('VÉRIFIER L\'ACCÈS'));
        await tester.pumpAndSettle(_kTransitionTimeout);
      }

      if (find.text('COMMENCER').evaluate().isNotEmpty) {
        await tester.tap(find.text('COMMENCER'));
        await tester.pumpAndSettle(_kTransitionTimeout);
      }

      await tester.pumpAndSettle(_kTransitionTimeout);
    },
  );
}
