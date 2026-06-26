import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/data/local/isar_service.dart';
import '../../../../core/logging/app_logger.dart';
// import '../../../../core/services/background_sync_service.dart';
import '../../../../core/providers/auth_provider.dart';
// Repository provider imports now come from feature-specific modules.
import 'package:lumina/features/bible/core/models/bible_models.dart';
import 'package:lumina/features/bible/data/services/bible_reward_service.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/services/offline_sync_manager.dart';

part 'bible_plan_service.g.dart';

/// Provides a list of available reading plans (hardcoded catalog).
List<BibleReadingPlanModel> getAvailablePlans() {
  return [
    _buildBibleIn1Year(),
    _buildProverbs31(),
    _buildPsalms30(),
    _buildGospels60(),
  ];
}

// ── Plan Builders ──────────────────────────────────

BibleReadingPlanModel _buildBibleIn1Year() {
  final plan = BibleReadingPlanModel()
    ..planId = 'bible_1_year'
    ..title = 'La Bible en 1 an'
    ..description =
        'Parcourez l\'intégralité de la Bible en 365 jours, avec des lectures de l\'Ancien et du Nouveau Testament chaque jour.'
    ..durationInDays = 365
    ..days = List.generate(365, (i) {
      return PlanDayModel()
        ..dayNumber = i + 1
        ..title = 'Jour ${i + 1}'
        ..references = _bible1YearRef(i + 1);
    });
  return plan;
}

BibleReadingPlanModel _buildProverbs31() {
  final plan = BibleReadingPlanModel()
    ..planId = 'proverbs_31'
    ..title = 'Proverbes en 31 jours'
    ..description =
        'Un chapitre de Proverbes par jour pendant un mois complet de sagesse.'
    ..durationInDays = 31
    ..days = List.generate(31, (i) {
      return PlanDayModel()
        ..dayNumber = i + 1
        ..title = 'Proverbes ${i + 1}'
        ..references = ['PRO ${i + 1}'];
    });
  return plan;
}

BibleReadingPlanModel _buildPsalms30() {
  final plan = BibleReadingPlanModel()
    ..planId = 'psalms_30'
    ..title = 'Psaumes en 30 jours'
    ..description =
        'Explorez les 150 Psaumes en 30 jours, 5 psaumes par jour pour nourrir votre vie de prière.'
    ..durationInDays = 30
    ..days = List.generate(30, (i) {
      final start = i * 5 + 1;
      final end = (start + 4).clamp(1, 150);
      return PlanDayModel()
        ..dayNumber = i + 1
        ..title = 'Psaumes $start–$end'
        ..references = List.generate(5, (j) => 'PSA ${start + j}')
            .where((r) => int.parse(r.split(' ').last) <= 150)
            .toList();
    });
  return plan;
}

BibleReadingPlanModel _buildGospels60() {
  final gospelChapters = <String>[
    ...List.generate(28, (i) => 'MAT ${i + 1}'),
    ...List.generate(16, (i) => 'MRK ${i + 1}'),
    ...List.generate(24, (i) => 'LUK ${i + 1}'),
    ...List.generate(21, (i) => 'JHN ${i + 1}'),
  ]; // 89 chapters total

  final plan = BibleReadingPlanModel()
    ..planId = 'gospels_60'
    ..title = 'Les Évangiles en 60 jours'
    ..description =
        'Plongez dans la vie de Jésus à travers les quatre Évangiles : Matthieu, Marc, Luc et Jean.'
    ..durationInDays = 60
    ..days = List.generate(60, (i) {
      final startIdx = (i * gospelChapters.length / 60).floor();
      final endIdx = ((i + 1) * gospelChapters.length / 60).floor();
      final refs = gospelChapters.sublist(startIdx, endIdx);
      return PlanDayModel()
        ..dayNumber = i + 1
        ..title = 'Jour ${i + 1}'
        ..references = refs;
    });
  return plan;
}

