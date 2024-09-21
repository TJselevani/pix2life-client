import 'package:bcrypt/bcrypt.dart';
import 'package:pix2life/core/utils/typeDef.dart';

import 'package:pix2life/src/api/data/data_source/api.service.dart';
import 'package:pix2life/core/secrets/app_secrets.dart';
import 'package:pix2life/core/utils/logger/logger.dart';
import 'package:pix2life/core/dtos/create_password_dto.dart';
import 'package:pix2life/core/dtos/create_user_dto.dart';
import 'package:pix2life/core/dtos/forgot_password_dto.dart';
import 'package:pix2life/core/dtos/resend_code_dto.dart';
import 'package:pix2life/core/dtos/reset_password_dto.dart';
import 'package:pix2life/core/dtos/route_access_dto.dart';
import 'package:pix2life/core/dtos/signIn_user_dto.dart';
import 'package:pix2life/core/dtos/user_from_token_dto.dart';
import 'package:pix2life/core/dtos/verify_email_dto.dart';
import 'package:pix2life/core/dtos/verify_reset_code_response.dart';

class UserService {
  late ApiService _apiService;
  UserService(this._apiService);
  final log = createLogger(UserService);

  Future checkUser(DataMap userData) async {
    const url = '${AppSecrets.baseUrl}/auth/user/check';
    final response = await _apiService.sendData(userData, url);
    return response;
  }

  Future<UserFromTokenResponse> getUserFromToken() async {
    const url = '${AppSecrets.baseUrl}/auth/user/token';
    final data = await _apiService.fetchData(url);
    final response = await UserFromTokenResponse.fromJson(data);
    return response;
  }

  Future<CreateUserResponse> createUser(DataMap userData) async {
    const url = '${AppSecrets.baseUrl}/auth/user/register';
    final data = await _apiService.sendData(userData, url);
    final response = CreateUserResponse.fromJson(data);
    // final token = response.token;
    // await _tokenService.storeToken(token);
    //user token message
    return response;
  }

  Future<VerifyEmailResponse> verifyEmail(DataMap userData) async {
    //code, email
    const url = '${AppSecrets.baseUrl}/auth/user/verify/email';
    final data = await _apiService.sendData(userData, url);
    //message, token
    return VerifyEmailResponse.fromJson(data);
  }

  Future<ResendCodeResponse> resendCode(DataMap userData) async {
    // email
    const url = '${AppSecrets.baseUrl}/auth/user/verify/resend';
    final data = await _apiService.sendData(userData, url);
    //message
    return ResendCodeResponse.fromJson(data);
  }

  Future<CreatePasswordResponse> createPassword(
      String password, String confirmPassword) async {
    //password, confirmPassword
    final userData = {'password': password, 'confirmPassword': confirmPassword};
    const url = '${AppSecrets.baseUrl}/auth/user/create-password';
    final data = await _apiService.sendData(userData, url);
    // email, message
    return CreatePasswordResponse.fromJson(data);
  }

  Future<UserSignInResponse> signIn(DataMap userData) async {
    //email, password
    log.i('$userData');
    const url = '${AppSecrets.baseUrl}/auth/user/login';
    final data = await _apiService.sendData(userData, url);
    final response = UserSignInResponse.fromJson(data);
    // final token = response.token;
    // await _tokenService.storeToken(token);
    //message, token
    return response;
  }

  Future<ForgotPasswordResponse> forgotPassword(
      DataMap userData) async {
    //email
    const url = '${AppSecrets.baseUrl}/auth/user/forgot-password';
    final data = await _apiService.sendData(userData, url);
    //message
    return ForgotPasswordResponse.fromJson(data);
  }

  Future<VerifyResetCodeResponse> verifyResetCode(
      DataMap userData) async {
    //email, code
    const url = '${AppSecrets.baseUrl}/auth/user/verify/reset-code';
    final data = await _apiService.sendData(userData, url);
    //message
    return VerifyResetCodeResponse.fromJson(data);
  }

  Future<ResetPasswordResponse> resetPassword(
      DataMap userData) async {
    //email
    const url = '${AppSecrets.baseUrl}/auth/user/reset-password';
    final data = await _apiService.sendData(userData, url);
    //message
    // if (data.isEmpty) {
    //   throw BadRequest(message: 'Invalid Credentials');
    // }
    return ResetPasswordResponse.fromJson(data);
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

  Future<RouteAccessResponse> protectedRoute(String token) async {
    //token
    const url = '${AppSecrets.baseUrl}/user/status';
    final data = await _apiService.fetchData(url);
    //message
    return RouteAccessResponse.fromJson(data);
  }

  Future logOut() async {}
}
