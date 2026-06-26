import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_animations.dart';
import 'package:lumina/core/widgets/widgets.dart';
import '../../../../core/widgets/charts/animated_counter.dart';

class KPICard extends StatefulWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final String? change;
  final bool isLoading;
  final List<FlSpot>? sparklineData;
  final double? numericValue;
  final bool useDuoTone;
  final VoidCallback? onTap;
  const KPICard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.change,
    this.isLoading = false,
    this.sparklineData,
    this.numericValue,
    this.useDuoTone = false,
    this.onTap,
  });

  @override
  State<KPICard> createState() => _KPICardState();
}

class _KPICardState extends State<KPICard> with SingleTickerProviderStateMixin {
  late AnimationController _iconController;
  late Animation<double> _iconRotation;
  late Animation<double> _iconScale;
//   final bool _isHovered = false; // UNUSED FIELD: _isHovered

  @override
  void initState() {
    super.initState();
    _iconController = AnimationController(
      duration: AppAnimations.emphasis,
      vsync: this,
    );
    _iconRotation = Tween<double>(begin: 0, end: 0.1).animate(
      CurvedAnimation(parent: _iconController, curve: Curves.easeInOut),
    );
    _iconScale = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _iconController, curve: Curves.easeInOut),
    );

    // Trigger entrance animation
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _iconController.forward();
      }
    });
  }

  @override
  void dispose() {
    _iconController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Semantics(
        label:
            '${widget.label}: ${widget.value}${widget.change != null ? ', changement: ${widget.change}' : ''}',
        child: ElasticPressable(
          onTap: widget.onTap ?? () {},
          child: Stack(
            children: [
              // Sparkline background (if provided)
              if (widget.sparklineData != null)
                _buildSparklineBackground(context),

              // Premium Glassmorphic Card
              GlassCard(
                padding: const EdgeInsets.all(AppSpacing.lg),
                borderRadius: 32,
                showShine: true,
                child: widget.isLoading
                    ? _buildShimmer(context)
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Animated Icon Container (Solid Round)
                              AnimatedBuilder(
                                animation: _iconController,
                                builder: (context, child) {
                                  return Transform.rotate(
                                    angle: _iconRotation.value,
                                    child: Transform.scale(
                                      scale: _iconScale.value,
                                      child: Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: widget.color.withOpacity(0.1),
                                          shape: BoxShape.circle,
                                        ),
                                        child: widget.useDuoTone
                                            ? DuoToneIcon(
                                                icon: widget.icon,
                                                color: widget.color,
                                                size: 24,
                                                backgroundOpacity: 0.3,
                                              )
                                            : Icon(
                                                widget.icon,
                                                color: widget.color,
                                                size: 24,
                                              ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              if (widget.change != null)
                                _buildChangeBadge(context),
                            ],
                          ),
                          SizedBox(height: AppSpacing.lg),
                          Text(
                            widget.label,
                            style: AppTypography.labelMedium.copyWith(
                              color: context.colors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 4),
                          // Animated value counter
                          widget.numericValue != null
                              ? AnimatedCounter(
                                  value: widget.numericValue!,
                                  textStyle:
                                      AppTypography.headlineMedium.copyWith(
                                    fontWeight: FontWeight.w900,
                                    color: context.colors.textPrimary,
                                  ),
                                )
                              : Text(
                                  widget.value,
                                  style: AppTypography.headlineMedium.copyWith(
                                    fontWeight: FontWeight.w900,
                                    color: context.colors.textPrimary,
                                  ),
                                ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChangeBadge(BuildContext context) {
    final color = _getChangeColor(widget.change!);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getChangeIcon(widget.change!),
            color: color,
            size: 14,
          ),
          SizedBox(width: 4),
          Text(
            widget.change!,
            style: AppTypography.labelSmall.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSparklineBackground(BuildContext context) {
    return Positioned.fill(
      child: Opacity(
        opacity: 0.3,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: LineChart(
            LineChartData(
              gridData: const FlGridData(show: false),
              titlesData: const FlTitlesData(show: false),
              borderData: FlBorderData(show: false),
              lineTouchData: const LineTouchData(enabled: false),
              lineBarsData: [
                LineChartBarData(
                  spots: widget.sparklineData!,
                  isCurved: true,
                  color: widget.color.withValues(alpha: 0.6),
                  barWidth: 2,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [
                        widget.color.withValues(alpha: 0.2),
                        widget.color.withValues(alpha: 0.0),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmer(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.3),
                borderRadius: AppSpacing.borderRadiusLg,
              ),
            ),
            Container(
              width: 50,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.3),
                borderRadius: AppSpacing.borderRadiusSm,
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.md),
        Container(
          width: 80,
          height: 16,
          decoration: BoxDecoration(
            color: Colors.grey.withValues(alpha: 0.3),
            borderRadius: AppSpacing.borderRadiusSm,
          ),
        ),
        SizedBox(height: AppSpacing.xs),
        Container(
          width: 120,
          height: 24,
          decoration: BoxDecoration(
            color: Colors.grey.withValues(alpha: 0.3),
            borderRadius: AppSpacing.borderRadiusSm,
          ),
        ),
      ],
    );
  }

  Color _getChangeColor(String change) {
    if (change.startsWith('+')) {
      return context.colors.successText;
    } else if (change.startsWith('-')) {
      return context.colors.errorText;
    }
    return context.colors.textSecondary;
  }

  IconData _getChangeIcon(String change) {
    if (change.startsWith('+')) {
      return Icons.trending_up;
    } else if (change.startsWith('-')) {
      return Icons.trending_down;
    }
    return Icons.trending_flat;
  }
}
