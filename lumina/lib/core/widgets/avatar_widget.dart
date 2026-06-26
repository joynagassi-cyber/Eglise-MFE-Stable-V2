// lib/core/widgets/avatar_widget.dart
// Widget d'avatar réutilisable

import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lumina/core/widgets/loading_dots.dart';

/// Avatar avec photo, initiales ou placeholder
class AvatarWidget extends StatelessWidget {
  final String? imageUrl;
  final String? initials;
  final String? fallbackName;
  final double size;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final bool showOnlineIndicator;
  final bool isOnline;
  final VoidCallback? onTap;
  final Widget? badge;

  const AvatarWidget({
    super.key,
    this.imageUrl,
    this.initials,
    this.fallbackName,
    this.size = 48,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 0,
    this.showOnlineIndicator = false,
    this.isOnline = false,
    this.onTap,
    this.badge,
  });

  String get _initials {
    if (initials != null && initials!.isNotEmpty) return initials!;
    if (fallbackName == null || fallbackName!.isEmpty) return '?';
    final parts = fallbackName!.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return fallbackName![0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? context.colors.bgElevated;

    Widget avatar = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: bgColor,
        border: borderWidth > 0
            ? Border.all(
                color: borderColor ?? context.colors.brandPrimary,
                width: borderWidth,
              )
            : null,
        boxShadow: borderWidth > 0
            ? [
                BoxShadow(
                  color:
                      (borderColor ?? context.colors.brandPrimary).withValues(alpha: 0.3),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: ClipOval(
        child: imageUrl != null && imageUrl!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: imageUrl!,
                fit: BoxFit.cover,
                width: size,
                height: size,
                memCacheWidth: size.toInt(),
                memCacheHeight: size.toInt(),
                errorWidget: (_, __, ___) => _buildInitials(context),
                placeholder: (_, __) => Center(
                  child: LoadingDots(size: size / 3),
                ),
              )
            : _buildInitials(context),
      ),
    );

    if (showOnlineIndicator || badge != null) {
      avatar = Stack(
        children: [
          avatar,
          if (showOnlineIndicator)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: size * 0.25,
                height: size * 0.25,
                decoration: BoxDecoration(
                  color: isOnline
                      ? context.colors.successIcon
                      : context.colors.textDisabled,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: context.colors.bgPage,
                    width: 2,
                  ),
                ),
              ),
            ),
          if (badge != null)
            Positioned(
              right: 0,
              bottom: 0,
              child: badge!,
            ),
        ],
      );
    }

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: avatar,
      );
    }

    return avatar;
  }

  Widget _buildInitials(BuildContext context) {
    return Center(
      child: Text(
        _initials,
        style: TextStyle(
          color: context.colors.brandPrimary,
          fontSize: size * 0.35,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Avatar de groupe (plusieurs personnes)
class AvatarGroup extends StatelessWidget {
  final List<String?> imageUrls;
  final List<String>? names;
  final double size;
  final int maxVisible;
  final double overlap;

  const AvatarGroup({
    super.key,
    required this.imageUrls,
    this.names,
    this.size = 32,
    this.maxVisible = 4,
    this.overlap = 0.3,
  });

  @override
  Widget build(BuildContext context) {
    final visible = imageUrls.take(maxVisible).toList();
    final remaining = imageUrls.length - maxVisible;

    return SizedBox(
      width: size +
          (visible.length - 1) * size * (1 - overlap) +
          (remaining > 0 ? size * (1 - overlap) : 0),
      height: size,
      child: Stack(
        children: [
          for (int i = 0; i < visible.length; i++)
            Positioned(
              left: i * size * (1 - overlap),
              child: AvatarWidget(
                imageUrl: visible[i],
                fallbackName:
                    names != null && i < names!.length ? names![i] : null,
                size: size,
                borderColor: context.colors.bgPage,
                borderWidth: 2,
              ),
            ),
          if (remaining > 0)
            Positioned(
              left: visible.length * size * (1 - overlap),
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: context.colors.bgElevated,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: context.colors.bgPage,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    '+$remaining',
                    style: TextStyle(
                      color: context.colors.textOnBrand,
                      fontSize: size * 0.3,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
