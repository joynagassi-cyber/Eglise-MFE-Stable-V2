import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/church_service.dart';
import '../repositories/i_celebration_repository.dart';

class GetServicesUseCase {
  final ICelebrationRepository repository;

  GetServicesUseCase(this.repository);

  Future<Either<Failure, List<ChurchService>>> call(String churchId) async {
    try {
      final services = await repository.getServices(churchId);
      return Right(services);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}