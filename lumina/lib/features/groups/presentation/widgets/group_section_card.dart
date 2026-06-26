import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import '../../../../core/theme/app_typography.dart';
import 'package:lumina/core/widgets/widgets.dart';
/// Widget carte pour afficher une Section/Groupe dans le Dashboard
/// Utilisé pour les Ministères (Chorale, Jeunesse, etc.) avec leur budget propre
class GroupSectionCard extends StatelessWidget {
  final String name;
  final String? slug;
  final String? description;
  final int memberCount;
  final double? budgetAllocated;
  final double? budgetSpent;
  final String? leaderName;
  final VoidCallback? onTap;
  final VoidCallback? onViewBudget;
  final Color? accentColor;

  const GroupSectionCard({
    super.key,
    required this.name,
    this.slug,
    this.description,
    this.memberCount = 0,
    this.budgetAllocated,
    this.budgetSpent,
    this.leaderName,
    this.onTap,
    this.onViewBudget,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = accentColor ?? context.colors.brandPrimary;

    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: context.colors.borderSubtle.withValues(alpha: 0.5)),
      ),
      color: context.colors.bgCard,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête coloré
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color, color.withValues(alpha: 0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: AppTypography.labelLarge.copyWith(
                      color: context.colors.textInverse,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (leaderName != null)
                    Text(
                      'Responsable: $leaderName',
                      style: AppTypography.labelSmall.copyWith(
                        color: context.colors.textInverse.withValues(alpha: 0.9),
                      ),
                    ),
                ],
              ),
            ),

            // Corps
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nombre de membres
                  _buildInfoRow(context, Icons.group, '$memberCount membres'),

                  // Budget si disponible
                  if (budgetAllocated != null) ...[
                    SizedBox(height: 8),
                    _buildBudgetProgress(context, color),
                  ],

                  // Actions
                  if (onViewBudget != null) ...[
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          onPressed: onViewBudget,
                          icon: Icon(
                            Icons.account_balance_wallet,
                            size: LuminaIcon.sm,
                          ),
                          label: Text(
                            'Budget',
                            style: AppTypography.bodySmall,
                          ),
                          style: TextButton.styleFrom(
                            foregroundColor: color,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: LuminaIcon.sm, color: context.colors.textTertiary),
        SizedBox(width: 8),
        Text(
          text,
          style: AppTypography.bodySmall.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildBudgetProgress(BuildContext context, Color color) {
    final allocated = budgetAllocated ?? 0;
    final spent = budgetSpent ?? 0;
    final progress = allocated > 0 ? (spent / allocated).clamp(0.0, 1.0) : 0.0;
    final remaining = allocated - spent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Budget',
              style: AppTypography.labelSmall.copyWith(
                color: context.colors.textTertiary,
              ),
            ),
            Text(
              '${_formatAmount(spent)} / ${_formatAmount(allocated)} FCFA',
              style: AppTypography.labelSmall.copyWith(
                fontWeight: FontWeight.bold,
                color: context.colors.textPrimary,
              ),
            ),
          ],
        ),
        SizedBox(height: 4),
        AppProgressBar(
          value: progress,
          color: progress > 0.9 ? context.colors.errorText : color,
        ),
        SizedBox(height: 4),
        Text(
          remaining >= 0
              ? 'Reste: ${_formatAmount(remaining)} FCFA'
              : 'Dépassement: ${_formatAmount(remaining.abs())} FCFA',
          style: AppTypography.labelSmall.copyWith(
            fontWeight: FontWeight.w500,
            color: remaining >= 0 ? context.colors.successText : context.colors.errorText,
          ),
        ),
      ],
    );
  }

  String _formatAmount(double amount) {
    return amount.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]} ',
        );
  }
}
