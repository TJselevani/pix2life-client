import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pix2life/core/utils/type_def.dart';
import 'package:pix2life/src/features/auth/domain/entities/user.dart';
import 'package:pix2life/src/features/auth/presentation/bloc/auth_bloc.dart';

class MyUserProvider with ChangeNotifier {
  final BuildContext context;

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

    // Listen for AuthBloc state changes
    authBloc.stream.listen((state) {
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

  // Method to update user data
  Future<void> updateUser(User updatedUser) async {
    final authBloc = BlocProvider.of<AuthBloc>(context);

    try {
      _loading = true;
      notifyListeners();

      // Dispatch an event to update the user
      // authBloc.add(AuthUpdateUserEvent(updatedUser));

      // Optionally listen for the update success
      authBloc.stream.listen((state) {
        if (state is AuthenticatedUser) {
          _user = state.user;
          notifyListeners();
        } else if (state is AuthFailure) {
          _errorMessage = state.message;
          notifyListeners();
        }
      });
    } catch (e) {
      _loading = false;
      _errorMessage = 'Failed to update user';
      notifyListeners();
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
}
