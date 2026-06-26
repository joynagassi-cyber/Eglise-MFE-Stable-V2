// lib/core/widgets/apple_style_widgets.dart
import 'dart:ui';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import '../utils/haptic_helper.dart';
import 'duo_tone_icon.dart';

/// Un AppBar avec effet de verre dépoli (Glassmorphism) style iOS
class GlassAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final double elevation;
  final Color? backgroundColor;
  final double blur;

  const GlassAppBar({
    super.key,
    this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.elevation = 0,
    this.backgroundColor,
    this.blur = 15.0,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: AppBar(
          title: title,
          actions: actions,
          leading: leading,
          centerTitle: centerTitle,
          elevation: elevation,
          scrolledUnderElevation: 0,
          backgroundColor: (backgroundColor ?? context.colors.bgPage)
              .withValues(alpha: isDark ? 0.7 : 0.8),
          systemOverlayStyle:
              isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Un wrapper qui ajoute un effet de rebond (élasticité) et haptique au toucher
class ElasticPressable extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double scaleFactor;
  final Duration duration;
  final HapticFeedbackType hapticType;

  const ElasticPressable({
    super.key,
    required this.child,
    this.onTap,
    this.scaleFactor = 0.96,
    this.duration = const Duration(milliseconds: 100),
    this.hapticType = HapticFeedbackType.light,
  });

  @override
  State<ElasticPressable> createState() => _ElasticPressableState();
}

class _ElasticPressableState extends State<ElasticPressable>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    _scaleAnimation =
        Tween<double>(begin: 1.0, end: widget.scaleFactor).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
    _triggerHaptic();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  void _triggerHaptic() {
    switch (widget.hapticType) {
      case HapticFeedbackType.light:
        HapticHelper.light();
        break;
      case HapticFeedbackType.medium:
        HapticHelper.medium();
        break;
      case HapticFeedbackType.heavy:
        HapticHelper.heavy();
        break;
      default:
        HapticHelper.selection();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.onTap != null ? _onTapDown : null,
      onTapUp: widget.onTap != null ? _onTapUp : null,
      onTapCancel: widget.onTap != null ? _onTapCancel : null,
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: widget.child,
      ),
    );
  }
}

/// Une barre de navigation flottante avec effet de verre dépoli
class PremiumBottomBar extends StatelessWidget {
  final List<BottomNavigationBarItem> items;
  final int currentIndex;
  final Function(int) onTap;
  final Widget? middleAction;

  const PremiumBottomBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    this.middleAction,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final int halfLen = (items.length / 2).floor();

    return Container(
      padding: const EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        bottom: AppSpacing.lg,
        top: AppSpacing.xs,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
          child: Container(
            height: 72,
            decoration: BoxDecoration(
              color: (isDark
                      ? Theme.of(context).colorScheme.surface
                      : Theme.of(context).colorScheme.surface)
                  .withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: (isDark
                        ? Theme.of(context).colorScheme.onSurface
                        : Theme.of(context).colorScheme.onSurface)
                    .withValues(alpha: 0.1),
                width: 0.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 12.0,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Première moitié des items
                ...List.generate(
                    halfLen, (index) => _buildItem(context, index, isDark)),

                // Bouton d'action central
                if (middleAction != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: middleAction!,
                  ),

                // Deuxième moitié des items
                ...List.generate(items.length - halfLen, (index) {
                  final actualIndex = index + halfLen;
                  return _buildItem(context, actualIndex, isDark);
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index, bool isDark) {
    final isSelected = currentIndex == index;
    final item = items[index];
    final onSurfaceColor = Theme.of(context).colorScheme.onSurface;

    Widget displayIcon;
    if (item.icon is DuoToneIcon) {
      final duoIcon = item.icon as DuoToneIcon;
      displayIcon = DuoToneIcon(
        icon: duoIcon.icon,
        backgroundIcon: duoIcon.backgroundIcon,
        size: 26,
        color: isSelected
            ? context.colors.brandPrimary
            : (isDark
                ? onSurfaceColor.withValues(alpha: 0.6)
                : onSurfaceColor.withValues(alpha: 0.54)),
        backgroundOpacity: duoIcon.backgroundOpacity,
        isFlamboyant: duoIcon.isFlamboyant,
      );
    } else {
      displayIcon = Icon(
        isSelected
            ? _getSelectedIcon(item.icon)
            : (item.icon is Icon ? (item.icon as Icon).icon : Icons.help),
        color: isSelected
            ? context.colors.brandPrimary
            : (isDark
                ? onSurfaceColor.withValues(alpha: 0.6)
                : onSurfaceColor.withValues(alpha: 0.54)),
        size: 26,
      );
    }

    return ElasticPressable(
      onTap: () => onTap(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSelected
                  ? context.colors.brandPrimary.withValues(alpha: 0.15)
                  : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: displayIcon,
          ),
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 2),
              width: 4,
              height: 4,
              decoration: BoxDecoration(color: context.colors.brandPrimary,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }

  IconData _getSelectedIcon(Widget icon) {
    if (icon is Icon) {
      return icon.icon ?? Icons.help;
    }
    if (icon is DuoToneIcon) {
      return icon.icon;
    }
    return Icons.help;
  }
}
