// lib/core/widgets/pull_to_refresh.dart
// Pull-to-refresh premium avec animations personnalisées Lumina

import 'dart:async';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:lumina/core/theme/app_spacing.dart';
import 'app_progress_bar.dart';

/// Widget pull-to-refresh premium avec animation de feu
class FirePullToRefresh extends StatefulWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  final Color? backgroundColor;
  final Color? color;
  final String? message;

  const FirePullToRefresh({
    super.key,
    required this.child,
    required this.onRefresh,
    this.backgroundColor,
    this.color,
    this.message,
  });

  @override
  State<FirePullToRefresh> createState() => _FirePullToRefreshState();
}

class _FirePullToRefreshState extends State<FirePullToRefresh>
    with TickerProviderStateMixin {
  late AnimationController _sparkController;
  late Animation<double> _sparkAnimation;

  double _dragOffset = 0.0;
  bool _isRefreshing = false;
  static const double _refreshHeight = 100.0;

  @override
  void initState() {
    super.initState();

    _sparkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _sparkAnimation = CurvedAnimation(
      parent: _sparkController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _sparkController.dispose();
    super.dispose();
  }

  void _onPointerMove(PointerMoveEvent event) {
    if (_isRefreshing) return;

    setState(() {
      _dragOffset = (event.delta.dy * 0.5).clamp(0.0, _refreshHeight);
    });
  }

  void _onPointerUp(PointerUpEvent event) async {
    if (_isRefreshing) return;

    if (_dragOffset >= _refreshHeight * 0.6) {
      // Lancer le refresh
      setState(() {
        _isRefreshing = true;
      });

      // Démarrer l'animation de feu
      unawaited(_sparkController.repeat());

      // Attendre la fonction onRefresh
      await widget.onRefresh();

      // Arrêter l'animation
      setState(() {
        _isRefreshing = false;
        _dragOffset = 0.0;
      });
      _sparkController.stop();
      _sparkController.reset();
    } else {
      // Annuler
      setState(() {
        _dragOffset = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        widget.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor;

    return Stack(
      children: [
        Positioned.fill(
          child: widget.child,
        ),
        Positioned(
          top: -_refreshHeight + _dragOffset,
          left: 0,
          right: 0,
          height: _refreshHeight,
          child: _buildRefreshIndicator(backgroundColor),
        ),
        // Détecteur de gestes
        Positioned.fill(
          child: Listener(
            onPointerMove: _onPointerMove,
            onPointerUp: _onPointerUp,
            child: const SizedBox.expand(),
          ),
        ),
      ],
    );
  }

  Widget _buildRefreshIndicator(Color backgroundColor) {
    final progress = (_dragOffset / _refreshHeight).clamp(0.0, 1.0);

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(AppSpacing.radiusLg),
          bottomRight: Radius.circular(AppSpacing.radiusLg),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: progress * 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Effet de feu en arrière-plan
          if (progress > 0.0 || _isRefreshing) _buildFireEffect(progress),

          // Contenu du refresh
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo animé
              AnimatedBuilder(
                animation: _sparkAnimation,
                builder: (context, child) {
                  return Transform.rotate(
                    angle:
                        _isRefreshing ? _sparkAnimation.value * math.pi * 4 : 0,
                    child: Transform.scale(
                      scale: _isRefreshing
                          ? 1.0 +
                              (math.sin(_sparkAnimation.value * math.pi * 6) *
                                  0.1)
                          : 0.5 + (progress * 0.5),
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: context.colors.brandPrimaryGradient,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: context.colors.brandPrimary.withValues(
                                  alpha: _isRefreshing ? 0.5 : 0.3 * progress),
                              blurRadius: 12.0,
                              spreadRadius: _isRefreshing ? 2.0 : 1.0,
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/app_logo.png',
                            fit: BoxFit.cover,
                            opacity: AlwaysStoppedAnimation(
                                _isRefreshing ? 1.0 : progress),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              SizedBox(height: AppSpacing.md),

              // Texte
              AnimatedOpacity(
                duration: AppSpacing.animationFast,
                opacity: progress > 0.3 || _isRefreshing ? 1.0 : progress * 3.0,
                child: Text(
                  _isRefreshing
                      ? widget.message ?? 'Rechargement...'
                      : 'Tirez pour rafraîchir',
                  style: TextStyle(
                    color: context.colors.brandPrimary
                        .withValues(alpha: _isRefreshing ? 1.0 : progress),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              SizedBox(height: AppSpacing.sm),

              // Barre de progression
              if (_isRefreshing)
                AppProgressBar(
                  width: 40,
                  height: 2,
                  backgroundColor: context.colors.brandPrimary.withValues(alpha: 0.2),
                  color: context.colors.brandPrimary,
                )
              else
                Container(
                  width: 40 * progress,
                  height: 2,
                  decoration: BoxDecoration(
                    gradient: context.colors.brandPrimaryGradient,
                    borderRadius: AppSpacing.borderRadiusFull,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFireEffect(double progress) {
    return AnimatedBuilder(
      animation: _sparkAnimation,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: List.generate(8, (index) {
            final angle = (index * 45) * math.pi / 180;
            final scale = _isRefreshing
                ? 1.0 + (_sparkAnimation.value * 2.0)
                : 1.0 + (progress * 1.0);

            return Transform.translate(
              offset: Offset(
                math.cos(angle) * 40 * scale,
                math.sin(angle) * 40 * scale,
              ),
              child: Container(
                width: _isRefreshing ? 12 : 8,
                height: _isRefreshing ? 12 : 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: context.colors.brandSecondary.withValues(
                    alpha: _isRefreshing
                        ? (0.6 + _sparkAnimation.value * 0.4)
                        : (0.4 * progress),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

/// ScrollView avec pull-to-refresh intégré
class FireRefreshScrollView extends StatelessWidget {
  final List<Widget> children;
  final Future<void> Function() onRefresh;
  final ScrollController? controller;

  const FireRefreshScrollView({
    super.key,
    required this.children,
    required this.onRefresh,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return FirePullToRefresh(
      onRefresh: onRefresh,
      child: SingleChildScrollView(
        controller: controller,
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: children,
        ),
      ),
    );
  }
}
