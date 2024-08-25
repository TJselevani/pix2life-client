import 'package:dio/dio.dart';
import 'application_error.dart';
import 'errors.dart';

class ErrorHandler {
  static void handleError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.cancel ||
        e.type == DioExceptionType.badResponse) {
      // Handle network-related errors or server downtime
      throw ApplicationError(
        message:
            'Service Unavailable. Please check your internet connection and try again.',
        status: 503, // Service Unavailable
      );
    }

    if (e.response != null) {
      final statusCode = e.response?.statusCode ?? 500;
      final message = e.response?.data['message'] ?? 'An error occurred';

      switch (statusCode) {
        case 400:
          throw BadRequest(message: message);
        case 401:
          throw Unauthorized(message: message);
        case 403:
          throw Forbidden(message: message);
        case 404:
          throw NotFoundError(message: message);
        case 405:
          throw MethodNotAllowed(message: message);
        case 409:
          throw Conflict(message: message);
        case 500:
          throw InternalServerError(message: message);
        case 501:
          throw NotImplemented(message: message);
        case 503:
          throw ServiceUnavailable(message: message);
        default:
          throw ApplicationError(message: message, status: statusCode);
      }
    } else {
      // If no response is available, it's a network issue or other unknown error
      throw ApplicationError(
        message: 'An unexpected error occurred. Please try again later.',
        status: 500,
      );
    }
  }
}
