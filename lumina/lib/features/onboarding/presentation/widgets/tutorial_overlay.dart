import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:lumina/core/theme/lumina_colors_extension.dart';
import '../../../../core/utils/haptic_helper.dart';
import '../../../../core/widgets/glassmorphic_container.dart';
import 'shimmer_button.dart';

class TutorialOverlay {
  static void showDashboardTutorial(
    BuildContext context, {
    required GlobalKey membersKey,
    required GlobalKey financeKey,
    required GlobalKey eventsKey,
    required GlobalKey menuKey,
    VoidCallback? onFinish,
  }) {
    final targets = <TargetFocus>[
      TargetFocus(
        identify: "members",
        keyTarget: membersKey,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) => _buildContent(
              context,
              icon: Icons.people_outline,
              title: "Gestion des Membres",
              description:
                  "Accédez à la liste complète des membres, ajoutez de nouveaux membres et suivez leur parcours spirituel.",
              onNext: () {
                HapticHelper.light();
                controller.next();
              },
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: "finance",
        keyTarget: financeKey,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) => _buildContent(
              context,
              icon: Icons.account_balance_wallet_outlined,
              title: "Finances",
              description:
                  "Gérez les revenus et dépenses, consultez l'historique des transactions et générez des rapports financiers.",
              onNext: () {
                HapticHelper.light();
                controller.next();
              },
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: "events",
        keyTarget: eventsKey,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) => _buildContent(
              context,
              icon: Icons.event_outlined,
              title: "Événements",
              description:
                  "Créez et gérez les événements de l'église, suivez les présences et envoyez des rappels.",
              onNext: () {
                HapticHelper.light();
                controller.next();
              },
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: "menu",
        keyTarget: menuKey,
        alignSkip: Alignment.topLeft,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) => _buildContent(
              context,
              icon: Icons.menu,
              title: "Menu Principal",
              description:
                  "Accédez à toutes les fonctionnalités : groupes, célébrations, communications et paramètres.",
              onNext: () {
                HapticHelper.success();
                controller.next();
              },
              isLast: true,
            ),
          ),
        ],
      ),
    ];

    TutorialCoachMark(
      targets: targets,
      colorShadow: context.colors.premiumGradient.colors.first,
      paddingFocus: 10,
      opacityShadow: 0.8,
      onFinish: () {
        HapticHelper.success();
        onFinish?.call();
      },
      onSkip: () {
        HapticHelper.light();
        onFinish?.call();
        return true;
      },
    ).show(context: context);
  }

  static Widget _buildContent(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onNext,
    bool isLast = false,
  }) {
    return GlassmorphicContainer(
      blurRadius: 12.0,
      backgroundOpacity: 0.1,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: context.colors.bgOverlay,
              blurRadius: 12.0,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: context.colors.premiumGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: context.colors.textInverse, size: LuminaIcon.lg),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: context.colors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              description,
              style: TextStyle(
                fontSize: 15,
                height: 1.5,
                color: context.colors.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: ShimmerButton(
                text: isLast ? 'TERMINER' : 'SUIVANT',
                onPressed: onNext,
                icon: isLast ? Icons.check_circle_outline : Icons.arrow_forward,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
