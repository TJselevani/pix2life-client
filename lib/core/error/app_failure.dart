import 'package:pix2life/core/error/exceptions.dart';
import 'package:pix2life/core/utils/type_def.dart';

class AppFailure extends ApplicationError {
  const AppFailure({
    required String message,
    required int statusCode,
  }) : super(message: message, statusCode: statusCode);

  AppFailure.fromApplicationError(ApplicationError error)
      : this(
          message: error.message,
          statusCode: error.statusCode,
        );

  @override
  DataMap serialize() => {'message': message, 'status': statusCode};

  String get errorMessage => '$statusCode Error: $message';
}
