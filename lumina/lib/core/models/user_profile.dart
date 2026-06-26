// ============================================================
// FICHIER : lib/core/models/user_profile.dart
// DESCRIPTION : Modèle UserProfile mappé depuis la table 'profiles'
// DÉPENDANCES : aucune (pur Dart)
// ============================================================

class UserProfile {
  final String id;
  final String? churchId;
  final String firstName;
  final String lastName;
  final String? email;
  final String? phone;
  final String role;
  final String? specificRole;
  final String? groupId;
  final String? avatarUrl;
  final DateTime? memberSince;
  final bool isActive;
  final DateTime createdAt;

  const UserProfile({
    required this.id,
    this.churchId,
    this.firstName = '',
    this.lastName = '',
    this.email,
    this.phone,
    this.role = 'member',
    this.specificRole,
    this.groupId,
    this.avatarUrl,
    this.memberSince,
    this.isActive = true,
    required this.createdAt,
  });

  String get displayName {
    final full = '$firstName $lastName'.trim();
    return full.isEmpty ? (email ?? 'Utilisateur') : full;
  }

  String get initials {
    final f = firstName.isNotEmpty ? firstName[0].toUpperCase() : '';
    final l = lastName.isNotEmpty ? lastName[0].toUpperCase() : '';
    return '$f$l'.isEmpty ? '?' : '$f$l';
  }

  bool get isSuperAdmin => role == 'superadmin';
  bool get isAdmin => role == 'superadmin' || role == 'admin';
  bool get isGroupLeader => role == 'group_leader';
  bool get isMember => role == 'member';

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      churchId: json['church_id'] as String?,
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      role: json['role'] as String? ?? 'member',
      specificRole: json['specific_role'] as String?,
      groupId: json['group_id'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      memberSince: json['member_since'] != null
          ? DateTime.tryParse(json['member_since'] as String)
          : null,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(
        json['created_at'] as String? ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'church_id': churchId,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'role': role,
      'specific_role': specificRole,
      'group_id': groupId,
      'avatar_url': avatarUrl,
      'member_since': memberSince?.toIso8601String(),
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
    };
  }

  UserProfile copyWith({
    String? id,
    String? churchId,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? role,
    String? specificRole,
    String? groupId,
    String? avatarUrl,
    DateTime? memberSince,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      churchId: churchId ?? this.churchId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      specificRole: specificRole ?? this.specificRole,
      groupId: groupId ?? this.groupId,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      memberSince: memberSince ?? this.memberSince,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfile &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'UserProfile($displayName, role: $role)';
}
