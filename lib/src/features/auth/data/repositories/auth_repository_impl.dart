import 'package:fpdart/fpdart.dart';
import 'package:pix2life/core/error/exceptions.dart';
import 'package:pix2life/core/error/api_failure.dart';
import 'package:pix2life/core/utils/type_def.dart';
import 'package:pix2life/src/features/auth/data/models/user.model.dart';
import 'package:pix2life/src/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:pix2life/src/features/auth/domain/entities/user.dart';
import 'package:pix2life/src/features/auth/domain/repositories/auth_repository.dart';

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
  ResultFuture<UserModel> userSignIn(
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
  ResultFuture<UserModel> userSignUp({
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
  ResultFuture<String> logOutUser() async {
    try {
      final message = await _remoteDataSource.logOutUser();
      return right(message);
    } on ServerException catch (e) {
      return left(ApiFailure.fromServerException(e));
    }
  }

  @override
  Future<Either<ApiFailure, UserModel>> getUserData(
     ) async {
    try {
      final user = await _remoteDataSource.getUserData();
      return right(user);
    } on ServerException catch (e) {
      return left(ApiFailure.fromServerException(e));
    }
  }

  @override
  ResultFuture<User> retrieveAuthUser() async {
    try {
      final user = await _remoteDataSource.retrieveAuthUser();
      return right(user);
    } on ServerException catch (e) {
      return left(ApiFailure.fromServerException(e));
    }
  }

  @override
  ResultFuture<String> forgotPassword({required String email}) async {
    try {
      final message = await _remoteDataSource.forgotPassword(email: email);
      return right(message);
    } on ServerException catch (e) {
      return left(ApiFailure.fromServerException(e));
    }
  }

  @override
  ResultFuture<String> resetPassword(
      {required String email,
      required String resetCode,
      required String password,
      required String confirmPassword}) async {
    try {
      final message = await _remoteDataSource.resetPassword(
        email: email,
        resetCode: resetCode,
        password: password,
        confirmPassword: confirmPassword,
      );
      return right(message);
    } on ServerException catch (e) {
      return left(ApiFailure.fromServerException(e));
    }
  }

  @override
  ResultFuture<String> verifyResetCode(
      {required String email, required String resetCode}) async {
    try {
      final message = await _remoteDataSource.verifyResetCode(
          email: email, resetCode: email);
      return right(message);
    } on ServerException catch (e) {
      return left(ApiFailure.fromServerException(e));
    }
  }
}
