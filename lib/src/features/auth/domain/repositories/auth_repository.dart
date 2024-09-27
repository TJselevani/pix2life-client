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

  ResultFuture<String> logOutUser({
    required String token,
  });

  ResultFuture<User> checkAuthStatus({
    required String token,
  });

  ResultFuture<User> retrieveAuthUser();
}
