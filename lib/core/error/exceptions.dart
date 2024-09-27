import 'package:equatable/equatable.dart';
import 'package:pix2life/core/utils/type_def.dart';

// ServerException for general server errors.
class ServerException extends Equatable implements Exception {
  final String message;
  final int statusCode;

  const ServerException({String? message, int? statusCode})
      : message = message ?? 'ServerException',
        statusCode = statusCode ?? 500;

  @override
  List<Object?> get props => [message, statusCode];
}

// ApplicationError for app-level errors, extendable for specific cases.
class ApplicationError extends Equatable implements Exception {
  final String message;
  final int statusCode;

  const ApplicationError({String? message, int? statusCode})
      : message = message ?? 'ApplicationError',
        statusCode = statusCode ?? 505;

  DataMap serialize() => {'message': message, 'status': statusCode};

  @override
  String toString() => message;

  @override
  List<Object?> get props => [message, statusCode];
}
