import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumina/core/theme/lumina_design_system.dart';
import 'package:lumina/core/utils/haptic_helper.dart';
import 'package:lumina/core/router/app_routes.dart';
import '../extensions/context_extension.dart';

/// Le conteneur standard pour tous les écrans Lumina 2.0.
/// Fournit une navigation sécurisée, une gestion d'erreur et une cohérence visuelle.
class LuminaPage extends ConsumerWidget {
  final Widget body;
  final String? title;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final bool showBackButton;
  final bool showHomeButton;
  final Widget? drawer;
  final bool extendBodyBehindAppBar;
  final Future<void> Function()? onRefresh;

  const LuminaPage({
    super.key,
    required this.body,
    this.title,
    this.actions,
    this.floatingActionButton,
    this.showBackButton = true,
    this.showHomeButton = true,
    this.drawer,
    this.extendBodyBehindAppBar = false,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: context.colors.bgPage,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      drawer: drawer,
      appBar: title != null || actions != null 
        ? AppBar(
            backgroundColor: extendBodyBehindAppBar ? Colors.transparent : context.colors.bgPage,
            elevation: 0,
            scrolledUnderElevation: 0, // Désactive l'effet de flou natif sur scroll
            centerTitle: false,
            title: title != null 
              ? Text(title!, style: LuminaDesign.h2Of(context).copyWith(fontSize: 18, fontWeight: FontWeight.bold)) 
              : null,
            leading: showBackButton && context.canPop()
              ? IconButton(
                  icon: Icon(Icons.arrow_back_ios_new_rounded, color: context.colors.textPrimary),
                  onPressed: () => context.pop(),
                )
              : null,
            actions: [
              ...?actions,
              if (showHomeButton)
                IconButton(
                  icon: Icon(Icons.home_rounded, color: LuminaDesign.primary),
                  onPressed: () {
                    HapticHelper.light();
                    context.go(AppRoutes.dashboard);
                  },
                ),
              SizedBox(width: 8),
            ],
          )
        : null,
      body: onRefresh != null
        ? RefreshIndicator(
            onRefresh: onRefresh!,
            color: LuminaDesign.primary,
            child: body,
          )
        : body,
      floatingActionButton: floatingActionButton,
    );
  }
}
