import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/event.dart';
import '../repositories/i_event_repository.dart';

class GetEventsUseCase {
  final IEventRepository repository;

  GetEventsUseCase(this.repository);

  Future<Either<Failure, List<Event>>> call({String? churchId}) async {
    try {
      final result = await repository.getEvents(churchId: churchId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}