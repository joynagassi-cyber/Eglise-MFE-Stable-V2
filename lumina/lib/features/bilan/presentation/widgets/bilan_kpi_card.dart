import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import 'package:lumina/core/widgets/widgets.dart';
import '../../../finance/domain/services/currency_service.dart';

class BilanKpiCard extends StatelessWidget {
  final String title;
  final double? amount;
  final String? value;
  final IconData? icon;
  final Color color;

  const BilanKpiCard({
    required this.title,
    this.amount,
    this.value,
    this.icon,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final displayValue = amount != null
        ? CurrencyService.format(amount!, 'XAF').replaceAll(' FCFA', '')
        : value ?? '-';

    return Semantics(
      label: '$title: $displayValue ${amount != null ? 'FCFA' : ''}',
      child: AnimatedEntrance(
        child: GlassCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          borderColor: color,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon ?? _getIconForTitle(title),
                    size: 14,
                    color: color.withOpacity(0.8),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    title.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                      color: isDark
                          ? Colors.white70
                          : context.colors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                displayValue,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                  color: color,
                ),
              ),
              if (amount != null)
                Text(
                  'FCFA',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: color.withOpacity(0.6),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  static const Map<String, IconData> _iconMap = {
    'Revenus': Icons.trending_up_rounded,
    'Dépenses': Icons.trending_down_rounded,
    'Solde': Icons.account_balance_wallet_rounded,
    'Scellées': Icons.verified_user_rounded,
  };

  IconData _getIconForTitle(String title) {
    for (final entry in _iconMap.entries) {
      if (title.contains(entry.key)) return entry.value;
    }
    return Icons.insert_chart_outlined_rounded;
  }
}
