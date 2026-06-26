import 'package:dartz/dartz.dart';
import 'package:lumina/core/error/failures.dart';
import '../entities/prayer_vigil.dart';
import '../entities/permanent_prayer_subject.dart';

abstract class IntercessionRepository {
  Future<Either<Failure, List<PrayerVigil>>> getPrayerVigils(String groupId);
  Future<Either<Failure, List<PermanentPrayerSubject>>>
      getPermanentPrayerSubjects(String groupId);
  Future<Either<Failure, void>> createPrayerVigil(PrayerVigil vigil);
  Future<Either<Failure, void>> createPermanentPrayerSubject(
      PermanentPrayerSubject subject);
}