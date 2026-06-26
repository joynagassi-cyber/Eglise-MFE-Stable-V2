// lib/core/presentation/screens/not_found_screen.dart
//
// Page 404 — Design premium avec bouton retour

import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:go_router/go_router.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import '../../router/app_routes.dart';

class NotFoundScreen extends StatelessWidget {
  final String uri;
  const NotFoundScreen({super.key, required this.uri});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.bgPage,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Illustrative icon
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: context.colors.brandPrimary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.explore_off_rounded,
                    size: 60,
                    color: context.colors.brandPrimary,
                  ),
                ),

                const SizedBox(height: AppSpacing.xl),

                // 404
                Text(
                  '404',
                  style: TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 4,
                    color: context.colors.textDisabled.withOpacity(0.3),
                  ),
                ),

                const SizedBox(height: AppSpacing.md),

                // Title
                Text(
                  'Page non trouvée',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: context.colors.textPrimary,
                  ),
                ),

                const SizedBox(height: AppSpacing.sm),

                // URI
                Text(
                  uri,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: context.colors.textTertiary,
                    fontFamily: 'monospace',
                  ),
                ),

                const SizedBox(height: AppSpacing.sm),

                Text(
                  'Cette page n\'existe pas ou a été déplacée.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: context.colors.textSecondary,
                  ),
                ),

                const SizedBox(height: AppSpacing.xxl),

                // Back to Dashboard
                SizedBox(
                  width: 220,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () => context.go(AppRoutes.dashboard),
                    icon: const Icon(Icons.home_rounded, size: 20),
                    label: const Text(
                      'Retour au Dashboard',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.colors.brandPrimary,
                      foregroundColor: context.colors.textOnBrand,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.md),

                // Go back
                TextButton(
                  onPressed: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go(AppRoutes.dashboard);
                    }
                  },
                  child: Text(
                    'ou revenir en arrière',
                    style: TextStyle(
                      color: context.colors.textTertiary,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
