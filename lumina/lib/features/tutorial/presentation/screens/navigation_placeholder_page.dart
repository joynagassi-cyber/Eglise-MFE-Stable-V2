import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:go_router/go_router.dart';

/// Page placeholder pour les routes non encore implémentées.
/// Affichée lorsqu'un tutoriel pointe vers une fonctionnalité en développement.
class NavigationPlaceholderPage extends StatelessWidget {
  final String? featureName;

  const NavigationPlaceholderPage({
    super.key,
    this.featureName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.bgPage,
      appBar: AppBar(
        title: Text(featureName ?? 'En développement'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: context.colors.brandPrimary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Icon(Icons.construction_rounded,
                  size: 64,
                  color: context.colors.brandPrimary,
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Cette fonctionnalité\narrive bientôt !',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: context.colors.textPrimary,
                  height: 1.3,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Nous travaillons activement sur cette section. '
                'Elle sera disponible dans une prochaine mise à jour.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: context.colors.textSecondary,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 32),
              SizedBox(
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () => context.pop(),
                  icon: Icon(Icons.arrow_back_rounded),
                  label: Text(
                    'Retour au tutoriel',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colors.brandPrimary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
