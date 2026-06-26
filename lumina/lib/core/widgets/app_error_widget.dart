// lib/core/widgets/app_error_widget.dart
// Widget standardisé pour les états d'erreur avec retry

import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:lumina/core/theme/app_spacing.dart';
/// Widget d'erreur standardisé avec bouton retry
class AppErrorWidget extends StatelessWidget {
  final String? title;
  final String message;
  final String? technicalDetails;
  final VoidCallback? onRetry;
  final String retryLabel;
  final IconData icon;
  final bool showTechnicalDetails;

  const AppErrorWidget({
    super.key,
    this.title,
    required this.message,
    this.technicalDetails,
    this.onRetry,
    this.retryLabel = 'Réessayer',
    this.icon = Icons.error_outline_rounded,
    this.showTechnicalDetails = false,
  });

  /// Constructeur pour erreur réseau
  factory AppErrorWidget.network({
    VoidCallback? onRetry,
    String? technicalDetails,
  }) {
    return AppErrorWidget(
      title: 'Problème de connexion',
      message:
          'Impossible de se connecter au serveur. Vérifiez votre connexion internet.',
      icon: Icons.wifi_off_rounded,
      onRetry: onRetry,
      technicalDetails: technicalDetails,
    );
  }

  /// Constructeur pour erreur de permission
  factory AppErrorWidget.permission({
    String? message,
    VoidCallback? onRetry,
  }) {
    return AppErrorWidget(
      title: 'Accès refusé',
      message: message ??
          'Vous n\'avez pas la permission d\'accéder à cette ressource.',
      icon: Icons.lock_outline_rounded,
      onRetry: onRetry,
    );
  }

  /// Constructeur pour erreur 404
  factory AppErrorWidget.notFound({
    String? message,
    VoidCallback? onRetry,
    String retryLabel = 'Réessayer',
  }) {
    return AppErrorWidget(
      title: 'Introuvable',
      message:
          message ?? 'La ressource demandée n\'existe pas ou a été supprimée.',
      icon: Icons.search_off_rounded,
      onRetry: onRetry,
      retryLabel: retryLabel,
    );
  }

  /// Constructeur pour erreur serveur
  factory AppErrorWidget.server({
    String? technicalDetails,
    VoidCallback? onRetry,
  }) {
    return AppErrorWidget(
      title: 'Erreur serveur',
      message:
          'Une erreur s\'est produite sur le serveur. Veuillez réessayer plus tard.',
      icon: Icons.cloud_off_rounded,
      onRetry: onRetry,
      technicalDetails: technicalDetails,
      showTechnicalDetails: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icône d'erreur
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: context.colors.errorText.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: AppSpacing.iconFeature,
                color: context.colors.errorText,
              ),
            ),

            SizedBox(height: AppSpacing.lg),

            // Titre
            if (title != null) ...[
              Text(
                title!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: context.colors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(height: AppSpacing.sm),
            ],

            // Message principal
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: context.colors.textSecondary,
                  ),
            ),

            // Détails techniques (collapsible)
            if (showTechnicalDetails && technicalDetails != null) ...[
              SizedBox(height: AppSpacing.md),
              _TechnicalDetailsExpansion(details: technicalDetails!),
            ],

            // Bouton Retry
            if (onRetry != null) ...[
              SizedBox(height: AppSpacing.lg),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: Icon(Icons.refresh_rounded),
                label: Text(retryLabel),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Widget pour afficher les détails techniques pliables
class _TechnicalDetailsExpansion extends StatefulWidget {
  final String details;

  const _TechnicalDetailsExpansion({required this.details});

  @override
  State<_TechnicalDetailsExpansion> createState() =>
      _TechnicalDetailsExpansionState();
}

class _TechnicalDetailsExpansionState
    extends State<_TechnicalDetailsExpansion> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        TextButton.icon(
          onPressed: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          icon: Icon(
            _isExpanded
                ? Icons.keyboard_arrow_up_rounded
                : Icons.keyboard_arrow_down_rounded,
          ),
          label: Text(
            _isExpanded ? 'Masquer les détails' : 'Voir les détails techniques',
          ),
        ),
        if (_isExpanded) ...[
          SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: isDark
                  ? context.colors.bgCard
                  : context.colors.borderSubtle.withValues(alpha: 0.3),
              borderRadius: AppSpacing.borderRadiusMd,
              border: Border.all(
                color: context.colors.borderSubtle,
              ),
            ),
            child: SelectableText(
              widget.details,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontFamily: 'monospace',
                    color: context.colors.textSecondary,
                  ),
            ),
          ),
        ],
      ],
    );
  }
}
