import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pix2life/src/features/auth/domain/entities/user.dart';
import 'package:pix2life/src/features/auth/domain/usecases/get_user_data.dart';
import 'package:pix2life/src/features/auth/domain/repositories/auth_repository.dart';

import 'auth_repository.mock.dart';

void main() {
  late GetUserData usecase;
  late AuthRepository repository;

  setUp(() {
    repository = MockAuthRepository();
    usecase = GetUserData(repository);
  });

  const User user = User.empty();

  test('Should call the [AuthRepository.checkAuthStatus]', () async {
    //arrange
    when(() => repository.getUserData())
        .thenAnswer((_) async => const Right(user));

    //act
    final result = await usecase();

    //assert
    expect(result, equals(const Right<dynamic, User>(user)));
    verify(() => repository.getUserData()).called(1);

    verifyNoMoreInteractions(repository);
  });
}
