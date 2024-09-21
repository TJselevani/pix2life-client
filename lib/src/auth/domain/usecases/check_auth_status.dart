import 'package:equatable/equatable.dart';
import 'package:pix2life/core/usecases/usecase.dart';
import 'package:pix2life/core/utils/typeDef.dart';
import 'package:pix2life/src/auth/domain/entities/user.dart';
import 'package:pix2life/src/auth/domain/repositories/auth_repository.dart';

class CheckAuthStatusParams extends Equatable {
  final String token;

  CheckAuthStatusParams({
    required this.token,
  });

  CheckAuthStatusParams.empty() : this(token: '_empty.token');

  @override
  List<Object?> get props => [token];
}

class CheckAuthStatus implements UseCase<User, CheckAuthStatusParams> {
  final AuthRepository _authRepository;
  const CheckAuthStatus(this._authRepository);
  @override
  ResultFuture<User> call(params) async {
    return await _authRepository.checkAuthStatus(
      token: params.token,
    );
  }
}
