import 'package:pix2life/core/utils/type_def.dart';
import 'package:pix2life/src/features/auth/data/models/user.model.dart';

class ResetPasswordResponse {
  final String message;
  final UserModel user;

  ResetPasswordResponse({required this.user, required this.message});

  factory ResetPasswordResponse.fromJson(DataMap json) {
    final DataMap userData = json['user'];
    final UserModel user = UserModel.fromJson(userData);
    return ResetPasswordResponse(
      message: json['message'],
      user: user,
    );
  }
}
