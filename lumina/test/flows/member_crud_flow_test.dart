import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lumina/main.dart' as app;

void main() {
  

  group('Member CRUD Flow', () {
    testWidgets('Create → View → Edit → Delete member', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Navigate to members
      final membersTab = find.text('Brebis');
      if (membersTab.evaluate().isNotEmpty) {
        await tester.tap(membersTab);
        await tester.pumpAndSettle();

        // CREATE
        final addButton = find.byIcon(Icons.add);
        await tester.tap(addButton);
        await tester.pumpAndSettle();

        await tester.enterText(find.byKey(const Key('first_name_field')), 'Test');
        await tester.enterText(find.byKey(const Key('last_name_field')), 'User');
        await tester.enterText(find.byKey(const Key('email_field')), 'test@test.com');

        final saveButton = find.text('Enregistrer');
        await tester.tap(saveButton);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // VIEW
        expect(find.text('Test User'), findsOneWidget);
        await tester.tap(find.text('Test User'));
        await tester.pumpAndSettle();

        // EDIT
        final editButton = find.byIcon(Icons.edit);
        await tester.tap(editButton);
        await tester.pumpAndSettle();

        await tester.enterText(find.byKey(const Key('first_name_field')), 'Updated');
        await tester.tap(find.text('Enregistrer'));
        await tester.pumpAndSettle(const Duration(seconds: 2));

        expect(find.text('Updated User'), findsOneWidget);

        // DELETE
        await tester.tap(find.text('Updated User'));
        await tester.pumpAndSettle();

        final deleteButton = find.byIcon(Icons.delete);
        await tester.tap(deleteButton);
        await tester.pumpAndSettle();

        final confirmButton = find.text('Supprimer');
        await tester.tap(confirmButton);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        expect(find.text('Updated User'), findsNothing);
      }
    });
  });
}
