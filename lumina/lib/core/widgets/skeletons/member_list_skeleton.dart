import 'package:flutter/material.dart';
import 'fire_skeleton_system.dart';

/// Skeleton qui mime la disposition de MemberCard (avatar + nom + badge + chevron)
class MemberListSkeleton extends StatelessWidget {
  const MemberListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: 8,
      itemBuilder: (_, __) => const Padding(
        padding: EdgeInsets.only(bottom: 12),
        child: _MemberCardSkeleton(),
      ),
    );
  }
}

class _MemberCardSkeleton extends StatelessWidget {
  const _MemberCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return FireShimmer(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Theme.of(context).cardColor
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: Theme.of(context).dividerColor.withOpacity(0.1),
          ),
        ),
        child: Row(
          children: [
            // Avatar circle
            FireSkeletonAtom.circle(context: context, diameter: 60),
            const SizedBox(width: 16),
            // Name + badge
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FireSkeletonAtom.textLine(
                    context: context,
                    widthFactor: 0.55,
                    height: 16,
                    margin: const EdgeInsets.only(bottom: 6),
                  ),
                  FireSkeletonAtom.chip(context: context, width: 100, height: 22),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      FireSkeletonAtom.chip(context: context, width: 50, height: 18),
                      const SizedBox(width: 6),
                      FireSkeletonAtom.chip(context: context, width: 40, height: 18),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Chevron
            FireSkeletonAtom.circle(context: context, diameter: 28),
          ],
        ),
      ),
    );
  }
}
