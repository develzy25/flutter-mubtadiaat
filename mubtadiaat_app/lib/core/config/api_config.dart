class ApiConfig {
  static const String devBaseUrl = 'https://dev-api.mubtadiaat.com/api/v1';
  static const String stagingBaseUrl = 'https://staging-api.mubtadiaat.com/api/v1';
  static const String prodBaseUrl = 'https://api.mubtadiaat.com/api/v1';

  static const int connectTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000;

  static const String contentType = 'application/json';
  static const String accept = 'application/json';
}
