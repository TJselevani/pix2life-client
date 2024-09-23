part of 'auth_bloc.dart';

@immutable
sealed class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class Authenticated extends AuthState {
  final String message;
  const Authenticated({required this.message});

  @override
  List<Object> get props => [message];
}

final class AuthUnauthenticated extends AuthState {
  final String? message;
  const AuthUnauthenticated({this.message});

  @override
  List<Object?> get props => [message];
}

final class AuthSuccess extends AuthState {
  final User user;
  final String message;

  const AuthSuccess({
    required this.user,
    required this.message,
  });

  @override
  List<Object> get props => [user, message];
}

final class AuthFailure extends AuthState {
  final String message;

  const AuthFailure({required this.message});

  @override
  List<Object> get props => [message];
}
