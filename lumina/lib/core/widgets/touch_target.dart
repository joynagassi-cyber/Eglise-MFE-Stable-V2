// lib/core/widgets/touch_target.dart
// Widget helper pour garantir les touch targets minimums (Accessibilité)

import 'package:flutter/material.dart';

/// Wrapper pour garantir un touch target minimum de 44x44px (WCAG 2.1 Level AAA)
///
/// Utilisation:
/// ```dart
/// TouchTarget(
///   child: Icon(Icons.close, size: 20),
/// )
/// ```
class TouchTarget extends StatelessWidget {
  final Widget child;
  final double minSize;

  const TouchTarget({
    super.key,
    required this.child,
    this.minSize = 56.0, // Lumina standard
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: minSize,
        minHeight: minSize,
      ),
      child: Center(child: child),
    );
  }
}

/// Extension pour faciliter l'usage
extension TouchTargetExtension on Widget {
  /// Enveloppe le widget dans un TouchTarget
  Widget withTouchTarget({double minSize = 56.0}) {
    return TouchTarget(
      minSize: minSize,
      child: this,
    );
  }
}
