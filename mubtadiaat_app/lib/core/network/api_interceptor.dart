import 'package:dio/dio.dart';
import '../storage/secure_storage.dart';
import '../services/logger_service.dart';

class ApiInterceptor extends Interceptor {
  final SecureStorage secureStorage;

  ApiInterceptor(this.secureStorage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    LoggerService.info('API Request: ${options.method} ${options.uri}');
    
    // Inject JWT Token
    final token = await secureStorage.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    LoggerService.info('API Response: ${response.statusCode} ${response.requestOptions.uri}');
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    LoggerService.error('API Error: ${err.message}');
    
    // Check if unauthorized (Token expired)
    if (err.response?.statusCode == 401) {
      LoggerService.warning('Token expired, attempting refresh...');
      // Implement token refresh logic here
      // If refresh fails, log out user
    }
    
    return handler.next(err);
  }
}
