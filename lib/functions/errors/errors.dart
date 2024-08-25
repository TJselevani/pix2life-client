import 'package:pix2life/functions/errors/application_error.dart';

class BadRequest extends ApplicationError {
  BadRequest({String? message, int? status})
      : super(message: message ?? 'Bad request', status: status ?? 400);
}

class Unauthorized extends ApplicationError {
  Unauthorized({String? message, int? status})
      : super(message: message ?? 'Unauthorized', status: status ?? 401);
}

class Forbidden extends ApplicationError {
  Forbidden({String? message, int? status})
      : super(message: message ?? 'Forbidden', status: status ?? 403);
}

class NotFoundError extends ApplicationError {
  NotFoundError({String? message, int? status})
      : super(message: message ?? 'Not Found', status: status ?? 404);
}

class MethodNotAllowed extends ApplicationError {
  MethodNotAllowed({String? message, int? status})
      : super(message: message ?? 'Method Not Allowed', status: status ?? 405);
}

class Conflict extends ApplicationError {
  Conflict({String? message, int? status})
      : super(message: message ?? 'Conflict', status: status ?? 409);
}

class InternalServerError extends ApplicationError {
  InternalServerError({String? message, int? status})
      : super(message: message ?? 'Internal Server Error', status: status ?? 500);
}

class NotImplemented extends ApplicationError {
  NotImplemented({String? message, int? status})
      : super(message: message ?? 'Not Implemented', status: status ?? 501);
}

class ServiceUnavailable extends ApplicationError {
  ServiceUnavailable({String? message, int? status})
      : super(message: message ?? 'Service Unavailable', status: status ?? 503);
}
