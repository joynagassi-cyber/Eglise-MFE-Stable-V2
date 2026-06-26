import 'dart:async';
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

  /// État vide par défaut (utilisé pendant le chargement ou si l'utilisateur
  /// n'a pas encore de fiche membre dans la table members).
  static const empty = MemberDashboardState(
    member: null,
    totalContributions: 0,
    nextEvent: null,
    recentAnnonces: [],
    myGroups: [],
  );
}

@riverpod
class MemberDashboard extends _$MemberDashboard {
  @override
  Future<MemberDashboardState> build() async {
    final authState = ref.watch(authProvider);
    final user = authState.valueOrNull;

    // Pas d'utilisateur connecté → état vide immédiat
    if (user == null || user.userId == null) {
      return MemberDashboardState.empty;
    }

    final memberRepo = ref.watch(memberRepositoryProvider);
    final eventRepo = ref.watch(eventRepositoryProvider);
    final annonceRepo = ref.watch(annonceRepositoryProvider);
    final groupRepo = ref.watch(groupRepositoryProvider);

    // Timeout global : le dashboard ne doit JAMAIS rester bloqué en loading.
    // Chaque sous-requête a aussi son propre timeout en sécurité.
    try {
      return await _loadDashboard(
        userId: user.userId!,
        memberRepo: memberRepo,
        eventRepo: eventRepo,
        annonceRepo: annonceRepo,
        groupRepo: groupRepo,
      ).timeout(const Duration(seconds: 10), onTimeout: () {
        // En cas de timeout global, retourner un état partiel/vide
        // plutôt que de rester en loading indéfiniment.
        return MemberDashboardState.empty;
      });
    } catch (e) {
      // En cas d'erreur inattendue, retourner un état vide affichable.
      return MemberDashboardState.empty;
    }
  }

  Future<MemberDashboardState> _loadDashboard({
    required String userId,
    required dynamic memberRepo,
    required dynamic eventRepo,
    required dynamic annonceRepo,
    required dynamic groupRepo,
  }) async {
    // 1. Get Member profile — timeout individuel de 5s
    Member? member;
    try {
      final memberResult = await memberRepo
          .getMemberByUserId(userId)
          .timeout(const Duration(seconds: 5));
      member = memberResult.fold((_) => null, (m) => m);
    } catch (_) {
      member = null;
    }

    // Si pas de fiche membre, retourner un état vide mais VALIDE
    // (le dashboard affichera un message d'accueil sans données).
    if (member == null) {
      return MemberDashboardState.empty;
    }

    // 2. Personal contribution total
    final totalContributions = member.totalContributionsThisYear;

    // 3. Get Next Upcoming Event — timeout 5s, non bloquant
    Event? nextEvent;
    try {
      final upcomingEvents = await eventRepo
          .getUpcomingEvents(churchId: member.churchId, limit: 1)
          .timeout(const Duration(seconds: 5));
      nextEvent = upcomingEvents.isNotEmpty ? upcomingEvents.first : null;
    } catch (_) {
      nextEvent = null; // Non bloquant
    }

    // 4. Get Recent Announcements — timeout 5s, non bloquant
    List<Annonce> latestAnnonces = [];
    try {
      latestAnnonces = await annonceRepo
          .getPublishedAnnonces(churchId: member.churchId, limit: 5)
          .timeout(const Duration(seconds: 5));
    } catch (_) {
      latestAnnonces = []; // Non bloquant
    }

    // 5. Get My Groups — timeout 5s, non bloquant
    final myGroups = <Group>[];
    try {
      final memberships = await groupRepo
          .getMemberGroups(member.id)
          .timeout(const Duration(seconds: 5));
      for (final membership in memberships) {
        try {
          final group = await groupRepo
              .getGroup(membership.groupId)
              .timeout(const Duration(seconds: 3));
          if (group != null) {
            myGroups.add(group);
          }
        } catch (_) {
          // Ignorer un groupe individuel en erreur
        }
      }
    } catch (_) {
      // Non bloquant — myGroups reste vide
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
