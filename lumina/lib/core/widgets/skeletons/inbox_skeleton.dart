import 'package:flutter/material.dart';
import 'fire_skeleton_system.dart';

/// Skeleton qui mime les conversations de l'inbox (avatar + nom + message + badge non-lu)
class InboxSkeleton extends StatelessWidget {
  const InboxSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: 8,
      itemBuilder: (_, __) => const Padding(
        padding: EdgeInsets.only(bottom: 12),
        child: _InboxItemSkeleton(),
      ),
    );
  }
}

class _InboxItemSkeleton extends StatelessWidget {
  const _InboxItemSkeleton();

  @override
  Widget build(BuildContext context) {
    return FireShimmer(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Theme.of(context).cardColor
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Theme.of(context).dividerColor.withOpacity(0.1),
          ),
        ),
        child: Row(
          children: [
            // Avatar
            FireSkeletonAtom.circle(context: context, diameter: 50),
            const SizedBox(width: 16),
            // Name + last message
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FireSkeletonAtom.textLine(
                    context: context,
                    widthFactor: 0.45,
                    height: 15,
                    margin: const EdgeInsets.only(bottom: 6),
                  ),
                  FireSkeletonAtom.textLine(
                    context: context,
                    widthFactor: 0.8,
                    height: 12,
                    margin: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Unread badge
            FireSkeletonAtom.circle(context: context, diameter: 20),
          ],
        ),
      ),
    );
  }
}
