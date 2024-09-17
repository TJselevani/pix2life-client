import 'package:bcrypt/bcrypt.dart';

import 'package:pix2life/core/api/api.service.dart';
import 'package:pix2life/core/secrets/app_secrets.dart';
import 'package:pix2life/core/utils/logger/logger.dart';
import 'package:pix2life/core/services/auth_manager.dart';
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
  final ApiService apiService = ApiService();
  final AuthManager tokenService = AuthManager();
  final log = createLogger(UserService);

  Future checkUser(Map<String, dynamic> userData) async {
    const url = '${AppSecrets.baseUrl}/auth/user/check';
    final response = await apiService.sendData(userData, url);
    return response;
  }

  Future<UserFromTokenResponse> getUserFromToken() async {
    const url = '${AppSecrets.baseUrl}/auth/user/token';
    final data = await apiService.fetchData(url);
    final response = await UserFromTokenResponse.fromJson(data);
    return response;
  }

  Future<CreateUserResponse> createUser(Map<String, dynamic> userData) async {
    const url = '${AppSecrets.baseUrl}/auth/user/register';
    final data = await apiService.sendData(userData, url);
    final response = CreateUserResponse.fromJson(data);
    // final token = response.token;
    // await tokenService.storeToken(token);
    //user token message
    return response;
  }

  Future<VerifyEmailResponse> verifyEmail(Map<String, dynamic> userData) async {
    //code, email
    const url = '${AppSecrets.baseUrl}/auth/user/verify/email';
    final data = await apiService.sendData(userData, url);
    //message, token
    return VerifyEmailResponse.fromJson(data);
  }

  Future<ResendCodeResponse> resendCode(Map<String, dynamic> userData) async {
    // email
    const url = '${AppSecrets.baseUrl}/auth/user/verify/resend';
    final data = await apiService.sendData(userData, url);
    //message
    return ResendCodeResponse.fromJson(data);
  }

  Future<CreatePasswordResponse> createPassword(
      String password, String confirmPassword) async {
    //password, confirmPassword
    final userData = {'password': password, 'confirmPassword': confirmPassword};
    const url = '${AppSecrets.baseUrl}/auth/user/create-password';
    final data = await apiService.sendData(userData, url);
    // email, message
    return CreatePasswordResponse.fromJson(data);
  }

  Future<UserSignInResponse> signIn(Map<String, dynamic> userData) async {
    //email, password
    log.i('$userData');
    const url = '${AppSecrets.baseUrl}/auth/user/login';
    final data = await apiService.sendData(userData, url);
    final response = UserSignInResponse.fromJson(data);
    // final token = response.token;
    // await tokenService.storeToken(token);
    //message, token
    return response;
  }

  Future<ForgotPasswordResponse> forgotPassword(
      Map<String, dynamic> userData) async {
    //email
    const url = '${AppSecrets.baseUrl}/auth/user/forgot-password';
    final data = await apiService.sendData(userData, url);
    //message
    return ForgotPasswordResponse.fromJson(data);
  }

  Future<VerifyResetCodeResponse> verifyResetCode(
      Map<String, dynamic> userData) async {
    //email, code
    const url = '${AppSecrets.baseUrl}/auth/user/verify/reset-code';
    final data = await apiService.sendData(userData, url);
    //message
    return VerifyResetCodeResponse.fromJson(data);
  }

  Future<ResetPasswordResponse> resetPassword(
      Map<String, dynamic> userData) async {
    //email
    const url = '${AppSecrets.baseUrl}/auth/user/reset-password';
    final data = await apiService.sendData(userData, url);
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
    final data = await apiService.fetchData(url);
    //message
    return RouteAccessResponse.fromJson(data);
  }

  Future logOut() async {}
}

// try {
//     final response = await ApiClient.sendData(data, uri);
//     print('Response: $response');
//   } catch (error) {
//     if (error is BadRequest) {
//       print('Error: ${error.message}');
//     } else {
//       print('Unknown error: $error');
//     }
//   }
