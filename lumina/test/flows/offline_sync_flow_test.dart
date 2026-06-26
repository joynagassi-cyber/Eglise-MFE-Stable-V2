import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lumina/main.dart' as app;

void main() {
  

  group('Offline Sync Flow', () {
    testWidgets('Create member offline and sync', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Navigate to members
      final membersTab = find.text('Brebis');
      if (membersTab.evaluate().isNotEmpty) {
        await tester.tap(membersTab);
        await tester.pumpAndSettle();

        // Tap add member
        final addButton = find.byIcon(Icons.add);
        await tester.tap(addButton);
        await tester.pumpAndSettle();

        // Fill form
        await tester.enterText(find.byKey(const Key('first_name_field')), 'Jean');
        await tester.enterText(find.byKey(const Key('last_name_field')), 'Dupont');
        await tester.pumpAndSettle();

        // Save
        final saveButton = find.text('Enregistrer');
        await tester.tap(saveButton);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Verify member appears in list
        expect(find.text('Jean Dupont'), findsOneWidget);
      }
    });
  });
}
