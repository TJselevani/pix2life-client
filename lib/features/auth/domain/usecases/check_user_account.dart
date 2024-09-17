import 'package:fpdart/fpdart.dart';
import 'package:pix2life/core/error/failure.dart';
import 'package:pix2life/core/usecases/usecase.dart';
import 'package:pix2life/features/auth/domain/repositories/auth_repository.dart';

class CheckUserAccountParams {
  final String email;

  CheckUserAccountParams({
    required this.email,
  });
}

class CheckUserAccount implements UseCase<String, CheckUserAccountParams> {
  final AuthRepository authRepository;
  const CheckUserAccount(this.authRepository);
  @override
  Future<Either<Failure, String>> call(params) async {
    return await authRepository.checkUserAccount(
      email: params.email,
    );
  }
}
