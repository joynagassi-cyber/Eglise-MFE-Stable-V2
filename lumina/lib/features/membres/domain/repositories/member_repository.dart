import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/member.dart';
import '../../data/models/member_models.dart' hide Member;

abstract class MemberRepository {
  Future<Either<Failure, List<Member>>> getMembers({
    int page = 1,
    int perPage = 50,
    String? search,
  });
  Future<Either<Failure, Member>> getMemberById(String id);
  Future<Either<Failure, Member>> getMemberByUserId(String userId);
  Future<Either<Failure, void>> createMember(Member member);
  Future<Either<Failure, void>> updateMember(Member member);
  Future<Either<Failure, void>> deleteMember(String id);
  Stream<List<Member>> watchMembers();
  Future<Either<Failure, String>> uploadMemberPhoto(
      String memberId, File photoFile);

  // Sprint 5: Family Relationships
  Future<Either<Failure, List<FamilyRelationship>>> getFamilyRelationships(
      String memberId);
  Future<Either<Failure, void>> addFamilyRelationship(
      FamilyRelationship relationship);
  Future<Either<Failure, void>> removeFamilyRelationship(String relationshipId);

  // Sprint 5: Spiritual Tracking
  Future<Either<Failure, SpiritualTracking?>> getSpiritualTracking(
      String memberId);
  Future<Either<Failure, void>> updateSpiritualTracking(
      SpiritualTracking tracking);

  // Sprint 5: Member History
  Future<Either<Failure, List<MemberHistory>>> getMemberHistory(
      String memberId);
  Future<Either<Failure, List<Member>>> getMembersByGroup(String groupId);
}