import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/data/local/isar_service.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/services/offline_sync_manager.dart';
import 'package:isar/isar.dart';
import 'package:lumina/features/bible/core/models/bible_models.dart';

part 'bible_reward_service.g.dart';

@Riverpod(keepAlive: true)
class BibleRewardService extends _$BibleRewardService {
  late final IsarService _isarService;
  late final OfflineSyncManager _syncManager;

  @override
  FutureOr<List<BibleRewardModel>> build() async {
    _isarService = ref.watch(isarServiceProvider);
    _syncManager = ref.watch(offlineSyncManagerProvider);
    return _fetchLocalRewards();
  }

  Future<List<BibleRewardModel>> _fetchLocalRewards() async {
    final authState = ref.read(authProvider).valueOrNull;
    final userId = authState?.user?.id;
    final churchId = authState?.activeChurchId;

    if (userId == null || churchId == null) return [];

    return _isarService.bibleRewardModels
        .filter()
        .userIdEqualTo(userId)
        .churchIdEqualTo(churchId)
        .sortByGrantedAtDesc()
        .build()
        .findAll();
  }

  /// Map of Plan ID and completion milestones to PDF rewards
  static const Map<String, String> _planRewardMap = {
    'bible_1_year': 'Une-vie-motivée-par-lessentiel.Rick-Warren.pdf',
    'proverbs_31': 'aix-fre.pdf',
    'psalms_30': 'bxl1-fre.pdf',
    'gospels_60': 'bxl2-fre.pdf',
  };

  /// Unlocks a reward for a specific plan.
  Future<void> unlockReward({
    required String planId,
    required String type, // 'badge', 'pdf'
    String? rewardName,
  }) async {
    final authState = ref.read(authProvider).valueOrNull;
    final userId = authState?.user?.id;
    final churchId = authState?.activeChurchId;

    if (userId == null || churchId == null) {
      AppLogger.w('Cannot unlock reward: No user or church session', 'REWARD_SERVICE');
      return;
    }

    final rewardUrl = type == 'pdf' ? _planRewardMap[planId] : null;

    final reward = BibleRewardModel()
      ..userId = userId
      ..churchId = churchId
      ..planId = planId
      ..rewardType = type
      ..rewardUrl = rewardUrl
      ..grantedAt = DateTime.now();

    await _isarService.db.writeTxn(() async {
      await _isarService.bibleRewardModels.put(reward);
    });

    // Sync with Supabase
    await _syncManager.registerAction(
      entityType: 'bible_reading_rewards',
      action: 'INSERT',
      payload: {
        'user_id': userId,
        'church_id': churchId,
        'subscription_id': null, // Will be linked in Supabase if needed, or we could pass subId
        'reward_type': type,
        'reward_url': rewardUrl,
        'granted_at': reward.grantedAt.toIso8601String(),
      },
      churchId: churchId,
    );

    AppLogger.i('Reward unlocked: $type for plan $planId', 'REWARD_SERVICE');
    ref.invalidateSelf();
  }

  /// Checks if a reward is already unlocked for a plan
  Future<bool> isRewardUnlocked(String planId, String type) async {
    final rewards = await _fetchLocalRewards();
    return rewards.any((r) => r.planId == planId && r.rewardType == type);
  }
}