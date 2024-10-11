
import 'package:pix2life/core/usecases/usecase.dart';
import 'package:pix2life/core/utils/type_def.dart';
import 'package:pix2life/src/features/auth/domain/repositories/auth_repository.dart';

class LogOutUser implements UseCaseWithoutParams<String> {
  final AuthRepository _authRepository;
  const LogOutUser(this._authRepository);
  @override
  ResultFuture<String> call() async {
    return await _authRepository.logOutUser();
  }
}
