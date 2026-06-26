/// Catégorie d'utilisateur basée sur le rôle
///
/// Utilisé pour déterminer le flow d'onboarding et la catégorie
/// d'accès de l'utilisateur dans l'application.
enum UserCategory {
  /// Super administrateur système
  superadmin,

  /// Chef de groupe (berger, responsable, adjoint)
  groupLeader,

  /// Membre standard
  member,
}
