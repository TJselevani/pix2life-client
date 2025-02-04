import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pix2life/core/error/exceptions.dart';
import 'package:pix2life/core/error/api_failure.dart';
import 'package:pix2life/core/network/connection_checker.dart';
import 'package:pix2life/src/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:pix2life/src/features/auth/data/models/user.model.dart';
import 'package:pix2life/src/features/auth/data/repositories/auth_repository_impl.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockConnectionChecker extends Mock implements ConnectionChecker {}

void main() {
  late AuthRemoteDataSource remoteDataSource;
  late ConnectionChecker connectionChecker;
  late AuthRepositoryImpl repositoryImpl;
  const UserModel user = UserModel.empty();

  setUp(() {
    remoteDataSource = MockAuthRemoteDataSource();
    connectionChecker = MockConnectionChecker();
    repositoryImpl = AuthRepositoryImpl(remoteDataSource, connectionChecker);
  });

  group('userSignIn', () {
    const String email = '_whatever.email';
    const String password = '_whatever.password';

    const tException = ServerException(
      message: 'Unknown Error Occured',
      statusCode: 500,
    );

    final tFailure = ApiFailure(
      message: tException.message,
      statusCode: tException.statusCode,
    );

    test(
        'should call [remoteDataSource.userSignIn] and return [UserModel] on success',
        () async {
      //arrange
      when(
        () => remoteDataSource.userSignIn(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => Future.value(user));

      //act
      final result =
          await repositoryImpl.userSignIn(email: email, password: password);

      //assert
      expect(result, equals(const Right(user)));

      verify(() =>
              remoteDataSource.userSignIn(email: email, password: password))
          .called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });

    test('should return a [Failure] when the request is unsuccessful',
        () async {
      //arrange
      when(
        () => remoteDataSource.userSignIn(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(tException);

      //act
      final result =
          await repositoryImpl.userSignIn(email: email, password: password);

      //assert
      expect(result, equals(Left(tFailure)));

      verify(() =>
              remoteDataSource.userSignIn(email: email, password: password))
          .called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });
  });
}
