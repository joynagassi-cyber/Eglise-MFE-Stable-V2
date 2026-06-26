import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import 'loading_dots.dart';

/// État de chargement standardisé avec shimmer effect
class LoadingState extends StatelessWidget {
  final String? message;
  final bool useShimmer;
  final Widget? skeleton;

  const LoadingState({
    super.key,
    this.message,
    this.useShimmer = true,
    this.skeleton,
  });

  @override
  Widget build(BuildContext context) {
    if (skeleton != null) {
      return skeleton!;
    }

    if (useShimmer) {
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
            if (message != null) ...[
              const SizedBox(height: AppSpacing.md),
              Text(
                message!,
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final shimmerColor = isDark
        ? context.colors.bgCardElevated.withValues(alpha: 0.3)
        : context.colors.borderSubtle.withValues(alpha: 0.3);

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: 5,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.smd),
      itemBuilder: (context, index) {
        return AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Container(
              height: 80,
              decoration: BoxDecoration(
                color: context.colors.bgCard,
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
                              shimmerColor,
                              shimmerColor.withValues(alpha: 0.1),
                              shimmerColor,
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

/// Skeleton pour card individuelle
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: height ?? 100,
      width: width,
      decoration: BoxDecoration(
        color: isDark
            ? context.colors.bgCardElevated.withValues(alpha: 0.3)
            : context.colors.borderSubtle.withValues(alpha: 0.3),
        borderRadius: AppSpacing.borderRadiusCard,
      ),
    );
  }
}
