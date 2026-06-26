import "package:lumina/core/widgets/widgets.dart";
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumina/core/theme/lumina_design_system.dart';
import 'package:lumina/core/widgets/lumina_page.dart';

import '../providers/tutorial_provider.dart';
import '../../../../core/extensions/context_extension.dart';

class TutorialPage extends ConsumerWidget {
  const TutorialPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roleCode = ref.watch(currentRoleTutorialProvider);
    final tutorialAsync = ref.watch(tutorialProvider(roleCode));

    return LuminaPage(
      title: "Guide Rapide",
      body: tutorialAsync.when(
        data: (state) => SingleChildScrollView(
          padding: const EdgeInsets.all(LuminaDesign.paddingLg),
          child: Column(
            children: [
              _buildProgress(state),
              const SizedBox(height: 32),
              ...state.config.steps.map((s) => _StepCard(step: s, isDone: state.isStepCompleted(s.id))),
            ],
          ),
        ),
        loading: () => const LoadingState(),
        error: (e, _) => Center(child: Text("Erreur : $e")),
      ),
    );
  }

  Widget _buildProgress(TutorialState state) {
    return LuminaCard(
      color: LuminaDesign.primary.withOpacity(0.05),
      child: Column(
        children: [
          Text("VOTRE DÉCOUVERTE", style: LuminaDesign.labelOf(context)),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: state.progressPercentage,
            backgroundColor: context.colors.textTertiary.withOpacity(0.1),
            color: LuminaDesign.primary,
          ),
          const SizedBox(height: 8),
          Text("${(state.progressPercentage * 100).toInt()}% complété", style: LuminaDesign.labelOf(context)),
        ],
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  final dynamic step;
  final bool isDone;
  const _StepCard({required this.step, required this.isDone});

  @override
  Widget build(BuildContext context) {
    return LuminaCard(
      color: isDone ? Colors.green.withOpacity(0.05) : null,
      child: Row(
        children: [
          Icon(step.icon, color: isDone ? Colors.green : LuminaDesign.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(step.title, style: LuminaDesign.bodyLargeOf(context).copyWith(fontWeight: FontWeight.bold)),
                Text(step.description, style: LuminaDesign.labelOf(context)),
              ],
            ),
          ),
          if (isDone) const Icon(Icons.check_circle, color: Colors.green)
          else const Icon(Icons.play_circle_outline, color: LuminaDesign.primary),
        ],
      ),
    );
  }
}
