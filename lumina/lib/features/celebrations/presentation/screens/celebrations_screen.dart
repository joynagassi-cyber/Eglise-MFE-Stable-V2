import "package:lumina/core/widgets/widgets.dart";
// lib/features/celebrations/presentation/screens/celebrations_screen.dart
// Écran des célébrations - Fire Theme

import 'dart:async';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumina/core/router/app_routes.dart';
import 'package:intl/intl.dart';
import 'package:lumina/core/theme/app_spacing.dart';




import 'package:lumina/core/utils/haptic_helper.dart';
import 'package:lumina/features/celebrations/domain/entities/church_service.dart';
import 'package:lumina/features/celebrations/presentation/providers/celebration_providers.dart';
import 'package:lumina/features/celebrations/presentation/widgets/add_celebration_dialog.dart';
import 'package:lumina/core/providers/user_context_provider.dart';
import 'package:lumina/core/auth/domain/entities/enums/role_level.dart';

class CelebrationsScreen extends ConsumerStatefulWidget {
  const CelebrationsScreen({super.key});

  @override
  ConsumerState<CelebrationsScreen> createState() => _CelebrationsScreenState();
}

class _CelebrationsScreenState extends ConsumerState<CelebrationsScreen> {
  ServiceType? _selectedType;

  @override
  Widget build(BuildContext context) {
    final servicesAsync = _selectedType != null
        ? ref.watch(celebrationsByTypeProvider(_selectedType!))
        : ref.watch(celebrationsProvider);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = context.colors.textPrimary;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context, textColor),
          SliverToBoxAdapter(
            child: Padding(
              padding: AppSpacing.screenPadding.copyWith(bottom: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTypeChips(context, isDark),
                  SizedBox(height: AppSpacing.md),
                ],
              ),
            ),
          ),
          servicesAsync.when(
            data: (services) {
              if (services.isEmpty) {
                return SliverToBoxAdapter(
                  child: _buildEmptyState(context, isDark),
                );
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final service = services[index];
                  return AnimatedEntrance.fromBottom(
                    delay: Duration(milliseconds: 100 + (index * 50)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.screenHorizontalPadding,
                        vertical: AppSpacing.xs,
                      ),
                      child: _ServiceCard(service: service),
                    ),
                  );
                }, childCount: services.length),
              );
            },
            loading: () => SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.xxl),
                child: LoadingState(message: 'Chargement des célébrations...'),
              ),
            ),
            error: (e, _) => SliverToBoxAdapter(
              child: EmptyState(
                icon: Icons.error_outline,
                title: 'Erreur de chargement',
                subtitle: e.toString(),
              ),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
        ],
      ),
      floatingActionButton: Semantics(
        label: 'Ajouter un nouveau culte',
        button: true,
        child: Container(
          decoration: BoxDecoration(
            gradient: context.colors.brandPrimaryGradient,
            borderRadius: AppSpacing.borderRadiusLg,
            boxShadow: AppSpacing.shadowPrimary(context.colors.brandPrimary),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () async {
                await HapticHelper.light();
                if (context.mounted) {
                  unawaited(showDialog(
                    context: context,
                    builder: (context) => const AddCelebrationDialog(),
                  ));
                }
              },
              borderRadius: AppSpacing.borderRadiusLg,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.mlg,
                  vertical: AppSpacing.smd + 2,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add_rounded, color: context.colors.textOnBrand),
                    SizedBox(width: AppSpacing.sm),
                    Text(
                      'Nouveau Culte',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: context.colors.textOnBrand,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, Color textColor) {
    final theme = Theme.of(context);
    return SliverAppBar(
      expandedHeight: 100.0,
      floating: false,
      pinned: true,
      backgroundColor: context.colors.bgCard,
      surfaceTintColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: false,
        titlePadding: const EdgeInsets.only(
          left: AppSpacing.mlg,
          bottom: AppSpacing.md,
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.xs + 2),
              decoration: BoxDecoration(
                gradient: context.colors.brandPrimaryGradient,
                borderRadius: AppSpacing.borderRadiusSm,
              ),
              child: Icon(Icons.church_rounded,
                color: context.colors.textOnBrand,
                size: AppSpacing.iconXs,
              ),
            ),
            SizedBox(width: AppSpacing.sm + 2),
            Text(
              'Célébrations',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeChips(BuildContext context, bool isDark) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildTypeChip(context, null, 'Tous', isDark),
          SizedBox(width: 8),
          ...ServiceType.values.map(
            (type) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _buildTypeChip(context, type, type.label, isDark),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeChip(
    BuildContext context,
    ServiceType? type,
    String label,
    bool isDark,
  ) {
    final theme = Theme.of(context);
    final isSelected = _selectedType == type;
    return Semantics(
      label: 'Filtre: $label',
      selected: isSelected,
      button: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            await HapticHelper.selection();
            setState(() {
              _selectedType = isSelected ? null : type;
            });
          },
          borderRadius: BorderRadius.circular(20),
          child: AnimatedContainer(
            duration: AppSpacing.animationFast,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? context.colors.brandPrimary : context.colors.bgCard,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color:
                    isSelected ? context.colors.brandPrimary : context.colors.borderSubtle,
              ),
            ),
            child: Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? Colors.white
                    : context.colors.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isDark) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: context.colors.brandPrimary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.event_note_outlined,
                size: AppSpacing.iconFeature,
                color: context.colors.brandPrimary,
              ),
            ),
            SizedBox(height: AppSpacing.md),
            Text(
              'Aucun culte trouvé',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: context.colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final ChurchService service;

  const _ServiceCard({required this.service});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final isFuture = service.date.isAfter(now);
    final daysUntil = service.date.difference(now).inDays;

    return Semantics(
      label:
          '${service.type.label} du ${DateFormat('dd MMMM yyyy').format(service.date)}, ${service.attendanceCount} participants',
      button: true,
      child: GlassCard(
        onTap: () async {
          await HapticHelper.light();
          if (context.mounted) {
            context.go(AppRoutes.celebrationDetailsWithId(service.id), extra: service);
          }
        },
        padding: AppSpacing.cardPadding,
        child: Row(
          children: [
            // Date Badge avec Hero animation
            Hero(
              tag: 'celebration_${service.id}',
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.smd),
                decoration: BoxDecoration(
                  gradient: context.colors.brandPrimaryGradient,
                  borderRadius: AppSpacing.borderRadiusMd,
                  boxShadow: [
                    BoxShadow(
                      color: context.colors.brandPrimary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      DateFormat('dd').format(service.date),
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      DateFormat('MMM').format(service.date).toUpperCase(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          service.title ?? service.type.label,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      // Countdown badge pour événements futurs
                      if (isFuture && daysUntil <= 7)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: AppSpacing.xxs,
                          ),
                          decoration: BoxDecoration(
                            color: daysUntil == 0
                                ? context.colors.successText.withValues(alpha: 0.15)
                                : context.colors.warningText.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            daysUntil == 0
                                ? "Aujourd'hui"
                                : daysUntil == 1
                                    ? 'Demain'
                                    : 'J-$daysUntil',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: daysUntil == 0
                                  ? context.colors.successText
                                  : context.colors.warningText,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                    ],
                  ),
                  if (service.theme != null) ...[
                    SizedBox(height: AppSpacing.xxs),
                    Text(
                      'Thème: ${service.theme}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                  SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      Icon(
                        Icons.people_rounded,
                        size: AppSpacing.iconXs,
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                      SizedBox(width: AppSpacing.xxs),
                      Text(
                        '${service.attendanceCount}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.5),
                        ),
                      ),
                      if (service.preacherName != null) ...[
                        SizedBox(width: AppSpacing.smd),
                        Icon(
                          Icons.mic_rounded,
                          size: AppSpacing.iconXs,
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.5),
                        ),
                        SizedBox(width: AppSpacing.xxs),
                        Expanded(
                          child: Text(
                            service.preacherName!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.5),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
            ),
            SizedBox(width: AppSpacing.sm),
            Consumer(
              builder: (context, ref, _) {
                final userContext =
                    ref.watch(userContextNotifierProvider).valueOrNull;
                final canManage = userContext?.isSuperAdmin == true ||
                    userContext?.role.level == RoleLevel.staff ||
                    userContext?.role.level == RoleLevel.finance;

                if (!canManage) return const SizedBox.shrink();

                return IconButton(
                  icon: Icon(Icons.how_to_reg_rounded,
                      color: context.colors.brandPrimary),
                  onPressed: () {
                    context.go(
                        '/vie-spirituelle/celebrations/${service.id}/attendance',
                        extra: service);
                  },
                  tooltip: 'Pointage',
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
