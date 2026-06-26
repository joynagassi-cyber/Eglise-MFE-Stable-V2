import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart'; // For IconData
import '../../domain/entities/member.dart';
import '../../domain/entities/enums/enums.dart'; // For MemberStatus
import '../../domain/usecases/get_members_use_case.dart';
import 'package:lumina/core/providers/repository_providers_profile.dart';

part 'member_list_provider.g.dart';

// --- FILTER & SEARCH STATE ---

enum MemberFilter {
  all,
  active,
  baptized,
  birthdays,
  visitors,
  leaders;

  String get label {
    switch (this) {
      case MemberFilter.all:
        return 'Tous';
      case MemberFilter.active:
        return 'Actifs';
      case MemberFilter.baptized:
        return 'Baptisés';
      case MemberFilter.birthdays:
        return 'Anniversaires';
      case MemberFilter.visitors:
        return 'Visiteurs';
      case MemberFilter.leaders:
        return 'Leaders';
    }
  }

  IconData? get iconData {
    switch (this) {
      case MemberFilter.all:
        return Icons.people;
      case MemberFilter.active:
        return Icons.check_circle;
      case MemberFilter.baptized:
        return Icons.church;
      case MemberFilter.birthdays:
        return Icons.cake;
      case MemberFilter.visitors:
        return Icons.waving_hand;
      case MemberFilter.leaders:
        return Icons.star;
    }
  }

  String get semanticLabel {
    return 'Filtre: $label';
  }
}

final memberFilterProvider = StateProvider<MemberFilter>(
  (ref) => MemberFilter.all,
);
final memberSearchProvider = StateProvider<String>((ref) => '');

// --- PROVIDERS ---

@riverpod
Stream<List<Member>> memberList(MemberListRef ref) {
  final repository = ref.watch(memberRepositoryProvider);
  return repository.watchMembers();
}

/// État pour la pagination
class MemberPaginationState {
  final List<Member> members;
  final bool isLoading;
  final bool hasMore;
  final int page;

  const MemberPaginationState({
    this.members = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.page = 1,
  });

  MemberPaginationState copyWith({
    List<Member>? members,
    bool? isLoading,
    bool? hasMore,
    int? page,
  }) {
    return MemberPaginationState(
      members: members ?? this.members,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
    );
  }
}

/// Notifier pour l'Infinite Scroll (Supporte des milliers de membres)
@riverpod
class PaginatedMembers extends _$PaginatedMembers {
  @override
  MemberPaginationState build() {
    // On réinitialise si la recherche ou le filtre change
    ref.listen(memberSearchProvider, (previous, next) {
      refresh();
    });
    ref.listen(memberFilterProvider, (previous, next) {
      refresh();
    });

    Future.microtask(() => fetchNextPage());
    return const MemberPaginationState();
  }

  Future<void> fetchNextPage() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true);

    try {
      final useCase = ref.read(getMembersUseCaseProvider);
      final search = ref.read(memberSearchProvider);

      final newMembers = await useCase.execute(
        page: state.page,
        perPage: 25,
        search: search.isNotEmpty ? search : null,
      );

      state = state.copyWith(
        members: [...state.members, ...newMembers],
        isLoading: false,
        hasMore: newMembers.length >= 25,
        page: state.page + 1,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> refresh() async {
    state = const MemberPaginationState();
    await fetchNextPage();
  }
}

@riverpod
List<Member> filteredMembers(FilteredMembersRef ref) {
  final paginationState = ref.watch(paginatedMembersProvider);
  final filter = ref.watch(memberFilterProvider);
  // searchQuery is handled by the provider itself

  var filtered = paginationState.members;

  // 1. Initial Filtering
  switch (filter) {
    case MemberFilter.all:
      break;
    case MemberFilter.active:
      filtered =
          filtered.where((m) => m.status == MemberStatus.active).toList();
      break;
    case MemberFilter.baptized:
      filtered = filtered.where((m) => m.isBaptized).toList();
      break;
    case MemberFilter.birthdays:
      filtered = filtered.where((m) {
        if (m.birthDate == null) return false;
        final daysUntil = m.daysUntilBirthday;
        return daysUntil != null && daysUntil <= 30;
      }).toList();
      filtered.sort(
        (a, b) =>
            (a.daysUntilBirthday ?? 999).compareTo(b.daysUntilBirthday ?? 999),
      );
      break;
    case MemberFilter.visitors:
      filtered = filtered.where((m) => m.isVisitor).toList();
      break;
    case MemberFilter.leaders:
      filtered = filtered.where((m) => m.isLeader).toList();
      break;
  }

  // 2. Search Query (Now handled at the repository level for performance)
  // The paginatedMembersProvider already re-fetches when searchQuery changes

  return filtered;
}
