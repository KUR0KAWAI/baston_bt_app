// lib/services/db_bootstrap.dart
import 'dart:convert';
import 'dart:developer' as dev;
import 'package:sqflite_sqlcipher/sqflite.dart';

import '../data/local_db.dart';
import '../services/secure.dart';

class DbBootstrap {
  static bool _ready = false;
  static String? _lastError;

  static Future<void> init() async {
    if (_ready) return;
    try {
      await LocalDb.instance();
      _ready = true;
      _lastError = null;
      dev.log('✅ BD inicializada', name: 'PathSense.DB');
    } catch (e, st) {
      _lastError = '$e';
      dev.log('❌ Error inicializando BD: $e', name: 'PathSense.DB', stackTrace: st);
      rethrow;
    }
  }

  static bool get isReady => _ready;
  static String? get lastError => _lastError;

  static Future<String> getDbFilePath() async {
    await init();
    final path = LocalDb.openedPath ?? '<desconocida>';
    return path;
  }

  static Future<Map<String, String>> getKeyBothFormats() async {
    final base64UrlKey = await SecureStore.getOrCreateDbKey();
    final hexKey = _base64UrlToHex(base64UrlKey);
    return {'base64url': base64UrlKey, 'hex': hexKey};
  }

  static Future<List<String>> listTables() async {
    final db = await LocalDb.instance();
    final rows = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table' ORDER BY 1;");
    return rows.map((e) => e['name']?.toString() ?? '').where((s) => s.isNotEmpty).toList();
  }

  /// 🔍 Método de debug: junta todo y lo loguea
  static Future<void> logDebugInfo() async {
    await init();
    final path = await getDbFilePath();
    final key = await getKeyBothFormats();
    final tables = await listTables();

    dev.log('📄 BD: $path', name: 'PathSense.DB');
    dev.log('🔑 Base64URL: ${key['base64url']}', name: 'PathSense.DB');
    dev.log('🔑 HEX: ${key['hex']}', name: 'PathSense.DB');
    dev.log('🗂️ Tablas: $tables', name: 'PathSense.DB');
  }

  static String _base64UrlToHex(String b64url) {
    final bytes = base64Url.decode(b64url);
    final sb = StringBuffer();
    for (final b in bytes) {
      sb.write(b.toRadixString(16).padLeft(2, '0'));
    }
    return sb.toString();
  }
}
