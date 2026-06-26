import 'package:flutter/widgets.dart';

/// Optimisations de performance
class PerformanceOptimizations {
  // Cache d'images
  static void setupImageCache() {
    PaintingBinding.instance.imageCache.maximumSize = 100;
    PaintingBinding.instance.imageCache.maximumSizeBytes = 50 << 20; // 50 MB
  }

  // Limiter rebuilds
  static Widget optimizedBuilder({
    required Widget Function(BuildContext) builder,
  }) {
    return RepaintBoundary(
      child: Builder(builder: builder),
    );
  }

  // Lazy loading
  static Widget lazyList({
    required int itemCount,
    required Widget Function(BuildContext, int) itemBuilder,
  }) {
    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      cacheExtent: 500,
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: true,
    );
  }
}

/// Mixin pour optimiser les widgets
mixin PerformanceMixin on StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: buildOptimized(context),
    );
  }

  Widget buildOptimized(BuildContext context);
}
