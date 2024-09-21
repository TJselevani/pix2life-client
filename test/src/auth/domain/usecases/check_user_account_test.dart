import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pix2life/src/auth/domain/usecases/check_user_account.dart';
import 'package:pix2life/src/auth/domain/repositories/auth_repository.dart';

import 'auth_repository.mock.dart';

void main() {
  late CheckUserAccount usecase;
  late AuthRepository repository;

  setUp(() {
    repository = MockAuthRepository();
    usecase = CheckUserAccount(repository);
  });

  final params = CheckUserAccountParams.empty();
  final String message = '';

  test('Should call the [AuthRepository.checkUserAccount]', () async {
    //arrange
    when(() => repository.checkUserAccount(email: any(named: 'email')))
        .thenAnswer((_) async => Right(message));

    //act
    final result = await usecase(params);

    //assert
    expect(result, equals(Right<dynamic, String>(message)));
    verify(() => repository.checkUserAccount(email: params.email)).called(1);

    verifyNoMoreInteractions(repository);
  });
}
