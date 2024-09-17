part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class Authenticated extends AuthState {
  final String message;
  Authenticated({required this.message});
}

final class AuthUnauthenticated extends AuthState {
  final String? message;
  AuthUnauthenticated({this.message});
}

final class AuthSuccess extends AuthState {
  final User user;
  final String message;

  AuthSuccess({
    required this.user,
    required this.message,
  });
}

final class AuthFailure extends AuthState {
  final String message;

  AuthFailure({required this.message});
}
