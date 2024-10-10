import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    // Start listening to AuthBloc state changes
    _initialize();
  }

  void _initialize() {
    final authBloc = BlocProvider.of<AuthBloc>(context);

    // Listen for changes in the AudioBloc state
    authBloc.stream.listen((state) {
      if (state is AuthLoading) {
        _loading = true;
        _errorMessage = '';
        notifyListeners();
      } else if (state is AuthenticatedUser) {
        _user = state.user;
        _loading = false;
        notifyListeners();
      } else if (state is AuthFailure) {
        _errorMessage = state.message;
        _loading = false;
        notifyListeners();
      }
    });

    authBloc.add(AuthRetrieveAuthenticatedUserEvent());
  }
}

// import 'package:flutter/material.dart';
// import 'package:pix2life/core/utils/logger/logger.dart';
// import 'package:pix2life/src/features/auth/data/data_source/auth_manager.dart';
// import 'package:pix2life/src/features/auth/data/data_source/auth_service.dart';
// import 'package:pix2life/src/features/auth/data/models/user.model.dart';

// class MyUserProvider extends ChangeNotifier {
//   final log = createLogger(MyUserProvider);
//   final AuthService _authService;
//   final AuthManager _authManager;
//   UserModel? _user;

//   static const String userKey = "user_data"; // Key to store/retrieve user

//   MyUserProvider(this._authService, this._authManager);

//   // Getter for user
//   UserModel? get user => _user;

//   Future<void> loadUser() async {
//     log.d('Loading User From Provider');
//     try {
//       final String? token = await _authManager.getToken();
//       if (token != null) {
//         log.d('Token found: $token');

//         // Using the predefined key to retrieve the user
//         _user = await _authService.retrieveUser(userKey);
//         if (_user == const UserModel.empty()) {
//           _user = null;
//         }
//         if (_user != null && _user!.email.isNotEmpty) {
//           log.i('User loaded: ${_user!.email}');
//         }
//       } else {
//         log.e('Token not found');
//         _user = null;
//       }
//       notifyListeners();
//     } catch (e) {
//       log.e('Error on UserProvider');
//       _user = null;
//       notifyListeners();
//       log.e(e.toString());
//     }
//   }

//   Future<void> logout() async {
//     await _authManager.deleteToken();
//     _user = null;
//     notifyListeners();
//   }

//   // Check if user is logged in
//   bool get isLoggedIn => _user != null;
// }
