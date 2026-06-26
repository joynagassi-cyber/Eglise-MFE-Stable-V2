import 'package:lumina/core/extensions/context_extension.dart';
// lib/core/widgets/seal_status_indicator.dart
import 'package:flutter/material.dart';
import '../../features/finance/domain/entities/enums/validation_status.dart';
import '../../features/finance/presentation/utils/finance_enums_ui_extensions.dart';

/// Widget indicateur du statut de scellement cryptographique (IMAGIR)
/// Affiche l'état de validation d'une preuve photographique
class SealStatusIndicator extends StatelessWidget {
  final bool isSealed;
  final ValidationStatus? validationStatus;
  final VoidCallback? onTap;
  final bool compact;

  const SealStatusIndicator({
    super.key,
    required this.isSealed,
    this.validationStatus,
    this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final status = validationStatus ?? ValidationStatus.pending;

    if (compact) {
      return _buildCompact(context, status);
    }

    return _buildFull(context, status);
  }

  Widget _buildCompact(BuildContext context, ValidationStatus status) {
    return Tooltip(
      message: _getTooltipMessage(status),
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: _getBackgroundColor(context, status),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          _getIcon(status),
          size: 14,
          color: _getIconColor(context, status),
        ),
      ),
    );
  }

  Widget _buildFull(BuildContext context, ValidationStatus status) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: _getBackgroundColor(context, status),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: status.getColor(context).withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getIcon(status),
              size: 16,
              color: _getIconColor(context, status),
            ),
            const SizedBox(width: 8),
            Text(
              _getLabel(status),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: _getIconColor(context, status),
              ),
            ),
            if (isSealed) ...[
              const SizedBox(width: 4),
              Icon(Icons.lock,
                size: 12,
                color: context.colors.successText,
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getIcon(ValidationStatus status) {
    if (!isSealed) return Icons.lock_open;
    return status.icon;
  }

  Color _getBackgroundColor(BuildContext context, ValidationStatus status) {
    if (!isSealed) {
      return context.colors.textTertiary.withValues(alpha: 0.1);
    }
    return status.getColor(context).withValues(alpha: 0.1);
  }

  Color _getIconColor(BuildContext context, ValidationStatus status) {
    if (!isSealed) return context.colors.textTertiary;
    return status.getColor(context);
  }

  String _getLabel(ValidationStatus status) {
    if (!isSealed) return 'Non scellé';
    switch (status) {
      case ValidationStatus.pending:
        return 'Scellé - En attente';
      case ValidationStatus.validated:
        return 'Scellé - Validé';
      case ValidationStatus.rejected:
        return 'Scellé - Rejeté';
    }
  }

  String _getTooltipMessage(ValidationStatus status) {
    if (!isSealed) {
      return 'Document non scellé cryptographiquement';
    }
    switch (status) {
      case ValidationStatus.pending:
        return 'Document scellé, en attente de validation';
      case ValidationStatus.validated:
        return 'Document scellé et validé par un responsable';
      case ValidationStatus.rejected:
        return 'Document scellé mais rejeté';
    }
  }
}

/// Widget pour afficher le badge de scellement sur une image
class SealBadge extends StatelessWidget {
  final bool isSealed;
  final ValidationStatus status;

  const SealBadge({
    super.key,
    required this.isSealed,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 4,
      right: 4,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: context.colors.brandSecondary.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          isSealed ? Icons.verified : Icons.lock_open,
          size: 16,
          color: isSealed ? context.colors.successText : context.colors.warningText,
        ),
      ),
    );
  }
}
