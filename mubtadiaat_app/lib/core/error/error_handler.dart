import 'package:dio/dio.dart';
import 'exceptions.dart';
import 'failures.dart';
import 'error_message.dart';

class ErrorHandler {
  static Failure handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutFailure(ErrorMessage.timeout);
      
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final responseData = error.response?.data;
        
        String message = ErrorMessage.serverError;
        if (responseData != null && responseData is Map<String, dynamic>) {
          message = responseData['message'] ?? message;
        }

        switch (statusCode) {
          case 400:
            return ValidationFailure(message);
          case 401:
            return const UnauthorizedFailure(ErrorMessage.unauthorized);
          case 403:
            return const ForbiddenFailure(ErrorMessage.forbidden);
          case 404:
            return const NotFoundFailure(ErrorMessage.notFound);
          case 500:
            return ServerFailure(message);
          default:
            return UnknownFailure(message);
        }
        
      case DioExceptionType.connectionError:
        return const NetworkFailure(ErrorMessage.networkError);
        
      case DioExceptionType.cancel:
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
      default:
        return const UnknownFailure(ErrorMessage.unknown);
    }
  }

  static Failure handleException(Exception exception) {
    if (exception is ServerException) {
      return ServerFailure(exception.message);
    } else if (exception is CacheException) {
      return CacheFailure(exception.message);
    } else if (exception is NetworkException) {
      return NetworkFailure(exception.message);
    } else if (exception is UnauthorizedException) {
      return UnauthorizedFailure(exception.message);
    } else {
      return const UnknownFailure(ErrorMessage.unknown);
    }
  }
}
