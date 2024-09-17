import 'package:fpdart/fpdart.dart';
import 'package:pix2life/core/error/failure.dart';
import 'package:pix2life/core/usecases/usecase.dart';
import 'package:pix2life/features/auth/domain/repositories/auth_repository.dart';

class logOutUserParams {
  final String token;

  logOutUserParams({
    required this.token,
  });
}

class LogOutUser implements UseCase<String, logOutUserParams> {
  final AuthRepository authRepository;
  const LogOutUser(this.authRepository);
  @override
  Future<Either<Failure, String>> call(params) async {
    return await authRepository.logOutUser(
      token: params.token,
    );
  }
}
