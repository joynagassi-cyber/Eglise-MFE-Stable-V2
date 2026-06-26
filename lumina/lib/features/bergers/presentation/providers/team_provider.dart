// lib/features/bergers/presentation/providers/team_provider.dart
// Provider pour l'équipe pastorale (Bergers)

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../membres/domain/entities/member.dart';
import '../../../membres/presentation/providers/member_list_provider.dart';

/// Provider qui filtre uniquement les leaders/bergers depuis la liste des membres
final teamListProvider = FutureProvider<List<Member>>((ref) async {
  final allMembers = await ref.watch(memberListProvider.future);

  // Filtre les membres qui sont considérés comme leaders
  // (ceux qui ont un rôle défini autre que membre simple ou visiteur)
  final leaders = allMembers.where((m) => m.isLeader).toList();

  // Trie par niveau hiérarchique (niveau le plus bas = plus gradé)
  leaders.sort((a, b) => a.primaryRole.level.compareTo(b.primaryRole.level));

  return leaders;
});