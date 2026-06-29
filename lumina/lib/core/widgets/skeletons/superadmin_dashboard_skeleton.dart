import 'package:flutter/material.dart';
import 'fire_skeleton_system.dart';

/// Skeleton qui mime la disposition de SuperadminDashboardView
class SuperadminDashboardSkeleton extends StatelessWidget {
  const SuperadminDashboardSkeleton({super.key});

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
                  widthFactor: 0.4,
                  height: 12,
                  margin: const EdgeInsets.only(bottom: 4),
                ),
                FireSkeletonAtom.textLine(
                  context: context,
                  widthFactor: 0.5,
                  height: 24,
                  margin: EdgeInsets.zero,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Section title
          FireSkeletonAtom.textLine(
            context: context,
            widthFactor: 0.3,
            height: 12,
          ),
          const SizedBox(height: 12),
          // Network stats row
          Row(
            children: [
              Expanded(child: _buildNetworkStatCard(context)),
              const SizedBox(width: 12),
              Expanded(child: _buildNetworkStatCard(context)),
            ],
          ),
          const SizedBox(height: 24),
          // Section: Audit preview
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FireSkeletonAtom.textLine(
                context: context,
                widthFactor: 0.3,
                height: 12,
              ),
              FireSkeletonAtom.textLine(
                context: context,
                widthFactor: 0.2,
                height: 12,
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Audit items
          _buildAuditItem(context),
          const SizedBox(height: 8),
          _buildAuditItem(context),
          const SizedBox(height: 8),
          _buildAuditItem(context),
          const SizedBox(height: 24),
          // Section: Strategic actions
          FireSkeletonAtom.textLine(
            context: context,
            widthFactor: 0.4,
            height: 12,
          ),
          const SizedBox(height: 12),
          // Action grid
          Row(
            children: [
              Expanded(child: _buildActionGridItem(context)),
              const SizedBox(width: 12),
              Expanded(child: _buildActionGridItem(context)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildActionGridItem(context)),
              const SizedBox(width: 12),
              Expanded(child: _buildActionGridItem(context)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNetworkStatCard(BuildContext context) {
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
            FireSkeletonAtom.circle(context: context, diameter: 32),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FireSkeletonAtom.textLine(
                  context: context,
                  widthFactor: 0.6,
                  height: 12,
                  margin: const EdgeInsets.only(bottom: 4),
                ),
                FireSkeletonAtom.textLine(
                  context: context,
                  widthFactor: 0.4,
                  height: 18,
                  margin: EdgeInsets.zero,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuditItem(BuildContext context) {
    return FireShimmer(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Theme.of(context).cardColor
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).dividerColor.withOpacity(0.1),
          ),
        ),
        child: Row(
          children: [
            FireSkeletonAtom.circle(context: context, diameter: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FireSkeletonAtom.textLine(
                    context: context,
                    widthFactor: 0.6,
                    height: 12,
                    margin: const EdgeInsets.only(bottom: 4),
                  ),
                  FireSkeletonAtom.textLine(
                    context: context,
                    widthFactor: 0.45,
                    height: 10,
                    margin: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
            FireSkeletonAtom.textLine(
              context: context,
              widthFactor: 0.15,
              height: 10,
              margin: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionGridItem(BuildContext context) {
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
            FireSkeletonAtom.circle(context: context, diameter: 20),
            const SizedBox(width: 12),
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
