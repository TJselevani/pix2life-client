part of 'auth_bloc.dart';

@immutable
sealed class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthenticatedUser extends AuthState {
  final User user;
  final String message;

  const AuthenticatedUser({required this.user, required this.message});

  @override
  List<Object> get props => [user, message];
}

final class AuthLoggedInUser extends AuthState {
  final User user;
  final String message;

  const AuthLoggedInUser({required this.user, required this.message});

  @override
  List<Object> get props => [user, message];
}

final class AuthUpdatedUser extends AuthState {
  const AuthUpdatedUser();

  @override
  List<Object> get props => [];
}

final class AuthUnauthenticated extends AuthState {
  final String message;
  const AuthUnauthenticated({required this.message});

  @override
  List<Object?> get props => [message];
}

final class AuthPaymentSuccess extends AuthState {
  final String clientSecret;

  const AuthPaymentSuccess({required this.clientSecret});

  @override
  List<Object> get props => [clientSecret];
}

final class AuthSuccess extends AuthState {
  final String message;

  const AuthSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

final class AuthFailure extends AuthState {
  final String message;

  const AuthFailure({required this.message});

  @override
  List<Object> get props => [message];
}
