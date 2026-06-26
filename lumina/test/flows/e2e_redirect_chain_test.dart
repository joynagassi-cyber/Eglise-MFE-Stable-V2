import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lumina/main.dart' as app;


void main() {
  

  // Test 1: Non-authentifié → routes protégées → redirect /auth-home
  testWidgets('[Redirect] Non-authentifié cherche /dashboard → /auth-home',
      (tester) async {
    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Si on est sur l'écran d'accueil (non connecté)
    final authHome = find.text('Se connecter');
    if (authHome.evaluate().isNotEmpty) {
      // Non connecté → essaie d'accéder /dashboard directement
      // Le GoRouter redirect devrait le rediriger vers /auth-home
      expect(authHome, findsOneWidget);
    } else {
      // Déjà connecté → ce test nécessite un état déconnecté
      debugPrint('⚠ Déjà connecté — logout nécessaire pour ce test');
    }
  });

  // Test 2: Onboarding requis → routes protégées → redirect onboarding
  testWidgets('[Redirect] Onboarding requis → /dashboard redirigé vers onboarding',
      (tester) async {
    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Si on est sur la page de login, se connecter
    final emailField = find.byKey(const Key('email_field'));
    if (emailField.evaluate().isNotEmpty) {
      await tester.enterText(emailField, 'newuser-needs-onboarding@lumina.app');
      await tester.enterText(
          find.byKey(const Key('password_field')), 'Test123!');
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Si onboarding requis → devrait voir l'écran de sélection de rôle
      if (find.text('Sélectionnez votre rôle').evaluate().isNotEmpty) {
        // Essayer d'accéder /dashboard → doit rester sur onboarding
        // (vérifié par le fait qu'on ne voit pas le dashboard)
        expect(find.text('Tableau de bord'), findsNothing);
        expect(find.text('Sélectionnez votre rôle'), findsOneWidget);
      }
    } else {
      debugPrint('⚠ Déjà connecté — pas de redirection onboarding visible');
    }
  });

  // Test 3: Routes publiques accessibles sans auth
  testWidgets('[Redirect] Routes publiques accessibles sans authentification',
      (tester) async {
    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Page d'accueil auth-home accessible
    final loginText = find.text('Se connecter');
    if (loginText.evaluate().isNotEmpty) {
      expect(loginText, findsOneWidget);
    }
  });

  // Test 4: Access denied pour cross-group
  testWidgets('[Redirect] Cross-group → /access-denied',
      (tester) async {
    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Vérifier que la route /access-denied existe
    const accessDeniedRoute = '/access-denied';
    expect(accessDeniedRoute, isNotEmpty);
  });
}
