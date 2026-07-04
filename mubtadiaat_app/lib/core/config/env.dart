enum Environment { development, staging, production }

class Env {
  static Environment _currentEnvironment = Environment.development;
  static Environment get currentEnvironment => _currentEnvironment;

  static void setEnvironment(Environment env) {
    _currentEnvironment = env;
  }

  static bool get isProduction => _currentEnvironment == Environment.production;
  static bool get isDevelopment => _currentEnvironment == Environment.development;
  static bool get isStaging => _currentEnvironment == Environment.staging;
}
