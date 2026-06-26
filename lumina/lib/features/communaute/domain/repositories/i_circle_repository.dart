import '../entities/circle.dart';

abstract class ICircleRepository {
  /// Get all circles for a church
  Future<List<Circle>> getCircles({required String churchId});

  /// Get a circle by ID
  Future<Circle?> getCircleById(String id);

  /// Create a new circle
  Future<Circle> createCircle(Circle circle);

  /// Update a circle
  Future<Circle> updateCircle(Circle circle);

  /// Delete a circle
  Future<void> deleteCircle(String id);

  /// Get members of a circle
  Future<List<CircleMember>> getCircleMembers(String circleId);

  /// Add a member to a circle
  Future<void> addMemberToCircle({
    required String circleId,
    required String memberId,
    String role = 'member',
  });

  /// Remove a member from a circle
  Future<void> removeMemberFromCircle({
    required String circleId,
    required String memberId,
  });

  /// Search circles
  Future<List<Circle>> searchCircles({
    required String churchId,
    required String query,
  });
}