import 'package:flutter/material.dart';
import 'fire_skeleton_system.dart';

/// Skeleton qui mime la disposition du DashboardScreen (LuminaPage + contenu)
class DashboardSkeleton extends StatelessWidget {
  const DashboardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          // Header: greeting + avatar
          FireShimmer(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FireSkeletonAtom.textLine(
                        context: context,
                        widthFactor: 0.25,
                        height: 12,
                        margin: const EdgeInsets.only(bottom: 6),
                      ),
                      FireSkeletonAtom.textLine(
                        context: context,
                        widthFactor: 0.4,
                        height: 24,
                        margin: const EdgeInsets.only(bottom: 8),
                      ),
                      FireSkeletonAtom.chip(
                        context: context,
                        width: 80,
                        height: 20,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                FireSkeletonAtom.circle(context: context, diameter: 52),
              ],
            ),
          ),
          const SizedBox(height: 28),
          // KPI cards row
          Row(
            children: [
              Expanded(child: _buildKPISkeleton(context)),
              const SizedBox(width: 14),
              Expanded(child: _buildKPISkeleton(context)),
            ],
          ),
          const SizedBox(height: 24),
          // Bible card skeleton
          FireShimmer(
            child: Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Theme.of(context).cardColor
                    : Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Theme.of(context).dividerColor.withOpacity(0.1),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Section title
          FireSkeletonAtom.textLine(
            context: context,
            widthFactor: 0.3,
            height: 14,
          ),
          const SizedBox(height: 16),
          // Groups horizontal list
          SizedBox(
            height: 110,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: List.generate(4, (i) => Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Column(
                  children: [
                    FireSkeletonAtom.circle(context: context, diameter: 60),
                    const SizedBox(height: 8),
                    FireSkeletonAtom.textLine(
                      context: context,
                      widthFactor: 0.7,
                      height: 10,
                      margin: EdgeInsets.zero,
                    ),
                  ],
                ),
              )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKPISkeleton(BuildContext context) {
    return FireShimmer(
      child: Container(
        height: 120,
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
            FireSkeletonAtom.circle(context: context, diameter: 40),
            const SizedBox(height: 14),
            FireSkeletonAtom.textLine(
              context: context,
              widthFactor: 0.5,
              height: 10,
              margin: const EdgeInsets.only(bottom: 4),
            ),
            FireSkeletonAtom.textLine(
              context: context,
              widthFactor: 0.35,
              height: 22,
              margin: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }
}
