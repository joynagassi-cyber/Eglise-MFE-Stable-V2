// Configuration de l'API pour le système de gestion de photos
class ApiConstants {
  // Cloudflare Worker R2
  static const String baseUrl =
      'https://lumina-storage-worker.joynagassi.workers.dev';

  // Endpoints
  static const String uploadPhotoEndpoint = '/upload';
  static const String downloadEndpoint = '/download';
  static const String healthCheckEndpoint = '/health';

  // URL complète pour l'upload
  static String get uploadPhotoUrl => '$baseUrl$uploadPhotoEndpoint';

  // Timeout pour les requêtes
  static const Duration requestTimeout = Duration(seconds: 30);
}
