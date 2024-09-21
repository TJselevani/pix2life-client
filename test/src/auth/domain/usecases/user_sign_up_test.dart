import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pix2life/src/auth/domain/entities/user.dart';
import 'package:pix2life/src/auth/domain/usecases/user_sign_up.dart';
import 'package:pix2life/src/auth/domain/repositories/auth_repository.dart';

import 'auth_repository.mock.dart';

void main() {
  late UserSignUp usecase;
  late AuthRepository repository;

  setUp(() {
    repository = MockAuthRepository();
    usecase = UserSignUp(repository);
  });

  final params = UserSignUpParams.empty();
  final User user = User.empty();

  test('Should call the [AuthRepository.userSignUp]', () async {
    //arrange
    when(
      () => repository.userSignUp(
        username: any(named: 'username'),
        email: any(named: 'email'),
        address: any(named: 'address'),
        phoneNumber: any(named: 'phoneNumber'),
        postCode: any(named: 'postCode'),
      ),
    ).thenAnswer((_) async => Right(user));

    //act
    final result = await usecase(params);

    //assert
    expect(result, equals(Right<dynamic, User>(user)));
    verify(() => repository.userSignUp(
          username: params.username,
          email: params.email,
          address: params.address,
          phoneNumber: params.phoneNumber,
          postCode: params.postCode,
        )).called(1);

    verifyNoMoreInteractions(repository);
  });
}