/// Simplified references for 1 Year plan (OT + NT mix).
/// Generates dummy references based on day number.
List<String> _bible1YearRef(int day) {
  // Simplified: distribute ~929 OT chapters + 260 NT chapters across 365 days
  final otChapter = ((day - 1) * 929 / 365).floor() + 1;
  final ntChapter = ((day - 1) * 260 / 365).floor() + 1;

  final otBooks = [
    'GEN',
    'EXO',
    'LEV',
    'NUM',
    'DEU',
    'JOS',
    'JDG',
    'RUT',
    '1SA',
    '2SA',
    '1KI',
    '2KI',
    '1CH',
    '2CH',
    'EZR',
    'NEH',
    'EST',
    'JOB',
    'PSA',
    'PRO',
    'ECC',
    'SNG',
    'ISA',
    'JER',
    'LAM',
    'EZK',
    'DAN',
    'HOS',
    'JOL',
    'AMO',
    'OBA',
    'JON',
    'MIC',
    'NAM',
    'HAB',
    'ZEP',
    'HAG',
    'ZEC',
    'MAL',
  ];
  final ntBooks = [
    'MAT',
    'MRK',
    'LUK',
    'JHN',
    'ACT',
    'ROM',
    '1CO',
    '2CO',
    'GAL',
    'EPH',
    'PHP',
    'COL',
    '1TH',
    '2TH',
    '1TI',
    '2TI',
    'TIT',
    'PHM',
    'HEB',
    'JAS',
    '1PE',
    '2PE',
    '1JN',
    '2JN',
    '3JN',
    'JUD',
    'REV',
  ];

  final otBook =
      otBooks[(otChapter * otBooks.length ~/ 930).clamp(0, otBooks.length - 1)];
  final ntBook =
      ntBooks[(ntChapter * ntBooks.length ~/ 261).clamp(0, ntBooks.length - 1)];

  return ['$otBook ${(otChapter % 50) + 1}', '$ntBook ${(ntChapter % 28) + 1}'];
}

// ── Riverpod Service ───────────────────────────────

@Riverpod(keepAlive: true)
class BiblePlanService extends _$BiblePlanService {
  late final IsarService _isarService;
  late final OfflineSyncManager _syncManager;

  @override
  List<BibleReadingPlanModel> build() {
    _isarService = ref.watch(isarServiceProvider);
    _syncManager = ref.watch(offlineSyncManagerProvider);
    return getAvailablePlans();
  }

  /// Start a plan for the current user.
  Future<void> startPlan(String planId) async {
    final authState = ref.read(authProvider).valueOrNull;
    final userId = authState?.user?.id ?? 'anonymous';
    final churchId = authState?.activeChurchId ?? 'default';

    // Check if already started
    final existing = await _isarService.biblePlanProgressModels
        .filter()
        .planIdEqualTo(planId)
        .userIdEqualTo(userId)
        .churchIdEqualTo(churchId)
        .findFirst();

    if (existing != null) {
      AppLogger.i('Plan $planId already started for $userId', 'PLAN_SERVICE');
      return;
    }

    final progress = BiblePlanProgressModel()
      ..planId = planId
      ..userId = userId
      ..churchId = churchId
      ..startDate = DateTime.now()
      ..completedDays = []
      ..lastReadAt = DateTime.now()
      ..status = 'active';

    await _isarService.db.writeTxn(() async {
      await _isarService.biblePlanProgressModels.put(progress);
    });

    // Sync subscription with Supabase
    await _syncManager.registerAction(
      entityType: 'bible_reading_plan_subscriptions',
      action: 'INSERT',
      payload: {
        'user_id': userId,
        'church_id': churchId,
        'plan_id': planId,
        'start_date': progress.startDate.toIso8601String(),
        'current_day': 1,
        'status': 'active',
      },
      churchId: churchId,
    );

    AppLogger.i('Plan $planId started!', 'PLAN_SERVICE');
    ref.invalidate(activeBiblePlansProvider);
  }

