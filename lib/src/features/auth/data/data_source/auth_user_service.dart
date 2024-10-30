import 'package:bcrypt/bcrypt.dart';
import 'package:pix2life/core/dtos/check_user_account_dto.dart';
import 'package:pix2life/core/dtos/payment_stripe_response_dto.dart';
import 'package:pix2life/core/utils/type_def.dart';

import 'package:pix2life/src/api/data/data_source/api.service.dart';
import 'package:pix2life/core/secrets/app_secrets.dart';
import 'package:pix2life/core/dtos/create_password_dto.dart';
import 'package:pix2life/core/dtos/sign_up_user_dto.dart';
import 'package:pix2life/core/dtos/forgot_password_dto.dart';
import 'package:pix2life/core/dtos/resend_code_dto.dart';
import 'package:pix2life/core/dtos/reset_password_dto.dart';
import 'package:pix2life/core/dtos/route_access_dto.dart';
import 'package:pix2life/core/dtos/sign_in_user_dto.dart';
import 'package:pix2life/core/dtos/user_from_token_dto.dart';
import 'package:pix2life/core/dtos/verify_email_dto.dart';
import 'package:pix2life/core/dtos/verify_reset_code_response.dart';

class UserService {
  final ApiService _apiService;
  UserService(this._apiService);

  Future<CheckUserAccountResponse> checkUser(DataMap userData) async {
    const url = '${AppSecrets.baseUrl}/auth/user/check';
    final data = await _apiService.sendData(userData, url);
    return CheckUserAccountResponse.fromJson(data);
  }

  Future<UserFromTokenResponse> getUserFromToken() async {
    const url = '${AppSecrets.baseUrl}/auth/user/token';
    final data = await _apiService.fetchData(url);
    return UserFromTokenResponse.fromJson(data);
  }

  Future<CreateUserResponse> createUser(DataMap userData) async {
    const url = '${AppSecrets.baseUrl}/auth/user/register';
    final data = await _apiService.sendData(userData, url);
    return CreateUserResponse.fromJson(data);
  }

  Future<VerifyEmailResponse> verifyEmail(DataMap userData) async {
    const url = '${AppSecrets.baseUrl}/auth/user/verify/email';
    final data = await _apiService.sendData(userData, url);
    return VerifyEmailResponse.fromJson(data);
  }

  Future<ResendCodeResponse> resendCode(DataMap userData) async {
    const url = '${AppSecrets.baseUrl}/auth/user/verify/resend';
    final data = await _apiService.sendData(userData, url);
    return ResendCodeResponse.fromJson(data);
  }

  Future<CreatePasswordResponse> createPassword(
      String password, String confirmPassword) async {
    final userData = {'password': password, 'confirmPassword': confirmPassword};
    const url = '${AppSecrets.baseUrl}/auth/user/create-password';
    final data = await _apiService.sendData(userData, url);
    return CreatePasswordResponse.fromJson(data);
  }

  Future<UserSignInResponse> signIn(DataMap userData) async {
    const url = '${AppSecrets.baseUrl}/auth/user/login';
    final data = await _apiService.sendData(userData, url);
    return UserSignInResponse.fromJson(data);
  }

  Future<ForgotPasswordResponse> forgotPassword(DataMap userData) async {
    const url = '${AppSecrets.baseUrl}/auth/user/forgot-password';
    final data = await _apiService.sendData(userData, url);
    return ForgotPasswordResponse.fromJson(data);
  }

  Future<VerifyResetCodeResponse> verifyResetCode(DataMap userData) async {
    const url = '${AppSecrets.baseUrl}/auth/user/verify/reset-code';
    final data = await _apiService.sendData(userData, url);
    return VerifyResetCodeResponse.fromJson(data);
  }

  Future<ResetPasswordResponse> resetPassword(DataMap userData) async {
    const url = '${AppSecrets.baseUrl}/auth/user/reset-password';
    final data = await _apiService.sendData(userData, url);
    return ResetPasswordResponse.fromJson(data);
  }

  Future<PaymentStripeResponse> makeStripePayment(DataMap paymentData) async {
    const url = '${AppSecrets.baseUrl}/payment/stripe/create-payment-intent';
    final data = await _apiService.sendData(paymentData, url);
     return PaymentStripeResponse.fromJson(data);
  }

  Future<String> makePayPalPayment(DataMap paymentData) async {
    const url = '${AppSecrets.baseUrl}/payment/stripe/create-payment-intent';
    return await _apiService.sendData(paymentData, url);
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
    const url = '${AppSecrets.baseUrl}/user/status';
    final data = await _apiService.fetchData(url);
    return RouteAccessResponse.fromJson(data);
  }

  Future logOut() async {}
}
