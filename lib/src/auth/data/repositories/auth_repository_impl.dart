import 'package:fpdart/fpdart.dart';
import 'package:pix2life/core/error/exceptions.dart';
import 'package:pix2life/core/error/api_failure.dart';
import 'package:pix2life/core/utils/typeDef.dart';
import 'package:pix2life/src/auth/domain/entities/user.dart';
import 'package:pix2life/src/auth/data/data_source/auth_remote_data_source.dart';
import 'package:pix2life/src/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  const AuthRepositoryImpl(this._remoteDataSource);

  @override
  ResultFuture<String> checkUserAccount({required String email}) async {
    try {
      final message = await _remoteDataSource.checkUserAccount(email: email);
      return right(message);
    } on ServerException catch (e) {
      return left(ApiFailure.fromServerException(e));
    }
  }

  @override
  ResultFuture<String> createUserPassword(
      {required String password, required String confirmPassword}) async {
    try {
      final message = await _remoteDataSource.createUserPassword(
          password: password, confirmPassword: confirmPassword);
      return right(message);
    } on ServerException catch (e) {
      return left(ApiFailure.fromServerException(e));
    }
  }

  @override
  ResultFuture<User> userSignIn(
      {required String email, required String password}) async {
    try {
      final user =
          await _remoteDataSource.userSignIn(email: email, password: password);
      return right(user);
    } on ServerException catch (e) {
      return left(ApiFailure.fromServerException(e));
    }
  }

  @override
  ResultFuture<User> userSignUp({
    required String username,
    required String email,
    required String address,
    required String phoneNumber,
    required String postCode,
  }) async {
    try {
      final user = await _remoteDataSource.userSignUp(
        username: username,
        email: email,
        address: address,
        phoneNumber: phoneNumber,
        postCode: postCode,
      );
      return right(user);
    } on ServerException catch (e) {
      return left(ApiFailure.fromServerException(e));
    }
  }

  @override
  ResultFuture<String> logOutUser({required String token}) async {
    try {
      final message = await _remoteDataSource.logOutUser(token: token);
      return right(message);
    } on ServerException catch (e) {
      return left(ApiFailure.fromServerException(e));
    }
  }

  @override
  Future<Either<ApiFailure, User>> checkAuthStatus(
      {required String token}) async {
    try {
      final user = await _remoteDataSource.checkAuthStatus(token: token);
      return right(user);
    } on ServerException catch (e) {
      return left(ApiFailure.fromServerException(e));
    }
  }
}
