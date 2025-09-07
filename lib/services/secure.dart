import 'dart:convert';
import 'dart:math';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStore {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  static const _dbKeyName = 'db_key_sqlcipher';
  static const _jwtKeyName = 'access_token';
  static const _refreshKeyName = 'refresh_token';

  /// Retorna la clave de SQLCipher; si no existe la crea (32 bytes aleatorios).
  static Future<String> getOrCreateDbKey() async {
    var key = await _storage.read(key: _dbKeyName);
    if (key != null && key.isNotEmpty) return key;

    final rnd = Random.secure();
    final bytes = List<int>.generate(32, (_) => rnd.nextInt(256));
    key = base64UrlEncode(bytes); // string seguro
    await _storage.write(key: _dbKeyName, value: key);
    return key;
  }

  // Opcionales para tu auth:
  static Future<void> saveJwt(String jwt) => _storage.write(key: _jwtKeyName, value: jwt);
  static Future<String?> readJwt() => _storage.read(key: _jwtKeyName);
  static Future<void> saveRefresh(String token) => _storage.write(key: _refreshKeyName, value: token);
  static Future<String?> readRefresh() => _storage.read(key: _refreshKeyName);
  static Future<void> clearAll() => _storage.deleteAll();
}
