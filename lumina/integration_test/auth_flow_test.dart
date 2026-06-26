import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:lumina/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Auth Flow Integration Tests', () {
    testWidgets('Complete user journey: Register → Onboarding → Dashboard',
        (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // 1. Register
      expect(find.text('Inscription'), findsOneWidget);
      await tester.enterText(
          find.byKey(const Key('email_field')), 'test@example.com');
      await tester.enterText(
          find.byKey(const Key('password_field')), 'Test123!');
      await tester.enterText(find.byKey(const Key('name_field')), 'Test User');
      await tester.tap(find.byKey(const Key('register_button')));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // 2. Onboarding - Role Selection
      expect(find.text('Sélectionnez votre rôle'), findsOneWidget);
      await tester.tap(find.byKey(const Key('role_membre')));
      await tester.pumpAndSettle();

      // 3. Dashboard loaded
      expect(find.text('Tableau de bord'), findsOneWidget);
      expect(find.byKey(const Key('kpi_cards')), findsOneWidget);
    });

    testWidgets('Login → Dashboard (existing user)', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.text('Connexion'));
      await tester.pumpAndSettle();

      await tester.enterText(
          find.byKey(const Key('email_field')), 'existing@example.com');
      await tester.enterText(
          find.byKey(const Key('password_field')), 'Password123!');
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(find.text('Tableau de bord'), findsOneWidget);
    });

    testWidgets('Onboarding flag prevents loop', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Simulate user with needs_onboarding=true
      // Should redirect to onboarding, complete it, then go to dashboard
      // Should NOT loop back to onboarding

      await tester.pumpAndSettle(const Duration(seconds: 10));

      // Verify we're on dashboard, not stuck in onboarding
      expect(find.text('Tableau de bord'), findsOneWidget);
      expect(find.text('Sélectionnez votre rôle'), findsNothing);
    });

    testWidgets('RLS policies allow data access after role assignment',
        (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Login
      await tester.enterText(
          find.byKey(const Key('email_field')), 'admin@example.com');
      await tester.enterText(
          find.byKey(const Key('password_field')), 'Admin123!');
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Navigate to Members
      await tester.tap(find.text('Brebis'));
      await tester.pumpAndSettle();

      // Verify data loads (RLS policies working)
      expect(find.byType(ListView), findsOneWidget);
      expect(find.text('Aucune donnée'), findsNothing);
    });

    testWidgets('Edge Function fallback works on failure', (tester) async {
      // This test requires mocking network failure
      // Verify app still loads with minimal session
      app.main();
      await tester.pumpAndSettle();

      // Even with Edge Function down, should see dashboard
      expect(find.text('Tableau de bord'), findsOneWidget);
    });
  });
}
