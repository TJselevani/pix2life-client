import 'package:equatable/equatable.dart';
import 'package:pix2life/core/usecases/usecase.dart';
import 'package:pix2life/core/utils/typeDef.dart';
import 'package:pix2life/src/auth/domain/repositories/auth_repository.dart';

class CreateUserPasswordParams extends Equatable {
  final String password;
  final String confirmPassword;

  CreateUserPasswordParams({
    required this.password,
    required this.confirmPassword,
  });

  CreateUserPasswordParams.empty()
      : this(
          password: '_empty.password',
          confirmPassword: '_empty.confirmPassword',
        );

  @override
  List<Object?> get props => [password, confirmPassword];
}

class CreateUserPassword implements UseCase<String, CreateUserPasswordParams> {
  final AuthRepository _authRepository;
  const CreateUserPassword(this._authRepository);
  @override
  ResultFuture<String> call(params) async {
    return await _authRepository.createUserPassword(
      password: params.password,
      confirmPassword: params.confirmPassword,
    );
  }
}
