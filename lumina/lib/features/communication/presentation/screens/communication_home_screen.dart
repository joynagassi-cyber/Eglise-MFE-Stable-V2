import 'package:flutter/material.dart';
import 'package:lumina/core/theme/app_spacing.dart';
// import 'package:lumina/core/extensions/context_extension.dart';
import 'package:lumina/core/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

class CommunicationHomeScreen extends StatelessWidget {
  const CommunicationHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
//     final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Communication'),
      ),
      body: GridView.count(
        padding: AppSpacing.screenPadding,
        crossAxisCount: 2,
        mainAxisSpacing: AppSpacing.md,
        crossAxisSpacing: AppSpacing.md,
        children: [
          _buildHubCard(
            context,
            title: 'Annonces',
            icon: Icons.announcement_rounded,
            color: Colors.orange,
            onTap: () => context.push('/communication/annonces'),
          ),
          _buildHubCard(
            context,
            title: 'Messages',
            icon: Icons.message_rounded,
            color: Colors.blue,
            onTap: () => context.push('/communication/messaging'),
          ),
          _buildHubCard(
            context,
            title: 'Flux Social',
            icon: Icons.share_rounded,
            color: Colors.pink,
            onTap: () => context.push('/communication/social'),
          ),
          _buildHubCard(
            context,
            title: 'Tâches',
            icon: Icons.task_alt_rounded,
            color: Colors.green,
            onTap: () => context.push('/communication/tasks'),
          ),
        ],
      ),
    );
  }

  Widget _buildHubCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: AppSpacing.sm),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
