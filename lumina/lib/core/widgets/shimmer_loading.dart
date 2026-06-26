// lib/core/widgets/shimmer_loading.dart
// Widget de shimmer loading pour les images et contenus

import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import '../animations/app_animations.dart';

/// Widget shimmer pour le chargement de contenu
class ShimmerLoading extends StatefulWidget {
  final Widget child;
  final bool isLoading;
  final Duration duration;
  final LinearGradient? gradient;

  const ShimmerLoading({
    super.key,
    required this.child,
    this.isLoading = true,
    this.duration = AppAnimations.shimmerDuration,
    this.gradient,
  });

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();

    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutSine,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading) {
      return widget.child;
    }

    final gradient = widget.gradient ?? AppAnimations.shimmerGradient(context);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return gradient.createShader(
              Rect.fromLTWH(
                bounds.width * _animation.value,
                0,
                bounds.width,
                bounds.height,
              ),
            );
          },
          blendMode: BlendMode.srcATop,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// Widget shimmer pour les boîtes (cards, containers)
class ShimmerBox extends StatelessWidget {
  final double? width;
  final double? height;
  final double borderRadius;

  const ShimmerBox({
    super.key,
    this.width,
    this.height,
    this.borderRadius = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: context.colors.shimmerBase,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

/// Widget shimmer pour le texte
class ShimmerText extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerText({
    super.key,
    this.width = 100,
    this.height = 16,
    this.borderRadius = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerBox(
      width: width,
      height: height,
      borderRadius: borderRadius,
    );
  }
}

/// Widget shimmer pour les avatars circulaires
class ShimmerCircle extends StatelessWidget {
  final double size;

  const ShimmerCircle({
    super.key,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: context.colors.shimmerBase,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

/// Widget shimmer pour les listes de cartes
class ShimmerCardList extends StatelessWidget {
  final int itemCount;
  final double itemHeight;
  final EdgeInsetsGeometry? padding;
  final double spacing;

  const ShimmerCardList({
    super.key,
    this.itemCount = 3,
    this.itemHeight = 100,
    this.padding,
    this.spacing = 16,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: padding,
      itemCount: itemCount,
      separatorBuilder: (context, index) => SizedBox(height: spacing),
      itemBuilder: (context, index) {
        return ShimmerBox(
          height: itemHeight,
        );
      },
    );
  }
}

/// Widget shimmer composite pour les pages de détail (Header + List)
class ShimmerDetail extends StatelessWidget {
  const ShimmerDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Skeleton
        ShimmerBox(
          height: 240,
          borderRadius: 0,
        ),
        SizedBox(height: 24),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerText(width: 200, height: 24),
              SizedBox(height: 16),
              ShimmerBox(height: 80, borderRadius: 12),
              SizedBox(height: 24),
              ShimmerText(width: 150, height: 20),
              SizedBox(height: 16),
              ShimmerBox(height: 100, borderRadius: 12),
              SizedBox(height: 12),
              ShimmerBox(height: 100, borderRadius: 12),
            ],
          ),
        ),
      ],
    );
  }
}
