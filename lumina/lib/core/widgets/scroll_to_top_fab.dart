// lib/core/widgets/scroll_to_top_fab.dart
// FAB pour remonter en haut des listes longues

import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import '../animations/app_animations.dart';

/// FAB qui apparaît quand on scroll et permet de remonter en haut
class ScrollToTopFAB extends StatefulWidget {
  final ScrollController scrollController;
  final double showThreshold;
  final VoidCallback? onPressed;

  const ScrollToTopFAB({
    super.key,
    required this.scrollController,
    this.showThreshold = 200,
    this.onPressed,
  });

  @override
  State<ScrollToTopFAB> createState() => _ScrollToTopFABState();
}

class _ScrollToTopFABState extends State<ScrollToTopFAB>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: AppAnimations.fast,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: AppAnimations.elastic,
    );

    widget.scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_scrollListener);
    _animationController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    final shouldShow = widget.scrollController.offset > widget.showThreshold;

    if (shouldShow != _isVisible) {
      setState(() {
        _isVisible = shouldShow;
        if (_isVisible) {
          _animationController.forward();
        } else {
          _animationController.reverse();
        }
      });
    }
  }

  void _scrollToTop() {
    widget.onPressed?.call();
    widget.scrollController.animateTo(
      0,
      duration: AppAnimations.slow,
      curve: AppAnimations.emphasized,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: FloatingActionButton.small(
        onPressed: _scrollToTop,
        backgroundColor: context.colors.brandPrimary,
        foregroundColor: context.colors.textOnBrand,
        elevation: 4,
        child: Icon(Icons.keyboard_arrow_up_rounded),
      ),
    );
  }
}

/// Extension sur ScrollController pour faciliter l'ajout du FAB
extension ScrollControllerExtension on ScrollController {
  /// Crée un ScrollToTopFAB lié à ce controller
  Widget buildScrollToTopFAB({
    double showThreshold = 200,
    VoidCallback? onPressed,
  }) {
    return ScrollToTopFAB(
      scrollController: this,
      showThreshold: showThreshold,
      onPressed: onPressed,
    );
  }
}
