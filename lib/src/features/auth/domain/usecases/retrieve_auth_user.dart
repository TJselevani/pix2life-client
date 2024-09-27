import 'package:pix2life/core/usecases/usecase.dart';
import 'package:pix2life/core/utils/type_def.dart';
import 'package:pix2life/src/features/auth/domain/entities/user.dart';
import 'package:pix2life/src/features/auth/domain/repositories/auth_repository.dart';

class RetrieveAuthUser implements UseCaseWithoutParams<User> {
  final AuthRepository _authRepository;
  const RetrieveAuthUser(this._authRepository);
  @override
  ResultFuture<User> call() async {
    return await _authRepository.retrieveAuthUser();
  }
}
