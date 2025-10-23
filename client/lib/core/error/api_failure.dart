import 'package:pix2life/core/error/exceptions.dart';
import 'package:pix2life/core/utils/type_def.dart';

class ApiFailure extends ServerException {
  const ApiFailure({
    required String message,
    required int statusCode,
  }) : super(message: message, statusCode: statusCode);

  ApiFailure.fromServerException(ServerException exception)
      : this(
          message: exception.message,
          statusCode: exception.statusCode,
        );
  const ApiFailure.fromAppException(String message)
      : this(
          message: message,
          statusCode: 505,
        );

  DataMap serialize() => {'message': message, 'status': statusCode};

  String get errorMessage => '$statusCode Error: $message';
}
