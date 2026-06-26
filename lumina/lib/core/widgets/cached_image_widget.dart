// lib/core/widgets/cached_image_widget.dart
// Widget réutilisable pour afficher des images en cache avec placeholder et gestion d'erreurs

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// Widget pour afficher des images réseau avec cache automatique
///
/// Fonctionnalités:
/// - Cache mémoire et disque
/// - Placeholder shimmer pendant le chargement
/// - Widget d'erreur en cas d'échec
/// - Optimisation mémoire (memCacheWidth/Height)
/// - Support du mode offline
class CachedImageWidget extends StatelessWidget {
  /// URL de l'image à afficher
  final String imageUrl;

  /// Largeur du widget
  final double? width;

  /// Hauteur du widget
  final double? height;

  /// BoxFit pour l'image
  final BoxFit fit;

  /// BorderRadius pour arrondir les coins
  final BorderRadius? borderRadius;

  /// Largeur du cache mémoire (optimisation)
  final int? memCacheWidth;

  /// Hauteur du cache mémoire (optimisation)
  final int? memCacheHeight;

  /// Widget placeholder personnalisé
  final Widget? placeholder;

  /// Widget d'erreur personnalisé
  final Widget? errorWidget;

  const CachedImageWidget({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.memCacheWidth,
    this.memCacheHeight,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget imageWidget = CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      memCacheWidth: memCacheWidth ?? 400,
      memCacheHeight: memCacheHeight ?? 400,

      // Placeholder pendant le chargement
      placeholder: (context, url) =>
          placeholder ?? _buildShimmerPlaceholder(theme),

      // Widget d'erreur
      errorWidget: (context, url, error) =>
          errorWidget ?? _buildErrorWidget(theme),

      // Fade in animation
      fadeInDuration: const Duration(milliseconds: 300),
      fadeOutDuration: const Duration(milliseconds: 100),
    );

    // Appliquer borderRadius si défini
    if (borderRadius != null) {
      imageWidget = ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  /// Placeholder shimmer par défaut
  Widget _buildShimmerPlaceholder(ThemeData theme) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: borderRadius,
      ),
      child: Center(
        child: _ShimmerLoading(
          width: width,
          height: height,
          borderRadius: borderRadius,
        ),
      ),
    );
  }

  /// Widget d'erreur par défaut
  Widget _buildErrorWidget(ThemeData theme) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        borderRadius: borderRadius,
      ),
      child: Icon(
        Icons.broken_image_outlined,
        size: 32,
        color: theme.colorScheme.onErrorContainer,
      ),
    );
  }
}

/// Widget shimmer pour effet de chargement
class _ShimmerLoading extends StatefulWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const _ShimmerLoading({
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  State<_ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<_ShimmerLoading>
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
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius,
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                theme.colorScheme.surfaceContainerHighest,
                theme.colorScheme.surfaceContainerHigh,
                theme.colorScheme.surfaceContainerHighest,
              ],
              stops: [
                _animation.value - 0.3,
                _animation.value,
                _animation.value + 0.3,
              ].map((e) => e.clamp(0.0, 1.0)).toList(),
            ),
          ),
        );
      },
    );
  }
}

/// Widget pour avatar circulaire avec cache
class CachedAvatarWidget extends StatelessWidget {
  final String imageUrl;
  final double radius;
  final String? fallbackText;

  const CachedAvatarWidget({
    super.key,
    required this.imageUrl,
    this.radius = 20,
    this.fallbackText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CircleAvatar(
      radius: radius,
      backgroundColor: theme.colorScheme.primaryContainer,
      child: ClipOval(
        child: CachedImageWidget(
          imageUrl: imageUrl,
          width: radius * 2,
          height: radius * 2,
          fit: BoxFit.cover,
          memCacheWidth: (radius * 2).toInt(),
          memCacheHeight: (radius * 2).toInt(),
          errorWidget: fallbackText != null
              ? Center(
                  child: Text(
                    fallbackText!,
                    style: TextStyle(
                      color: theme.colorScheme.onPrimaryContainer,
                      fontSize: radius * 0.6,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : null,
        ),
      ),
    );
  }
}

/// Widget pour image de profil membre
class MemberPhotoWidget extends StatelessWidget {
  final String? photoUrl;
  final String memberName;
  final double size;

  const MemberPhotoWidget({
    super.key,
    required this.photoUrl,
    required this.memberName,
    this.size = 80,
  });

  @override
  Widget build(BuildContext context) {
    if (photoUrl == null || photoUrl!.isEmpty) {
      return _buildFallbackAvatar(context);
    }

    return CachedAvatarWidget(
      imageUrl: photoUrl!,
      radius: size / 2,
      fallbackText: _getInitials(memberName),
    );
  }

  Widget _buildFallbackAvatar(BuildContext context) {
    final theme = Theme.of(context);

    return CircleAvatar(
      radius: size / 2,
      backgroundColor: theme.colorScheme.primaryContainer,
      child: Text(
        _getInitials(memberName),
        style: TextStyle(
          color: theme.colorScheme.onPrimaryContainer,
          fontSize: size * 0.3,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }
}
