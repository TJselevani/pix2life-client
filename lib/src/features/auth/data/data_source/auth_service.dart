import 'dart:convert';
import 'package:pix2life/src/features/auth/data/models/user.model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  late final SharedPreferences sharedPreferences;
  AuthService(this.sharedPreferences);

  // Store the user object in SharedPreferences
  Future<void> storeUser(UserModel user, String userKey) async {
    final String userJson = jsonEncode(user.toJson());
    await sharedPreferences.setString(userKey, userJson);
  }

  // Retrieve the user object from SharedPreferences
  Future<UserModel> retrieveUser(String userKey) async {
    final String? userJson = sharedPreferences.getString(userKey);

    if (userJson != null) {
      final Map<String, dynamic> userMap = jsonDecode(userJson);
      return UserModel.fromJson(userMap);
    }

    // Return an empty user if no user data is found
    return const UserModel.empty();
  }

  // Remove the user data (for logout)
  Future<void> removeUser(String userKey) async {
    await sharedPreferences.remove(userKey);
  }

  // Check if user is stored
  Future<bool> isUserLoggedIn(String userKey) async {
    return sharedPreferences.containsKey(userKey);
  }
}
