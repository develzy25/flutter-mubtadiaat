import 'env.dart';
import 'api_config.dart';

class Flavor {
  static String get title {
    switch (Env.currentEnvironment) {
      case Environment.development:
        return "e-Mubtadi'at Dev";
      case Environment.staging:
        return "e-Mubtadi'at Staging";
      case Environment.production:
        return "e-Mubtadi'at";
    }
  }

  static String get baseUrl {
    switch (Env.currentEnvironment) {
      case Environment.development:
        return ApiConfig.devBaseUrl;
      case Environment.staging:
        return ApiConfig.stagingBaseUrl;
      case Environment.production:
        return ApiConfig.prodBaseUrl;
    }
  }
}
