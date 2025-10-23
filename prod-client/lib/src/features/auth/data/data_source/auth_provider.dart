import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pix2life/core/utils/type_def.dart';
import 'package:pix2life/src/features/auth/domain/entities/user.dart';
import 'package:pix2life/src/features/auth/presentation/bloc/auth_bloc.dart';

class MyUserProvider with ChangeNotifier {
  final BuildContext context;
  late final StreamSubscription
      _authSubscription; // Store the stream subscription

  User? _user;
  bool _loading = false;
  String _errorMessage = '';

  User? get user => _user;
  bool get isLoading => _loading;
  String get errorMessage => _errorMessage;

  MyUserProvider(this.context) {
    _initialize();
  }

  // Initialize and listen for AuthBloc state changes
  void _initialize() {
    final authBloc = BlocProvider.of<AuthBloc>(context);

    // Store the subscription so we can cancel it later
    _authSubscription = authBloc.stream.listen((state) {
      if (state is AuthLoading) {
        _loading = true;
        _errorMessage = '';
        notifyListeners();
      } else if (state is AuthenticatedUser) {
        _user = state.user;
        _loading = false;
        notifyListeners();
      } else if (state is AuthUpdatedUser) {
        authBloc.add(AuthRetrieveAuthenticatedUserEvent());
        notifyListeners();
      } else if (state is AuthLoggedInUser) {
        _user = state.user;
        authBloc.add(AuthGetUserDataEvent());
        _loading = false;
        notifyListeners();
      } else if (state is AuthFailure) {
        _errorMessage = state.message;
        _loading = false;
        notifyListeners();
      }
    });

    // Initial fetch of authenticated user
    authBloc.add(AuthRetrieveAuthenticatedUserEvent());
  }

  Future<void> fetchUser() async {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    authBloc.add(AuthRetrieveAuthenticatedUserEvent());
  }

  // Method to update user data
  Future<void> updateUser(User updatedUser) async {
    final authBloc = BlocProvider.of<AuthBloc>(context);

    _loading = true;
    notifyListeners();

    // authBloc.add(AuthUpdateUserEvent(updatedUser));

    await for (var state in authBloc.stream) {
      if (state is AuthenticatedUser) {
        _user = state.user;
        _loading = false;
        notifyListeners();
        break; // Exit the loop once successful
      } else if (state is AuthFailure) {
        _errorMessage = state.message;
        _loading = false;
        notifyListeners();
        break; // Exit the loop on failure
      }
    }
  }

  // Method to make stripe payment
  void makeStripePayment(DataMap paymentData) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    _loading = true;
    _errorMessage = '';
    notifyListeners();

    // Dispatch an [AuthStripePaymentEvent] to the [AuthBloc]
    authBloc.add(AuthStripePaymentEvent(paymentData: paymentData));
  }

  // Refetch user data
  Future<void> refetchUser() async {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    authBloc.add(AuthGetUserDataEvent());
  }

  Future<void> logOutUser() async {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    authBloc.add(AuthLogoutEvent());
  }

  // Dispose method to prevent memory leaks
  @override
  void dispose() {
    _authSubscription.cancel(); // Cancel the stream subscription
    super.dispose();
  }
}
