import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/event.dart';
import '../repositories/i_event_repository.dart';

class CreateEventUseCase {
  final IEventRepository repository;

  CreateEventUseCase(this.repository);

  Future<Either<Failure, Event>> call(Event event) async {
    if (event.title.isEmpty) {
      return const Left(ValidationFailure('Title is required'));
    }
    try {
      final result = await repository.createEvent(event);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}