import 'package:sqflite/sqflite.dart' as sqlite;
import 'package:path/path.dart' as path;


class DBUtil {
  static const _versao = 1;

  static Future<sqlite.Database> getDB() async {
    final databasePath = await sqlite.getDatabasesPath();
    final arqBD = path.join(databasePath, "umadose.db");

    return sqlite.openDatabase(
      arqBD,
      version: _versao,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE usuarios(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT NOT NULL,
            email TEXT NOT NULL UNIQUE,
            senha TEXT NOT NULL,
            faculdade TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE bares(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT NOT NULL,
            descricao TEXT,
            lat REAL NOT NULL,
            lng REAL NOT NULL,
            preco TEXT,
            temComida INTEGER NOT NULL,
            temBebida INTEGER NOT NULL,
            temSemAlcool INTEGER NOT NULL,
            musicaAoVivo INTEGER NOT NULL,
            fechaHora TEXT,
            tags TEXT,
            movimento TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE eventos(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT NOT NULL,
            local TEXT NOT NULL,
            lat REAL NOT NULL,
            lng REAL NOT NULL,
            categoria TEXT,
            dia TEXT,
            hora TEXT,
            entrada TEXT,
            destaque INTEGER NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE salvos(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            usuarioId INTEGER NOT NULL,
            barId INTEGER NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE checkins(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            usuarioId INTEGER NOT NULL,
            barId INTEGER NOT NULL,
            quando TEXT NOT NULL
          )
        ''');
      },
    );
  }


  static Future<int> insert(String table, Map<String, dynamic> dados) async {
    final db = await getDB();
    return db.insert(table, dados,
        conflictAlgorithm: sqlite.ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> list(String table) async {
    final db = await getDB();
    return db.query(table);
  }

  static Future<List<Map<String, dynamic>>> where(
      String table, String clausula, List<Object?> args) async {
    final db = await getDB();
    return db.query(table, where: clausula, whereArgs: args);
  }

  static Future<int> delete(String table, String clausula, List<Object?> args) async {
    final db = await getDB();
    return db.delete(table, where: clausula, whereArgs: args);
  }

  static Future<int> count(String table) async {
    final db = await getDB();
    final res = await db.rawQuery('SELECT COUNT(*) AS n FROM $table');
    return (res.first['n'] as int?) ?? 0;
  }
}
