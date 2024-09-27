import 'package:pix2life/core/dtos/check_user_account_dto.dart';
import 'package:pix2life/core/dtos/create_password_dto.dart';
import 'package:pix2life/core/dtos/sign_up_user_dto.dart';
import 'package:pix2life/core/dtos/sign_in_user_dto.dart';
import 'package:pix2life/core/dtos/user_from_token_dto.dart';
import 'package:pix2life/core/error/exceptions.dart';
import 'package:pix2life/core/utils/logger/logger.dart';
import 'package:pix2life/core/utils/type_def.dart';
import 'package:pix2life/src/features/auth/data/data_source/auth_manager.dart';
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

  Future<UserModel> retrieveAuthUser();

  Future<String> logOutUser({
    required String token,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final UserService _userService;
  final AuthManager _authManager;
  // late final AuthService _authService;
  AuthRemoteDataSourceImpl(this._userService, this._authManager);
  final logger = createLogger(AuthRemoteDataSourceImpl);

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
      // await _authService.storeUser(user, token);
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
      // await _authService.storeUser(user, token);
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
      // ignore: unused_local_variable
      final response = await _userService.logOut();
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
      // await _authService.storeUser(user, token);
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
      // final String? token = await _authManager.getToken();
      // final UserModel user = await _authService.retrieveUser(token!);
      return const UserModel.empty();
    } catch (e) {
      logger.e(e);
      throw ApplicationError(message: e.toString(), statusCode: 505);
    }
  }
}
