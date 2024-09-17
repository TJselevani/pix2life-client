import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pix2life/core/services/auth_manager.dart';
import 'package:pix2life/core/utils/logger/logger.dart';
import 'package:pix2life/features/auth/domain/entities/user.dart';
import 'package:pix2life/features/auth/domain/usecases/check_user_account.dart';
import 'package:pix2life/features/auth/domain/usecases/create_user_password.dart';
import 'package:pix2life/features/auth/domain/usecases/user_log_out.dart';
import 'package:pix2life/features/auth/domain/usecases/user_sign_in.dart';
import 'package:pix2life/features/auth/domain/usecases/user_sign_up.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserSignIn _userSignIn;
  final CheckUserAccount _checkUserAccount;
  final LogOutUser _logOutUser;
  final CreateUserPassword _createUserPassword;
  final AuthManager _authManager = AuthManager();
  final logger = createLogger(AuthBloc);

  AuthBloc({
    required UserSignUp userSignUp,
    required UserSignIn userSignIn,
    required CheckUserAccount checkUserAccount,
    required LogOutUser logOutUSer,
    required CreateUserPassword createUserPassword,
  })  : _userSignUp = userSignUp,
        _userSignIn = userSignIn,
        _checkUserAccount = checkUserAccount,
        _logOutUser = logOutUSer,
        _createUserPassword = createUserPassword,
        super(AuthInitial()) {
    on<AuthCheckAccountEvent>(_onCheckAccountEvent);
    on<AuthSignUpEvent>(_onSignUpEvent);
    on<AuthSignInEvent>(_onLoginEvent);
    on<AuthLogoutEvent>(_onLogoutEvent);
    on<AuthCreatePasswordEvent>(_onCreatePasswordEvent);
  }

  Future<void> _onCreatePasswordEvent(
      AuthCreatePasswordEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final response = await _createUserPassword(CreateUserPasswordParams(
        password: event.password, confirmPassword: event.confirmPassword));
    response.fold(
      (failure) => emit(AuthFailure(message: failure.message)),
      (user) => emit(Authenticated(message: 'Valid email address')),
    );
  }

  Future<void> _onCheckAccountEvent(
      AuthCheckAccountEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final response =
        await _checkUserAccount(CheckUserAccountParams(email: event.email));
    response.fold(
      (failure) => emit(AuthFailure(message: failure.message)),
      (user) => emit(Authenticated(message: 'Valid email address')),
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
      (failure) => emit(AuthFailure(message: failure.message)),
      (user) => emit(AuthSuccess(user: user, message: 'Sign in Successful')),
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
      (l) => emit(AuthFailure(message: l.message)),
      (r) => emit(AuthSuccess(user: r, message: 'Log in Successful')),
    );
  }

  Future<void> _onLogoutEvent(
      AuthLogoutEvent event, Emitter<AuthState> emit) async {
    final String token = _authManager.getToken() as String;
    if (token.isNotEmpty) {
      final response = await _logOutUser(logOutUserParams(token: token));
      response.fold(
        (failure) => emit(AuthFailure(message: failure.message)),
        (user) => emit(Authenticated(message: 'Successfully logged out')),
      );
    } else {
      emit(AuthUnauthenticated());
    }
  }
}
