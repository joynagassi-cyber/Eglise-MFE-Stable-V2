import 'dart:ui';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import '../../../../core/theme/app_animations.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/charts/animated_counter.dart';
import '../providers/transaction_history_provider.dart';

class TransactionStatsCards extends StatelessWidget {
  final TransactionStats stats;

  const TransactionStatsCards({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _EnhancedStatCard(
            title: 'Revenus',
            value: stats.totalIncome,
            icon: Icons.arrow_downward,
            color: context.colors.successText,
            index: 0,
          ),
        ),
        SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _EnhancedStatCard(
            title: 'Dépenses',
            value: stats.totalExpense,
            icon: Icons.arrow_upward,
            color: context.colors.errorText,
            index: 1,
          ),
        ),
        SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _EnhancedStatCard(
            title: 'Solde',
            value: stats.balance,
            icon: Icons.account_balance_wallet,
            color:
                stats.balance >= 0 ? context.colors.brandPrimary : context.colors.warningText,
            index: 2,
          ),
        ),
      ],
    );
  }
}

class _EnhancedStatCard extends StatefulWidget {
  final String title;
  final double value;
  final IconData icon;
  final Color color;
  final int index;

  const _EnhancedStatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.index,
  });

  @override
  State<_EnhancedStatCard> createState() => _EnhancedStatCardState();
}

class _EnhancedStatCardState extends State<_EnhancedStatCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppAnimations.emphasis,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    _rotationAnimation = Tween<double>(
      begin: -0.1,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // Staggered entrance animation
    Future.delayed(AppAnimations.getStaggerDelay(widget.index), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.rotate(
            angle: _rotationAnimation.value,
            child: MouseRegion(
              onEnter: (_) => setState(() => _isHovered = true),
              onExit: (_) => setState(() => _isHovered = false),
              child: AnimatedContainer(
                duration: AppAnimations.micro,
                curve: AppAnimations.defaultCurve,
                transform: _isHovered
                    ? (Matrix4.identity()..translate(0.0, -2.0, 0.0))
                    : Matrix4.identity(),
                child: ClipRRect(
                  borderRadius: AppSpacing.borderRadiusCard,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            widget.color.withValues(
                              alpha: _isHovered ? 0.15 : 0.08,
                            ),
                            widget.color.withValues(
                              alpha: _isHovered ? 0.08 : 0.03,
                            ),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: AppSpacing.borderRadiusCard,
                        border: Border.all(
                          color: widget.color.withValues(
                            alpha: _isHovered ? 0.4 : 0.3,
                          ),
                          width: _isHovered ? 1.5 : 1,
                        ),
                        boxShadow: _isHovered
                            ? [
                                BoxShadow(
                                  color: widget.color.withValues(alpha: 0.2),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : AppSpacing.shadowSm,
                      ),
                      child: Column(
                        children: [
                          // Animated icon
                          Container(
                            padding: const EdgeInsets.all(AppSpacing.sm),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  widget.color.withValues(alpha: 0.2),
                                  widget.color.withValues(alpha: 0.1),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: AppSpacing.borderRadiusLg,
                              boxShadow: [
                                BoxShadow(
                                  color: widget.color.withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              widget.icon,
                              color: widget.color,
                              size: AppSpacing.iconMd,
                            ),
                          ),
                          SizedBox(height: AppSpacing.sm),
                          // Title
                          Text(
                            widget.title,
                            style: AppTypography.labelSmall.copyWith(
                              color: context.colors.textSecondary,
                            ),
                          ),
                          SizedBox(height: AppSpacing.xs),
                          // Animated value
                          AnimatedCurrencyCounter(
                            value: widget.value,
                            symbol: 'FCFA',
                            textStyle: AppTypography.labelMedium.copyWith(
                              color: widget.color,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