  /// Mark a specific day as completed.
  Future<void> markDayAsCompleted(String planId, int dayNumber) async {
    final authState = ref.read(authProvider).valueOrNull;
    final userId = authState?.user?.id ?? 'anonymous';
    final churchId = authState?.activeChurchId ?? 'default';

    final progress = await _isarService.biblePlanProgressModels
        .filter()
        .planIdEqualTo(planId)
        .userIdEqualTo(userId)
        .churchIdEqualTo(churchId)
        .findFirst();

    if (progress == null) return;

    if (!progress.completedDays.contains(dayNumber)) {
      progress.completedDays = [...progress.completedDays, dayNumber];
      progress.lastReadAt = DateTime.now();

      // Check if plan is fully completed
      final plan = getAvailablePlans().firstWhere((p) => p.planId == planId);
      if (progress.completedDays.length >= plan.durationInDays) {
        progress.status = 'completed';
        // Unlock Reward
        await ref.read(bibleRewardServiceProvider.notifier).unlockReward(
              planId: planId,
              type: 'pdf',
            );
        await ref.read(bibleRewardServiceProvider.notifier).unlockReward(
              planId: planId,
              type: 'badge',
            );
      }

      await _isarService.db.writeTxn(() async {
        await _isarService.biblePlanProgressModels.put(progress);
      });

      // Sync progress with Supabase
      await _syncManager.registerAction(
        entityType: 'bible_reading_daily_progress',
        action: 'INSERT',
        payload: {
          'user_id': userId,
          'church_id': churchId,
          'plan_id': planId,
          'day_number': dayNumber,
          'completed_at': progress.lastReadAt.toIso8601String(),
        },
        churchId: churchId,
      );

      // Update subscription current_day
      await _syncManager.registerAction(
        entityType: 'bible_reading_plan_subscriptions',
        action: 'UPDATE',
        payload: {
          'user_id': userId,
          'plan_id': planId,
          'current_day': progress.completedDays.length + 1,
          'status': progress.isCompleted ? 'completed' : 'active',
        },
        churchId: churchId,
      );

      AppLogger.d('Day $dayNumber completed for plan $planId', 'PLAN_SERVICE');
      ref.invalidate(activeBiblePlansProvider);
    }
  }

  /// Get the progress for a specific plan.
  Future<BiblePlanProgressModel?> getProgress(String planId) async {
    final authState = ref.read(authProvider).valueOrNull;
    final userId = authState?.user?.id ?? 'anonymous';
    final churchId = authState?.activeChurchId ?? 'default';

    return _isarService.biblePlanProgressModels
        .filter()
        .planIdEqualTo(planId)
        .userIdEqualTo(userId)
        .churchIdEqualTo(churchId)
        .findFirst();
  }

  /// Get all active plans for the current user.
  Future<List<BiblePlanProgressModel>> getActivePlans() async {
    final authState = ref.read(authProvider).valueOrNull;
    final userId = authState?.user?.id ?? 'anonymous';
    final churchId = authState?.activeChurchId ?? 'default';

    return _isarService.biblePlanProgressModels
        .filter()
        .userIdEqualTo(userId)
        .churchIdEqualTo(churchId)
        .findAll();
  }

  /// Delete a plan's progress (abandon the plan).
  Future<void> abandonPlan(String planId) async {
    final authState = ref.read(authProvider).valueOrNull;
    final userId = authState?.user?.id ?? 'anonymous';
    final churchId = authState?.activeChurchId ?? 'default';

    final progress = await _isarService.biblePlanProgressModels
        .filter()
        .planIdEqualTo(planId)
        .userIdEqualTo(userId)
        .churchIdEqualTo(churchId)
        .findFirst();

    if (progress != null) {
      await _isarService.db.writeTxn(() async {
        await _isarService.biblePlanProgressModels.delete(progress.id);
      });

      // Sync with Supabase
      await _syncManager.registerAction(
        entityType: 'bible_reading_plan_subscriptions',
        action: 'UPDATE',
        payload: {
          'user_id': userId,
          'plan_id': planId,
          'status': 'abandoned',
        },
        churchId: churchId,
      );

      AppLogger.i('Plan $planId abandoned', 'PLAN_SERVICE');
      ref.invalidate(activeBiblePlansProvider);
    }
  }
}

@riverpod
Future<List<BiblePlanProgressModel>> activeBiblePlans(
    ActiveBiblePlansRef ref) async {
  final service = ref.watch(biblePlanServiceProvider.notifier);
  return service.getActivePlans();
}
