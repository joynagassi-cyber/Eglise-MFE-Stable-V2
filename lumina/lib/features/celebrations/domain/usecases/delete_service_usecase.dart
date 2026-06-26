import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/i_celebration_repository.dart';

class DeleteServiceUseCase {
  final ICelebrationRepository repository;

  DeleteServiceUseCase(this.repository);

  Future<Either<Failure, void>> call(String serviceId) async {
    if (serviceId.isEmpty) {
      return const Left(ValidationFailure('Service ID cannot be empty'));
    }
    try {
      await repository.deleteService(serviceId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}