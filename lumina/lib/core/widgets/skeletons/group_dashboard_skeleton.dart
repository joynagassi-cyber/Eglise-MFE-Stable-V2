import 'package:flutter/material.dart';
import 'fire_skeleton_system.dart';

/// Skeleton qui mime la disposition de GroupDashboardView
class GroupDashboardSkeleton extends StatelessWidget {
  const GroupDashboardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          FireShimmer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FireSkeletonAtom.textLine(
                  context: context,
                  widthFactor: 0.35,
                  height: 12,
                  margin: const EdgeInsets.only(bottom: 4),
                ),
                FireSkeletonAtom.textLine(
                  context: context,
                  widthFactor: 0.45,
                  height: 24,
                  margin: EdgeInsets.zero,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // KPI cards row
          Row(
            children: [
              Expanded(child: _buildStatCard(context, 'Membres')),
              const SizedBox(width: 12),
              Expanded(child: _buildStatCard(context, 'Caisse')),
            ],
          ),
          const SizedBox(height: 24),
          // Primary action button
          FireShimmer(
            child: Container(
              width: double.infinity,
              height: 48,
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Theme.of(context).cardColor
                    : Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(28),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Secondary actions row
          Row(
            children: [
              Expanded(child: _buildActionCard(context)),
              const SizedBox(width: 12),
              Expanded(child: _buildActionCard(context)),
            ],
          ),
          const SizedBox(height: 24),
          // Section title
          FireSkeletonAtom.textLine(
            context: context,
            widthFactor: 0.4,
            height: 14,
          ),
          const SizedBox(height: 12),
          // Alert cards
          _buildAlertCard(context),
          const SizedBox(height: 12),
          _buildAlertCard(context),
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String label) {
    return FireShimmer(
      child: Container(
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
          children: [
            FireSkeletonAtom.textLine(
              context: context,
              widthFactor: 0.5,
              height: 12,
              margin: const EdgeInsets.only(bottom: 6),
            ),
            FireSkeletonAtom.textLine(
              context: context,
              widthFactor: 0.3,
              height: 24,
              margin: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(BuildContext context) {
    return FireShimmer(
      child: Container(
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
          children: [
            FireSkeletonAtom.circle(context: context, diameter: 32),
            const SizedBox(height: 8),
            FireSkeletonAtom.textLine(
              context: context,
              widthFactor: 0.5,
              height: 12,
              margin: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertCard(BuildContext context) {
    return FireShimmer(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Theme.of(context).cardColor
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).dividerColor.withOpacity(0.1),
          ),
        ),
        child: Row(
          children: [
            FireSkeletonAtom.circle(context: context, diameter: 24),
            const SizedBox(width: 16),
            Expanded(
              child: FireSkeletonAtom.textLine(
                context: context,
                widthFactor: 0.7,
                height: 14,
                margin: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
