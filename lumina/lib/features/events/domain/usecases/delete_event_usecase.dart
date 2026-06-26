import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/i_event_repository.dart';

class DeleteEventUseCase {
  final IEventRepository repository;

  DeleteEventUseCase(this.repository);

  Future<Either<Failure, void>> call(String eventId,
      {required String churchId}) async {
    if (eventId.isEmpty) {
      return const Left(ValidationFailure('Event ID cannot be empty'));
    }
    try {
      await repository.deleteEvent(eventId, churchId: churchId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}