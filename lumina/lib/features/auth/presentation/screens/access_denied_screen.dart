// lib/features/auth/presentation/screens/access_denied_screen.dart
// Écran affiché en cas de violation de permission (RBAC)

import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:go_router/go_router.dart';
import 'package:lumina/core/router/app_routes.dart';
import 'package:lumina/core/theme/lumina_colors_extension.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class AccessDeniedScreen extends StatelessWidget {
  const AccessDeniedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Semantics(
                label: 'Accès verrouillé',
                child: Icon(
                  Icons.lock_person_outlined,
                  size: LuminaIcon.giga,
                  color: context.colors.errorText,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Accès Refusé',
                style: AppTypography.headlineMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.colors.errorText,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                "Vous n'avez pas les permissions nécessaires pour accéder à cette section. Si vous pensez qu'il s'agit d'une erreur, contactez votre administrateur.",
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium.copyWith(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? context.colors.textSecondary
                      : context.colors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              ElevatedButton.icon(
                onPressed: () => context.go(AppRoutes.splash),
                icon: const Icon(Icons.home_outlined),
                label: const Text('Retour à l\'accueil'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colors.brandPrimary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
