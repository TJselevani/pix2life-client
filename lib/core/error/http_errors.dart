import 'package:pix2life/core/error/exceptions.dart';

// Defining specific HTTP error classes based on status codes.
class BadRequest extends ServerException {
  const BadRequest({String? message, int? statusCode})
      : super(message: message ?? 'Bad request', statusCode: statusCode ?? 400);
}

class Unauthorized extends ServerException {
  const Unauthorized({String? message, int? statusCode})
      : super(
            message: message ?? 'Unauthorized', statusCode: statusCode ?? 401);
}

class Forbidden extends ServerException {
  const Forbidden({String? message, int? statusCode})
      : super(message: message ?? 'Forbidden', statusCode: statusCode ?? 403);
}

class NotFoundError extends ServerException {
  const NotFoundError({String? message, int? statusCode})
      : super(message: message ?? 'Not Found', statusCode: statusCode ?? 404);
}

class MethodNotAllowed extends ServerException {
  const MethodNotAllowed({String? message, int? statusCode})
      : super(
            message: message ?? 'Method Not Allowed',
            statusCode: statusCode ?? 405);
}

class Conflict extends ServerException {
  const Conflict({String? message, int? statusCode})
      : super(message: message ?? 'Conflict', statusCode: statusCode ?? 409);
}

class InternalServerError extends ServerException {
  const InternalServerError({String? message, int? statusCode})
      : super(
            message: message ?? 'Internal Server Error',
            statusCode: statusCode ?? 500);
}

class NotImplemented extends ServerException {
  const NotImplemented({String? message, int? statusCode})
      : super(
            message: message ?? 'Not Implemented',
            statusCode: statusCode ?? 501);
}

class ServiceUnavailable extends ServerException {
  const ServiceUnavailable({String? message, int? statusCode})
      : super(
            message: message ?? 'Service Unavailable',
            statusCode: statusCode ?? 503);
}
