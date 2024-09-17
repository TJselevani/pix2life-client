import 'package:fpdart/fpdart.dart';
import 'package:pix2life/core/error/failure.dart';
import 'package:pix2life/core/usecases/usecase.dart';
import 'package:pix2life/features/auth/domain/entities/user.dart';
import 'package:pix2life/features/auth/domain/repositories/auth_repository.dart';

class UserSignInParams {
  final String email;
  final String password;

  UserSignInParams({
    required this.email,
    required this.password,
  });
}

class UserSignIn implements UseCase<User, UserSignInParams> {
  final AuthRepository authRepository;
  const UserSignIn(this.authRepository);
  @override
  Future<Either<Failure, User>> call(params) async {
    return await authRepository.userSignIn(
      email: params.email,
      password: params.password,
    );
  }
}
