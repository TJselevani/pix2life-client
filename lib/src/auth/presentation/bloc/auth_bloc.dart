import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pix2life/src/auth/data/data_source/auth_manager.dart';
import 'package:pix2life/core/utils/logger/logger.dart';
import 'package:pix2life/src/auth/domain/entities/user.dart';
import 'package:pix2life/src/auth/domain/usecases/check_auth_status.dart';
import 'package:pix2life/src/auth/domain/usecases/check_user_account.dart';
import 'package:pix2life/src/auth/domain/usecases/create_user_password.dart';
import 'package:pix2life/src/auth/domain/usecases/user_log_out.dart';
import 'package:pix2life/src/auth/domain/usecases/user_sign_in.dart';
import 'package:pix2life/src/auth/domain/usecases/user_sign_up.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserSignIn _userSignIn;
  final CheckUserAccount _checkUserAccount;
  final LogOutUser _logOutUser;
  final CreateUserPassword _createUserPassword;
  final CheckAuthStatus _checkAuthStatus;
  final AuthManager _authManager = AuthManager();
  final logger = createLogger(AuthBloc);

  AuthBloc({
    required UserSignUp userSignUp,
    required UserSignIn userSignIn,
    required CheckUserAccount checkUserAccount,
    required LogOutUser logOutUSer,
    required CreateUserPassword createUserPassword,
    required CheckAuthStatus checkAuthStatus,
  })  : _userSignUp = userSignUp,
        _userSignIn = userSignIn,
        _checkUserAccount = checkUserAccount,
        _logOutUser = logOutUSer,
        _createUserPassword = createUserPassword,
        _checkAuthStatus = checkAuthStatus,
        super(AuthInitial()) {
    on<AuthCheckAccountEvent>(_onCheckAccountEvent);
    on<AuthSignUpEvent>(_onSignUpEvent);
    on<AuthSignInEvent>(_onLoginEvent);
    on<AuthLogoutEvent>(_onLogoutEvent);
    on<AuthCreatePasswordEvent>(_onCreatePasswordEvent);
    on<AuthCheckAuthStatusEvent>(_onCheckAuthStatusEvent);
  }

  Future<void> _onCreatePasswordEvent(
      AuthCreatePasswordEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final response = await _createUserPassword(CreateUserPasswordParams(
        password: event.password, confirmPassword: event.confirmPassword));
    response.fold(
      (failure) => emit(AuthFailure(message: failure.errorMessage)),
      (message) => emit(Authenticated(message: message)),
    );
  }

  Future<void> _onCheckAccountEvent(
      AuthCheckAccountEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final response =
        await _checkUserAccount(CheckUserAccountParams(email: event.email));
    response.fold(
      (failure) => emit(AuthFailure(message: failure.errorMessage)),
      (message) => emit(Authenticated(message: message)),
    );
  }

  Future<void> _onCheckAuthStatusEvent(
      AuthCheckAuthStatusEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final token = await _authManager.getToken();
    if (token != null) {
      final response =
          await _checkAuthStatus(CheckAuthStatusParams(token: token));
      response.fold(
        (failure) => emit(AuthFailure(message: failure.errorMessage)),
        (user) => emit(AuthSuccess(user: user, message: 'Authenticated')),
      );
    } else {
      emit(const AuthUnauthenticated());
    }
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
      (failure) => emit(AuthFailure(message: failure.errorMessage)),
      (user) => emit(AuthSuccess(user: user, message: 'Log in Successful')),
    );
  }

  Future<void> _onLogoutEvent(
      AuthLogoutEvent event, Emitter<AuthState> emit) async {
    final String token = _authManager.getToken() as String;
    if (token.isNotEmpty) {
      final response = await _logOutUser(LogOutUserParams(token: token));
      response.fold(
        (failure) => emit(AuthFailure(message: failure.errorMessage)),
        (user) => emit(const Authenticated(message: 'Successfully logged out')),
      );
    } else {
      emit(const AuthFailure(message: 'Failed to Sign Out'));
    }
  }
}
