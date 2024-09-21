import 'package:equatable/equatable.dart';
import 'package:pix2life/core/usecases/usecase.dart';
import 'package:pix2life/core/utils/typeDef.dart';
import 'package:pix2life/src/auth/domain/repositories/auth_repository.dart';

class CheckUserAccountParams extends Equatable {
  final String email;

  CheckUserAccountParams({
    required this.email,
  });

  CheckUserAccountParams.empty() : this(email: '_empty.email');

  @override
  List<Object?> get props => [email];
}

class CheckUserAccount implements UseCase<String, CheckUserAccountParams> {
  final AuthRepository _authRepository;
  const CheckUserAccount(this._authRepository);
  @override
  ResultFuture<String> call(params) async {
    return await _authRepository.checkUserAccount(
      email: params.email,
    );
  }
}
