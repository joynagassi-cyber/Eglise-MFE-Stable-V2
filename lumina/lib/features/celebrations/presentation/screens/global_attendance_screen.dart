import 'dart:async';
import 'package:lumina/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lumina/core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import 'package:lumina/core/widgets/widgets.dart';
import '../../../../core/utils/haptic_helper.dart';
import '../../../membres/domain/entities/member.dart';
import '../../../membres/presentation/providers/member_list_provider.dart';
import '../../domain/entities/church_service.dart';
import '../../domain/entities/service_attendance.dart';
import '../providers/attendance_management_provider.dart';

class GlobalAttendanceScreen extends ConsumerStatefulWidget {
  final String serviceId;
  final ChurchService? service;

  const GlobalAttendanceScreen({
    super.key,
    required this.serviceId,
    this.service,
  });

  @override
  ConsumerState<GlobalAttendanceScreen> createState() =>
      _GlobalAttendanceScreenState();
}

class _GlobalAttendanceScreenState
    extends ConsumerState<GlobalAttendanceScreen> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final attendanceAsync =
        ref.watch(attendanceManagementControllerProvider(widget.serviceId));
    final membersAsync =
        ref.watch(memberListProvider); // Pour la recherche globale

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pointage : ${widget.service?.type.label ?? "Service"}',
              style: AppTypography.labelLarge
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            if (widget.service != null)
              Text(
                DateFormat('dd MMMM yyyy').format(widget.service!.date),
                style: AppTypography.labelSmall
                    .copyWith(color: Colors.white.withValues(alpha: 0.7)),
              ),
          ],
        ),
        actions: [
          attendanceAsync.when(
            data: (attendance) {
              final presentCount = attendance.where((a) => a.isPresent).length;
              return Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Chip(
                    label: Text('$presentCount Présents'),
                    backgroundColor: context.colors.successText.withValues(alpha: 0.1),
                    labelStyle: AppTypography.labelSmall.copyWith(
                        color: context.colors.successText, fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
            loading: () => SizedBox(),
            error: (_, __) => SizedBox(),
          ),
          IconButton(
            icon: Icon(Icons.save_rounded),
            onPressed: () => ref
                .read(attendanceManagementControllerProvider(widget.serviceId)
                    .notifier)
                .save(),
            tooltip: 'Enregistrer maintenant',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchField(),
          Expanded(
            child: membersAsync.when(
              data: (members) {
                final filteredMembers = members
                    .where((m) =>
                        m.firstName
                            .toLowerCase()
                            .contains(_searchQuery.toLowerCase()) ||
                        m.lastName
                            .toLowerCase()
                            .contains(_searchQuery.toLowerCase()) ||
                        (m.memberNumber
                                ?.toLowerCase()
                                .contains(_searchQuery.toLowerCase()) ??
                            false))
                    .toList();

                return attendanceAsync.when(
                  data: (attendance) =>
                      _buildAttendanceList(filteredMembers, attendance),
                  loading: () =>
                      const LoadingState(message: 'Chargement du pointage...'),
                  error: (e, _) => AppErrorWidget(message: e.toString()),
                );
              },
              loading: () =>
                  const LoadingState(message: 'Chargement des membres...'),
              error: (e, _) => AppErrorWidget(message: e.toString()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Rechercher un membre (nom, code...)',
          prefixIcon: Icon(Icons.search_rounded),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear_rounded),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                )
              : null,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: AppSpacing.borderRadiusMd,
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: (value) => setState(() => _searchQuery = value),
      ),
    );
  }

  Widget _buildAttendanceList(
      List<Member> members, List<ServiceAttendance> attendance) {
    if (members.isEmpty) {
      return const EmptyState(
        icon: Icons.person_search_rounded,
        title: 'Aucun membre trouvé',
        subtitle: 'Vérifiez l\'orthographe ou ajoutez le membre.',
      );
    }

    return ListView.builder(
      itemCount: members.length,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      itemBuilder: (context, index) {
        final member = members[index];
        final record = attendance.firstWhere(
          (a) => a.memberId == member.id,
          orElse: () => ServiceAttendance(
              id: '',
              serviceId: widget.serviceId,
              memberId: member.id,
              isPresent: false),
        );

        return _AttendanceMemberTile(
          member: member,
          record: record,
          onToggle: (val) async {
            await HapticHelper.selection();
            unawaited(ref
                .read(attendanceManagementControllerProvider(widget.serviceId)
                    .notifier)
                .updateAttendance(member.id, val));
          },
        );
      },
    );
  }
}

class _AttendanceMemberTile extends StatelessWidget {
  final Member member;
  final ServiceAttendance record;
  final ValueChanged<bool> onToggle;

  const _AttendanceMemberTile({
    required this.member,
    required this.record,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: context.colors.brandPrimary.withValues(alpha: 0.1),
            child: Text(
              member.firstName.isNotEmpty ? member.firstName[0] : '?',
              style: AppTypography.labelLarge.copyWith(
                  color: context.colors.brandPrimaryFire, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${member.firstName} ${member.lastName}',
                  style: AppTypography.labelLarge
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  member.memberNumber ?? 'Pas de code',
                  style: AppTypography.labelSmall.copyWith(
                      color: context.colors.textSecondary
                          .withValues(alpha: 0.6)),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: record.isPresent,
            onChanged: onToggle,
            activeColor: context.colors.successText,
          ),
        ],
      ),
    );
  }
}
