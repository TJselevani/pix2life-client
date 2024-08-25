part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class SignUpEvent extends AuthEvent {
  final String username;
  final String email;
  final String address;
  final String phoneNumber;
  final String postCode;

  SignUpEvent({
    required this.username,
    required this.email,
    required this.address,
    required this.phoneNumber,
    required this.postCode,
  });
}

final class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  LoginEvent({
    required this.email,
    required this.password,
  });
}

final class UserUpdatedEvent extends AuthEvent {}

final class CheckAuthStatusEvent extends AuthEvent {}

final class LogoutEvent extends AuthEvent {}
