import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lumina/main.dart' as app;

void main() {
  

  group('Auth Flow Integration Test', () {
    testWidgets('Complete login to dashboard flow', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Find login fields
      final emailField = find.byKey(const Key('email_field'));
      final passwordField = find.byKey(const Key('password_field'));
      final loginButton = find.byKey(const Key('login_button'));

      if (emailField.evaluate().isEmpty) {
        // Already logged in, skip to dashboard verification
        expect(find.text('Lumina'), findsOneWidget);
        return;
      }

      // Enter credentials
      await tester.enterText(emailField, 'test@mfejc.org');
      await tester.enterText(passwordField, 'Test123!');
      await tester.pumpAndSettle();

      // Tap login
      await tester.tap(loginButton);
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Verify dashboard loaded
      expect(find.text('Lumina'), findsOneWidget);
    });

    testWidgets('Logout flow', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Open drawer
      final drawerButton = find.byIcon(Icons.menu);
      await tester.tap(drawerButton);
      await tester.pumpAndSettle();

      // Tap logout
      final logoutButton = find.text('Déconnexion');
      if (logoutButton.evaluate().isNotEmpty) {
        await tester.tap(logoutButton);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Verify back to login
        expect(find.text('Email'), findsOneWidget);
      }
    });
  });
}
