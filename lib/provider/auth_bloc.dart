import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pix2life/config/logger/logger.dart';
import 'package:pix2life/functions/services/token.services.dart';
import 'package:pix2life/functions/services/user.services.dart';
import 'package:pix2life/models/entities/user.model.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserService _userService = UserService();
  final TokenService _tokenService = TokenService();
  final log = logger(AuthBloc);

  AuthBloc() : super(AuthInitial()) {
    on<SignUpEvent>(_onSignUpEvent);
    on<LoginEvent>(_onLoginEvent);
    on<LogoutEvent>(_onLogoutEvent);
    on<UserUpdatedEvent>(_onUpdateUserStateEvent);
    on<CheckAuthStatusEvent>(_onCheckAuthStatusEvent);
  }

  Future<void> _onSignUpEvent(
      SignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final response = await _userService.createUser(_createUserCredentials(event));
      await _handleAuthResponse(response, emit);
    } catch (e) {
      _handleError(e, emit, "Sign-up Failed");
    }
  }

  Future<void> _onLoginEvent(
      LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final response = await _userService.signIn(_createLoginCredentials(event));
      await _handleAuthResponse(response, emit);
    } catch (e) {
      _handleError(e, emit, "Sign-in failed");
    }
  }

  Future<void> _onCheckAuthStatusEvent(
      CheckAuthStatusEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final token = await _tokenService.getToken();
    if (token != null) {
      try {
        final response = await _userService.getUserFromToken();
        final authUser = User.fromJson(response.user);
        emit(AuthSuccess(user: authUser, message: 'Authenticated'));
      } catch (e) {
        _handleError(e, emit, 'Authentication failed');
      }
    } else {
      emit(Unauthenticated());
    }
  }

  Future<void> _onUpdateUserStateEvent(
      UserUpdatedEvent event, Emitter<AuthState> emit) async {
    final token = await _tokenService.getToken();
    if (token != null) {
      try {
        final response = await _userService.getUserFromToken();
        final authUser = User.fromJson(response.user);
        emit(AuthSuccess(user: authUser, message: 'User updated'));
      } catch (e) {
        _handleError(e, emit, 'User update failed');
      }
    } else {
      emit(Unauthenticated());
    }
  }

  Future<void> _onLogoutEvent(
      LogoutEvent event, Emitter<AuthState> emit) async {
    await _tokenService.deleteToken();
    emit(Unauthenticated());
  }

  Map<String, dynamic> _createUserCredentials(SignUpEvent event) {
    return {
      'username': event.username,
      'email': event.email,
      'address': event.address,
      'phoneNumber': event.phoneNumber,
      'postCode': event.postCode,
    };
  }

  Map<String, dynamic> _createLoginCredentials(LoginEvent event) {
    return {
      'email': event.email,
      'password': event.password,
    };
  }

  Future<void> _handleAuthResponse(
      dynamic response, Emitter<AuthState> emit) async {
    final String token = response.token;
    final Map<String, dynamic> userData = response.user;
    final String authMessage = response.message;
    await _tokenService.storeToken(token);
    log.i('message: $authMessage');
    log.i('token: $token');
    log.i('userData: $userData');

    final User authUser = await User.fromJson(userData);
    emit(AuthSuccess(user: authUser, message: authMessage));
  }

  void _handleError(dynamic error, Emitter<AuthState> emit, String defaultMessage) {
    log.e(error);
    emit(AuthFailure(message: defaultMessage));
  }
}
