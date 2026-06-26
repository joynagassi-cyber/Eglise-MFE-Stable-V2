import "package:lumina/core/widgets/widgets.dart";
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumina/core/theme/lumina_design_system.dart';
import 'package:lumina/core/widgets/lumina_page.dart';
import 'package:lumina/core/widgets/spiritual_timeline.dart';
import 'package:lumina/features/vie-spirituelle/data/repositories/jalons_repository.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/extensions/context_extension.dart';

class EtapesSpirituellesScreen extends ConsumerWidget {
  const EtapesSpirituellesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jalonsAsync = ref.watch(jalonsProvider);
    final mesJalonsAsync = ref.watch(membreJalonsProvider);

    return LuminaPage(
      title: "Parcours de Croissance",
      onRefresh: () async {
        ref.invalidate(jalonsProvider);
        ref.invalidate(membreJalonsProvider);
      },
      body: jalonsAsync.when(
        data: (jalons) {
          if (jalons.isEmpty) return Center(child: Text("Aucun jalon défini."));

          // Préparation des noeuds de la timeline
          final timelineNodes = jalons.map((j) {
            final monJalon = mesJalonsAsync.valueOrNull?.where((m) => m.jalonId == j.id).firstOrNull;
            
            return TimelineNode(
              title: j.displayTitre,
              description: j.displayDescription,
              icon: j.iconData,
              isAchieved: monJalon != null,
              date: monJalon?.displayDate,
              color: j.color,
            );
          }).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(LuminaDesign.paddingLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- INTRO ---
                Text(
                  "VOTRE HISTOIRE AVEC DIEU",
                  style: LuminaDesign.labelOf(context).copyWith(color: LuminaDesign.primary),
                ).animate().fadeIn().slideX(begin: -0.2),
                SizedBox(height: 8),
                Text(
                  "Chaque étape est une victoire de la foi.",
                  style: LuminaDesign.bodyLargeOf(context).copyWith(color: context.colors.textSecondary),
                ).animate().fadeIn(delay: 200.ms),
                
                SizedBox(height: 48),

                // --- TIMELINE ---
                SpiritualTimeline(nodes: timelineNodes)
                  .animate()
                  .fadeIn(delay: 400.ms)
                  .slideY(begin: 0.1),
                  
                SizedBox(height: 100),
              ],
            ),
          );
        },
        loading: () => const LoadingState(),
        error: (e, _) => Center(child: Text("Erreur : $e")),
      ),
    );
  }
}
