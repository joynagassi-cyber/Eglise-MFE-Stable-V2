import 'package:lumina/core/extensions/context_extension.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import 'package:lumina/core/theme/app_theme.dart';
import 'package:lumina/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('BuildContextExtension exposes theme, media query and l10n', (
    tester,
  ) async {
    BuildContext? capturedContext;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('fr'),
        home: Builder(
          builder: (context) {
            capturedContext = context;
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(capturedContext, isNotNull);
    expect(capturedContext!.colors.brandPrimary, isNotNull);
    expect(capturedContext!.l10n.dashboardTitle, 'Tableau de Bord');
    expect(capturedContext!.screenSize.width, greaterThan(0));
    expect(capturedContext!.isPortrait || capturedContext!.isLandscape, isTrue);
    expect(AppSpacing.borderRadiusFull, isA<BorderRadius>());
  });
}
