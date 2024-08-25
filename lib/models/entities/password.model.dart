import 'package:pix2life/models/entities/user.model.dart';

class Password {
  final User userId;
  final String password;
  final String confirmPassword;

  Password(
      {required this.userId,
      required this.password,
      required this.confirmPassword});
}
