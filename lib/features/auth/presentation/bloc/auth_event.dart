part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthCheckAccountEvent extends AuthEvent {
  final String email;

  AuthCheckAccountEvent({required this.email});
}

final class AuthSignUpEvent extends AuthEvent {
  final String username;
  final String email;
  final String address;
  final String phoneNumber;
  final String postCode;

  AuthSignUpEvent({
    required this.username,
    required this.email,
    required this.address,
    required this.phoneNumber,
    required this.postCode,
  });
}

final class AuthSignInEvent extends AuthEvent {
  final String email;
  final String password;

  AuthSignInEvent({
    required this.email,
    required this.password,
  });
}

final class AuthCreatePasswordEvent extends AuthEvent {
  final String password;
  final String confirmPassword;

  AuthCreatePasswordEvent({
    required this.password,
    required this.confirmPassword,
  });
}

final class AuthCheckAuthStatusEvent extends AuthEvent {}

final class AuthLogoutEvent extends AuthEvent {}
