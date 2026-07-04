import 'package:dio/dio.dart';
import '../config/flavor.dart';
import '../config/api_config.dart';
import 'api_interceptor.dart';

class ApiClient {
  late final Dio _dio;

  ApiClient(ApiInterceptor interceptor) {
    _dio = Dio(
      BaseOptions(
        baseUrl: Flavor.baseUrl,
        connectTimeout: const Duration(milliseconds: ApiConfig.connectTimeout),
        receiveTimeout: const Duration(milliseconds: ApiConfig.receiveTimeout),
        headers: {
          'Content-Type': ApiConfig.contentType,
          'Accept': ApiConfig.accept,
        },
      ),
    );

    _dio.interceptors.add(interceptor);
  }

  Dio get dio => _dio;
}
