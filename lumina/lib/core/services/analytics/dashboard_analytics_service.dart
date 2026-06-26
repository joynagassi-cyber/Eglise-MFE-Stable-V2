import '../../../features/membres/domain/entities/member.dart';
import '../../../features/membres/domain/entities/enums/enums.dart';
import '../../../features/finance/domain/entities/finance_transaction.dart';
import '../../../features/events/domain/entities/event.dart';

class DashboardAnalyticsService {
  Map<String, dynamic> calculateMemberAnalytics(List<Member> members) {
    final now = DateTime.now();
    final lastMonth = now.subtract(const Duration(days: 30));

    final newMembersMonth = members
        .where((m) => m.createdAt != null && m.createdAt!.isAfter(lastMonth))
        .length;
    final membersWithBirthDate = members.where((m) => m.birthDate != null);
    final avgAge = membersWithBirthDate.isEmpty
        ? 0
        : membersWithBirthDate
                .map((m) => now.year - m.birthDate!.year)
                .fold(0, (a, b) => a + b) ~/
            membersWithBirthDate.length;

    return {
      'total': members.length,
      'newMonth': newMembersMonth,
      'growthRate': members.isNotEmpty
          ? (newMembersMonth / members.length * 100).toStringAsFixed(1)
          : '0',
      'avgAge': avgAge,
      'retention': _calculateRetention(members),
    };
  }

  Map<String, dynamic> calculateFinanceAnalytics(
      List<FinanceTransaction> transactions) {
    final now = DateTime.now();
    final thisMonth = transactions
        .where((t) => t.date.year == now.year && t.date.month == now.month);
    final lastMonth = transactions.where((t) =>
        t.date.year == (now.month == 1 ? now.year - 1 : now.year) &&
        t.date.month == (now.month == 1 ? 12 : now.month - 1));

    final income = thisMonth
        .where((t) => t.type.name == 'income')
        .fold(0.0, (s, t) => s + t.amount);
    final expense = thisMonth
        .where((t) => t.type.name == 'expense')
        .fold(0.0, (s, t) => s + t.amount);
    final lastIncome = lastMonth
        .where((t) => t.type.name == 'income')
        .fold(0.0, (s, t) => s + t.amount);

    return {
      'income': income,
      'expense': expense,
      'balance': income - expense,
      'growth': lastIncome > 0
          ? ((income - lastIncome) / lastIncome * 100).toStringAsFixed(1)
          : '0',
      'savingsRate': income > 0
          ? ((income - expense) / income * 100).toStringAsFixed(1)
          : '0',
    };
  }

  Map<String, dynamic> calculateEventAnalytics(List<Event> events) {
    final now = DateTime.now();
    final upcoming = events.where((e) => e.date.isAfter(now)).length;
    final past = events.where((e) => e.date.isBefore(now)).length;
    final eventsWithParticipants =
        events.where((e) => e.actualParticipants != null);
    final avgAttendance = eventsWithParticipants.isEmpty
        ? 0
        : eventsWithParticipants
                .map((e) => e.actualParticipants!)
                .fold(0, (a, b) => a + b) ~/
            eventsWithParticipants.length;

    return {
      'total': events.length,
      'upcoming': upcoming,
      'past': past,
      'avgAttendance': avgAttendance,
      'completionRate': events.isNotEmpty
          ? (past / events.length * 100).toStringAsFixed(1)
          : '0',
    };
  }

  double _calculateRetention(List<Member> members) {
    final now = DateTime.now();
    final sixMonthsAgo = now.subtract(const Duration(days: 180));
    final oldMembers = members.where(
        (m) => m.createdAt != null && m.createdAt!.isBefore(sixMonthsAgo));
    final activeOldMembers =
        oldMembers.where((m) => m.status == MemberStatus.active);
    return oldMembers.isEmpty
        ? 100
        : (activeOldMembers.length / oldMembers.length * 100);
  }
}
