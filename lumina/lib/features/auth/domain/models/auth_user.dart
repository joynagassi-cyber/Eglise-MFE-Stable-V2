// lib/features/auth/domain/models/auth_user.dart

class AppAuthUser {
  final String id;
  final String email;
  final String? firstName;
  final String? lastName;

  const AppAuthUser({
    required this.id,
    required this.email,
    this.firstName,
    this.lastName,
  });

  factory AppAuthUser.fromSupabase(Map<String, dynamic> data) {
    return AppAuthUser(
      id: data['id'] as String,
      email: data['email'] as String,
      firstName: data['first_name'] as String?,
      lastName: data['last_name'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
    };
  }
}