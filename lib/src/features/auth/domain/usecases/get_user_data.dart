
import 'package:pix2life/core/usecases/usecase.dart';
import 'package:pix2life/core/utils/type_def.dart';
import 'package:pix2life/src/features/auth/domain/entities/user.dart';
import 'package:pix2life/src/features/auth/domain/repositories/auth_repository.dart';


class GetUserData implements UseCaseWithoutParams<User> {
  final AuthRepository _authRepository;
  const GetUserData(this._authRepository);
  @override
  ResultFuture<User> call() async {
    return await _authRepository.getUserData();
  }
}
