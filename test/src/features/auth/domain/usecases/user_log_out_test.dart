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

  const String message = '';

  test('Should call the [AuthRepository.logOutUser]', () async {
    //arrange
    when(() => repository.logOutUser())
        .thenAnswer((_) async => const Right(message));

    //act
    final result = await usecase();

    //assert
    expect(result, equals(const Right<dynamic, String>(message)));

    verify(() => repository.logOutUser()).called(1);

    verifyNoMoreInteractions(repository);
  });
}
