import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/church_service.dart';
import '../repositories/i_celebration_repository.dart';

class CreateServiceUseCase {
  final ICelebrationRepository repository;

  CreateServiceUseCase(this.repository);

  Future<Either<Failure, void>> call(ChurchService service) async {
    if (service.churchId.isEmpty) {
      return const Left(ValidationFailure('Church ID cannot be empty'));
    }
    try {
      await repository.createService(service);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}