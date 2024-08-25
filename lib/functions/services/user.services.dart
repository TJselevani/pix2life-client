import 'package:pix2life/config/app/app.config.dart';
import 'package:pix2life/config/logger/logger.dart';
import 'package:pix2life/dto/create_password_dto.dart';
import 'package:pix2life/dto/forgot_password_dto.dart';
import 'package:pix2life/dto/resend_code_dto.dart';
import 'package:pix2life/dto/reset_password_dto.dart';
import 'package:pix2life/dto/route_access_dto.dart';
import 'package:pix2life/dto/signIn_user_dto.dart';
import 'package:pix2life/dto/user_from_token_dto.dart';
import 'package:pix2life/dto/verify_email_dto.dart';
import 'package:pix2life/dto/create_user_dto.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:pix2life/dto/verify_reset_code_response.dart';
import 'package:pix2life/functions/services/api.services.dart';
import 'package:pix2life/functions/services/token.services.dart';

class UserService {
  final ApiService apiService = ApiService();
  final TokenService tokenService = TokenService();
  final log = logger(UserService);

  Future checkUser(Map<String, dynamic> userData) async {
    const url = '${AppConfig.baseUrl}/auth/user/check';
    final response = await apiService.sendData(userData, url);
    return response;
  }

  Future<UserFromTokenResponse> getUserFromToken() async {
    const url = '${AppConfig.baseUrl}/auth/user/token';
    final data = await apiService.fetchData(url);
    final response = await UserFromTokenResponse.fromJson(data);
    return response;
  }

  Future<CreateUserResponse> createUser(Map<String, dynamic> userData) async {
    const url = '${AppConfig.baseUrl}/auth/user/register';
    final data = await apiService.sendData(userData, url);
    final response = CreateUserResponse.fromJson(data);
    // final token = response.token;
    // await tokenService.storeToken(token);
    //user token message
    return response;
  }

  Future<VerifyEmailResponse> verifyEmail(Map<String, dynamic> userData) async {
    //code, email
    const url = '${AppConfig.baseUrl}/auth/user/verify/email';
    final data = await apiService.sendData(userData, url);
    //message, token
    return VerifyEmailResponse.fromJson(data);
  }

  Future<ResendCodeResponse> resendCode(Map<String, dynamic> userData) async {
    // email
    const url = '${AppConfig.baseUrl}/auth/user/verify/resend';
    final data = await apiService.sendData(userData, url);
    //message
    return ResendCodeResponse.fromJson(data);
  }

  Future<CreatePasswordResponse> createPassword(
      String password, String confirmPassword) async {
    //password, confirmPassword
    final userData = {'password': password, 'confirmPassword': confirmPassword};
    const url = '${AppConfig.baseUrl}/auth/user/create-password';
    final data = await apiService.sendData(userData, url);
    // email, message
    return CreatePasswordResponse.fromJson(data);
  }

  Future<UserSignInResponse> signIn(Map<String, dynamic> userData) async {
    //email, password
    log.i('$userData');
    const url = '${AppConfig.baseUrl}/auth/user/login';
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
    const url = '${AppConfig.baseUrl}/auth/user/forgot-password';
    final data = await apiService.sendData(userData, url);
    //message
    return ForgotPasswordResponse.fromJson(data);
  }

  Future<VerifyResetCodeResponse> verifyResetCode(
      Map<String, dynamic> userData) async {
    //email, code
    const url = '${AppConfig.baseUrl}/auth/user/verify/reset-code';
    final data = await apiService.sendData(userData, url);
    //message
    return VerifyResetCodeResponse.fromJson(data);
  }

  Future<ResetPasswordResponse> resetPassword(
      Map<String, dynamic> userData) async {
    //email
    const url = '${AppConfig.baseUrl}/auth/user/reset-password';
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
    const url = '${AppConfig.baseUrl}/user/status';
    final data = await apiService.fetchData(url);
    //message
    return RouteAccessResponse.fromJson(data);
  }
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
