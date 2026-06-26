// lib/features/admin/presentation/screens/church_list_screen.dart
// Écran de gestion de la liste des églises (Admin)

import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:lumina/core/widgets/widgets.dart';
class ChurchListScreen extends StatelessWidget {
  const ChurchListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des Églises'),
      ),
      body: const EmptyState(
        icon: Icons.church_outlined,
        title: 'Liste des églises',
        subtitle: 'Ce module est en cours de développement.',
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implémenter l'ajout d'église
        },
        backgroundColor: context.colors.brandPrimary,
        child: const Icon(Icons.add),
      ),
    );
  }
}
