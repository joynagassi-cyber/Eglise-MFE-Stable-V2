import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumina/core/theme/app_text.dart';
import 'package:lumina/core/widgets/widgets.dart';
import '../providers/enfants_providers.dart';

class MedicalAlertsWidget extends ConsumerWidget {
  const MedicalAlertsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardsAsync = ref.watch(safetyCardsNotifierProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Vigilance Sécurité & Médicale',
          style: AppText.h3(context),
        ),
        SizedBox(height: 12),
        cardsAsync.when(
          data: (cards) {
            final alertCards = cards
                .where((c) =>
                    c.allergies.isNotEmpty ||
                    (c.medicalInfo['critical'] ?? false))
                .toList();
            if (alertCards.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: const Color(0xFF10B981).withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle_outline, color: Color(0xFF10B981)),
                    SizedBox(width: 12),
                    Text('Aucun incident ou alerte critique.'),
                  ],
                ),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: alertCards.length,
              itemBuilder: (ctx, index) {
                final card = alertCards[index];
                return _buildAlertCard(ctx, card);
              },
            );
          },
          loading: () => Center(child: LoadingState()),
          error: (e, _) => Text('Error: $e'),
        ),
      ],
    );
  }

  Widget _buildAlertCard(BuildContext context, dynamic card) {
    final errorColor = context.colors.errorText;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: errorColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: errorColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: errorColor.withValues(alpha: 0.2),
            child: Icon(Icons.warning, color: errorColor, size: 20),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  card.memberId, // Replace with actual name if joined
                  style: AppText.bodyBold(context),
                ),
                Text(
                  'Allergies: ${card.allergies.join(", ")}',
                  style: AppText.caption(context).copyWith(color: errorColor),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: card.isActive
                  ? const Color(0xFF10B981).withOpacity(0.2)
                  : const Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              card.isActive ? 'PRÉSENT' : 'ABSENT',
              style: AppText.caption(context).copyWith(
                fontWeight: FontWeight.bold,
                color: card.isActive
                    ? const Color(0xFF10B981)
                    : const Color(0xFF757575),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
