import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pix2life/core/utils/logger/logger.dart';

class AuthManager {
  final log = createLogger(AuthManager);
  final FlutterSecureStorage _storage;
  AuthManager(this._storage);

  Future<void> storeToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
    log.d('stored Token successfully');
  }

  Future<String?> getToken() async {
    log.d('retrieving Token');
    return await _storage.read(key: 'auth_token');
  }

  Future<void> deleteToken() async {
    log.d('Deleting Token');
    await _storage.delete(key: 'auth_token');
  }
}
