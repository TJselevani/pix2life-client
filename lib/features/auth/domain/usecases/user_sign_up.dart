import 'package:fpdart/fpdart.dart';
import 'package:pix2life/core/error/failure.dart';
import 'package:pix2life/core/usecases/usecase.dart';
import 'package:pix2life/features/auth/domain/entities/user.dart';
import 'package:pix2life/features/auth/domain/repositories/auth_repository.dart';

class UserSignUpParams {
  final String username;
  final String email;
  final String address;
  final String phoneNumber;
  final String postCode;

  UserSignUpParams({
    required this.username,
    required this.email,
    required this.address,
    required this.phoneNumber,
    required this.postCode,
  });
}

class UserSignUp implements UseCase<User, UserSignUpParams> {
  final AuthRepository authRepository;
  const UserSignUp(this.authRepository);
  @override
  Future<Either<Failure, User>> call(params) async {
    return await authRepository.userSignUp(
      username: params.username,
      email: params.email,
      address: params.address,
      phoneNumber: params.phoneNumber,
      postCode: params.postCode,
    );
  }
}
