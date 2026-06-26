import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:intl/intl.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import '../../data/models/approval_request.dart';

class ApprovalDetailSheet extends StatelessWidget {
  final ApprovalRequest request;

  const ApprovalDetailSheet({super.key, required this.request});

  static Future<void> show(BuildContext context, ApprovalRequest request) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ApprovalDetailSheet(request: request),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final numberFormat = NumberFormat('#,###', 'fr_FR');

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            
            // Type Badge
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xxs,
              ),
              decoration: BoxDecoration(
                gradient: context.colors.brandPrimaryGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                request.entityType.toUpperCase(),
                style: theme.textTheme.labelMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            
            // Title
            Text(
              request.entityLabel ?? 'Sans titre',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            
            // Amount
            if (request.entityAmount != null && request.entityAmount! > 0)
              Text(
                '${numberFormat.format(request.entityAmount)} FCFA',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.colors.brandPrimary,
                ),
              ),
            const SizedBox(height: AppSpacing.lg),
            
            // Info Row
            _buildInfoRow(
              theme, 
              Icons.calendar_today_rounded, 
              'Date de demande', 
              DateFormat('dd MMMM yyyy, HH:mm', 'fr_FR').format(request.requestedAt)
            ),
            const SizedBox(height: AppSpacing.md),
            _buildInfoRow(
              theme, 
              Icons.tag_rounded, 
              'ID Référence', 
              request.entityId
            ),
            const SizedBox(height: AppSpacing.md),
            _buildInfoRow(
              theme, 
              Icons.check_circle_outline_rounded, 
              'Progression', 
              'Étape ${request.currentStepOrder} sur ${request.totalSteps}'
            ),
            const SizedBox(height: AppSpacing.xl),
            
            // Action Button
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Fermer les détails'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(ThemeData theme, IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
