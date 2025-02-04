import 'package:pix2life/core/utils/type_def.dart';
import 'package:pix2life/src/features/auth/data/models/user.model.dart';

class UserSignInResponse {
  final UserModel user;
  final String token;
  final String message;

  UserSignInResponse(
      {required this.user, required this.token, required this.message});

  factory UserSignInResponse.fromJson(DataMap json) {
    final DataMap userData = json['user'];
    final UserModel user = UserModel.fromJson(userData);
    return UserSignInResponse(
      user: user,
      token: json['token'],
      message: json['message'],
    );
  }
}
