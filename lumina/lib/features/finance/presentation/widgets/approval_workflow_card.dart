// import 'package:lumina/core/theme/lumina_colors_extension.dart';
import 'package:lumina/core/extensions/context_extension.dart';
// lib/features/finance/presentation/widgets/approval_workflow_card.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/skeletons/fire_skeleton_system.dart';
import '../../domain/entities/approval.dart';
import '../../domain/entities/enums/transaction_status.dart';
// import 'package:lumina/core/extensions/build_context_extensions.dart';

/// Widget affichant le workflow d'approbation d'une transaction
class ApprovalWorkflowCard extends StatelessWidget {
  final TransactionStatus currentStatus;
  final List<Approval> approvals;
  final String? currentUserRole;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;
  final bool isLoading;

  const ApprovalWorkflowCard({
    super.key,
    required this.currentStatus,
    required this.approvals,
    this.currentUserRole,
    this.onApprove,
    this.onReject,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête avec gradient icon
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.xs),
                decoration: BoxDecoration(
                  gradient: context.colors.brandPrimaryGradient,
                  borderRadius: AppSpacing.borderRadiusSm,
                ),
                child: Icon(
                  Icons.approval_rounded,
                  color: context.colors.textOnBrand,
                  size: AppSpacing.iconSm,
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Text(
                'Workflow d\'approbation',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),

          // Timeline des approbations
          if (approvals.isEmpty)
            _buildEmptyState(theme)
          else
            _buildApprovalTimeline(context, theme),

          // Actions disponibles
          if (_canPerformAction) ...[
            Divider(height: AppSpacing.lg),
            _buildActionButtons(context, theme),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.smd),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: AppSpacing.borderRadiusMd,
      ),
      child: Row(
        children: [
          Icon(
            Icons.hourglass_empty_rounded,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
          ),
          SizedBox(width: AppSpacing.smd),
          Expanded(
            child: Text(
              'Aucune approbation pour le moment',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApprovalTimeline(BuildContext context, ThemeData theme) {
    return Column(
      children: List.generate(approvals.length, (index) {
        final approval = approvals[index];
        final isApproved = approval.decision == ApprovalDecision.approved;
        final color = isApproved ? context.colors.successText : context.colors.errorText;
        final isLast = index == approvals.length - 1;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Timeline connector
              SizedBox(
                width: 32,
                child: Column(
                  children: [
                    // Cercle icône
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: color.withValues(alpha: 0.5),
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        isApproved ? Icons.check_rounded : Icons.close_rounded,
                        color: color,
                        size: 16,
                      ),
                    ),
                    // Ligne verticale connectrice
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 2,
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                color.withValues(alpha: 0.5),
                                color.withValues(alpha: 0.1),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              // Détails
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: isLast ? 0 : AppSpacing.md,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${approval.decision.label} par ${approval.roleUsed}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (approval.comment != null)
                        Padding(
                          padding: const EdgeInsets.only(top: AppSpacing.xxs),
                          child: Text(
                            approval.comment!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.6),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      Text(
                        _formatDate(approval.decidedAt),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.4),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildActionButtons(BuildContext context, ThemeData theme) {
    if (isLoading) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (onReject != null)
            FireShimmer(
              child: Container(
                height: 40,
                width: 100,
                decoration: BoxDecoration(
                  color: context.colors.errorText.withValues(alpha: 0.3),
                  borderRadius: AppSpacing.borderRadiusFull,
                ),
              ),
            ),
          SizedBox(width: AppSpacing.smd),
          if (onApprove != null)
            FireShimmer(
              child: Container(
                height: 40,
                width: 120,
                decoration: BoxDecoration(
                  color: context.colors.successText.withValues(alpha: 0.3),
                  borderRadius: AppSpacing.borderRadiusFull,
                ),
              ),
            ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (onReject != null)
          OutlinedButton.icon(
            onPressed: () async {
              await HapticFeedback.mediumImpact();
              onReject?.call();
            },
            icon: Icon(Icons.close_rounded, size: 18),
            label: Text('Rejeter'),
            style: OutlinedButton.styleFrom(
              foregroundColor: context.colors.errorText,
              side: BorderSide(color: context.colors.errorText),
            ),
          ),
        SizedBox(width: AppSpacing.smd),
        if (onApprove != null)
          FilledButton.icon(
            onPressed: () async {
              await HapticFeedback.heavyImpact();
              onApprove?.call();
            },
            icon: Icon(Icons.check_rounded, size: 18),
            label: Text('Approuver',
                style: TextStyle(color: context.colors.textOnBrand)),
            style:
                FilledButton.styleFrom(backgroundColor: context.colors.successText),
          ),
      ],
    );
  }

  bool get _canPerformAction {
    return currentStatus == TransactionStatus.pending &&
        currentUserRole != null &&
        (onApprove != null || onReject != null);
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}