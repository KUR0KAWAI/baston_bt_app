// lib/pages/debug_page.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
import '../services/secure.dart';

class DebugPage extends StatelessWidget {
  const DebugPage({super.key});

  // Convierte Base64URL -> HEX (para DB Browser si lo pide en HEX)
  String _base64UrlToHex(String b64url) {
    final bytes = base64Url.decode(b64url);
    final sb = StringBuffer();
    for (final b in bytes) {
      sb.write(b.toRadixString(16).padLeft(2, '0'));
    }
    return sb.toString();
    // Ejemplo de salida: "3fa4...c1"
  }

  Future<void> _showDbPath() async {
    final path = await getDatabasesPath();
    // ignore: avoid_print
    print('📂 Carpeta de bases de datos (Android/iOS): $path');
  }

  Future<void> _showKey() async {
    final keyB64 = await SecureStore.getOrCreateDbKey();
    final keyHex = _base64UrlToHex(keyB64);
    // ignore: avoid_print
    print('🔑 Clave SQLCipher (Base64URL): $keyB64');
    print('🔑 Clave SQLCipher (HEX): $keyHex'); // Útil para DB Browser
  }

  Future<void> _listTables() async {
    final dbPath = await getDatabasesPath();
    // ignore: avoid_print
    print('📂 Usa esta ruta en ADB/Device File Explorer: $dbPath');

    final db = await openDatabase(
      // No reabro; solo me aseguro de tener instancia ya abierta en LocalDb
      // Si quisieras listar con rawQuery usa la instancia:
      // final db = await LocalDb.instance();
      // y luego el query de abajo:
      // (pero aquí lo mantengo simple)
      '$dbPath/baston.db',
      // No pongas password aquí si LocalDb ya está abierto y en uso.
    );

    final tablas = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' ORDER BY 1;"
    );
    print('🗂️ Tablas: $tablas');
    await db.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Debug BD local')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            FilledButton(
              onPressed: _showDbPath,
              child: const Text('Mostrar ruta de BD en consola'),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: _showKey,
              child: const Text('Mostrar clave (Base64 y HEX)'),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: _listTables,
              child: const Text('Listar tablas en consola'),
            ),
            const SizedBox(height: 24),
            const Text(
              '⚠️ Esta página es solo para debugging.\nNo la incluyas en producción.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
