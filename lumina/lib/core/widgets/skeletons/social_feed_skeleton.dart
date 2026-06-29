import 'package:flutter/material.dart';
import 'fire_skeleton_system.dart';

/// Skeleton qui mime la disposition de SocialFeedScreen
class SocialFeedSkeleton extends StatelessWidget {
  const SocialFeedSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 3,
      itemBuilder: (_, __) => const Padding(
        padding: EdgeInsets.only(bottom: 20),
        child: _PostCardSkeleton(),
      ),
    );
  }
}

class _PostCardSkeleton extends StatelessWidget {
  const _PostCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return FireShimmer(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Theme.of(context).cardColor
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Theme.of(context).dividerColor.withOpacity(0.1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Author row: avatar + name + time
            Row(
              children: [
                FireSkeletonAtom.circle(context: context, diameter: 40),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FireSkeletonAtom.textLine(
                        context: context,
                        widthFactor: 0.35,
                        height: 14,
                        margin: const EdgeInsets.only(bottom: 4),
                      ),
                      FireSkeletonAtom.textLine(
                        context: context,
                        widthFactor: 0.2,
                        height: 10,
                        margin: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Post text lines
            FireSkeletonAtom.textLine(
              context: context,
              widthFactor: 0.9,
              height: 14,
              margin: const EdgeInsets.only(bottom: 6),
            ),
            FireSkeletonAtom.textLine(
              context: context,
              widthFactor: 0.75,
              height: 14,
              margin: const EdgeInsets.only(bottom: 6),
            ),
            FireSkeletonAtom.textLine(
              context: context,
              widthFactor: 0.4,
              height: 14,
              margin: const EdgeInsets.only(bottom: 16),
            ),
            // Post image
            FireSkeletonAtom.rect(
              context: context,
              height: 200,
              radius: 16,
            ),
            const SizedBox(height: 16),
            // Action row (like, comment, share)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                3,
                (i) => FireSkeletonAtom.circle(context: context, diameter: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
