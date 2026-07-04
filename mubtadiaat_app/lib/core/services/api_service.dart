import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const String kBaseUrl = 'http://127.0.0.1:8787/api/v1';

class ApiService {
  final Dio _dio;

  ApiService()
      : _dio = Dio(
          BaseOptions(
            baseUrl: kBaseUrl,
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        ) {
    // Interceptor untuk token & error handling
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Inject Bearer Token from Secure Storage here
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          // Handle global errors here
          return handler.next(e);
        },
      ),
    );
  }

  /// Generic GET request
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    return await _dio.get(path, queryParameters: queryParameters);
  }

  /// Generic POST request
  Future<Response> post(String path, {dynamic data}) async {
    return await _dio.post(path, data: data);
  }

  /// Generic PUT request
  Future<Response> put(String path, {dynamic data}) async {
    return await _dio.put(path, data: data);
  }

  /// Generic DELETE request
  Future<Response> delete(String path) async {
    return await _dio.delete(path);
  }
}

// Provider untuk API Service
final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

// Contoh Generic Provider untuk Fetch List Data
final genericListProvider = FutureProvider.family<List<dynamic>, String>((ref, endpoint) async {
  final api = ref.read(apiServiceProvider);
  try {
    final response = await api.get(endpoint);
    // If API returns array directly:
    if (response.data is List) {
      return response.data as List<dynamic>;
    }
    // If API returns { "data": [...] }
    if (response.data != null && response.data['data'] != null) {
      return response.data['data'] as List<dynamic>;
    }
    return [];
  } catch (e) {
    // Return empty list or throw for error state UI
    // throw Exception('Gagal mengambil data dari $endpoint');
    return []; // For now, prevent hard crash on unbuilt endpoints
  }
});
