import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pix2life/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:pix2life/src/features/auth/domain/usecases/create_user_password.dart';

import 'auth_repository.mock.dart';

void main() {
  late CreateUserPassword usecase;
  late AuthRepository repository;

  setUp(() {
    repository = MockAuthRepository();
    usecase = CreateUserPassword(repository);
  });

  const params = CreateUserPasswordParams.empty();
  const String message = '';
  
  test('Should call the [AuthRepository.createUserPassword]', () async {
    //arrange
    when(() => repository.createUserPassword(
          password: any(named: 'password'),
          confirmPassword: any(named: 'confirmPassword'),
        )).thenAnswer((_) async => const Right(message));

    //act
    final result = await usecase(params);

    //assert
    expect(result, equals(const Right<dynamic, String>(message)));

    verify(() => repository.createUserPassword(
          password: params.password,
          confirmPassword: params.confirmPassword,
        )).called(1);

    verifyNoMoreInteractions(repository);
  });
}
