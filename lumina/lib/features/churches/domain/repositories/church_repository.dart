import '../entities/church.dart';
import '../entities/federation.dart';

/// Interface du repository pour la gestion des églises
abstract class ChurchRepository {
  // ==================== CRUD Églises ====================

  /// Récupère une église par son ID
  /// Lecture prioritaire depuis le cache local (Isar)
  Future<Church?> getChurchById(String id);

  /// Récupère toutes les églises
  /// Retourne les données locales puis synchronise en arrière-plan
  Future<List<Church>> getAllChurches();

  /// Récupère les églises accessibles par l'utilisateur connecté
  /// Basé sur les permissions et les rôles de l'utilisateur
  Future<List<Church>> getUserChurches(String userId);

  /// Récupère les églises enfants d'une église mère
  Future<List<Church>> getChildChurches(String parentChurchId);

  /// Récupère les églises d'une fédération
  Future<List<Church>> getFederationChurches(String federationId);

  /// Crée une nouvelle église
  /// Sauvegarde localement puis synchronise avec Supabase
  Future<Church> createChurch(Church church);

  /// Met à jour une église existante
  Future<Church> updateChurch(Church church);

  /// Supprime une église (soft delete)
  Future<void> deleteChurch(String id);

  // ==================== CRUD Fédérations ====================

  /// Récupère une fédération par son ID
  Future<Federation?> getFederationById(String id);

  /// Récupère toutes les fédérations
  Future<List<Federation>> getAllFederations();

  /// Crée une nouvelle fédération
  Future<Federation> createFederation(Federation federation);

  /// Met à jour une fédération
  Future<Federation> updateFederation(Federation federation);

  /// Supprime une fédération
  Future<void> deleteFederation(String id);

  /// Ajoute une église à une fédération
  Future<void> addChurchToFederation(String churchId, String federationId);

  /// Retire une église d'une fédération
  Future<void> removeChurchFromFederation(String churchId, String federationId);

  // ==================== Synchronisation ====================

  /// Synchronise toutes les églises avec le serveur
  Future<void> syncChurches();

  /// Synchronise toutes les fédérations avec le serveur
  Future<void> syncFederations();

  // ==================== Streams Temps Réel ====================

  /// Stream des changements d'une église spécifique
  Stream<Church?> watchChurch(String id);

  /// Stream des églises de l'utilisateur
  Stream<List<Church>> watchUserChurches(String userId);

  /// Stream de toutes les églises
  Stream<List<Church>> watchAllChurches();

  /// Stream d'une fédération
  Stream<Federation?> watchFederation(String id);

  // ==================== Recherche & Filtres ====================

  /// Recherche d'églises par nom
  Future<List<Church>> searchChurches(String query);

  /// Filtre églises par type
  Future<List<Church>> getChurchesByType(ChurchType type);

  /// Filtre églises par ville
  Future<List<Church>> getChurchesByCity(String city);

  // ==================== Statistiques ====================

  /// Récupère le nombre total de membres de toutes les églises
  Future<int> getTotalMemberCount();

  /// Récupère les statistiques d'une église
  Future<Map<String, dynamic>> getChurchStats(String churchId);
}