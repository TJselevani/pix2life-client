import 'package:pix2life/core/error/exceptions.dart';
import 'package:pix2life/core/utils/logger/logger.dart';
import 'package:pix2life/core/utils/typeDef.dart';
import 'package:pix2life/src/auth/data/data_source/auth_manager.dart';
import 'package:pix2life/src/auth/data/data_source/auth_user_service.dart';
import 'package:pix2life/src/auth/data/models/user.model.dart';

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

  Future<String> logOutUser({
    required String token,
  });
}

const kCreateUseEndpoint = '/users';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  late UserService _userService;
  late AuthManager _authManager;
  AuthRemoteDataSourceImpl(this._userService, this._authManager);
  final logger = createLogger(AuthRemoteDataSourceImpl);

  @override
  Future<UserModel> userSignIn({
    required String email,
    required String password,
  }) async {
    try {
      final DataMap userData = {'email': email, 'password': password};
      final response = await _userService.signIn(userData);
      final UserInfo = response.user;
      final message = response.message;
      final token = response.token;
      await _authManager.storeToken(token);
      logger.i(message);
      final UserModel user = UserModel.fromJson(UserInfo);
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
      final response = await _userService.createUser(userData);
      final UserInfo = response.user;
      final message = response.message;
      final token = response.token;
      await _authManager.storeToken(token);
      logger.i(message);
      final UserModel user = UserModel.fromJson(UserInfo);
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
      final response = await _userService.checkUser(userData);
      return response;
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
      final response =
          await _userService.createPassword(password, confirmPassword);
      final message = response.message;
      final userEmail = response.userEmail;
      logger.i('successfully created password for $userEmail');
      return message;
    } on ServerException {
      rethrow;
    } catch (e) {
      logger.e(e);
      throw ApplicationError(message: 2.toString(), statusCode: 505);
    }
  }

  @override
  Future<String> logOutUser({required String token}) async {
    try {
      // ignore: unused_local_variable
      final response = await _userService.logOut();
      final message = '';
      return message;
    } on ServerException {
      rethrow;
    } catch (e) {
      logger.e(e);
      throw ApplicationError(message: 2.toString(), statusCode: 505);
    }
  }

  @override
  Future<UserModel> checkAuthStatus({required String token}) async {
    try {
      final response = await _userService.getUserFromToken();
      final userInfo = response.user;
      final UserModel user = UserModel.fromJson(userInfo);
      return user;
    } on ServerException {
      rethrow;
    } catch (e) {
      logger.e(e);
      throw ApplicationError(message: 2.toString(), statusCode: 505);
    }
  }
}
