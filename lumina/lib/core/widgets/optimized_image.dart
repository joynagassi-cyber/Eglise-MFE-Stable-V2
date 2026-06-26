// lib/core/widgets/optimized_image.dart
import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import 'loading_state.dart';

class OptimizedImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const OptimizedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? AppSpacing.borderRadiusCard,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) => SkeletonCard(
          width: width,
          height: height,
        ),
        errorWidget: (context, url, error) {
          return Container(
            width: width,
            height: height,
            color: context.colors.bgCard,
            child: Icon(
              Icons.error_outline,
              color: context.colors.textSecondary,
            ),
          );
        },
        memCacheWidth: width?.toInt(),
        memCacheHeight: height?.toInt(),
        maxWidthDiskCache: 1000,
        maxHeightDiskCache: 1000,
      ),
    );
  }
}
