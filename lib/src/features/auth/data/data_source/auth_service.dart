import 'dart:convert';
import 'package:pix2life/core/utils/logger/logger.dart';
import 'package:pix2life/src/features/auth/data/models/user.model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final log = createLogger(AuthService);
  late final SharedPreferences _sharedPreferences;

  AuthService(this._sharedPreferences);

  // Store the user object in _SharedPreferences
  Future<void> storeUser(UserModel user, String userKey) async {
    final String userJson = jsonEncode(user.toJson());
    log.d('User JSON to store: $userJson');
    await _sharedPreferences.setString(userKey, userJson);
    log.d('Stored User successfully to SharedPreferences');
  }

  Future<UserModel?> retrieveUser(String userKey) async {
    final String? userJson = _sharedPreferences.getString(userKey);
    log.d(
        'Raw User JSON from SharedPreferences: $userJson'); // Log before decoding
    if (userJson != null) {
      try {
        final userMap = jsonDecode(userJson);
        return UserModel.fromJsonString(userMap);
      } catch (e) {
        log.e('Error decoding user data: $e');
      }
    }
    return null; // or however you want to handle no user found
  }

  // Remove the user data (for logout)
  Future<void> removeUser(String userKey) async {
    await _sharedPreferences.remove(userKey);
    log.d('Removing User from SharedPreferences');
  }

  // Check if user is stored
  Future<bool> isUserLoggedIn(String userKey) async {
    log.d('Checking User in SharedPreferences');
    return _sharedPreferences.containsKey(userKey);
  }
}
