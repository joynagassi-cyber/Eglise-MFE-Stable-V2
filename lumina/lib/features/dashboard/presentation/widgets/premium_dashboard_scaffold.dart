import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumina/l10n/app_localizations.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import '../../../../core/theme/app_breakpoints.dart';
import 'package:lumina/core/widgets/widgets.dart';
/// A reusable Premium Scaffold for dashboards.
/// Handles:
/// - Slivers & Parallax Header
/// - Pull-to-Refresh
/// - Loading & Error States
/// - Animations (Entrance)
class PremiumDashboardScaffold extends ConsumerWidget {
  final String title;
  final String subtitle;
  final Widget? background;
  final VoidCallback? onRefresh;
  final AsyncSnapshot<dynamic>? asyncData; // Optional async state handling
  final Widget? body;
  final List<Widget>? slivers;
  final Widget? headerAction;

  const PremiumDashboardScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    this.body,
    this.slivers,
    this.background,
    this.onRefresh,
    this.asyncData,
    this.headerAction,
  }) : assert(
          body != null || slivers != null,
          'Either body or slivers must be provided',
        );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          if (onRefresh != null) onRefresh!();
        },
        child: CustomScrollView(
          slivers: [
            // 1. Premium Sliver App Bar
            SliverAppBar(
              expandedHeight: 120.0,
              floating: false,
              pinned: true,
              backgroundColor: context.colors.bgPage,
              surfaceTintColor: Colors.transparent,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: false,
                titlePadding: const EdgeInsets.only(
                  left: 56, // Align with back button
                  bottom: 16,
                ),
                title: Text(
                  title,
                  style: TextStyle(
                    color: isDark ? context.colors.textInverse : context.colors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                background: background ??
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            context.colors.brandPrimary.withOpacity(0.1),
                            context.colors.bgPage,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
              ),
              actions: [
                if (headerAction != null) headerAction!,
                if (onRefresh != null && headerAction == null)
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: onRefresh,
                  ),
              ],
            ),

            // 2. Main Content
            if (slivers != null)
              ..._buildAsyncSlivers(context)
            else
              SliverPadding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppBreakpoints.horizontalPadding(context),
                  vertical: AppSpacing.md,
                ),
                sliver: _buildSliverBody(context),
              ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildAsyncSlivers(BuildContext context) {
    if (asyncData == null) {
      return [
        SliverPadding(
          padding: EdgeInsets.symmetric(
            horizontal: AppBreakpoints.horizontalPadding(context),
            vertical: AppSpacing.md,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _buildSubtitle(context),
              const SizedBox(height: AppSpacing.lg),
            ]),
          ),
        ),
        ...slivers!,
      ];
    }

    if (asyncData!.connectionState == ConnectionState.waiting) {
      return [
        SliverFillRemaining(
          child: Center(
            child: LoadingState(message: AppLocalizations.of(context)!.loading),
          ),
        ),
      ];
    }

    if (asyncData!.hasError) {
      return [
        SliverFillRemaining(
          child: Center(
            child: EmptyState(
              icon: Icons.error_outline,
              title: AppLocalizations.of(context)!.errorOccurred,
              subtitle: asyncData!.error.toString(),
              actionLabel: AppLocalizations.of(context)!.retry,
              onAction: onRefresh,
            ),
          ),
        ),
      ];
    }

    return [
      SliverPadding(
        padding: EdgeInsets.symmetric(
          horizontal: AppBreakpoints.horizontalPadding(context),
          vertical: AppSpacing.md,
        ),
        sliver: SliverList(
          delegate: SliverChildListDelegate([
            _buildSubtitle(context),
            const SizedBox(height: AppSpacing.lg),
          ]),
        ),
      ),
      ...slivers!,
      const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
    ];
  }

  Widget _buildSliverBody(BuildContext context) {
    if (body == null) return const SliverToBoxAdapter(child: SizedBox.shrink());

    // If no async data is provided, just show the body
    if (asyncData == null) {
      return SliverList(
        delegate: SliverChildListDelegate([
          _buildSubtitle(context),
          const SizedBox(height: AppSpacing.lg),
          body!,
          const SizedBox(height: 80), // Bottom padding
        ]),
      );
    }

    // Handle Async State
    if (asyncData!.connectionState == ConnectionState.waiting) {
      return SliverFillRemaining(
        child: Center(
          child: LoadingState(message: AppLocalizations.of(context)!.loading),
        ),
      );
    }

    if (asyncData!.hasError) {
      return SliverFillRemaining(
        child: Center(
          child: EmptyState(
            icon: Icons.error_outline,
            title: AppLocalizations.of(context)!.errorOccurred,
            subtitle: asyncData!.error.toString(),
            actionLabel: AppLocalizations.of(context)!.retry,
            onAction: onRefresh,
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildListDelegate([
        _buildSubtitle(context),
        const SizedBox(height: AppSpacing.lg),
        AnimatedEntrance.fromBottom(child: body!),
        const SizedBox(height: 80), // Bottom padding
      ]),
    );
  }

  Widget _buildSubtitle(BuildContext context) {
    return AnimatedEntrance.fromBottom(
      child: Text(
        subtitle,
        style: Theme.of(
          context,
        ).textTheme.bodyLarge?.copyWith(color: context.colors.textSecondary),
      ),
    );
  }
}
