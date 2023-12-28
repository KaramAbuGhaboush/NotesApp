import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class NotesSqflite {
  static Future<Database> open() async {
    final dbPath = await getDatabasesPath();
    final db = await openDatabase(
      join(dbPath, 'notes.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE notes(id INTEGER PRIMARY KEY, title TEXT, subtitle TEXT)',
        );
      },
      version: 1,
    );
    return db;
  }

  static Future<void> insert(Map<String, Object?> note) async {
    final db = await open();
    await db.insert(
      'notes',
      note,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, Object?>>> getNote(int id) async {
    final db = await open();
    return db.query(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<List<Map<String, Object?>>> getNotes() async {
    final db = await open();
    return db.query('notes');
  }

  static Future<void> delete(int id) async {
    final db = await open();
    await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> update(Map<String, Object?> note) async {
    final db = await open();
    await db.update(
      'notes',
      note,
      where: 'id = ?',
      whereArgs: [note['id']],
    );
  }
}
