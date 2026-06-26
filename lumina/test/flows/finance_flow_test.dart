import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lumina/main.dart' as app;

void main() {
  

  group('Finance Flow', () {
    testWidgets('Add transaction → View history → Export', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Navigate to finance
      final financeTab = find.text('Finance');
      if (financeTab.evaluate().isNotEmpty) {
        await tester.tap(financeTab);
        await tester.pumpAndSettle();

        // ADD TRANSACTION
        final addButton = find.byType(FloatingActionButton);
        await tester.tap(addButton);
        await tester.pumpAndSettle();

        await tester.enterText(find.byKey(const Key('amount_field')), '50000');
        await tester.enterText(
            find.byKey(const Key('description_field')), 'Test Transaction');

        final saveButton = find.text('Enregistrer');
        await tester.tap(saveButton);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // VIEW HISTORY
        final historyButton = find.text('Tout voir');
        await tester.tap(historyButton);
        await tester.pumpAndSettle();

        expect(find.text('Test Transaction'), findsOneWidget);

        // EXPORT
        final exportButton = find.byIcon(Icons.summarize_outlined);
        await tester.tap(exportButton);
        await tester.pumpAndSettle();

        final pdfButton = find.text('Format PDF');
        expect(pdfButton, findsOneWidget);
      }
    });
  });
}
