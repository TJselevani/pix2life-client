import 'package:pix2life/core/utils/type_def.dart';
import 'package:pix2life/src/features/auth/domain/entities/user.dart';

abstract interface class AuthRepository {
  const AuthRepository();

  ResultFuture<String> checkUserAccount({
    required String email,
  });

  ResultFuture<User> userSignUp({
    required String username,
    required String email,
    required String address,
    required String phoneNumber,
    required String postCode,
  });

  ResultFuture<String> createUserPassword({
    required String password,
    required String confirmPassword,
  });

  ResultFuture<User> userSignIn({
    required String email,
    required String password,
  });

  ResultFuture<String> logOutUser();

  ResultFuture<String> forgotPassword({
    required String email,
  });

  ResultFuture<String> verifyResetCode({
    required String email,
    required String resetCode,
  });

  ResultFuture<String> resetPassword({
    required String email,
    required String resetCode,
    required String password,
    required String confirmPassword,
  });

  ResultFuture<String> stripePayment({
    required DataMap paymentData,
  });

  ResultFuture<User> getUserData();

  ResultFuture<User> retrieveAuthUser();

  ResultFuture<User> isUserLoggedIn();
}
