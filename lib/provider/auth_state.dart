part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}
final class Authenticated extends AuthState {
  final User user;
  Authenticated({required this.user});
}

final class Unauthenticated extends AuthState {}
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
