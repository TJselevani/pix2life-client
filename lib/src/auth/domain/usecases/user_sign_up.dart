import 'package:equatable/equatable.dart';
import 'package:pix2life/core/usecases/usecase.dart';
import 'package:pix2life/core/utils/typeDef.dart';
import 'package:pix2life/src/auth/domain/entities/user.dart';
import 'package:pix2life/src/auth/domain/repositories/auth_repository.dart';

class UserSignUpParams extends Equatable {
  final String username;
  final String email;
  final String address;
  final String phoneNumber;
  final String postCode;

  UserSignUpParams.empty()
      : this(
          username: '_empty.username',
          email: '_empty.email',
          address: 'empty.address',
          phoneNumber: '_empty.phoneNumber',
          postCode: '_empty.postCode',
        );

  UserSignUpParams({
    required this.username,
    required this.email,
    required this.address,
    required this.phoneNumber,
    required this.postCode,
  });

  @override
  List<Object?> get props => [username, email, address, phoneNumber, postCode];
}

class UserSignUp implements UseCase<User, UserSignUpParams> {
  final AuthRepository _authRepository;
  const UserSignUp(this._authRepository);
  @override
  ResultFuture<User> call(params) async {
    return await _authRepository.userSignUp(
      username: params.username,
      email: params.email,
      address: params.address,
      phoneNumber: params.phoneNumber,
      postCode: params.postCode,
    );
  }
}
