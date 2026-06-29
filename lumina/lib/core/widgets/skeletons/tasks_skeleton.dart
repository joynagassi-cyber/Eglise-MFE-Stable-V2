import 'package:flutter/material.dart';
import 'fire_skeleton_system.dart';

/// Skeleton qui mime les items de tâches (checkbox + titre + date)
class TasksSkeleton extends StatelessWidget {
  const TasksSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress card skeleton
          FireShimmer(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Theme.of(context).cardColor
                    : Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Theme.of(context).dividerColor.withOpacity(0.1),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FireSkeletonAtom.textLine(
                    context: context,
                    widthFactor: 0.35,
                    height: 12,
                  ),
                  const SizedBox(height: 12),
                  FireSkeletonAtom.rect(
                    context: context,
                    height: 8,
                    radius: 4,
                  ),
                  const SizedBox(height: 8),
                  FireSkeletonAtom.textLine(
                    context: context,
                    widthFactor: 0.2,
                    height: 12,
                    margin: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          // Section title
          FireSkeletonAtom.textLine(
            context: context,
            widthFactor: 0.3,
            height: 16,
          ),
          const SizedBox(height: 16),
          // Task items
          ...List.generate(6, (i) => const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: _TaskItemSkeleton(),
          )),
        ],
      ),
    );
  }
}

class _TaskItemSkeleton extends StatelessWidget {
  const _TaskItemSkeleton();

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
            // Checkbox circle
            FireSkeletonAtom.circle(context: context, diameter: 24),
            const SizedBox(width: 16),
            // Title + subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FireSkeletonAtom.textLine(
                    context: context,
                    widthFactor: 0.7,
                    height: 14,
                    margin: const EdgeInsets.only(bottom: 4),
                  ),
                  FireSkeletonAtom.textLine(
                    context: context,
                    widthFactor: 0.5,
                    height: 10,
                    margin: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
            // Date
            FireSkeletonAtom.rect(
              context: context,
              width: 40,
              height: 14,
              radius: 4,
            ),
          ],
        ),
      ),
    );
  }
}
