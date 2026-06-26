enum Environment { dev, staging, prod }

class EnvConfig {
  // Lire l'environnement depuis --dart-define=APP_ENV=prod (immutable, compile-time)
  static const String _envName = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'dev',
  );

  static final Environment current = _parseEnvironment(_envName);

  static Environment _parseEnvironment(String name) {
    switch (name) {
      case 'prod':
        return Environment.prod;
      case 'staging':
        return Environment.staging;
      default:
        return Environment.dev;
    }
  }

  static String get supabaseUrl {
    switch (current) {
      case Environment.dev:
        return const String.fromEnvironment('SUPABASE_URL_DEV');
      case Environment.staging:
        return const String.fromEnvironment('SUPABASE_URL_STAGING');
      case Environment.prod:
        return const String.fromEnvironment('SUPABASE_URL_PROD');
    }
  }

  static String get supabaseAnonKey {
    switch (current) {
      case Environment.dev:
        return const String.fromEnvironment('SUPABASE_ANON_KEY_DEV');
      case Environment.staging:
        return const String.fromEnvironment('SUPABASE_ANON_KEY_STAGING');
      case Environment.prod:
        return const String.fromEnvironment('SUPABASE_ANON_KEY_PROD');
    }
  }

  static bool get isProduction => current == Environment.prod;
  static bool get isDevelopment => current == Environment.dev;
}
