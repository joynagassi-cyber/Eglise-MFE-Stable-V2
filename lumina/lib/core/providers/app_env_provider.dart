import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_env_provider.g.dart';

/// Provider lecteur de variables d'environnement de l'app.
///
/// Résout les valeurs dans cet ordre :
/// 1. --dart-define injecté en CI (prioritaire)
/// 2. fichier .env local en debug
/// 3. flutter_dotenv (asset bundle legacy)
///
/// Expose aussi les valeurs les plus utilisées pour éviter
/// de répéter `String.fromEnvironment` dans le code métier.
class AppEnv {
  AppEnv(this._readEnv);

  final String? Function(String key) _readEnv;

  String? get(String key) => _readEnv(key);

  String? get googleWebClientId => get('GOOGLE_WEB_CLIENT_ID');

  String? get supabaseUrl => get('SUPABASE_URL');
  String? get supabaseAnonKey => get('SUPABASE_ANON_KEY');
}

@riverpod
AppEnv appEnv(AppEnvRef ref) {
  // Valeur par défaut sûre : en CI, AppBootstrap injecte l'override
  // avec le vrai reader construit depuis les --dart-define.
  // En debug sans .env, toutes les valeurs retournent null.
  return AppEnv((key) => null);
}

@riverpod
String? googleWebClientId(GoogleWebClientIdRef ref) {
  return ref.watch(appEnvProvider).googleWebClientId;
}
