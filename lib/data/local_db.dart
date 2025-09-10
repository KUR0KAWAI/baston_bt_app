import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:path/path.dart' as p;
import '../services/secure.dart';

class LocalDb {
  static Database? _db;
  static Future<Database>? _opening; // evita abrir 2 veces al mismo tiempo
  static String? _openedPath;
  static String? get openedPath => _openedPath;

  static const _dbName = 'baston.db';
  static const _version = 1;

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
        // ✅ Lo esencial: integridad referencial
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
        roles TEXT NOT NULL
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
    // Ejemplo: if (oldV < 2) await db.execute('ALTER TABLE ...');
  }

  // --------- DAO ---------
  static Future<void> upsertUsuarioLocal({
    required String id,
    required String email,
    String? nombres,
    String? apellidos,
    required String rolesJson,
  }) async {
    final db = await instance();
    await db.insert('usuario_local', {
      'id': id,
      'email': email,
      'nombres': nombres,
      'apellidos': apellidos,
      'roles': rolesJson,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> upsertDispositivo({
    required String id,
    required String personaUsuarioId,
    required String btAddress,
    String? modelo,
    String? firmware,
  }) async {
    final db = await instance();
    await db.insert('dispositivo_local', {
      'id': id,
      'persona_usuario_id': personaUsuarioId,
      'bt_address': btAddress,
      'modelo': modelo,
      'firmware': firmware,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> guardarPosicion({
    required String dispositivoId,
    required DateTime ts,
    required double lat,
    required double lon,
    double? precisionM,
    double? altM,
    String fuente = 'FUSED',
  }) async {
    final db = await instance();
    return db.insert('posicion_local', {
      'dispositivo_id': dispositivoId,
      'ts': ts.toIso8601String(),
      'lat': lat,
      'lon': lon,
      'precision_m': precisionM,
      'alt_m': altM,
      'fuente': fuente,
      'sync_estado': 'PENDIENTE',
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  static Future<List<Map<String, dynamic>>> pendientesPosicion({int limit = 200}) async {
    final db = await instance();
    return db.query(
      'posicion_local',
      where: 'sync_estado = ?',
      whereArgs: ['PENDIENTE'],
      orderBy: 'ts ASC',
      limit: limit,
    );
  }
}
