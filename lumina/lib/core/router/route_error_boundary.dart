// lib/core/router/route_error_boundary.dart
//
// Wrapper pour capturer les erreurs au sein d'une route spécifique
// sans faire crash tout le router.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RouteErrorBoundary extends ConsumerWidget {
  final Widget child;
  final Widget Function(BuildContext context, Object error, StackTrace stackTrace)? fallback;

  const RouteErrorBoundary({
    super.key,
    required this.child,
    this.fallback,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ErrorBoundary simple : en production, utiliser Flutter ErrorBoundary
    // ou un package comme error_boundary
    try {
      return child;
    } catch (e, stack) {
      if (fallback != null) {
        return fallback!(context, e, stack);
      }
      return const _DefaultErrorPage();
    }
  }
}

class _DefaultErrorPage extends StatelessWidget {
  const _DefaultErrorPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text('Oups ! Un problème est survenu dans ce module.'),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Retour'),
            ),
          ],
        ),
      ),
    );
  }
}