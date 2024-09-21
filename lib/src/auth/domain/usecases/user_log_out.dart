import 'package:equatable/equatable.dart';
import 'package:pix2life/core/usecases/usecase.dart';
import 'package:pix2life/core/utils/typeDef.dart';
import 'package:pix2life/src/auth/domain/repositories/auth_repository.dart';

class logOutUserParams extends Equatable {
  final String token;

  logOutUserParams({
    required this.token,
  });

  logOutUserParams.empty() : this(token: '_empty.token');

  @override
  List<Object?> get props => [token];
}

class LogOutUser implements UseCase<String, logOutUserParams> {
  final AuthRepository _authRepository;
  const LogOutUser(this._authRepository);
  @override
  ResultFuture<String> call(params) async {
    return await _authRepository.logOutUser(
      token: params.token,
    );
  }
}
