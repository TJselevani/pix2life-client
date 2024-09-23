import 'package:equatable/equatable.dart';
import 'package:pix2life/core/usecases/usecase.dart';
import 'package:pix2life/core/utils/type_def.dart';
import 'package:pix2life/src/features/auth/domain/entities/user.dart';
import 'package:pix2life/src/features/auth/domain/repositories/auth_repository.dart';

class UserSignInParams extends Equatable {
  final String email;
  final String password;

  const UserSignInParams({
    required this.email,
    required this.password,
  });

  const UserSignInParams.empty()
      : this(
          email: '_empty.email',
          password: '_empty.password',
        );

  @override
  List<Object?> get props => [email, password];
}

class UserSignIn implements UseCase<User, UserSignInParams> {
  final AuthRepository _authRepository;
  const UserSignIn(this._authRepository);
  @override
  ResultFuture<User> call(params) async {
    return await _authRepository.userSignIn(
      email: params.email,
      password: params.password,
    );
  }
}
