import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lumina/main.dart' as app;

void main() {
  

  group('Permission Flow', () {
    testWidgets('Admin sees all tabs, Member sees limited', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Login as admin
      final emailField = find.byKey(const Key('email_field'));
      if (emailField.evaluate().isNotEmpty) {
        await tester.enterText(emailField, 'admin@test.com');
        await tester.enterText(find.byKey(const Key('password_field')), 'admin123');
        await tester.tap(find.byKey(const Key('login_button')));
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Verify admin tabs
        expect(find.text('Finance'), findsOneWidget);
        expect(find.text('Bergers'), findsOneWidget);

        // Logout
        await tester.tap(find.byIcon(Icons.menu));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Déconnexion'));
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Login as member
        await tester.enterText(
            find.byKey(const Key('email_field')), 'member@test.com');
        await tester.enterText(find.byKey(const Key('password_field')), 'member123');
        await tester.tap(find.byKey(const Key('login_button')));
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Verify limited tabs
        expect(find.text('Finance'), findsNothing);
        expect(find.text('Bergers'), findsNothing);
      }
    });
  });
}
