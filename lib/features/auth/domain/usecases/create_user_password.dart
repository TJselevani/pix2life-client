import 'package:fpdart/fpdart.dart';
import 'package:pix2life/core/error/failure.dart';
import 'package:pix2life/core/usecases/usecase.dart';
import 'package:pix2life/features/auth/domain/repositories/auth_repository.dart';

class CreateUserPasswordParams {
  final String password;
  final String confirmPassword;

  CreateUserPasswordParams({
    required this.password,
    required this.confirmPassword,
  });
}

class CreateUserPassword implements UseCase<String, CreateUserPasswordParams> {
  final AuthRepository authRepository;
  const CreateUserPassword(this.authRepository);
  @override
  Future<Either<Failure, String>> call(params) async {
    return await authRepository.createUserPassword(
      password: params.password,
      confirmPassword: params.confirmPassword,
    );
  }
}
