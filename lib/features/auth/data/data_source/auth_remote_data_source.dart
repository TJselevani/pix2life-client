import 'package:pix2life/core/error/application_error.dart';
import 'package:pix2life/core/utils/logger/logger.dart';
import 'package:pix2life/core/services/auth_manager.dart';
import 'package:pix2life/core/services/auth_user_service.dart';
import 'package:pix2life/features/auth/data/models/user.model.dart';

abstract interface class AuthRemoteDataSource {
  Future<String> checkUserAccount({
    required String email,
  });

  Future<UserModel> userSignUp({
    required String username,
    required String email,
    required String address,
    required String phoneNumber,
    required String postCode,
  });

  Future<String> createUserPassword({
    required String password,
    required String confirmPassword,
  });

  Future<UserModel> userSignIn({
    required String email,
    required String password,
  });

  Future<String> logOutUser({
    required String token,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final UserService userService;
  final AuthManager authManager;
  AuthRemoteDataSourceImpl(this.authManager, this.userService);
  final logger = createLogger(AuthRemoteDataSourceImpl);

  @override
  Future<UserModel> userSignIn({
    required String email,
    required String password,
  }) async {
    try {
      final Map<String, dynamic> userData = {
        "email": email,
        "password": password,
      };
      final response = await userService.signIn(userData);
      final String token = response.token;
      final String message = response.message;
      final UserModel user = UserModel.fromJson(response.user);
      await authManager.storeToken(token);
      logger.i(message);
      return user;
    } catch (e) {
      logger.e(e);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> userSignUp({
    required String username,
    required String email,
    required String address,
    required String phoneNumber,
    required String postCode,
  }) async {
    try {
      final Map<String, dynamic> userData = {
        "username": username,
        "email": email,
        "address": address,
        "phoneNumber": phoneNumber,
        "postCode": postCode,
      };
      final response = await userService.createUser(userData);
      final String token = response.token;
      final String message = response.message;
      final UserModel user = UserModel.fromJson(response.user);
      await authManager.storeToken(token);
      logger.i(message);
      return user;
    } catch (e) {
      logger.e(e);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> checkUserAccount({required String email}) async {
    try {
      final Map<String, dynamic> userData = {
        "email": email,
      };
      final response = await userService.checkUser(userData);
      final String message = response;
      logger.i(message);
      return message;
    } catch (e) {
      logger.e(e);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> createUserPassword(
      {required String password, required String confirmPassword}) async {
    try {
      final response =
          await userService.createPassword(password, confirmPassword);
      final String message = response.message;
      final String userEmail = response.userEmail;
      logger.i('message: ${message}, userEmail: ${userEmail}');
      return message;
    } catch (e) {
      logger.e(e);
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> logOutUser({required String token}) async {
    try {
      final response = await userService.logOut();
      final String message = response;
      logger.i(message);
      return message;
    } catch (e) {
      logger.e(e);
      throw ServerException(e.toString());
    }
  }
}
