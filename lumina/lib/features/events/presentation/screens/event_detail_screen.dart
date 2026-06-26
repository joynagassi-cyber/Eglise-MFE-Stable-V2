import "package:lumina/core/widgets/widgets.dart";
// lib/features/events/presentation/screens/event_detail_screen.dart
// Détail Événement - Deep Purple Theme - MIGRATED TO DESIGN SYSTEM

import 'dart:async';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumina/core/router/app_routes.dart';
import 'package:intl/intl.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import 'package:lumina/core/theme/app_typography.dart';


import 'package:lumina/core/providers/auth_provider.dart';
import 'package:lumina/core/utils/haptic_helper.dart';


import 'package:lumina/features/events/presentation/providers/event_providers.dart';
import 'package:lumina/core/providers/repository_providers_content.dart';
import 'package:lumina/features/events/domain/entities/event.dart';

class EventDetailScreen extends ConsumerWidget {
  final String eventId;

  const EventDetailScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventAsync = ref.watch(_eventDetailProvider(eventId));
    final theme = Theme.of(context);

    return eventAsync.when(
      data: (event) {
        if (event == null) {
          return Scaffold(
            appBar: AppBar(),
            body: AppErrorWidget.notFound(
              message: 'Événement non trouvé',
              onRetry: () => ref.invalidate(_eventDetailProvider(eventId)),
            ),
          );
        }
        return _buildContent(context, ref, event, theme);
      },
      loading: () => Scaffold(
        appBar: AppBar(),
        body: const LoadingState(),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(),
        body: AppErrorWidget.server(
          technicalDetails: e.toString(),
          onRetry: () => ref.invalidate(_eventDetailProvider(eventId)),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    Event event,
    ThemeData theme,
  ) {
    final isPast = event.date.isBefore(DateTime.now());

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: Colors.transparent,
            leading: Semantics(
              label: 'Retour',
              button: true,
              child: IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: context.colors.glassDark.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_rounded,
                    color: context.colors.textOnBrand,
                    size: AppSpacing.iconSm,
                  ),
                ),
                onPressed: () async {
                  await HapticHelper.light();
                  if (context.mounted) context.pop();
                },
              ),
            ),
            actions: [
              Semantics(
                label: 'Options de l\'événement',
                button: true,
                child: PopupMenuButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: context.colors.glassDark.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.more_vert_rounded,
                      color: context.colors.textOnBrand,
                      size: AppSpacing.iconSm,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppSpacing.borderRadiusMd,
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit_rounded,
                            color: context.colors.brandPrimary,
                            size: AppSpacing.iconMd,
                          ),
                          const SizedBox(width: 8),
                          Text('Modifier', style: AppTypography.bodyMedium.copyWith(color: context.colors.textOnBrand)),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline_rounded,
                            color: context.colors.errorText,
                            size: AppSpacing.iconMd,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Supprimer',
                            style: AppTypography.bodyMedium.copyWith(
                              color: context.colors.errorText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) async {
                    await HapticHelper.light();
                    if (context.mounted) {
                      if (value == 'edit') {
                        unawaited(context.push(AppRoutes.eventEditWithId(event.id)));
                      } else if (value == 'delete') {
                        unawaited(
                            _confirmDelete(context, ref, event.id, theme));
                      }
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(gradient: context.colors.fireFusionGradient,
                    ),
                  ),
                  Positioned(
                    right: -40,
                    bottom: -40,
                    child: Icon(
                      Icons.event_rounded,
                      size: 200,
                      color: context.colors.textOnBrand.withValues(alpha: 0.1),
                    ),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: context.colors.glassDark.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  event.type.label,
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: context.colors.textOnBrand,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              if (isPast)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: context.colors.glassDark.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'TERMINÉ',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: context.colors.textOnBrand.withValues(alpha: 0.7),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              if (event.status == 'ANNULE')
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: context.colors.errorText.withValues(alpha: 0.8),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'ANNULÉ',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: context.colors.textOnBrand,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            event.title,
                            style: AppTypography.h2.copyWith(
                              color: context.colors.textOnBrand,
                              fontFamily: 'Outfit',
                              decoration: event.status == 'ANNULE' ? TextDecoration.lineThrough : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: AppSpacing.screenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedEntrance.fromBottom(
                    delay: const Duration(milliseconds: 100),
                    child: _buildInfoCard(
                      context,
                      Icons.access_time_rounded,
                      'Date & Heure',
                      DateFormat(
                        'EEEE d MMMM yyyy, HH:mm',
                        'fr_FR',
                      ).format(event.date),
                      theme,
                    ),
                  ),
                  if (event.location != null && event.location!.isNotEmpty)
                    AnimatedEntrance.fromBottom(
                      delay: const Duration(milliseconds: 200),
                      child: _buildInfoCard(
                        context,
                        Icons.location_on_rounded,
                        'Lieu',
                        event.location!,
                        theme,
                      ),
                    ),
                  const SizedBox(height: AppSpacing.lg),
                  _buildRegistrationSection(context, ref, event, theme),
                  const SizedBox(height: AppSpacing.lg),
                  AnimatedEntrance.fromBottom(
                    delay: const Duration(milliseconds: 300),
                    child: Text(
                      'Description',
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.colors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.smd),
                  AnimatedEntrance.fromBottom(
                    delay: const Duration(milliseconds: 400),
                    child: SizedBox(
                      width: double.infinity,
                      child: GlassCard(
                        padding: AppSpacing.cardPadding,
                        child: Text(
                          event.description ?? 'Aucune description',
                          style: AppTypography.bodyMedium.copyWith(
                            color: event.description != null
                                ? context.colors.textPrimary
                                : context.colors.textSecondary,
                            fontStyle: event.description == null
                                ? FontStyle.italic
                                : FontStyle.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegistrationSection(
    BuildContext context,
    WidgetRef ref,
    Event event,
    ThemeData theme,
  ) {
    if (event.status == 'ANNULE') return const SizedBox.shrink();

    final user = ref.watch(authProvider).valueOrNull;
    final isRegistered = user != null && event.participantsIds.contains(user.id);
    final count = event.participantsIds.length;
    final max = event.maxSeats ?? 0;
    final isFull = max > 0 && count >= max;

    return AnimatedEntrance.fromBottom(
      delay: const Duration(milliseconds: 250),
      child: GlassCard(
        padding: AppSpacing.cardPadding,
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.group_rounded,
                  color: context.colors.brandPrimaryFire,
                  size: AppSpacing.iconMd,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Participants',
                        style: AppTypography.labelMedium.copyWith(
                          color: context.colors.textSecondary,
                        ),
                      ),
                      Text(
                        max > 0 ? '$count / $max inscrits' : '$count inscrits',
                        style: AppTypography.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: context.colors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isFull && !isRegistered)
                  Text(
                    'COMPLET',
                    style: AppTypography.labelSmall.copyWith(
                      color: context.colors.errorText,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            if (user != null)
              SizedBox(
                width: double.infinity,
                child: isRegistered
                    ? OutlinedButton.icon(
                        onPressed: () => _handleUnregister(ref, event.id, user.id!),
                        icon: const Icon(Icons.person_remove_rounded, size: 20),
                        label: const Text('Se désinscrire'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: context.colors.errorText,
                          side: BorderSide(color: context.colors.errorText),
                        ),
                      )
                    : ElevatedButton.icon(
                        onPressed: isFull
                            ? null
                            : () => _handleRegister(ref, event.id, user.id!),
                        icon: const Icon(Icons.person_add_rounded, size: 20),
                        label: const Text('S\'inscrire à l\'événement'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.colors.brandPrimaryFire,
                          foregroundColor: context.colors.textOnBrand,
                        ),
                      ),
              )
            else
              const Text(
                'Connectez-vous pour vous inscrire',
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 13),
              ),
          ],
        ),
      ),
    );
  }

  void _handleRegister(WidgetRef ref, String eventId, String userId) async {
    await HapticHelper.medium();
    await ref.read(eventActionsProvider).registerMember(eventId, userId);
  }

  void _handleUnregister(WidgetRef ref, String eventId, String userId) async {
    await HapticHelper.medium();
    await ref.read(eventActionsProvider).unregisterMember(eventId, userId);
  }

  Widget _buildInfoCard(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    ThemeData theme,
  ) {
    return GlassCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.smd),
      padding: AppSpacing.cardPadding,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: context.colors.brandPrimaryFire.withValues(alpha: 0.1),
              borderRadius: AppSpacing.borderRadiusSm,
            ),
            child: Icon(
              icon,
              color: context.colors.brandPrimaryFire,
              size: AppSpacing.iconMd,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTypography.labelMedium.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
                Text(
                  value,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.colors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    String id,
    ThemeData theme,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.colors.bgCard,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusCard,
        ),
        title: Text(
          'Confirmer la suppression',
          style: AppTypography.h3.copyWith(fontFamily: 'Outfit'),
        ),
        content: Text(
          'Voulez-vous vraiment supprimer cet événement?',
          style: AppTypography.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await HapticHelper.light();
              if (context.mounted) Navigator.pop(context, false);
            },
            child: Text('Annuler', style: theme.textTheme.labelLarge),
          ),
          TextButton(
            onPressed: () async {
              await HapticHelper.medium();
              if (context.mounted) Navigator.pop(context, true);
            },
            child: Text(
              'Supprimer',
              style: theme.textTheme.labelLarge?.copyWith(
                color: context.colors.errorText,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      await ref.read(eventActionsProvider).deleteEvent(id);
      await HapticHelper.success();
      ref.invalidate(eventsProvider);
      if (context.mounted) context.pop();
    }
  }
}

final _eventDetailProvider = FutureProvider.family.autoDispose<Event?, String>((
  ref,
  id,
) {
  final repo = ref.watch(eventRepositoryProvider);
  return repo.getEventById(id);
});
