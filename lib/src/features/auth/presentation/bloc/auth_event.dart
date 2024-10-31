part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

final class AuthCheckAccountEvent extends AuthEvent {
  final String email;

  AuthCheckAccountEvent({required this.email});

  @override
  List<Object> get props => [email];
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

  @override
  List<Object> get props => [username, email, address, phoneNumber, postCode];
}

final class AuthSignInEvent extends AuthEvent {
  final String email;
  final String password;

  AuthSignInEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

final class AuthCreatePasswordEvent extends AuthEvent {
  final String password;
  final String confirmPassword;

  AuthCreatePasswordEvent({
    required this.password,
    required this.confirmPassword,
  });

  @override
  List<Object> get props => [password, confirmPassword];
}

final class AuthStripePaymentEvent extends AuthEvent {
  final DataMap paymentData;

  AuthStripePaymentEvent({
    required this.paymentData,
  });

  @override
  List<Object> get props => [paymentData];
}

final class AuthGetUserDataEvent extends AuthEvent {}

final class AuthRetrieveAuthenticatedUserEvent extends AuthEvent {}

final class AuthIsUserLoggedInEvent extends AuthEvent {}

final class AuthUserUpdatedEvent extends AuthEvent {}

final class AuthLogoutEvent extends AuthEvent {}
