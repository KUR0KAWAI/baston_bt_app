import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:path/path.dart' as p;
import '../services/secure.dart';

class LocalDb {
  static Database? _db;
  static const _dbName = 'baston.db';
  static const _version = 1;

  /// Llama esto en main() antes de runApp.
  static Future<Database> instance() async {
    if (_db != null) return _db!;

    final base = await getDatabasesPath();              // ruta válida Android/iOS
    final path = p.join(base, _dbName);
    final dbKey = await SecureStore.getOrCreateDbKey(); // clave segura

    _db = await openDatabase(
      path,
      password: dbKey,          // <<— CIFRADO ACTIVADO
      version: _version,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON;');
        await db.execute('PRAGMA journal_mode = WAL;');
        await db.execute('PRAGMA synchronous = NORMAL;');
        await db.execute('PRAGMA cipher_memory_security = ON;');
      },
      onCreate: (db, v) async => _createSchema(db),     // si NO existe, la crea aquí
      onUpgrade: (db, oldV, newV) async => _migrate(db, oldV, newV),
    );
    return _db!;
  }

  static Future<void> _createSchema(Database db) async {
    // Metadatos
    await db.execute('CREATE TABLE kv_meta (k TEXT PRIMARY KEY, v TEXT)');

    // Usuario local (sin password)
    await db.execute('''
      CREATE TABLE usuario_local(
        id TEXT PRIMARY KEY,
        email TEXT NOT NULL UNIQUE,
        nombres TEXT, apellidos TEXT,
        roles TEXT NOT NULL
      )
    ''');

    // Dispositivo (bastón)
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

    // Posiciones (cola offline)
    await db.execute('''
      CREATE TABLE posicion_local(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        dispositivo_id TEXT NOT NULL,
        ts TEXT NOT NULL,
        lat REAL NOT NULL, lon REAL NOT NULL,
        precision_m REAL, alt_m REAL,
        fuente TEXT NOT NULL,              -- 'GNSS'|'FUSED'|'WIFI'
        sync_estado TEXT NOT NULL DEFAULT 'PENDIENTE',
        FOREIGN KEY(dispositivo_id) REFERENCES dispositivo_local(id) ON DELETE CASCADE,
        UNIQUE(dispositivo_id, ts)
      )
    ''');
    await db.execute('CREATE INDEX idx_pos_sync_ts ON posicion_local(sync_estado, ts)');

    // Eventos (SOS/CAIDA/BATERIA_BAJA)
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

    // Retención simple (90 días ya enviados)
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
    // if (oldV < 2) await db.execute('ALTER TABLE ...');
  }

  // --------- DEMO / DAO BÁSICO ---------
  static Future<void> upsertUsuarioLocal({
    required String id,
    required String email,
    String? nombres,
    String? apellidos,
    required String rolesJson,
  }) async {
    final db = await instance();
    await db.insert('usuario_local', {
      'id': id, 'email': email,
      'nombres': nombres, 'apellidos': apellidos,
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
      'lat': lat, 'lon': lon,
      'precision_m': precisionM, 'alt_m': altM,
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
