import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import '../../domain/entities/mutual_aid_request.dart';
import 'package:lumina/core/theme/app_typography.dart';
import 'package:lumina/core/theme/app_spacing.dart';
class RequestCard extends StatelessWidget {
  final MutualAidRequest request;

  const RequestCard({
    super.key,
    required this.request,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = request.status == 'active' ? context.colors.infoText : context.colors.textSecondary;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colors.bgCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusColor.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _getTypeColor(context, request.type).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  request.type.toUpperCase(),
                  style: AppTypography.tiny.copyWith(
                    color: _getTypeColor(context, request.type),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Spacer(),
              Text(
                request.status,
                style: AppTypography.tiny.copyWith(color: statusColor),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            request.description ?? "Pas de description",
            style: AppTypography.labelMedium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.comment_rounded,
                size: 14,
                color: context.colors.textSecondary,
              ),
              SizedBox(width: 4),
              Text(
                '${request.responsesCount} réponses',
                style: AppTypography.tiny,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getTypeColor(BuildContext context, String type) {
    switch (type) {
      case 'financial':
        return context.colors.successText;
      case 'material':
        return context.colors.warningText;
      case 'emotional':
        return context.colors.brandPrimary;
      case 'practical':
        return context.colors.infoText;
      default:
        return context.colors.textSecondary;
    }
  }
}
