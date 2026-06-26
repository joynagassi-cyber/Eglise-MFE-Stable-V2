import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:go_router/go_router.dart';

class WorkInProgressScreen extends StatelessWidget {
  final String title;

  const WorkInProgressScreen({super.key, this.title = 'Bientôt disponible'});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction,
                size: 80, color: context.colors.brandPrimary.withValues(alpha: 0.5)),
            SizedBox(height: 20),
            Text(
              'Fonctionnalité en cours de développement',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              'Cette section sera bientôt disponible.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? context.colors.textSecondaryDark
                        : context.colors.textSecondaryLight,
                  ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => context.pop(),
              child: Text('Retour'),
            ),
          ],
        ),
      ),
    );
  }
}
