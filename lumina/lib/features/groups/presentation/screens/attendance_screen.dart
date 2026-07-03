import "package:lumina/core/widgets/widgets.dart";

import 'package:lumina/core/extensions/context_extension.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import 'package:lumina/core/theme/app_typography.dart';





import '../../domain/entities/group_attendance.dart';
import '../../domain/entities/group_membership.dart';
import '../providers/group_providers.dart';
import '../providers/attendance_provider.dart';
import 'package:lumina/core/providers/user_context_provider.dart';
import 'package:lumina/features/membres/presentation/providers/member_detail_provider.dart';

class AttendanceScreen extends ConsumerStatefulWidget {
  final String groupId;
  final DateTime date;

  const AttendanceScreen({
    super.key,
    required this.groupId,
    required this.date,
  });

  @override
  ConsumerState<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends ConsumerState<AttendanceScreen> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.date;
  }

  @override
  Widget build(BuildContext context) {
    final userContext = ref.watch(userContextNotifierProvider).valueOrNull;
    final churchId = userContext?.activeChurchId ?? '';

    final membersAsync = ref.watch(groupMembersProvider(widget.groupId));
    final attendanceAsync = ref.watch(
        attendanceControllerProvider(churchId, widget.groupId, _selectedDate));

    return Scaffold(
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          // Premium Header with Circular Progress
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            stretch: true,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                      decoration: BoxDecoration(
                          gradient: context.colors.fireFusionGradient)),
                  // Decorative Pattern
                  Positioned(
                    right: -20,
                    top: -20,
                    child: Icon(Icons.check_circle_rounded,
                        size: 200, color: context.colors.textInverse.withValues(alpha: 0.1)),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                  Text(
                                    'POINTAGE PRÉSENCE',
                                    style: AppTypography.labelSmall.copyWith(
                                      color: context.colors.textInverse.withValues(alpha: 0.7),
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                SizedBox(height: 4),
                                  Text(
                                    'Réunion du jour',
                                    style: AppTypography.h3.copyWith(
                                      color: context.colors.textInverse,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          // Premium Circular Progress Placeholder
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: context.colors.textInverse.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: context.colors.textInverse.withValues(alpha: 0.24), width: 4),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    membersAsync.maybeWhen(
                                      data: (m) => attendanceAsync.maybeWhen(
                                        data: (a) {
                                          final present = a
                                              .where((x) =>
                                                  x.status ==
                                                  AttendanceStatus.present)
                                              .length;
                                          return '${((present / m.length) * 100).toInt()}%';
                                        },
                                        orElse: () => '0%',
                                      ),
                                      orElse: () => '0%',
                                    ),
                                    style: AppTypography.labelLarge.copyWith(
                                      color: context.colors.textInverse,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  Text('TAUX',
                                      style: AppTypography.labelSmall.copyWith(
                                          color: context.colors.textInverse.withValues(alpha: 0.7),
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
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

          // Minimalist Date Selector
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg, vertical: AppSpacing.md),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                decoration: BoxDecoration(
                  color: context.colors.bgCard,
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                      color: context.colors.borderSubtle.withValues(alpha: 0.5)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => _changeDate(-1),
                      icon: Icon(Icons.arrow_back_ios_new_rounded,
                          size: 16),
                      tooltip: 'Jour précédent',
                      padding: EdgeInsets.zero,
                    ),
                    Semantics(
                      label:
                          'Date sélectionnée : ${_selectedDate.day} ${_getMonthName(_selectedDate.month)} ${_selectedDate.year}. Appuyez pour changer.',
                      button: true,
                      child: InkWell(
                        onTap: () => _selectDate(context),
                        child: Text(
                          '${_selectedDate.day} ${_getMonthName(_selectedDate.month)} ${_selectedDate.year}'
                              .toUpperCase(),
                          style: AppTypography.labelMedium.copyWith(
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                            color: context.colors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => _changeDate(1),
                      icon:
                          Icon(Icons.arrow_forward_ios_rounded, size: 16),
                      tooltip: 'Jour suivant',
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
            ),
          ),

          membersAsync.when(
            data: (members) => attendanceAsync.when(
              data: (attendanceList) => SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final membership = members[index];
                    final attendance = attendanceList.firstWhere(
                      (a) => a.memberId == membership.memberId,
                      orElse: () {
                        final userContext =
                            ref.read(userContextNotifierProvider).valueOrNull;
                        final churchId = userContext?.activeChurchId ?? '';
                        return GroupAttendance(
                          id: '',
                          churchId: churchId,
                          groupId: widget.groupId,
                          memberId: membership.memberId,
                          attendanceDate: _selectedDate,
                          status: AttendanceStatus.absent,
                        );
                      },
                    );

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg, vertical: AppSpacing.xs),
                      child: AnimatedEntrance.fromRight(
                        delay: Duration(milliseconds: 50 * index),
                        child: _AttendanceMemberRow(
                          membership: membership,
                          attendance: attendance,
                          onStatusChanged: (status) =>
                              _updateStatus(membership.memberId, status),
                        ),
                      ),
                    );
                  },
                  childCount: members.length,
                ),
              ),
              loading: () => const SliverFillRemaining(child: LoadingState()),
              error: (err, _) => SliverFillRemaining(
                  child: AppErrorWidget(message: err.toString())),
            ),
            loading: () => const SliverFillRemaining(child: LoadingState()),
            error: (err, _) => SliverFillRemaining(
                child: AppErrorWidget(message: err.toString())),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AnimatedEntrance.fromBottom(
        delay: const Duration(milliseconds: 400),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              gradient: context.colors.fireFusionGradient,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: context.colors.brandPrimary.withValues(alpha: 0.3),
                  blurRadius: 12.0,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () async {
                  await HapticFeedback.mediumImpact();
                  final userContext =
                      ref.read(userContextNotifierProvider).valueOrNull;
                  final churchId = userContext?.activeChurchId ?? '';
                  unawaited(ref
                      .read(attendanceControllerProvider(
                              churchId, widget.groupId, _selectedDate)
                          .notifier)
                      .save());
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Pointage enregistré avec succès')));
                    context.pop();
                  }
                },
                borderRadius: BorderRadius.circular(30),
                child: Center(
                  child: Text(
                    'ENREGISTRER LA RÉUNION',
                    style: AppTypography.labelLarge.copyWith(
                        color: context.colors.textInverse,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'JAN',
      'FÉV',
      'MAR',
      'AVR',
      'MAI',
      'JUN',
      'JUL',
      'AOÛ',
      'SEP',
      'OCT',
      'NOV',
      'DÉC'
    ];
    return months[month - 1];
  }

  void _changeDate(int days) {
    setState(() {
      _selectedDate = _selectedDate.add(Duration(days: days));
      HapticFeedback.lightImpact();
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      locale: const Locale('fr', 'FR'),
      helpText: 'Sélectionner la date de présence',
      cancelText: 'Annuler',
      confirmText: 'Confirmer',
    );
    if (picked != null) {
      if (!mounted) return;
      setState(() {
        _selectedDate = picked;
      });
      unawaited(HapticFeedback.lightImpact());
    }
  }

  void _updateStatus(String memberId, AttendanceStatus status) {
    final userContext = ref.read(userContextNotifierProvider).valueOrNull;
    final churchId = userContext?.activeChurchId ?? '';
    ref
        .read(attendanceControllerProvider(
                churchId, widget.groupId, _selectedDate)
            .notifier)
        .updateStatus(memberId, status);
    HapticFeedback.selectionClick();
  }
}

class _AttendanceMemberRow extends ConsumerWidget {
  final GroupMembership membership;
  final GroupAttendance attendance;
  final Function(AttendanceStatus) onStatusChanged;

  const _AttendanceMemberRow({
    required this.membership,
    required this.attendance,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memberAsync = ref.watch(memberDetailProvider(membership.memberId));

    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      borderRadius: 24,
      child: Row(
        children: [
          memberAsync.maybeWhen(
            data: (member) => AvatarWidget(
              imageUrl: member?.photoUrl,
              fallbackName: member?.fullName ?? '?',
              size: 44,
            ),
            orElse: () => SizedBox(width: 44, height: 44),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                memberAsync.maybeWhen(
                  data: (member) => Text(
                    member?.fullName ?? 'Inconnu',
                    style: AppTypography.bodySmall.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.2,
                      color: context.colors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  orElse: () => Text('Chargement...'),
                ),
                Text(
                  membership.role.name.toUpperCase(),
                  style: AppTypography.labelSmall.copyWith(
                    color: context.colors.textSecondary,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          _buildStatusSelector(context),
        ],
      ),
    );
  }

  Widget _buildStatusSelector(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: context.colors.borderSubtle.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StatusButton(
            icon: Icons.check_rounded,
            color: context.colors.successText,
            isActive: attendance.status == AttendanceStatus.present,
            semanticLabel: 'Présent',
            onTap: () => onStatusChanged(AttendanceStatus.present),
          ),
          _StatusButton(
            icon: Icons.close_rounded,
            color: context.colors.errorText,
            isActive: attendance.status == AttendanceStatus.absent,
            semanticLabel: 'Absent',
            onTap: () => onStatusChanged(AttendanceStatus.absent),
          ),
          _StatusButton(
            icon: Icons.access_time_filled_rounded,
            color: context.colors.warningText,
            isActive: attendance.status == AttendanceStatus.late,
            semanticLabel: 'En retard',
            onTap: () => onStatusChanged(AttendanceStatus.late),
          ),
        ],
      ),
    );
  }
}

class _StatusButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final bool isActive;
  final String semanticLabel;
  final VoidCallback onTap;

  const _StatusButton({
    required this.icon,
    required this.color,
    required this.isActive,
    required this.semanticLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      selected: isActive,
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isActive ? color : Colors.transparent,
            shape: BoxShape.circle,
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    )
                  ]
                : null,
          ),
          child: Icon(
            icon,
            color: isActive ? context.colors.textInverse : color.withValues(alpha: 0.4),
            size: LuminaIcon.sm,
          ),
        ),
      ),
    );
  }
}
