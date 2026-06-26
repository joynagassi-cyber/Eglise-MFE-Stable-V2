// lib/features/membres/presentation/providers/member_statistics_provider.dart
// Provider pour les statistiques démographiques des membres

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/member.dart';
import '../../domain/entities/enums/enums.dart';
import 'member_list_provider.dart';

part 'member_statistics_provider.g.dart';

/// Classe pour les statistiques de membres
class MemberStatistics {
  final int total;
  final Map<Gender, int> byGender;
  final Map<MemberStatus, int> byStatus;
  final Map<String, int> byAgeRange;
  final Map<String, int> growthByMonth;
  final double averageAge;
  final int baptizedCount;
  final int leaderCount;
  final int activeCount;

  MemberStatistics({
    required this.total,
    required this.byGender,
    required this.byStatus,
    required this.byAgeRange,
    required this.growthByMonth,
    required this.averageAge,
    required this.baptizedCount,
    required this.leaderCount,
    required this.activeCount,
  });
}

/// Provider pour les statistiques de membres
@riverpod
Future<MemberStatistics> memberStatistics(MemberStatisticsRef ref) async {
  final members = await ref.watch(memberListProvider.future);

  return MemberStatistics(
    total: members.length,
    byGender: _groupByGender(members),
    byStatus: _groupByStatus(members),
    byAgeRange: _groupByAgeRange(members),
    growthByMonth: _calculateGrowth(members),
    averageAge: _calculateAverageAge(members),
    baptizedCount: members.where((m) => m.isBaptized).length,
    leaderCount: members.where((m) => m.isLeader).length,
    activeCount: members.where((m) => m.status == MemberStatus.active).length,
  );
}

/// Grouper par genre
Map<Gender, int> _groupByGender(List<Member> members) {
  final result = <Gender, int>{};
  for (final gender in Gender.values) {
    result[gender] = members.where((m) => m.gender == gender).length;
  }
  return result;
}

/// Grouper par statut
Map<MemberStatus, int> _groupByStatus(List<Member> members) {
  final result = <MemberStatus, int>{};
  for (final status in MemberStatus.values) {
    result[status] = members.where((m) => m.status == status).length;
  }
  return result;
}

/// Grouper par tranche d'âge
Map<String, int> _groupByAgeRange(List<Member> members) {
  final ranges = {
    '0-12': 0, // Enfants
    '13-17': 0, // Adolescents
    '18-25': 0, // Jeunes
    '26-35': 0, // Jeunes adultes
    '36-50': 0, // Adultes
    '51-65': 0, // Seniors
    '66+': 0, // Aînés
  };

  for (final member in members) {
    if (member.birthDate == null) continue;

    final age = _calculateAge(member.birthDate!);
    if (age <= 12) {
      ranges['0-12'] = (ranges['0-12'] ?? 0) + 1;
    } else if (age <= 17) {
      ranges['13-17'] = (ranges['13-17'] ?? 0) + 1;
    } else if (age <= 25) {
      ranges['18-25'] = (ranges['18-25'] ?? 0) + 1;
    } else if (age <= 35) {
      ranges['26-35'] = (ranges['26-35'] ?? 0) + 1;
    } else if (age <= 50) {
      ranges['36-50'] = (ranges['36-50'] ?? 0) + 1;
    } else if (age <= 65) {
      ranges['51-65'] = (ranges['51-65'] ?? 0) + 1;
    } else {
      ranges['66+'] = (ranges['66+'] ?? 0) + 1;
    }
  }

  return ranges;
}

/// Calculer la croissance par mois (12 derniers mois)
Map<String, int> _calculateGrowth(List<Member> members) {
  final now = DateTime.now();
  final result = <String, int>{};

  // Initialiser les 12 derniers mois
  for (var i = 11; i >= 0; i--) {
    final month = DateTime(now.year, now.month - i, 1);
    final key = DateFormat('yyyy-MM').format(month);
    result[key] = 0;
  }

  // Compter les nouveaux membres par mois
  for (final member in members) {
    if (member.createdAt == null) continue;

    final createdMonth = DateFormat('yyyy-MM').format(member.createdAt!);
    if (result.containsKey(createdMonth)) {
      result[createdMonth] = (result[createdMonth] ?? 0) + 1;
    }
  }

  return result;
}

/// Calculer l'âge moyen
double _calculateAverageAge(List<Member> members) {
  final membersWithBirthDate =
      members.where((m) => m.birthDate != null).toList();

  if (membersWithBirthDate.isEmpty) return 0.0;

  final totalAge = membersWithBirthDate.fold<int>(
    0,
    (sum, member) => sum + _calculateAge(member.birthDate!),
  );

  return totalAge / membersWithBirthDate.length;
}

/// Calculer l'âge à partir de la date de naissance
int _calculateAge(DateTime birthDate) {
  final today = DateTime.now();
  var age = today.year - birthDate.year;
  if (today.month < birthDate.month ||
      (today.month == birthDate.month && today.day < birthDate.day)) {
    age--;
  }
  return age;
}