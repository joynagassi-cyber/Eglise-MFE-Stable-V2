// lib/features/dashboard/presentation/screens/equipe_screen.dart
import 'package:flutter/material.dart';
import 'package:lumina/core/widgets/widgets.dart';
class EquipeScreen extends StatelessWidget {
  const EquipeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion d\'Équipe'),
      ),
      body: const EmptyState(
        icon: Icons.groups_outlined,
        title: 'Gestion d\'Équipe',
        subtitle: 'Ce module est en cours de développement.',
      ),
    );
  }
}