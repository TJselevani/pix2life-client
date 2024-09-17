import 'package:fpdart/fpdart.dart';
import 'package:pix2life/core/error/failure.dart';
import 'package:pix2life/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:pix2life/features/auth/domain/entities/user.dart';
import 'package:pix2life/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  const AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, String>> checkUserAccount(
      {required String email}) async {
    try {
      final message = await remoteDataSource.checkUserAccount(email: email);
      return right(message);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> createUserPassword(
      {required String password, required String confirmPassword}) async {
    try {
      final message = await remoteDataSource.createUserPassword(
          password: password, confirmPassword: confirmPassword);
      return right(message);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> userSignIn(
      {required String email, required String password}) async {
    try {
      final user =
          await remoteDataSource.userSignIn(email: email, password: password);
      return right(user);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> userSignUp({
    required String username,
    required String email,
    required String address,
    required String phoneNumber,
    required String postCode,
  }) async {
    try {
      final user = await remoteDataSource.userSignUp(
        username: username,
        email: email,
        address: address,
        phoneNumber: phoneNumber,
        postCode: postCode,
      );
      return right(user);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> logOutUser({required String token}) async {
    try {
      final message = await remoteDataSource.logOutUser(token: token);
      return right(message);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
