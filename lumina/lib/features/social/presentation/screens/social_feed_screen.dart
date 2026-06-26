import "package:lumina/core/widgets/widgets.dart";
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumina/core/router/app_routes.dart';
import 'package:lumina/core/theme/lumina_design_system.dart';
import 'package:lumina/core/widgets/lumina_page.dart';
import 'package:lumina/features/social/presentation/providers/social_providers.dart';
import 'package:lumina/features/social/presentation/widgets/social_horizontal_feed.dart';

import 'package:lumina/core/widgets/lumina_coach_mark.dart';
import 'package:lumina/core/services/tutorial_service.dart';
import '../../../../core/extensions/context_extension.dart';

class SocialFeedScreen extends ConsumerStatefulWidget {
  const SocialFeedScreen({super.key});

  @override
  ConsumerState<SocialFeedScreen> createState() => _SocialFeedScreenState();
}

class _SocialFeedScreenState extends ConsumerState<SocialFeedScreen> {
  final GlobalKey _prayerButtonKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showSocialTutorial();
    });
  }

  Future<void> _showSocialTutorial() async {
    final service = await ref.read(tutorialServiceProvider.future);
    if (!service.getCompletedSteps('social').contains('glow_button')) {
      if (!mounted) return;
      LuminaCoachMark.show(
        context,
        targets: [
          LuminaCoachMark.target(
            key: _prayerButtonKey,
            identify: "glow",
            title: "Action de Grâce",
            description: "Cliquez ici pour envoyer une prière lumineuse à votre frère ou sœur.",
            step: 1,
            total: 1,
          ),
        ],
        onFinish: () => service.markStepCompleted('social', 'glow_button'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final postsAsync = ref.watch(allPostsProvider);

    return LuminaPage(
      title: "Fil de Grâce",
      onRefresh: () async => ref.invalidate(allPostsProvider),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.communicationSocialCreate),
        label: const Text("Publier"),
        icon: const Icon(Icons.edit, color: Colors.white),
        backgroundColor: LuminaDesign.primary,
      ),
      body: postsAsync.when(
        data: (posts) {
          if (posts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.feed_outlined, size: 60, color: context.colors.textTertiary),
                  const SizedBox(height: 16),
                  Text("Aucune publication pour le moment", style: LuminaDesign.bodyLargeOf(context)),
                  LuminaButton(
                    label: "Partager une pensée", 
                    onPressed: () => context.push(AppRoutes.communicationSocialCreate)
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(LuminaDesign.paddingMd),
            itemCount: posts.length,
            itemBuilder: (ctx, i) {
              if (i == 0) {
                return Container(
                  key: _prayerButtonKey,
                  child: SocialHorizontalFeed(posts: posts),
                );
              }
              return SocialHorizontalFeed(posts: [posts[i]]);
            },
          );
        },
        loading: () => const LoadingState(),
        error: (e, _) => Center(child: Text("Erreur d'intercession : $e")),
      ),
    );
  }
}
