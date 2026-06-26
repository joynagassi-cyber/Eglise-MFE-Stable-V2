import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:lumina/core/providers/repository_providers_content.dart';
import 'package:lumina/features/bergers/domain/entities/shepherd.dart';
import 'package:lumina/features/bergers/domain/entities/pastoral_visit.dart';

part 'equipe_controller.g.dart';

/// Controller for the Equipe (Team) module.
/// Aggregates shepherds and pastoral visits into a unified team view.
@riverpod
class EquipeController extends _$EquipeController {
  @override
  Future<EquipeState> build({String? churchId}) async {
    final shepherdRepo = ref.watch(shepherdRepositoryProvider);
    final shepherds = await shepherdRepo.getShepherds(churchId: churchId);
    final visits = await shepherdRepo.getPastoralVisits();

    final now = DateTime.now();
    final plannedVisits = visits.where((v) => v.date.isAfter(now)).toList();
    final completedVisits = visits.where((v) => v.date.isBefore(now)).toList();

    return EquipeState(
      shepherds: shepherds,
      plannedVisits: plannedVisits,
      completedVisits: completedVisits,
      totalVisitsThisMonth: visits
          .where((v) => v.date.month == now.month && v.date.year == now.year)
          .length,
    );
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }

  Future<void> logVisit(PastoralVisit visit) async {
    final repo = ref.read(shepherdRepositoryProvider);
    await repo.logPastoralVisit(visit);
    ref.invalidateSelf();
  }

  Future<void> createShepherd(Shepherd shepherd) async {
    final repo = ref.read(shepherdRepositoryProvider);
    await repo.createShepherd(shepherd);
    ref.invalidateSelf();
  }

  Future<void> updateShepherd(Shepherd shepherd) async {
    final repo = ref.read(shepherdRepositoryProvider);
    await repo.updateShepherd(shepherd);
    ref.invalidateSelf();
  }

  Future<void> deleteShepherd(String id) async {
    final repo = ref.read(shepherdRepositoryProvider);
    await repo.deleteShepherd(id);
    ref.invalidateSelf();
  }
}

class EquipeState {
  final List<Shepherd> shepherds;
  final List<PastoralVisit> plannedVisits;
  final List<PastoralVisit> completedVisits;
  final int totalVisitsThisMonth;

  const EquipeState({
    this.shepherds = const [],
    this.plannedVisits = const [],
    this.completedVisits = const [],
    this.totalVisitsThisMonth = 0,
  });

  int get activeShepherdCount => shepherds.length;
  int get pendingVisitCount => plannedVisits.length;
}
