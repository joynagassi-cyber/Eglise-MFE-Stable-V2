import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:lumina/core/providers/auth_provider.dart';
import 'package:lumina/core/providers/repository_providers_content.dart';
import 'package:lumina/core/providers/repository_providers_groups.dart';
import 'package:lumina/core/providers/repository_providers_profile.dart';
import 'package:lumina/features/membres/domain/entities/member.dart';
import 'package:lumina/features/events/domain/entities/event.dart';
import 'package:lumina/features/annonces/domain/entities/annonce.dart';
import 'package:lumina/features/groups/domain/entities/group.dart';

part 'member_dashboard_provider.g.dart';

class MemberDashboardState {
  final Member? member;
  final double totalContributions;
  final Event? nextEvent;
  final List<Annonce> recentAnnonces;
  final List<Group> myGroups;

  const MemberDashboardState({
    required this.member,
    required this.totalContributions,
    required this.nextEvent,
    required this.recentAnnonces,
    required this.myGroups,
  });
}

@riverpod
class MemberDashboard extends _$MemberDashboard {
  @override
  Future<MemberDashboardState> build() async {
    final authState = ref.watch(authProvider);
    final user = authState.valueOrNull;

    if (user == null) {
      return const MemberDashboardState(
        member: null,
        totalContributions: 0,
        nextEvent: null,
        recentAnnonces: [],
        myGroups: [],
      );
    }

    final memberRepo = ref.watch(memberRepositoryProvider);
    final eventRepo = ref.watch(eventRepositoryProvider);
    final annonceRepo = ref.watch(annonceRepositoryProvider);
    final groupRepo = ref.watch(groupRepositoryProvider);

    // 1. Get Member profile
    final memberResult = await memberRepo.getMemberByUserId(user.userId!);
    final member = memberResult.fold((_) => null, (m) => m);

    if (member == null) {
      return const MemberDashboardState(
        member: null,
        totalContributions: 0,
        nextEvent: null,
        recentAnnonces: [],
        myGroups: [],
      );
    }

    // 2. Personal contribution total (from member entity directly)
    final totalContributions = member.totalContributionsThisYear;

    // 3. Get Next Upcoming Event
    final upcomingEvents = await eventRepo.getUpcomingEvents(
      churchId: member.churchId,
      limit: 1,
    );
    final nextEvent = upcomingEvents.isNotEmpty ? upcomingEvents.first : null;

    // 4. Get Recent Announcements
    final latestAnnonces = await annonceRepo.getPublishedAnnonces(
      churchId: member.churchId,
      limit: 5,
    );

    // 5. Get My Groups
    final memberships = await groupRepo.getMemberGroups(member.id);
    final myGroups = <Group>[];
    for (final membership in memberships) {
      final group = await groupRepo.getGroup(membership.groupId);
      if (group != null) {
        myGroups.add(group);
      }
    }

    return MemberDashboardState(
      member: member,
      totalContributions: totalContributions,
      nextEvent: nextEvent,
      recentAnnonces: latestAnnonces,
      myGroups: myGroups,
    );
  }
}
