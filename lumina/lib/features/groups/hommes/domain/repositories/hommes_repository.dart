import 'package:dartz/dartz.dart';
import 'package:lumina/core/error/failures.dart';
import '../entities/group_project.dart';
import '../entities/mentorship_pair.dart';

abstract class HommesRepository {
  /// Projets
  Future<Either<Failure, List<GroupProject>>> getProjects(String groupId);
  Future<Either<Failure, GroupProject>> addProject(GroupProject project);
  Future<Either<Failure, GroupProject>> updateProject(GroupProject project);
  Future<Either<Failure, Unit>> deleteProject(String id, String churchId);

  /// Mentorat
  Future<Either<Failure, List<MentorshipPair>>> getMentorshipPairs(
      String groupId);
  Future<Either<Failure, MentorshipPair>> addMentorshipPair(
      MentorshipPair pair);
  Future<Either<Failure, MentorshipPair>> updateMentorshipPair(
      MentorshipPair pair);
  Future<Either<Failure, Unit>> deleteMentorshipPair(
      String id, String churchId);
}