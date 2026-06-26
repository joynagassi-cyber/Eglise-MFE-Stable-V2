// lib/core/widgets/async_button.dart
// AMÉLIORATION: Protection systématique contre le double-clic (double-submit).

import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'loading_dots.dart';


/// Un bouton qui gère automatiquement ses états de chargement (loading).
/// Empêche la soumission multiple tant que l'action asynchrone est en cours.
class AsyncButton extends StatefulWidget {
  final Future<void> Function() onPressed;
  final Widget child;
  final ButtonStyle? style;
  final bool isFullWidth;

  const AsyncButton({
    required this.onPressed,
    required this.child,
    this.style,
    this.isFullWidth = false,
    super.key,
  });

  @override
  State<AsyncButton> createState() => _AsyncButtonState();
}

class _AsyncButtonState extends State<AsyncButton> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final button = FilledButton(
      style: widget.style,
      onPressed: _loading ? null : _handle,
      child: _loading
          ? LoadingDots(size: 18, color: context.colors.textOnBrand)
          : widget.child,
    );

    if (widget.isFullWidth) {
      return SizedBox(
        width: double.infinity,
        child: button,
      );
    }

    return button;
  }

  Future<void> _handle() async {
    if (_loading) return;
    setState(() => _loading = true);
    try {
      await widget.onPressed();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}
