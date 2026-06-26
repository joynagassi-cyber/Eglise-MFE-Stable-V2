import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:lumina/core/providers/repository_providers_content.dart';
import '../../../../core/services/analytics/dashboard_analytics_service.dart';
import '../../../membres/presentation/providers/member_list_provider.dart';
import '../../../finance/presentation/providers/finance_providers.dart';

part 'analytics_provider.g.dart';

@riverpod
class DashboardAnalytics extends _$DashboardAnalytics {
  @override
  FutureOr<Map<String, dynamic>> build() async {
    final service = DashboardAnalyticsService();

    final members = await ref.watch(memberListProvider.future);
    final transactions = await ref.watch(transactionListProvider.future);
    final repository = ref.watch(eventRepositoryProvider);
    final events = await repository.getEvents();

    return {
      'members': service.calculateMemberAnalytics(members),
      'finance': service.calculateFinanceAnalytics(transactions),
      'events': service.calculateEventAnalytics(events),
    };
  }
}
