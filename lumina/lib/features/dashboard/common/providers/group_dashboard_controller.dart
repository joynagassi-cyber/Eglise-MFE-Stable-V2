import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../services/group_dashboard_service.dart';
import '../../../../core/providers/global_providers.dart';

part 'group_dashboard_controller.g.dart';

@riverpod
class GroupDashboardController extends _$GroupDashboardController {
  @override
  FutureOr<Map<String, dynamic>> build(String groupId) async {
    final service = GroupDashboardService(ref.watch(supabaseClientProvider));
    return await service.getDashboardData(groupId);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    // In build_runner generated code, the argument is available as 'this.groupId' or just 'groupId'
    state = await AsyncValue.guard(() async => await build(groupId));
  }
}