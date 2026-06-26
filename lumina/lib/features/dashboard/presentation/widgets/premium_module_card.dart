import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'dart:ui';
import 'package:lumina/core/theme/app_spacing.dart';
import '../../../../core/theme/app_animations.dart';
import 'package:lumina/core/widgets/widgets.dart';
import '../../../../core/utils/haptic_helper.dart';

class PremiumModuleCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Gradient gradient;
  final VoidCallback onTap;
  final int notificationCount;

  const PremiumModuleCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    required this.onTap,
    this.notificationCount = 0,
  });

  @override
  State<PremiumModuleCard> createState() => _PremiumModuleCardState();
}

class _PremiumModuleCardState extends State<PremiumModuleCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
//   final bool _isPressed = false; // UNUSED FIELD: _isPressed
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Start pulse animation for notification badge
    if (widget.notificationCount > 0) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(PremiumModuleCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.notificationCount > 0 && oldWidget.notificationCount == 0) {
      _pulseController.repeat(reverse: true);
    } else if (widget.notificationCount == 0 &&
        oldWidget.notificationCount > 0) {
      _pulseController.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasNotifications = widget.notificationCount > 0;

    return Semantics(
      label: '${widget.title}, ${widget.subtitle}',
      hint: hasNotifications
          ? '${widget.notificationCount} notifications non lues'
          : 'Ouvrir le module ${widget.title}',
      button: true,
      enabled: true,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: ElasticPressable(
          onTap: widget.onTap,
          hapticType: HapticFeedbackType.medium,
          child: AnimatedContainer(
            duration: AppAnimations.micro,
            curve: AppAnimations.defaultCurve,
            transform: _isHovered
                ? (Matrix4.identity()..translate(0.0, -6.0, 0.0))
                : Matrix4.identity(),
            child: Material(
              color: Colors.transparent,
              child: Stack(
                children: [
                  // Gradient background with enhanced effect
                  Ink(
                    decoration: BoxDecoration(
                      gradient: _getEnhancedGradient(),
                      borderRadius: BorderRadius.circular(24.0),
                      boxShadow: _isHovered
                          ? [
                              BoxShadow(
                                color: _getGlowColor().withOpacity(0.4),
                                blurRadius: 12.0,
                                offset: const Offset(0, 8),
                              ),
                            ]
                          : [],
                    ),
                    child: Container(
                      constraints: const BoxConstraints(
                        minHeight: AppSpacing.recommendedTouchTarget,
                        minWidth: AppSpacing.recommendedTouchTarget,
                      ),
                      padding: AppSpacing.cardPadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Icon container with glassmorphism
                          ClipRRect(
                            borderRadius: AppSpacing.borderRadiusLg,
                            child: BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaX: 4.0,
                                sigmaY: 4.0,
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(AppSpacing.smd),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimary
                                      .withValues(alpha: 0.25),
                                  borderRadius: AppSpacing.borderRadiusLg,
                                  border: Border.all(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary
                                        .withValues(
                                          alpha: 0.3,
                                        ),
                                    width: 1,
                                  ),
                                ),
                                child: Icon(
                                  widget.icon,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  size: 32,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: AppSpacing.md),
                          // Title and subtitle
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.4,
                                    ),
                              ),
                              SizedBox(height: AppSpacing.xs),
                              Text(
                                widget.subtitle,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary
                                          .withOpacity(0.7),
                                      fontStyle: FontStyle.italic,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Notification badge with pulse animation
                  if (hasNotifications)
                    Positioned(
                      top: AppSpacing.md,
                      right: AppSpacing.md,
                      child: AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: 1.0 + (_pulseController.value * 0.1),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.sm,
                                vertical: AppSpacing.xs,
                              ),
                              decoration: BoxDecoration(
                                color: context.colors.errorText,
                                borderRadius: AppSpacing.borderRadiusLg,
                                border: Border.all(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: context.colors.errorText.withValues(
                                      alpha: 0.5,
                                    ),
                                    blurRadius:
                                        8 + (_pulseController.value * 4),
                                    spreadRadius: _pulseController.value * 2,
                                  ),
                                ],
                              ),
                              child: Text(
                                widget.notificationCount > 99
                                    ? '99+'
                                    : widget.notificationCount.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Get enhanced gradient with 3+ colors
  Gradient _getEnhancedGradient() {
    // Extract colors from original gradient
    final colors = widget.gradient is LinearGradient
        ? (widget.gradient as LinearGradient).colors
        : [context.colors.brandPrimary, context.colors.brandPrimaryDark];

    if (colors.length < 2) {
      return widget.gradient;
    }

    // Create enhanced gradient with intermediate colors
    return LinearGradient(
      colors: [
        colors.first,
        Color.lerp(colors.first, colors.last, 0.5)!,
        colors.last,
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      stops: const [0.0, 0.5, 1.0],
    );
  }

  /// Get glow color from gradient
  Color _getGlowColor() {
    final colors = widget.gradient is LinearGradient
        ? (widget.gradient as LinearGradient).colors
        : [context.colors.brandPrimary];

    return colors.first.withValues(alpha: 0.3);
  }
}
