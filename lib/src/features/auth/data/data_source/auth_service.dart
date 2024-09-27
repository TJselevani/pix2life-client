import 'dart:convert';
import 'package:pix2life/src/features/auth/data/models/user.model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  late final SharedPreferences _sharedPreferences;
  AuthService(this._sharedPreferences);

  // Store the user object in _SharedPreferences
  Future<void> storeUser(UserModel user, String userKey) async {
    final String userJson = jsonEncode(user.toJson());
    await _sharedPreferences.setString(userKey, userJson);
  }

  // Retrieve the user object from _SharedPreferences
  Future<UserModel> retrieveUser(String userKey) async {
    final String? userJson = _sharedPreferences.getString(userKey);

    if (userJson != null) {
      final Map<String, dynamic> userMap = jsonDecode(userJson);
      return UserModel.fromJson(userMap);
    }

    // Return an empty user if no user data is found
    return const UserModel.empty();
  }

  // Remove the user data (for logout)
  Future<void> removeUser(String userKey) async {
    await _sharedPreferences.remove(userKey);
  }

  // Check if user is stored
  Future<bool> isUserLoggedIn(String userKey) async {
    return _sharedPreferences.containsKey(userKey);
  }
}
