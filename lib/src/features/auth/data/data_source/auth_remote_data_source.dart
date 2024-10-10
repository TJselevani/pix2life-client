import 'package:bcrypt/bcrypt.dart';
import 'package:pix2life/core/dtos/check_user_account_dto.dart';
import 'package:pix2life/core/dtos/create_password_dto.dart';
import 'package:pix2life/core/dtos/forgot_password_dto.dart';
import 'package:pix2life/core/dtos/reset_password_dto.dart';
import 'package:pix2life/core/dtos/sign_up_user_dto.dart';
import 'package:pix2life/core/dtos/sign_in_user_dto.dart';
import 'package:pix2life/core/dtos/user_from_token_dto.dart';
import 'package:pix2life/core/dtos/verify_reset_code_response.dart';
import 'package:pix2life/core/error/exceptions.dart';
import 'package:pix2life/core/utils/logger/logger.dart';
import 'package:pix2life/core/utils/type_def.dart';
import 'package:pix2life/src/features/auth/data/data_source/auth_manager.dart';
import 'package:pix2life/src/features/auth/data/data_source/auth_service.dart';
import 'package:pix2life/src/features/auth/data/data_source/auth_user_service.dart';
import 'package:pix2life/src/features/auth/data/models/user.model.dart';

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

  Future<UserModel> checkAuthStatus({
    required String token,
  });

  Future<String> forgotPassword({
    required String email,
  });

  Future<String> resetPassword({
    required String email,
    required String resetCode,
    required String password,
    required String confirmPassword,
  });

  Future<String> verifyResetCode({
    required String email,
    required String resetCode,
  });

  Future<UserModel> retrieveAuthUser();

  Future<String> logOutUser({
    required String token,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final UserService _userService;
  final AuthManager _authManager;
  late final AuthService _authService;
  AuthRemoteDataSourceImpl(
      this._userService, this._authManager, this._authService);
  final logger = createLogger(AuthRemoteDataSourceImpl);

  static const String userKey = "user_data";

  @override
  Future<UserModel> userSignIn({
    required String email,
    required String password,
  }) async {
    try {
      final DataMap userData = {'email': email, 'password': password};
      final UserSignInResponse response = await _userService.signIn(userData);
      final UserModel user = response.user;
      final message = response.message;
      final token = response.token;
      await _authManager.storeToken(token);
      await _authService.storeUser(user, userKey);
      logger.i(message);
      return user;
    } on ServerException {
      rethrow;
    } catch (e) {
      logger.e(e);
      throw ApplicationError(message: 2.toString(), statusCode: 505);
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
      final DataMap userData = {
        "username": username,
        "email": email,
        "address": address,
        "phoneNumber": phoneNumber,
        "postCode": postCode,
      };
      final CreateUserResponse response =
          await _userService.createUser(userData);
      final UserModel user = response.user;
      final String message = response.message;
      final String token = response.token;
      await _authManager.storeToken(token);
      await _authService.storeUser(user, userKey);
      logger.i(message);
      return user;
    } on ServerException {
      rethrow;
    } catch (e) {
      logger.e(e);
      throw ApplicationError(message: 2.toString(), statusCode: 505);
    }
  }

  @override
  Future<String> checkUserAccount({required String email}) async {
    try {
      final DataMap userData = {
        "email": email,
      };
      final CheckUserAccountResponse response =
          await _userService.checkUser(userData);
      final message = response.message;
      return message;
    } on ServerException {
      rethrow;
    } catch (e) {
      logger.e(e);
      throw ApplicationError(message: 2.toString(), statusCode: 505);
    }
  }

  @override
  Future<String> createUserPassword(
      {required String password, required String confirmPassword}) async {
    try {
      final CreatePasswordResponse response =
          await _userService.createPassword(password, confirmPassword);
      final message = response.message;
      final userEmail = response.userEmail;
      logger.i('successfully created password for $userEmail');
      return message;
    } on ServerException {
      rethrow;
    } catch (e) {
      logger.e(e);
      throw ApplicationError(message: e.toString(), statusCode: 505);
    }
  }

  @override
  Future<String> logOutUser({required String token}) async {
    try {
      await _userService.logOut();
      const message = '';
      return message;
    } on ServerException {
      rethrow;
    } catch (e) {
      logger.e(e);
      throw ApplicationError(message: e.toString(), statusCode: 505);
    }
  }

  @override
  Future<UserModel> checkAuthStatus({required String token}) async {
    try {
      final UserFromTokenResponse response =
          await _userService.getUserFromToken();
      final UserModel user = response.user;
      await _authService.storeUser(user, userKey);
      return user;
    } on ServerException {
      rethrow;
    } catch (e) {
      logger.e(e);
      throw ApplicationError(message: e.toString(), statusCode: 505);
    }
  }

  @override
  Future<UserModel> retrieveAuthUser() async {
    try {
      final UserModel user = await _authService.retrieveUser(userKey);
      return user;
    } catch (e) {
      logger.e(e);
      throw ApplicationError(message: e.toString(), statusCode: 505);
    }
  }

  @override
  Future<String> forgotPassword({required String email}) async {
    try {
      final DataMap userData = {'email': email};
      final ForgotPasswordResponse response =
          await _userService.forgotPassword(userData);
      final message = response.message;
      return message;
    } catch (e) {
      logger.e(e);
      throw ApplicationError(message: e.toString(), statusCode: 505);
    }
  }

  @override
  Future<String> resetPassword(
      {required String email,
      required String resetCode,
      required String password,
      required String confirmPassword}) async {
    try {
      final DataMap userData = {
        'email': email,
        'resetCode': resetCode,
        'password': password,
        'confirmPassword': confirmPassword,
      };
      final pass = comparePasswords(password, confirmPassword);
      if (!pass) {
        throw const ApplicationError(
            message: "Passwords Don't Match", statusCode: 400);
      }
      final ResetPasswordResponse response =
          await _userService.resetPassword(userData);
      final message = response.message;
      return message;
    } catch (e) {
      logger.e(e);
      throw ApplicationError(message: e.toString(), statusCode: 505);
    }
  }

  @override
  Future<String> verifyResetCode(
      {required String email, required String resetCode}) async {
    try {
      final DataMap userData = {'email': email, 'resetCode': resetCode};
      final VerifyResetCodeResponse response =
          await _userService.verifyResetCode(userData);
      final message = response.message;
      return message;
    } catch (e) {
      logger.e(e);
      throw ApplicationError(message: e.toString(), statusCode: 505);
    }
  }

  bool comparePasswords(String password1, String password2) {
    if (password1 == password2) {
      return true;
    } else {
      return false;
    }
  }

  String hash(String password) {
    return BCrypt.hashpw(password, BCrypt.gensalt());
  }
}
