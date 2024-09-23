import 'package:pix2life/core/utils/type_def.dart';
import 'package:pix2life/src/features/auth/data/models/user.model.dart';

class UserFromTokenResponse {
  final UserModel user;

  UserFromTokenResponse({required this.user});

  factory UserFromTokenResponse.fromJson(DataMap json) {
    final DataMap userData = json['user'];
    final UserModel user = UserModel.fromJson(userData);
    return UserFromTokenResponse(
      user: user,
    );
  }
}
