import 'package:pix2life/core/utils/type_def.dart';
import 'package:pix2life/src/features/auth/data/models/user.model.dart';

class CreateUserResponse {
  final UserModel user;
  final String token;
  final String message;

  CreateUserResponse(
      {required this.token, required this.user, required this.message});

  factory CreateUserResponse.fromJson(DataMap json) {
    final DataMap userData = json['user'];
    final UserModel user = UserModel.fromJson(userData);
    return CreateUserResponse(
      token: json['token'],
      user: user,
      message: json['message'],
    );
  }
}
