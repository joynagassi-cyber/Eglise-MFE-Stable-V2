import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import 'package:lumina/core/widgets/glass_card.dart';
import 'package:lumina/core/widgets/skeletons/fire_skeleton_system.dart';
import 'package:lumina/core/providers/repository_providers_finance.dart';
import '../../data/models/approval_request.dart';
import '../providers/approval_providers.dart';
import 'approval_detail_sheet.dart';

class ApprovalCard extends ConsumerStatefulWidget {
  final ApprovalRequest request;

  const ApprovalCard({required this.request, super.key});

  @override
  ConsumerState<ApprovalCard> createState() => _ApprovalCardState();
}

class _ApprovalCardState extends ConsumerState<ApprovalCard> {
  bool _isLoading = false;

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: context.colors.errorText,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccess(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: context.colors.successText,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<bool?> _showConfirmationDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer l\'approbation'),
        content: const Text(
          'Êtes-vous sûr de vouloir approuver cette demande ? Cette action est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(backgroundColor: context.colors.successText),
            child: const Text('Approuver'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final numberFormat = NumberFormat('#,###', 'fr_FR');

    if (_isLoading) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        child: FireShimmer(
          child: Container(
            height: 120, // Approximative height of card
            decoration: BoxDecoration(
              color: theme.colorScheme.surface.withValues(alpha: 0.1),
              borderRadius: AppSpacing.borderRadiusCard,
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      child: Dismissible(
        key: ValueKey(widget.request.id),
        // Swipe droite → Approuver
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                context.colors.successText.withValues(alpha: 0.8),
                context.colors.successText,
              ],
            ),
            borderRadius: AppSpacing.borderRadiusCard,
          ),
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: AppSpacing.lg),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle_rounded,
                  color: Colors.white, size: 28),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Approuver',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        // Swipe gauche → Détails
        secondaryBackground: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                context.colors.brandPrimary,
                context.colors.brandPrimary.withValues(alpha: 0.8),
              ],
            ),
            borderRadius: AppSpacing.borderRadiusCard,
          ),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: AppSpacing.lg),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Détails',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              const Icon(Icons.info_outline_rounded,
                  color: Colors.white, size: 28),
            ],
          ),
        ),
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.startToEnd) {
            // Approuver
            await HapticFeedback.heavyImpact();
            
            final confirm = await _showConfirmationDialog();
            if (confirm != true) return false;

            setState(() {
              _isLoading = true;
            });

            try {
              await ref.read(approvalRepositoryProvider).submitDecision(
                    requestId: widget.request.id,
                    decision: 'approved',
                    comment: 'Approuvé via Quick Action',
                  );
              _showSuccess('Demande approuvée avec succès.');
              ref.invalidate(pendingApprovalsProvider);
              return true; // Supprimer visuellement puisque c'est approuvé
            } catch (e) {
              _showError('Échec de l\'approbation: ${e.toString()}');
              setState(() {
                _isLoading = false;
              });
              return false;
            }
          } else {
            // Détails
            await HapticFeedback.mediumImpact();
            if (!mounted) return false;
            if (context.mounted) {
              await ApprovalDetailSheet.show(context, widget.request);
            }
            return false;
          }
        },
        child: GlassCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Type badge gradient
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
                      widget.request.entityType.toUpperCase(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${numberFormat.format(widget.request.entityAmount ?? 0)} FCFA',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.colors.brandPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.smd),
              Text(
                widget.request.entityLabel ?? 'Sans titre',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                'Demandé le ${DateFormat('dd MMM yyyy').format(widget.request.requestedAt)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: AppSpacing.smd),
              // Swipe hint
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.swipe_rounded,
                    size: AppSpacing.iconXs,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                  ),
                  const SizedBox(width: AppSpacing.xxs),
                  Text(
                    'Glisser pour agir',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
