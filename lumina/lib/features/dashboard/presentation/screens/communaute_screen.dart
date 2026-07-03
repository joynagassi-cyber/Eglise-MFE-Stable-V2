import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import 'package:lumina/core/widgets/widgets.dart';
import '../../../../core/utils/haptic_helper.dart';

class CommunauteScreen extends StatelessWidget {
  const CommunauteScreen({super.key});

  void _showComingSoon(BuildContext context) async {
    await HapticHelper.light();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Fonctionnalité bientôt disponible',
            style: AppTypography.bodyMedium.copyWith(color: Colors.white),
          ),
          backgroundColor: context.colors.brandPrimary,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: context.colors.surfaceObsidian,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMyGroupSection(context),
                  SizedBox(height: AppSpacing.xl),
                  _buildSectionHeader(
                      context, 'Découvrir', Icons.explore_rounded),
                  SizedBox(height: AppSpacing.md),
                  _buildGroupsGrid(context),
                  SizedBox(height: AppSpacing.xl),
                  _buildSectionHeader(context, 'Événements Proches',
                      Icons.event_available_rounded),
                  SizedBox(height: AppSpacing.md),
                  _buildEventCard(context),
                  SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showComingSoon(context),
        backgroundColor: context.colors.brandPrimary,
        child: Icon(Icons.search_rounded,
            color: Theme.of(context).colorScheme.onPrimary),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: context.colors.surfaceObsidian,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding:
            const EdgeInsets.only(left: AppSpacing.lg, bottom: AppSpacing.md),
        title: Text(
          'MA COMMUNAUTÉ',
          style: AppTypography.h3.copyWith(
            color: Colors.white,
            letterSpacing: 2,
            shadows: [
              Shadow(
                  color: context.colors.brandPrimary.withOpacity(0.5),
                  blurRadius: 10),
            ],
          ),
        ),
        background: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      context.colors.brandPrimary.withOpacity(0.15),
                      context.colors.surfaceObsidian,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              right: -30,
              top: -20,
              child: Icon(
                Icons.people_alt_rounded,
                size: 180,
                color: Colors.white.withOpacity(0.03),
              ),
            ),
          ],
        ),
      ),
      actions: [
        Semantics(
          label: 'Notifications',
          button: true,
          child: Tooltip(
            message: 'Notifications',
            child: IconButton(
              icon: Icon(Icons.notifications_none_rounded,
                  color: Colors.white70),
              onPressed: () => _showComingSoon(context),
            ),
          ),
        ),
        SizedBox(width: AppSpacing.sm),
      ],
    );
  }

  Widget _buildSectionHeader(
      BuildContext context, String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: context.colors.brandPrimary, size: 20),
        SizedBox(width: AppSpacing.sm),
        Text(
          title.toUpperCase(),
          style: AppTypography.h4.copyWith(
            color: Colors.white.withOpacity(0.9),
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildMyGroupSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
            context, 'Mon Équipe de Vie', Icons.favorite_border_rounded),
        SizedBox(height: AppSpacing.md),
        GlassCard(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: context.colors.brandPrimaryGradient,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: context.colors.brandPrimary.withOpacity(0.3),
                          blurRadius: 12.0,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Icon(Icons.local_fire_department_rounded,
                        color: Colors.white),
                  ),
                  SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Flammes d\'Adoration',
                          style: AppTypography.h4.copyWith(color: Colors.white),
                        ),
                        Text(
                          'Groupe de croissance • 12 membres',
                          style: AppTypography.bodySmall.copyWith(
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Semantics(
                    label: 'Voir le groupe',
                    button: true,
                    child: Tooltip(
                      message: 'Voir le groupe',
                      child: IconButton(
                        icon: Icon(Icons.chevron_right_rounded,
                            color: context.colors.brandSecondary),
                        onPressed: () => _showComingSoon(context),
                      ),
                    ),
                  ),
                ],
              ),
              Divider(height: 32, color: Colors.white10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildQuickAction(
                      context, Icons.chat_bubble_outline_rounded, 'Discuter'),
                  _buildQuickAction(
                      context, Icons.event_note_rounded, 'Agenda'),
                  _buildQuickAction(
                      context, Icons.auto_awesome_rounded, 'Prier'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickAction(BuildContext context, IconData icon, String label) {
    return Column(
      children: [
        GlassButton(
          onPressed: () => _showComingSoon(context),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Icon(icon,
                color: Theme.of(context).colorScheme.onPrimary, size: 20),
          ),
        ),
        SizedBox(height: AppSpacing.xs),
        Text(
          label,
          style: AppTypography.bodySmall
              .copyWith(color: Colors.white70, fontSize: 10),
        ),
      ],
    );
  }

  Widget _buildGroupsGrid(BuildContext context) {
    final categories = [
      {
        'name': 'Jeunesse',
        'icon': Icons.flash_on_rounded,
        'color': Colors.blue
      },
      {'name': 'Couples', 'icon': Icons.favorite_rounded, 'color': Colors.pink},
      {
        'name': 'Étude Bible',
        'icon': Icons.menu_book_rounded,
        'color': Colors.orange
      },
      {'name': 'Mission', 'icon': Icons.public_rounded, 'color': Colors.green},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
        childAspectRatio: 1.5,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final cat = categories[index];
        return GlassCard(
          onTap: () => _showComingSoon(context),
          padding: EdgeInsets.zero,
          child: Stack(
            children: [
              Positioned(
                right: -10,
                bottom: -10,
                child: Icon(
                  cat['icon'] as IconData,
                  size: 60,
                  color: (cat['color'] as Color).withOpacity(0.1),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(cat['icon'] as IconData,
                        color: cat['color'] as Color, size: 24),
                    SizedBox(height: AppSpacing.xs),
                    Text(
                      cat['name'] as String,
                      style: AppTypography.h4.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEventCard(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: context.colors.brandPrimary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSpacing.sm),
              border: Border.all(color: context.colors.brandPrimary.withOpacity(0.3)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('24',
                    style: AppTypography.h4
                        .copyWith(color: context.colors.brandPrimary)),
                Text('MARS',
                    style: AppTypography.bodySmall
                        .copyWith(color: context.colors.brandSecondary)),
              ],
            ),
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Veillée Régionale de Feu',
                  style: AppTypography.h4.copyWith(color: Colors.white),
                ),
                Text(
                  'Stade Municipal • 19:00',
                  style:
                      AppTypography.bodySmall.copyWith(color: Colors.white60),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios_rounded,
              color: Colors.white24, size: 14),
        ],
      ),
    );
  }
}
