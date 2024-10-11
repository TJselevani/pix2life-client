import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pix2life/src/features/auth/data/data_source/auth_manager.dart';
import 'package:pix2life/core/utils/logger/logger.dart';
import 'package:pix2life/src/features/auth/domain/entities/user.dart';
import 'package:pix2life/src/features/auth/domain/usecases/get_user_data.dart';
import 'package:pix2life/src/features/auth/domain/usecases/check_user_account.dart';
import 'package:pix2life/src/features/auth/domain/usecases/create_user_password.dart';
import 'package:pix2life/src/features/auth/domain/usecases/retrieve_auth_user.dart';
import 'package:pix2life/src/features/auth/domain/usecases/user_log_out.dart';
import 'package:pix2life/src/features/auth/domain/usecases/user_sign_in.dart';
import 'package:pix2life/src/features/auth/domain/usecases/user_sign_up.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserSignIn _userSignIn;
  final CheckUserAccount _checkUserAccount;
  final LogOutUser _logOutUser;
  final CreateUserPassword _createUserPassword;
  final GetUserData _getUserData;
  final RetrieveAuthUser _retrieveAuthUser;
  final AuthManager _authManager;
  final logger = createLogger(AuthBloc);

  AuthBloc({
    required UserSignUp userSignUp,
    required UserSignIn userSignIn,
    required CheckUserAccount checkUserAccount,
    required LogOutUser logOutUSer,
    required CreateUserPassword createUserPassword,
    required GetUserData getUserData,
    required RetrieveAuthUser retrieveAuthUser,
    required AuthManager authManager,
  })  : _userSignUp = userSignUp,
        _userSignIn = userSignIn,
        _checkUserAccount = checkUserAccount,
        _logOutUser = logOutUSer,
        _createUserPassword = createUserPassword,
        _getUserData = getUserData,
        _retrieveAuthUser = retrieveAuthUser,
        _authManager = authManager,
        super(AuthInitial()) {
    on<AuthCheckAccountEvent>(_onCheckAccountEvent);
    on<AuthSignUpEvent>(_onSignUpEvent);
    on<AuthSignInEvent>(_onLoginEvent);
    on<AuthLogoutEvent>(_onLogoutEvent);
    on<AuthCreatePasswordEvent>(_onCreatePasswordEvent);
    on<AuthGetUserDataEvent>(_onAuthGetUserDataEvent);
    on<AuthRetrieveAuthenticatedUserEvent>(
        _onAuthRetrieveAuthenticatedUserEvent);
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
    final String token = _authManager.getToken() as String;
    if (token.isNotEmpty) {
      final response = await _logOutUser();
      response.fold(
        (failure) => emit(AuthFailure(message: failure.errorMessage)),
        (user) => emit(const AuthSuccess(message: 'Successfully logged out')),
      );
    } else {
      emit(const AuthFailure(message: 'Failed to Sign Out'));
    }
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
}
