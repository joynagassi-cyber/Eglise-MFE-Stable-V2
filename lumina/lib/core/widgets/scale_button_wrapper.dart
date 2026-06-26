import 'package:flutter/material.dart';
import '../utils/haptic_helper.dart';

/// Un wrapper qui ajoute un effet visuel de réduction (scale down)
/// lorsqu'on appuie sur le widget enfant.
///
/// Contrairement à [ElasticPressable], ce widget ne gère pas le `onTap`,
/// il laisse le widget enfant (ex: ElevatedButton, InkWell) gérer les événements de tap.
/// Il intercepte simplement les événements de pointeur pour l'animation.
class ScaleButtonWrapper extends StatefulWidget {
  final Widget child;
  final bool enabled;
  final double scaleFactor;
  final Duration duration;
  final bool enableHaptic;

  const ScaleButtonWrapper({
    super.key,
    required this.child,
    this.enabled = true,
    this.scaleFactor = 0.95,
    this.duration = const Duration(milliseconds: 100),
    this.enableHaptic = true,
  });

  @override
  State<ScaleButtonWrapper> createState() => _ScaleButtonWrapperState();
}

class _ScaleButtonWrapperState extends State<ScaleButtonWrapper>
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
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scaleFactor,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) {
        if (widget.enabled) {
          _controller.forward();
          if (widget.enableHaptic) {
            HapticHelper.light();
          }
        }
      },
      onPointerUp: (_) {
        if (widget.enabled) {
          _controller.reverse();
        }
      },
      onPointerCancel: (_) {
        if (widget.enabled) {
          _controller.reverse();
        }
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: widget.child,
      ),
    );
  }
}
