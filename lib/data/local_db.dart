import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:path/path.dart' as p;
import '../services/secure.dart';

class LocalDb {
  static Database? _db;
  static Future<Database>? _opening;
  static String? _openedPath;
  static String? get openedPath => _openedPath;

  static const _dbName = 'baston.db';
  static const _version = 2;

  static Future<Database> instance() async {
    if (_db != null) return _db!;
    if (_opening != null) return _opening!;

    _opening = _openInternal();
    try {
      _db = await _opening!;
      return _db!;
    } finally {
      _opening = null;
    }
  }

  static Future<Database> _openInternal() async {
    final base = await getDatabasesPath();
    final path = p.join(base, _dbName);
    final dbKey = await SecureStore.getOrCreateDbKey();

    final db = await openDatabase(
      path,
      password: dbKey,
      version: _version,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON;');
      },
      onCreate: (db, v) async => _createSchema(db),
      onUpgrade: (db, oldV, newV) async => _migrate(db, oldV, newV),
    );

    _openedPath = path;
    return db;
  }

  static Future<void> _createSchema(Database db) async {
    await db.execute('CREATE TABLE kv_meta (k TEXT PRIMARY KEY, v TEXT)');

    await db.execute('''
      CREATE TABLE usuario_local(
        id TEXT PRIMARY KEY,
        email TEXT NOT NULL UNIQUE,
        nombres TEXT, apellidos TEXT,
        roles TEXT NOT NULL,
        token TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE dispositivo_local(
        id TEXT PRIMARY KEY,
        persona_usuario_id TEXT NOT NULL,
        bt_address TEXT NOT NULL,
        modelo TEXT, firmware TEXT,
        FOREIGN KEY(persona_usuario_id) REFERENCES usuario_local(id) ON DELETE CASCADE
      )
    ''');
    await db.execute('CREATE INDEX idx_disp_persona ON dispositivo_local(persona_usuario_id)');
    await db.execute('CREATE UNIQUE INDEX u_disp_owner_mac ON dispositivo_local(persona_usuario_id, bt_address)');

    await db.execute('''
      CREATE TABLE posicion_local(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        dispositivo_id TEXT NOT NULL,
        ts TEXT NOT NULL,
        lat REAL NOT NULL, lon REAL NOT NULL,
        precision_m REAL, alt_m REAL,
        fuente TEXT NOT NULL,
        sync_estado TEXT NOT NULL DEFAULT 'PENDIENTE',
        FOREIGN KEY(dispositivo_id) REFERENCES dispositivo_local(id) ON DELETE CASCADE,
        UNIQUE(dispositivo_id, ts)
      )
    ''');
    await db.execute('CREATE INDEX idx_pos_sync_ts ON posicion_local(sync_estado, ts)');

    await db.execute('''
      CREATE TABLE evento_alerta_local(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        dispositivo_id TEXT NOT NULL,
        ts TEXT NOT NULL,
        tipo TEXT NOT NULL,
        detalle TEXT,
        sync_estado TEXT NOT NULL DEFAULT 'PENDIENTE',
        FOREIGN KEY(dispositivo_id) REFERENCES dispositivo_local(id) ON DELETE CASCADE
      )
    ''');
    await db.execute('CREATE INDEX idx_evt_sync_ts ON evento_alerta_local(sync_estado, ts)');

    await db.execute('''
      CREATE TRIGGER tr_clean_old_positions
      AFTER INSERT ON posicion_local
      BEGIN
        DELETE FROM posicion_local 
        WHERE ts < datetime('now','-90 days') AND sync_estado <> 'PENDIENTE';
      END;
    ''');
  }

  static Future<void> _migrate(Database db, int oldV, int newV) async {
    if (oldV < 2) {
      await db.execute('ALTER TABLE usuario_local ADD COLUMN token TEXT');
    }
  }

  // -----------------------
  // 🔹 Helpers para kv_meta
  // -----------------------
  static Future<void> setKv(String key, String value) async {
    final db = await instance();
    await db.insert("kv_meta", {"k": key, "v": value},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<String?> getKv(String key) async {
    final db = await instance();
    final res = await db.query("kv_meta", where: "k = ?", whereArgs: [key]);
    return res.isNotEmpty ? res.first["v"] as String : null;
  }

  static Future<void> deleteKv(String key) async {
    final db = await instance();
    await db.delete("kv_meta", where: "k = ?", whereArgs: [key]);
  }

  // --------- DAO usuario_local ---------
  static Future<void> upsertUsuarioLocal({
    required String id,
    required String email,
    String? nombres,
    String? apellidos,
    required String rolesJson,
    required String token,
  }) async {
    final db = await instance();
    await db.insert('usuario_local', {
      'id': id,
      'email': email,
      'nombres': nombres,
      'apellidos': apellidos,
      'roles': rolesJson,
      'token': token,
    }, conflictAlgorithm: ConflictAlgorithm.replace);

    // Actualizamos el usuario actual
    await setKv("usuario_actual", id);
  }

  static Future<Map<String, dynamic>?> getUsuarioActual() async {
    final db = await instance();
    final res = await db.query("kv_meta", where: "k = ?", whereArgs: ["usuario_actual"]);
    if (res.isEmpty) return null;

    final userId = res.first["v"] as String;
    final usuario = await db.query("usuario_local", where: "id = ?", whereArgs: [userId], limit: 1);
    return usuario.isNotEmpty ? usuario.first : null;
  }

  static Future<void> logout() async {
    await deleteKv("usuario_actual");
    await deleteKv("jwt_token");
  }
}
