import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pix2life/src/auth/domain/entities/user.dart';
import 'package:pix2life/src/auth/domain/usecases/check_auth_status.dart';
import 'package:pix2life/src/auth/domain/repositories/auth_repository.dart';

import 'auth_repository.mock.dart';

void main() {
  late CheckAuthStatus usecase;
  late AuthRepository repository;

  setUp(() {
    repository = MockAuthRepository();
    usecase = CheckAuthStatus(repository);
  });

  final params = CheckAuthStatusParams.empty();
  final User user = User.empty();

  test('Should call the [AuthRepository.checkAuthStatus]', () async {
    //arrange
    when(
      () => repository.checkAuthStatus(token: any(named: 'token'))
    ).thenAnswer((_) async => Right(user));

    //act
    final result = await usecase(params);

    //assert
    expect(result, equals(Right<dynamic, User>(user)));
    verify(
      () => repository.checkAuthStatus(token: params.token)
    ).called(1);

    verifyNoMoreInteractions(repository);
  });
}
