import 'package:pix2life/core/error/exceptions.dart';

// Defining specific HTTP error classes based on status codes.
class BadRequest extends ServerException {
  BadRequest({String? message, int? statusCode})
      : super(message: message ?? 'Bad request', statusCode: statusCode ?? 400);
}

class Unauthorized extends ServerException {
  Unauthorized({String? message, int? statusCode})
      : super(
            message: message ?? 'Unauthorized', statusCode: statusCode ?? 401);
}

class Forbidden extends ServerException {
  Forbidden({String? message, int? statusCode})
      : super(message: message ?? 'Forbidden', statusCode: statusCode ?? 403);
}

class NotFoundError extends ServerException {
  NotFoundError({String? message, int? statusCode})
      : super(message: message ?? 'Not Found', statusCode: statusCode ?? 404);
}

class MethodNotAllowed extends ServerException {
  MethodNotAllowed({String? message, int? statusCode})
      : super(
            message: message ?? 'Method Not Allowed',
            statusCode: statusCode ?? 405);
}

class Conflict extends ServerException {
  Conflict({String? message, int? statusCode})
      : super(message: message ?? 'Conflict', statusCode: statusCode ?? 409);
}

class InternalServerError extends ServerException {
  InternalServerError({String? message, int? statusCode})
      : super(
            message: message ?? 'Internal Server Error',
            statusCode: statusCode ?? 500);
}

class NotImplemented extends ServerException {
  NotImplemented({String? message, int? statusCode})
      : super(
            message: message ?? 'Not Implemented',
            statusCode: statusCode ?? 501);
}

class ServiceUnavailable extends ServerException {
  ServiceUnavailable({String? message, int? statusCode})
      : super(
            message: message ?? 'Service Unavailable',
            statusCode: statusCode ?? 503);
}
