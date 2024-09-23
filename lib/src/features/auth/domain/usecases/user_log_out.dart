import 'package:equatable/equatable.dart';
import 'package:pix2life/core/usecases/usecase.dart';
import 'package:pix2life/core/utils/type_def.dart';
import 'package:pix2life/src/features/auth/domain/repositories/auth_repository.dart';

class LogOutUserParams extends Equatable {
  final String token;

  const LogOutUserParams({
    required this.token,
  });

  const LogOutUserParams.empty() : this(token: '_empty.token');

  @override
  List<Object?> get props => [token];
}

class LogOutUser implements UseCase<String, LogOutUserParams> {
  final AuthRepository _authRepository;
  const LogOutUser(this._authRepository);
  @override
  ResultFuture<String> call(params) async {
    return await _authRepository.logOutUser(
      token: params.token,
    );
  }
}
