import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pix2life/core/utils/logger/logger.dart';
import 'package:pix2life/core/utils/type_def.dart';
import 'package:pix2life/src/features/auth/domain/entities/user.dart';
import 'package:pix2life/src/features/auth/domain/usecases/get_user_data.dart';
import 'package:pix2life/src/features/auth/domain/usecases/check_user_account.dart';
import 'package:pix2life/src/features/auth/domain/usecases/create_user_password.dart';
import 'package:pix2life/src/features/auth/domain/usecases/payment_stripe.dart';
import 'package:pix2life/src/features/auth/domain/usecases/retrieve_auth_user.dart';
import 'package:pix2life/src/features/auth/domain/usecases/user_log_out.dart';
import 'package:pix2life/src/features/auth/domain/usecases/user_sign_in.dart';
import 'package:pix2life/src/features/auth/domain/usecases/user_sign_up.dart';
import 'package:pix2life/src/features/auth/domain/usecases/verify_user_logged_in.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final CheckUserAccount _checkUserAccount;
  final UserSignUp _userSignUp;
  final CreateUserPassword _createUserPassword;
  final UserSignIn _userSignIn;
  final LogOutUser _logOutUser;
  final GetUserData _getUserData;
  final RetrieveAuthUser _retrieveAuthUser;
  final IsUserLoggedIn _isUserLoggedIn;
  final StripePayment _stripePayment;
  final logger = createLogger(AuthBloc);

  AuthBloc({
    required CheckUserAccount checkUserAccount,
    required UserSignUp userSignUp,
    required CreateUserPassword createUserPassword,
    required UserSignIn userSignIn,
    required LogOutUser logOutUSer,
    required GetUserData getUserData,
    required RetrieveAuthUser retrieveAuthUser,
    required IsUserLoggedIn isUserLoggedIn,
    required StripePayment stripePayment,
  })  : _userSignUp = userSignUp,
        _userSignIn = userSignIn,
        _checkUserAccount = checkUserAccount,
        _logOutUser = logOutUSer,
        _createUserPassword = createUserPassword,
        _getUserData = getUserData,
        _retrieveAuthUser = retrieveAuthUser,
        _isUserLoggedIn = isUserLoggedIn,
        _stripePayment = stripePayment,
        super(AuthInitial()) {
    on<AuthCheckAccountEvent>(_onCheckAccountEvent);
    on<AuthSignUpEvent>(_onSignUpEvent);
    on<AuthCreatePasswordEvent>(_onCreatePasswordEvent);
    on<AuthSignInEvent>(_onLoginEvent);
    on<AuthLogoutEvent>(_onLogoutEvent);
    on<AuthGetUserDataEvent>(_onAuthGetUserDataEvent);
    on<AuthRetrieveAuthenticatedUserEvent>(
        _onAuthRetrieveAuthenticatedUserEvent);
    on<AuthIsUserLoggedInEvent>(_onAuthIsUserLoggedInEvent);
    on<AuthStripePaymentEvent>(_onAuthStripePaymentEvent);
    on<AuthUserUpdatedEvent>(_onAuthUserUpdatedEvent);
  }

  Future<void> _onCreatePasswordEvent(
      AuthCreatePasswordEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final response = await _createUserPassword(CreateUserPasswordParams(
        password: event.password, confirmPassword: event.confirmPassword));
    response.fold(
      (failure) => emit(AuthFailure(message: failure.errorMessage)),
      (message) => emit(AuthSuccess(message: message)),
    );
  }

  Future<void> _onCheckAccountEvent(
      AuthCheckAccountEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final response =
        await _checkUserAccount(CheckUserAccountParams(email: event.email));
    response.fold(
      (failure) => emit(AuthFailure(message: failure.errorMessage)),
      (message) => emit(AuthSuccess(message: message)),
    );
  }

  Future<void> _onAuthGetUserDataEvent(
      AuthGetUserDataEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final response = await _getUserData();
    response.fold(
      (failure) => emit(AuthFailure(message: failure.errorMessage)),
      (user) => emit(AuthenticatedUser(user: user, message: 'Authenticated')),
    );
  }

  Future<void> _onSignUpEvent(
      AuthSignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final response = await _userSignUp(UserSignUpParams(
      username: event.username,
      email: event.email,
      address: event.address,
      phoneNumber: event.phoneNumber,
      postCode: event.postCode,
    ));
    response.fold(
      (failure) => emit(AuthFailure(message: failure.errorMessage)),
      (user) =>
          emit(AuthenticatedUser(user: user, message: 'SignUp Successful')),
    );
  }

  Future<void> _onLoginEvent(
      AuthSignInEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final response = await _userSignIn(UserSignInParams(
      email: event.email,
      password: event.password,
    ));
    response.fold(
      (failure) => emit(AuthFailure(message: failure.errorMessage)),
      (user) =>
          emit(AuthenticatedUser(user: user, message: 'Log in Successful')),
    );
  }

  Future<void> _onLogoutEvent(
      AuthLogoutEvent event, Emitter<AuthState> emit) async {
    final response = await _logOutUser();
    response.fold(
      (failure) => emit(AuthFailure(message: failure.errorMessage)),
      (user) =>
          emit(const AuthUnauthenticated(message: 'Successfully logged out')),
    );
  }

  FutureOr<void> _onAuthRetrieveAuthenticatedUserEvent(
      AuthRetrieveAuthenticatedUserEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final response = await _retrieveAuthUser();
    response.fold(
      (failure) => emit(AuthFailure(message: failure.errorMessage)),
      (user) =>
          emit(AuthenticatedUser(user: user, message: 'Retrieval Successful')),
    );
  }

  FutureOr<void> _onAuthIsUserLoggedInEvent(
      AuthIsUserLoggedInEvent event, Emitter<AuthState> emit) async {
    final response = await _isUserLoggedIn();
    response.fold(
        (failure) => emit(AuthUnauthenticated(message: failure.errorMessage)),
        (user) => emit(
            AuthLoggedInUser(user: user, message: '${user.email} Logged In')));
  }

  FutureOr<void> _onAuthStripePaymentEvent(
      AuthStripePaymentEvent event, Emitter<AuthState> emit) async {
    final response = await _stripePayment(
        StripePaymentParams(paymentData: event.paymentData));
    response.fold((failure) => emit(AuthFailure(message: failure.errorMessage)),
        (clientSecret) => emit(AuthPaymentSuccess(clientSecret: clientSecret)));
  }

  FutureOr<void> _onAuthUserUpdatedEvent(
      AuthUserUpdatedEvent event, Emitter<AuthState> emit) {
    emit(AuthUpdatedUser());
  }
}
