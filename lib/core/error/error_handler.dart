import 'dart:io';
import 'package:dio/dio.dart';
import 'package:pix2life/core/error/exceptions.dart';
import 'package:pix2life/core/error/http_errors.dart';

class ErrorHandler {
  static void handleError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.cancel ||
        e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.unknown) {
      throw const ServiceUnavailable();
    } else if (e.error is SocketException) {
      throw const NotFoundError(
        message: 'Unable to connect to the server, please try again later',
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
          throw const ApplicationError(
              message: 'An unexpected error occurred. Please try again later!',
              statusCode: 500);
      }
    } else {
      throw const ApplicationError(
        message: 'An unexpected error occurred. Please try again later.',
        statusCode: 505,
      );
    }
  }
}
