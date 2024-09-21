import 'package:pix2life/core/error/exceptions.dart';
import 'package:pix2life/core/utils/typeDef.dart';

class ApiFailure extends ServerException {
  ApiFailure({
    required String message,
    required int statusCode,
  }) : super(message: message, statusCode: statusCode);

  ApiFailure.fromServerException(ServerException exception)
      : this(
          message: exception.message,
          statusCode: exception.statusCode,
        );

  DataMap serialize() => {'message': message, 'status': statusCode};

  String get errorMessage => '$statusCode Error: $message';
}
