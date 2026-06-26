import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import '../../theme/app_durations.dart';

// -----------------------------------------------------------------------------
// 1. ENGINE : Le Shimmer "Fire" (Orange -> Gold -> Orange)
// -----------------------------------------------------------------------------
class FireShimmer extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const FireShimmer({
    super.key,
    required this.child,
    this.duration = AppDurations.shimmer,
  });

  @override
  State<FireShimmer> createState() => _FireShimmerState();
}

class _FireShimmerState extends State<FireShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(duration: widget.duration, vsync: this)
      ..repeat();
    _anim = Tween<double>(begin: -1.5, end: 2.5).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Colors.transparent,
                context.colors.brandPrimary.withOpacity(0.08),
                context.colors.brandSecondary.withOpacity(0.04),
                context.colors.brandPrimary.withOpacity(0.08),
                Colors.transparent,
              ],
              stops: [
                (_anim.value - 0.6).clamp(0.0, 1.0),
                (_anim.value - 0.25).clamp(0.0, 1.0),
                _anim.value.clamp(0.0, 1.0),
                (_anim.value + 0.25).clamp(0.0, 1.0),
                (_anim.value + 0.6).clamp(0.0, 1.0),
              ],
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

// -----------------------------------------------------------------------------
// 2. ATOMS : Briques de base (Rect, Circle, Chip)
//    S'adapte au Thème Clair/Sombre via le contexte
// -----------------------------------------------------------------------------
class FireSkeletonAtom {
  FireSkeletonAtom._();

  static Color _base(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark
        ? context.colors.bgCard.withValues(alpha: 0.5)
        : context.colors.bgCardLight
            .withValues(alpha: 1.0); // Plus visible en light
  }

  static Widget rect({
    required BuildContext context,
    double? width,
    double height = 16,
    double radius = 8,
    EdgeInsetsGeometry margin = EdgeInsets.zero,
  }) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: _base(context),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }

  static Widget circle({
    required BuildContext context,
    double diameter = 48,
    EdgeInsetsGeometry margin = EdgeInsets.zero,
  }) {
    return Container(
      width: diameter,
      height: diameter,
      margin: margin,
      decoration: BoxDecoration(
        color: _base(context),
        shape: BoxShape.circle,
      ),
    );
  }

  static Widget chip({
    required BuildContext context,
    double width = 60,
    double height = 32,
    EdgeInsetsGeometry margin = EdgeInsets.zero,
  }) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: _base(context),
        borderRadius: BorderRadius.circular(height / 2),
      ),
    );
  }

  static Widget textLine({
    required BuildContext context,
    double widthFactor = 1.0,
    double height = 14,
    EdgeInsetsGeometry margin = const EdgeInsets.only(bottom: 8),
  }) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      child: Container(
        height: height,
        margin: margin,
        decoration: BoxDecoration(
          color: _base(context),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 3. COMPONENTS : Squelettes Composés (Cartes Métier)
// -----------------------------------------------------------------------------

// Mimic DashboardHeroCard
class FireSkeletonHeroCard extends StatelessWidget {
  const FireSkeletonHeroCard({super.key});

  @override
  Widget build(BuildContext context) {
    return FireShimmer(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          // On utilise une couleur un peu plus opaque pour le container principal
          color: Theme.of(context).brightness == Brightness.dark
              ? context.colors.bgCard
              : context.colors.bgCard,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: Theme.of(context).dividerColor.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FireSkeletonAtom.textLine(
                context: context,
                widthFactor: 0.40,
                height: 12,
                margin: const EdgeInsets.only(bottom: 6)),
            FireSkeletonAtom.textLine(
                context: context,
                widthFactor: 0.65,
                height: 22,
                margin: const EdgeInsets.only(bottom: 24)),
            FireSkeletonAtom.textLine(
                context: context,
                widthFactor: 0.45,
                height: 48,
                margin: const EdgeInsets.only(bottom: 12)),
            FireSkeletonAtom.chip(context: context, width: 200, height: 24),
          ],
        ),
      ),
    );
  }
}

