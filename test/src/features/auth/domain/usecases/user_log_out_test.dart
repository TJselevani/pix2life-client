import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pix2life/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:pix2life/src/features/auth/domain/usecases/user_log_out.dart';

import 'auth_repository.mock.dart';

void main() {
  late LogOutUser usecase;
  late AuthRepository repository;

  setUp(() {
    repository = MockAuthRepository();
    usecase = LogOutUser(repository);
  });

  const params = LogOutUserParams.empty();
  const String message = '';

  test('Should call the [AuthRepository.logOutUser]', () async {
    //arrange
    when(() => repository.logOutUser(token: any(named: 'token')))
        .thenAnswer((_) async => const Right(message));

    //act
    final result = await usecase(params);

    //assert
    expect(result, equals(const Right<dynamic, String>(message)));

    verify(() => repository.logOutUser(token: params.token)).called(1);

    verifyNoMoreInteractions(repository);
  });
}
