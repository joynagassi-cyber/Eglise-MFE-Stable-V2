import "package:lumina/core/widgets/widgets.dart";
// lib/features/celebrations/presentation/screens/celebration_detail_screen.dart
// Détail Célébration - Deep Purple Theme

// ignore_for_file: dead_code

import 'package:flutter/material.dart';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lumina/core/theme/app_spacing.dart';


import 'package:lumina/core/utils/haptic_helper.dart';
import 'package:lumina/features/celebrations/domain/entities/church_service.dart';
import 'package:lumina/core/providers/repository_providers_content.dart';
import 'package:lumina/features/membres/presentation/providers/member_list_provider.dart';
import '../providers/attendance_management_provider.dart';


class CelebrationDetailScreen extends ConsumerStatefulWidget {
  final ChurchService service;

  const CelebrationDetailScreen({super.key, required this.service});

  @override
  ConsumerState<CelebrationDetailScreen> createState() =>
      _CelebrationDetailScreenState();
}

class _CelebrationDetailScreenState
    extends ConsumerState<CelebrationDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late int _menVisitors;
  late int _womenVisitors;
  late int _childrenVisitors;
  late int _menCount;
  late int _womenCount;
  late int _childrenCount;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _menVisitors = widget.service.menVisitorsCount;
    _womenVisitors = widget.service.womenVisitorsCount;
    _childrenVisitors = widget.service.childrenVisitorsCount;
    _menCount = widget.service.menCount;
    _womenCount = widget.service.womenCount;
    _childrenCount = widget.service.childrenCount;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    await HapticHelper.medium();
    final updatedService = widget.service.copyWith(
      menVisitorsCount: _menVisitors,
      womenVisitorsCount: _womenVisitors,
      childrenVisitorsCount: _childrenVisitors,
      menCount: _menCount,
      womenCount: _womenCount,
      childrenCount: _childrenCount,
      attendanceCount: _menCount +
          _womenCount +
          _childrenCount +
          _menVisitors +
          _womenVisitors +
          _childrenVisitors,
    );

    final repository = ref.read(celebrationRepositoryProvider);
    await repository.updateService(updatedService);

    // Save attendance if modified
    await ref
        .read(
            attendanceManagementControllerProvider(widget.service.id).notifier)
        .save();

    await HapticHelper.success();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Modifications enregistrées',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.white),
              ),
            ],
          ),
          backgroundColor: context.colors.successText,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.borderRadiusMd,
          ),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = context.colors.textPrimary;

    final totalAttendance = _menCount +
        _womenCount +
        _childrenCount +
        _menVisitors +
        _womenVisitors +
        _childrenVisitors;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.service.type.label,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        actions: [
          Semantics(
            label: 'Enregistrer les modifications',
            button: true,
            child: Container(
              margin: const EdgeInsets.only(right: AppSpacing.xs),
              decoration: BoxDecoration(
                gradient: context.colors.brandPrimaryGradient,
                borderRadius: AppSpacing.borderRadiusMd,
              ),
              child: IconButton(
                icon: const Icon(Icons.save_rounded, color: Colors.white),
                onPressed: _saveChanges,
              ),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          onTap: (_) => HapticHelper.selection(),
          labelColor: context.colors.brandPrimary,
          unselectedLabelColor: context.colors.textSecondary,
          indicatorColor: context.colors.brandPrimary,
          indicatorWeight: 3,
          labelStyle: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          tabs: const [
            Tab(text: 'Résumé & Visiteurs'),
            Tab(text: 'Appel (Membres)'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSummaryTab(context, totalAttendance, isDark),
          _buildMemberAttendanceTab(context, isDark),
        ],
      ),
    );
  }

  Widget _buildSummaryTab(BuildContext context, int total, bool isDark) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: AppSpacing.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedEntrance.fromBottom(
            delay: const Duration(milliseconds: 100),
            child: _buildInfoCard(isDark),
          ),
          const SizedBox(height: AppSpacing.lg),
          AnimatedEntrance.fromBottom(
            delay: const Duration(milliseconds: 200),
            child: Container(
              width: double.infinity,
              padding: AppSpacing.cardPadding,
              decoration: BoxDecoration(
                gradient: context.colors.brandPrimaryGradient,
                borderRadius: AppSpacing.borderRadiusCard,
                boxShadow: AppSpacing.shadowPrimary(context.colors.brandPrimary),
              ),
              child: Column(
                children: [
                  Text(
                    'Total Présents',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    '$total',
                    style: theme.textTheme.displayLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AnimatedEntrance.fromBottom(
            delay: const Duration(milliseconds: 300),
            child: Text(
              'Statistiques de Présence (Membres)',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.colors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.smd),
          AnimatedEntrance.fromBottom(
            delay: const Duration(milliseconds: 350),
            child: _buildMemberCounters(isDark),
          ),
          const SizedBox(height: AppSpacing.lg),
          AnimatedEntrance.fromBottom(
            delay: const Duration(milliseconds: 400),
            child: Text(
              'Visiteurs',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.colors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.smd),
          AnimatedEntrance.fromBottom(
            delay: const Duration(milliseconds: 450),
            child: _buildVisitorCounters(isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(bool isDark) {
    return GlassCard(
      padding: AppSpacing.cardPadding,
      child: Column(
        children: [
          _buildInfoRow(
            'Date',
            DateFormat('dd MMM yyyy, HH:mm').format(widget.service.date),
            isDark,
          ),
          if (widget.service.theme != null) ...[
            Divider(
              height: 24,
              color: context.colors.borderSubtle,
            ),
            _buildInfoRow('Thème', widget.service.theme!, isDark),
          ],
          if (widget.service.preacherName != null) ...[
            Divider(
              height: 24,
              color: context.colors.borderSubtle,
            ),
            _buildInfoRow('Orateur', widget.service.preacherName!, isDark),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, bool isDark) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildMemberCounters(bool isDark) {
    return Column(
      children: [
        _buildCounterRow(
          'Hommes (Membres)',
          Icons.person_rounded,
          _menCount,
          (val) => setState(() => _menCount = val),
          isDark,
        ),
        _buildCounterRow(
          'Femmes (Membres)',
          Icons.person_3_rounded,
          _womenCount,
          (val) => setState(() => _womenCount = val),
          isDark,
        ),
        _buildCounterRow(
          'Enfants (Membres)',
          Icons.child_friendly_rounded,
          _childrenCount,
          (val) => setState(() => _childrenCount = val),
          isDark,
        ),
      ],
    );
  }

  Widget _buildVisitorCounters(bool isDark) {
    return Column(
      children: [
        _buildCounterRow(
          'Hommes',
          Icons.man_rounded,
          _menVisitors,
          (val) => setState(() => _menVisitors = val),
          isDark,
        ),
        _buildCounterRow(
          'Femmes',
          Icons.woman_rounded,
          _womenVisitors,
          (val) => setState(() => _womenVisitors = val),
          isDark,
        ),
        _buildCounterRow(
          'Enfants',
          Icons.child_care_rounded,
          _childrenVisitors,
          (val) => setState(() => _childrenVisitors = val),
          isDark,
        ),
      ],
    );
  }

  Widget _buildCounterRow(
    String label,
    IconData icon,
    int value,
    Function(int) onChanged,
    bool isDark,
  ) {
    final theme = Theme.of(context);
    return Semantics(
      label: '$label: $value visiteurs',
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.smd,
        ),
        decoration: BoxDecoration(
          color: context.colors.bgCard,
          borderRadius: AppSpacing.borderRadiusMd,
          border: Border.all(
            color: context.colors.borderSubtle,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: context.colors.brandPrimary, size: AppSpacing.iconLg),
            const SizedBox(width: AppSpacing.smd),
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Semantics(
              label: 'Diminuer le nombre de $label',
              button: true,
              child: Container(
                decoration: BoxDecoration(
                  color: context.colors.errorText.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(Icons.remove_rounded,
                    color: context.colors.errorText,
                  ),
                  onPressed: () async {
                    await HapticHelper.light();
                    onChanged(value > 0 ? value - 1 : 0);
                  },
                ),
              ),
            ),
            Container(
              width: 50,
              alignment: Alignment.center,
              child: Text(
                '$value',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.colors.textPrimary,
                ),
              ),
            ),
            Semantics(
              label: 'Augmenter le nombre de $label',
              button: true,
              child: Container(
                decoration: BoxDecoration(
                  color: context.colors.successText.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(Icons.add_rounded, color: context.colors.successText),
                  onPressed: () async {
                    await HapticHelper.light();
                    onChanged(value + 1);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberAttendanceTab(BuildContext context, bool isDark) {
    final theme = Theme.of(context);
    final membersAsync = ref.watch(memberListProvider);

    return membersAsync.when(
      data: (members) {
        if (members.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: context.colors.brandPrimary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.group_off_outlined,
                    size: AppSpacing.iconFeature,
                    color: context.colors.brandPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Aucun membre',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: AppSpacing.screenPadding.copyWith(bottom: AppSpacing.xxl),
          itemCount: members.length,
          separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
          itemBuilder: (context, index) {
            final member = members[index];
            final attendance = ref.watch(
                attendanceManagementControllerProvider(widget.service.id));
            final isPresent = attendance.maybeWhen(
              data: (list) =>
                  list.any((a) => a.memberId == member.id && a.isPresent),
              orElse: () => false,
            );

            return AnimatedEntrance.fromBottom(
              delay: Duration(milliseconds: 100 + (index * 30)),
              child: Semantics(
                label:
                    '${member.firstName} ${member.lastName}, ${member.gender.name}, ${isPresent ? "présent" : "absent"}',
                child: Container(
                  decoration: BoxDecoration(
                    color: context.colors.bgCard,
                    borderRadius: AppSpacing.borderRadiusMd,
                    border: Border.all(
                      color: isPresent
                          ? context.colors.successText.withValues(alpha: 0.5)
                          : context.colors.borderSubtle,
                      width: isPresent ? 2 : 1,
                    ),
                  ),
                  child: CheckboxListTile(
                    title: Text(
                      '${member.firstName} ${member.lastName}',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      member.gender.name,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: context.colors.textSecondary,
                      ),
                    ),
                    value: isPresent,
                    activeColor: context.colors.successText,
                    checkColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppSpacing.borderRadiusMd,
                    ),
                    onChanged: (val) async {
                      await HapticHelper.selection();
                      await ref
                          .read(attendanceManagementControllerProvider(
                                  widget.service.id)
                              .notifier)
                          .updateAttendance(member.id, val ?? false);
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(
        child: SizedBox(
          width: AppSpacing.iconLg,
          height: AppSpacing.iconLg,
          child: LoadingState(),
        ),
      ),
      error: (e, _) => Center(child: Text(
          'Impossible de charger les détails',
          style: TextStyle(color: context.colors.errorText),
        ),
      ),
    );
  }
}
