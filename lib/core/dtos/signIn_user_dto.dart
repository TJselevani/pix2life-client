import 'package:pix2life/core/utils/typeDef.dart';
import 'package:pix2life/src/auth/data/models/user.model.dart';

class UserSignInResponse {
  final UserModel user;
  final String token;
  final String message;

  UserSignInResponse(
      {required this.user, required this.token, required this.message});

  factory UserSignInResponse.fromJson(DataMap json) {
    final DataMap userData = json['updatedImage'];
    final UserModel user = UserModel.fromJson(userData);
    return UserSignInResponse(
      user: user,
      token: json['token'],
      message: json['message'],
    );
  }
}