// Mimic MemberCard (Grid)
class FireSkeletonMemberCardGrid extends StatelessWidget {
  const FireSkeletonMemberCardGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return FireShimmer(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? context.colors.bgCard
              : context.colors.bgCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: Theme.of(context).dividerColor.withOpacity(0.1)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FireSkeletonAtom.circle(
                context: context,
                diameter: 56,
                margin: const EdgeInsets.only(bottom: 12)),
            FireSkeletonAtom.textLine(
                context: context,
                widthFactor: 0.7,
                height: 14,
                margin: const EdgeInsets.only(bottom: 4)),
            FireSkeletonAtom.textLine(
                context: context, widthFactor: 0.5, height: 10),
          ],
        ),
      ),
    );
  }
}

// Mimic Transaction Item (ListTile)
class FireSkeletonTransactionItem extends StatelessWidget {
  const FireSkeletonTransactionItem({super.key});

  @override
  Widget build(BuildContext context) {
    return FireShimmer(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            FireSkeletonAtom.circle(
                context: context,
                diameter: 48,
                margin: const EdgeInsets.only(right: 16)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FireSkeletonAtom.textLine(
                      context: context,
                      widthFactor: 0.6,
                      height: 16,
                      margin: const EdgeInsets.only(bottom: 6)),
                  FireSkeletonAtom.textLine(
                      context: context, widthFactor: 0.4, height: 12),
                ],
              ),
            ),
            FireSkeletonAtom.rect(
                context: context, width: 60, height: 20, radius: 4),
          ],
        ),
      ),
    );
  }
}

// Mimic Stat Card (Dashboard)
class FireSkeletonStatCard extends StatelessWidget {
  const FireSkeletonStatCard({super.key});

  @override
  Widget build(BuildContext context) {
    return FireShimmer(
      child: Container(
        width: 140, // Largeur typique d'une stat card
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? context.colors.bgCard
              : context.colors.bgCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Theme.of(context).dividerColor.withOpacity(0.1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FireSkeletonAtom.circle(
                context: context,
                diameter: 32,
                margin: const EdgeInsets.only(bottom: 12)),
            FireSkeletonAtom.textLine(
                context: context,
                widthFactor: 0.8,
                height: 12,
                margin: const EdgeInsets.only(bottom: 8)),
            FireSkeletonAtom.textLine(
                context: context, widthFactor: 0.5, height: 24),
          ],
        ),
      ),
    );
  }
}

// Full Dashboard Skeleton
class FireSkeletonDashboard extends StatelessWidget {
  const FireSkeletonDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const FireSkeletonHeroCard(),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: FireSkeletonAtom.textLine(
                context: context,
                widthFactor: 0.3,
                height: 20,
                margin: const EdgeInsets.only(bottom: 16)),
          ),
          SizedBox(
            height: 140,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: 3,
              itemBuilder: (_, __) => const Padding(
                padding: EdgeInsets.only(right: 12),
                child: FireSkeletonStatCard(),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: FireSkeletonAtom.textLine(
                context: context,
                widthFactor: 0.4,
                height: 20,
                margin: const EdgeInsets.only(bottom: 16)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.5,
              ),
              itemCount: 4,
              itemBuilder: (_, __) => FireSkeletonAtom.rect(
                  context: context, height: 80, radius: 20),
            ),
          ),
        ],
      ),
    );
  }
}

// Member List Skeleton
class FireSkeletonMemberList extends StatelessWidget {
  const FireSkeletonMemberList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20),
      itemCount: 6,
      itemBuilder: (_, __) => const Padding(
        padding: EdgeInsets.only(bottom: 16),
        child: FireSkeletonTransactionItem(),
      ),
    );
  }
}

// Inbox Skeleton
class FireSkeletonInbox extends StatelessWidget {
  const FireSkeletonInbox({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20),
      itemCount: 8,
      itemBuilder: (_, __) => const Padding(
        padding: EdgeInsets.only(bottom: 16),
        child: FireSkeletonTransactionItem(), // Row style fits well
      ),
    );
  }
}

