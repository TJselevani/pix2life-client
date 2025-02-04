//What does the class depend on?
// ## :: auth_repository
//How can we create a mock of the dependency?
// ## :: MockTail
//How do we control what the dependencies do
// ## :: Using MockTail API

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pix2life/src/features/auth/domain/entities/user.dart';
import 'package:pix2life/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:pix2life/src/features/auth/domain/usecases/user_sign_in.dart';
import 'package:fpdart/fpdart.dart';

import 'auth_repository.mock.dart';

void main() {
  late UserSignIn usecase;
  late AuthRepository repository;

  setUp(() {
    repository = MockAuthRepository();
    usecase = UserSignIn(repository);
  });

  const params = UserSignInParams.empty();
  const User user = User.empty();
  test('Should call the [AuthRepository.userSignIn]', () async {
    //arrange
    when(
      () => repository.userSignIn(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async => const Right(user));

    //act
    final result = await usecase(params);

    //assert
    expect(result, equals(const Right<dynamic, User>(user)));
    verify(
      () => repository.userSignIn(
        email: params.email,
        password: params.password,
      ),
    ).called(1);

    verifyNoMoreInteractions(repository);
  });
}
