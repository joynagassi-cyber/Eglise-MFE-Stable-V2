import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'dart:ui';
import 'dart:math' as math;
import '../../theme/app_durations.dart';
import '../../utils/haptic_helper.dart';

// Modèle de données pour les items de navigation
class FireNavItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  const FireNavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}

class FireFloatingNavBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<FireNavItem> items;
  final double horizontalMargin;
  final double bottomMargin;
  final double height;

  const FireFloatingNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.horizontalMargin = 24.0,
    this.bottomMargin = 24.0, // Un peu plus haut pour style "Floating"
    this.height = 72.0, // Un peu plus grand pour plus de présence
  }) : assert(items.length >= 2 && items.length <= 5,
            'FireFloatingNavBar requiert entre 2 et 5 items.');

  @override
  State<FireFloatingNavBar> createState() => _FireFloatingNavBarState();
}

class _FireFloatingNavBarState extends State<FireFloatingNavBar>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _rotationAnims;
  late List<Animation<double>> _waveAnims;
  late List<Animation<double>> _scaleAnims;

  // Animation activée quand on change d'onglet (pill navigation)
  late AnimationController _pillCtrl;
  late Animation<double> _pillAnim;

  int _prevIndex = 0;

  @override
  void initState() {
    super.initState();
    _prevIndex = widget.currentIndex;

    // Contrôleurs individuels pour chaque icône (pour l'effet Wave au tap)
    _controllers = List.generate(widget.items.length, (index) {
      return AnimationController(
        duration: AppDurations.floatingNavWave,
        vsync: this,
      );
    });

    _rotationAnims = _controllers.map((ctrl) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: ctrl, curve: Curves.elasticOut),
      );
    }).toList();

    _waveAnims = _controllers.map((ctrl) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: ctrl, curve: Curves.easeOutExpo),
      );
    }).toList();

    _scaleAnims = _controllers.map((ctrl) {
      return TweenSequence<double>([
        TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.8), weight: 30),
        TweenSequenceItem(tween: Tween(begin: 0.8, end: 1.1), weight: 40),
        TweenSequenceItem(tween: Tween(begin: 1.1, end: 1.0), weight: 30),
      ]).animate(CurvedAnimation(parent: ctrl, curve: Curves.easeInOut));
    }).toList();

    // Contrôleur pour l'animation de translation de la pilule active
    // Note: Dans cette version simplifiée, la pilule est dessinée par item,
    // mais on pourrait l'animer globalement. Ici on anime l'apparition/disparition.
    _pillCtrl = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _pillAnim = CurvedAnimation(parent: _pillCtrl, curve: Curves.easeInOut);
    _pillCtrl.forward();
  }

  @override
  void didUpdateWidget(covariant FireFloatingNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentIndex != oldWidget.currentIndex) {
      _prevIndex = oldWidget.currentIndex;
      _controllers[widget.currentIndex].forward(from: 0.0);
      _pillCtrl.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    for (var ctrl in _controllers) {
      ctrl.dispose();
    }
    _pillCtrl.dispose();
    super.dispose();
  }

  void _onTap(int index) {
    HapticHelper.selection(); // Feedback haptique
    if (widget.currentIndex == index) {
      // Re-tap animation
      _controllers[index].forward(from: 0.0);
      return;
    }
    widget.onTap(index);
  }

  @override
  Widget build(BuildContext context) {
    // Calcul de la padding du bas pour les iphones X+
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Couleurs basées sur le thème
    final cardColor = isDark
        ? context.colors.bgCard.withOpacity(0.92)
        : context.colors.bgCardLight.withOpacity(0.92);
    // Supposons une couleur "surface" si non dispo
    final surfaceColor = isDark
        ? context.colors.bgCardDark.withOpacity(0.88)
        : context.colors.bgCardLight.withOpacity(0.88);
    final borderColor = isDark
        ? Theme.of(context).colorScheme.onSurface.withOpacity(0.10)
        : Theme.of(context).colorScheme.onSurface.withOpacity(0.05);
    final shadowColor1 =
        Theme.of(context).colorScheme.shadow.withOpacity(isDark ? 0.45 : 0.15);
    final shadowColor2 = context.colors.brandPrimary.withOpacity(0.12);

    return Padding(
      padding: EdgeInsets.only(
        left: widget.horizontalMargin,
        right: widget.horizontalMargin,
        bottom: widget.bottomMargin + bottomPadding,
      ),
      child: RepaintBoundary(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.height / 2),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
            child: Container(
              height: widget.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    cardColor,
                    surfaceColor,
                  ],
                ),
                borderRadius: BorderRadius.circular(widget.height / 2),
                border: Border.all(
                  color: borderColor,
                  width: 0.8,
                ),
                boxShadow: [
                  BoxShadow(
                    color: shadowColor1,
                    blurRadius: 12.0,
                    offset: const Offset(0, 12),
                    spreadRadius: -4,
                  ),
                  BoxShadow(
                    color: shadowColor2,
                    blurRadius: 12.0,
                    offset: const Offset(0, 4),
                    spreadRadius: -8,
                  ),
                ],
              ),
              child: Row(
                children: List.generate(widget.items.length, (index) {
                  return Expanded(
                    child: _NavTabItem(
                      item: widget.items[index],
                      isActive: index == widget.currentIndex,
                      rotationAnim: _rotationAnims[index],
                      waveAnim: _waveAnims[index],
                      scaleAnim: _scaleAnims[index],
                      pillAnim: index == widget.currentIndex ? _pillAnim : null,
                      rotationDirection: _prevIndex < index ? 1 : -1,
                      onTap: () => _onTap(index),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavTabItem extends StatelessWidget {
  final FireNavItem item;
  final bool isActive;
  final Animation<double> rotationAnim;
  final Animation<double> waveAnim;
  final Animation<double> scaleAnim;
  final Animation<double>? pillAnim; // null si inactif
  final int rotationDirection; // +1 horaire, -1 anti-horaire
  final VoidCallback onTap;

  const _NavTabItem({
    required this.item,
    required this.isActive,
    required this.rotationAnim,
    required this.waveAnim,
    required this.scaleAnim,
    required this.rotationDirection,
    required this.onTap,
    this.pillAnim,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: Listenable.merge([
          rotationAnim,
          waveAnim,
          scaleAnim,
          if (pillAnim != null) pillAnim!
        ]),
        builder: (context, _) {
          return Stack(
            alignment: Alignment.center,
            children: [
              _buildWave(context),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildPill(context),
                  SizedBox(height: 6), // Espace
                  _buildIcon(context),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildIcon(BuildContext context) {
    // Rotation légère lors de l'activation
    // Si isActive, on peut appliquer une rotation complète ou partielle
    final double rotationValue = isActive
        ? rotationAnim.value * 1.0 * rotationDirection
        : 0.0; // 0 à 1 tour ? Non, juste un petit tilt

    // On va faire un effet plus subtil: shake ou scale
    // Mais suivons le design: rotationAnimation est là.
    // Disons une rotation de 20 degrés * value
    final double angle = rotationValue * (math.pi / 180 * 20);

    return Transform.scale(
      scale: scaleAnim.value,
      child: Transform.rotate(
        angle: angle,
        child: Icon(
          isActive ? item.selectedIcon : item.icon,
          color: isActive
              ? context.colors.brandPrimary
              : context.colors.textSecondaryLight.withOpacity(
                  0.6), // Adapt based on Theme dynamically if needed
          size: 26,
        ),
      ),
    );
  }

  Widget _buildPill(BuildContext context) {
    if (!isActive || pillAnim == null) return SizedBox(height: 4);

    return Opacity(
      opacity: pillAnim!.value,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.8, end: 1.2),
        duration: const Duration(milliseconds: 1500),
        curve: Curves.easeInOut,
        builder: (context, pulse, child) {
          return Container(
            width: 20 * pillAnim!.value,
            height: 4,
            decoration: BoxDecoration(
              color: context.colors.brandPrimary,
              borderRadius: BorderRadius.circular(2),
              boxShadow: [
                BoxShadow(
                  color: context.colors.brandPrimary.withOpacity(0.4 * pulse),
                  blurRadius: 6 * pulse,
                  spreadRadius: 1 * (pulse - 1.0) * 5,
                  offset: const Offset(0, 2),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildWave(BuildContext context) {
    // Effet d'onde derrière l'icone au tap
    if (waveAnim.value <= 0.01 || waveAnim.isCompleted) {
      return const SizedBox.shrink();
    }

    return Opacity(
      opacity: (1.0 - waveAnim.value).clamp(0.0, 1.0),
      child: Container(
        width: 40 + (waveAnim.value * 20),
        height: 40 + (waveAnim.value * 20),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: context.colors.brandPrimary.withOpacity(0.1),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Scaffold spécial pour intégrer le FloatingNav
// -----------------------------------------------------------------------------
class FireFloatingNavScaffold extends StatelessWidget {
  final Widget body;
  final FireFloatingNavBar navBar;
  final bool extendBody;

  const FireFloatingNavScaffold({
    super.key,
    required this.body,
    required this.navBar,
    this.extendBody =
        true, // Par défaut true pour que le contenu passe sous la nav
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: extendBody,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Le contenu principal
          body,

          // 2. La NavBar positionnée en bas
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: navBar,
          ),
        ],
      ),
    );
  }
}
