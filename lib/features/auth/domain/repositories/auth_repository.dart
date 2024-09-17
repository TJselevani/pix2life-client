import 'package:fpdart/fpdart.dart';
import 'package:pix2life/core/error/failure.dart';
import 'package:pix2life/features/auth/domain/entities/user.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, String>> checkUserAccount({
    required String email,
  });

  Future<Either<Failure, User>> userSignUp({
    required String username,
    required String email,
    required String address,
    required String phoneNumber,
    required String postCode,
  });

  Future<Either<Failure, String>> createUserPassword({
    required String password,
    required String confirmPassword,
  });

  Future<Either<Failure, User>> userSignIn({
    required String email,
    required String password,
  });

  Future<Either<Failure, String>> logOutUser({
    required String token,
  });
}
