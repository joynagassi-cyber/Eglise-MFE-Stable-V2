import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import 'loading_dots.dart';

/// État de chargement standardisé avec shimmer effect.
///
/// Bonnes pratiques (NN/g + Material) :
/// - Le shimmer ne s'affiche qu'après [delay] (défaut 400ms) pour éviter
///   le "flash" quand le chargement est rapide (< 1s, jugé comme un bug
///   par l'utilisateur). En dessous du seuil, on renvoie [fastPlaceholder]
///   (ou rien), jamais un skeleton.
/// - Les couleurs proviennent des tokens sémantiques `shimmerBase` /
///   `shimmerHighlight` du design system, qui sont correctement contrastés
///   en light ET dark (ne jamais utiliser `bgCardElevated` qui devient
///   quasi-noir en dark mode).
class LoadingState extends StatefulWidget {
  final String? message;
  final bool useShimmer;
  final Widget? skeleton;

  /// Contenu affiché immédiatement (avant [delay]). Utile pour montrer la
  /// structure du dashboard sans flash. Si null, on garde un container vide.
  final Widget? fastPlaceholder;

  /// Délai avant d'afficher le skeleton. défaut 400ms (anti-flash NN/g).
  /// Mettre Duration.zero pour l'ancien comportement immédiat.
  final Duration delay;

  const LoadingState({
    super.key,
    this.message,
    this.useShimmer = true,
    this.skeleton,
    this.fastPlaceholder,
    this.delay = const Duration(milliseconds: 400),
  });

  @override
  State<LoadingState> createState() => _LoadingStateState();
}

class _LoadingStateState extends State<LoadingState> {
  bool _showSkeleton = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.delay == Duration.zero) {
      _showSkeleton = true;
    } else {
      // On ne montre le skeleton QUE si le chargement dure plus de [delay].
      // Cela évite le flash perçu comme un bug pour les chargements < 1s.
      _timer = Timer(widget.delay, () {
        if (mounted) setState(() => _showSkeleton = true);
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.skeleton != null && _showSkeleton) {
      return widget.skeleton!;
    }

    // Phase "rapide" : on n'a pas encore atteint le délai.
    if (!_showSkeleton) {
      return widget.fastPlaceholder ?? const SizedBox.shrink();
    }

    if (widget.skeleton != null) {
      return widget.skeleton!;
    }

    if (widget.useShimmer) {
      return const _ShimmerLoadingList();
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const LoadingDots(size: 32),
            if (widget.message != null) ...[
              SizedBox(height: AppSpacing.md),
              Text(
                widget.message!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: context.colors.textSecondaryLight,
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Shimmer loading pour les listes
class _ShimmerLoadingList extends StatefulWidget {
  const _ShimmerLoadingList();

  @override
  State<_ShimmerLoadingList> createState() => _ShimmerLoadingListState();
}

class _ShimmerLoadingListState extends State<_ShimmerLoadingList>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // FIX: utiliser les tokens sémantiques dédiés shimmerBase / shimmerHighlight
    // (déjà correctement contrastés en light ET dark dans le design system).
    // Auparavant on utilisait bgCardElevated.withValues(alpha: 0.3) qui rendait
    // le skeleton quasi-invisible en dark mode → bug "page noire".
    final baseColor = context.colors.shimmerBase;
    final highlightColor = context.colors.shimmerHighlight;

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: 5,
      separatorBuilder: (_, __) => SizedBox(height: AppSpacing.smd),
      itemBuilder: (context, index) {
        return AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Container(
              height: 80,
              decoration: BoxDecoration(
                color: baseColor,
                borderRadius: AppSpacing.borderRadiusCard,
                border: Border.all(
                  color: context.colors.borderSubtle,
                ),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: AppSpacing.borderRadiusCard,
                      child: ShaderMask(
                        shaderCallback: (bounds) {
                          return LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              baseColor,
                              highlightColor,
                              baseColor,
                            ],
                            stops: [
                              _animation.value - 0.4,
                              _animation.value,
                              _animation.value + 0.4,
                            ],
                          ).createShader(bounds);
                        },
                        child: Container(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

/// Skeleton pour card individuelle.
///
/// Utilise les tokens sémantiques du design system (shimmerBase/shimmerHighlight)
/// pour rester visible en light ET dark mode.
class SkeletonCard extends StatelessWidget {
  final double? height;
  final double? width;

  const SkeletonCard({
    super.key,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 100,
      width: width,
      decoration: BoxDecoration(
        color: context.colors.shimmerBase,
        borderRadius: AppSpacing.borderRadiusCard,
      ),
    );
  }
}

/// Bloc de shimmer réutilisable (boîte arrondie avec animation).
///
/// Usage :
/// ```dart
/// ShimmerBox(width: 120, height: 16) // ligne de texte
/// ShimmerBox(width: 60, height: 60, shape: BoxShape.circle) // avatar
/// ```
class ShimmerBox extends StatefulWidget {
  final double? width;
  final double height;
  final BorderRadius? borderRadius;
  final BoxShape shape;

  /// Durée d'un cycle de balayage. Défaut 1500ms (recommandation NN/g).
  final Duration duration;

  const ShimmerBox({
    super.key,
    this.width,
    required this.height,
    this.borderRadius,
    this.shape = BoxShape.rectangle,
    this.duration = const Duration(milliseconds: 1500),
  });

  @override
  State<ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<ShimmerBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = context.colors.shimmerBase;
    final highlightColor = context.colors.shimmerHighlight;
    final radius = widget.borderRadius ??
        (widget.shape == BoxShape.circle
            ? BorderRadius.circular(widget.height / 2)
            : BorderRadius.circular(8));

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: baseColor,
            borderRadius: widget.shape == BoxShape.circle ? null : radius,
            shape: widget.shape,
          ),
          foregroundDecoration: BoxDecoration(
            borderRadius: widget.shape == BoxShape.circle ? null : radius,
            shape: widget.shape,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                baseColor,
                highlightColor,
                baseColor,
              ],
              stops: [
                _animation.value - 0.4,
                _animation.value,
                _animation.value + 0.4,
              ],
            ),
          ),
        );
      },
    );
  }
}