// Social Feed Skeleton
class FireSkeletonSocialFeed extends StatelessWidget {
  const FireSkeletonSocialFeed({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: 3,
      itemBuilder: (_, __) => FireShimmer(
        child: Container(
          margin: const EdgeInsets.only(bottom: 24),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.colors.bgCard,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  FireSkeletonAtom.circle(context: context, diameter: 40),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FireSkeletonAtom.textLine(context: context, widthFactor: 0.3, height: 14),
                      FireSkeletonAtom.textLine(context: context, widthFactor: 0.2, height: 10, margin: EdgeInsets.zero),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              FireSkeletonAtom.textLine(context: context, widthFactor: 0.9, height: 14),
              FireSkeletonAtom.textLine(context: context, widthFactor: 0.8, height: 14),
              FireSkeletonAtom.textLine(context: context, widthFactor: 0.5, height: 14),
              const SizedBox(height: 16),
              FireSkeletonAtom.rect(context: context, height: 200, radius: 16),
            ],
          ),
        ),
      ),
    );
  }
}

// Kanban Skeleton
class FireSkeletonKanban extends StatelessWidget {
  const FireSkeletonKanban({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(3, (i) => Container(
          width: 280,
          margin: const EdgeInsets.only(right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FireSkeletonAtom.textLine(context: context, widthFactor: 0.4, height: 20, margin: const EdgeInsets.only(bottom: 16)),
              ...List.generate(3, (j) => FireShimmer(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: context.colors.bgCard,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FireSkeletonAtom.textLine(context: context, widthFactor: 0.8, height: 14),
                      FireSkeletonAtom.textLine(context: context, widthFactor: 0.4, height: 10),
                    ],
                  ),
                ),
              )),
            ],
          ),
        )),
      ),
    );
  }
}

// Summary / Home Skeleton
class FireSkeletonCommSummary extends StatelessWidget {
  const FireSkeletonCommSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(3, (i) => Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: i < 2 ? 12 : 0),
              child: FireSkeletonAtom.rect(context: context, height: 80, radius: 16),
            ),
          )),
        ),
        const SizedBox(height: 24),
        FireSkeletonAtom.rect(context: context, height: 200, radius: 24),
        const SizedBox(height: 24),
        FireSkeletonAtom.rect(context: context, height: 150, radius: 24),
      ],
    );
  }
}

// Budget Dashboard Skeleton
class FireSkeletonBudgetDashboard extends StatelessWidget {
  const FireSkeletonBudgetDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          FireSkeletonAtom.rect(
              context: context, height: 250, radius: 20), // Chart mimic
          const SizedBox(height: 32),
          FireSkeletonAtom.textLine(
              context: context,
              widthFactor: 0.4,
              height: 20,
              margin: const EdgeInsets.only(bottom: 16)),
          ...List.generate(
              3,
              (i) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: FireSkeletonAtom.rect(
                        context: context, height: 100, radius: 16),
                  )),
        ],
      ),
    );
  }
}

// Details Page Skeleton (generic for lists of data rows)
class FireSkeletonDetails extends StatelessWidget {
  const FireSkeletonDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 32),
        FireSkeletonAtom.rect(
            context: context,
            width: 200,
            height: 40,
            radius: 8), // Amount mimic
        const SizedBox(height: 12),
        FireSkeletonAtom.chip(
            context: context, width: 100, height: 24), // Status mimic
        const SizedBox(height: 48),
        ...List.generate(
            4,
            (i) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FireSkeletonAtom.rect(
                          context: context, width: 100, height: 16),
                      FireSkeletonAtom.rect(
                          context: context, width: 140, height: 16),
                    ],
                  ),
                )),
        const SizedBox(height: 24),
        const Divider(),
        const SizedBox(height: 24),
        Align(
          alignment: Alignment.centerLeft,
          child:
              FireSkeletonAtom.rect(context: context, width: 150, height: 24),
        ),
        const SizedBox(height: 16),
        Row(
          children: List.generate(
              3,
              (i) => Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: FireSkeletonAtom.rect(
                        context: context, width: 80, height: 80, radius: 8),
                  )),
        ),
      ],
    );
  }
}
