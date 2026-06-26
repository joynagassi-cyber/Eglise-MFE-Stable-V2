import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/church_service.dart';
import '../repositories/i_celebration_repository.dart';

class UpdateServiceUseCase {
  final ICelebrationRepository repository;

  UpdateServiceUseCase(this.repository);

  Future<Either<Failure, void>> call(ChurchService service) async {
    if (service.id.isEmpty) {
      return const Left(ValidationFailure('Service ID cannot be empty'));
    }
    try {
      await repository.updateService(service);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}