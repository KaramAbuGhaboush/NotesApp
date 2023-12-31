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
          '''
      CREATE TABLE notes(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      content TEXT,
      date TEXT)
      ''',
        );
      },
      version: 1,
    );
    return db;
  }

  static Future<void> insert(String title, String content, String date) async {
    final db = await open();
    await db.insert(
      'notes',
      {
        'title': title,
        'content': content,
        'date': date,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, Object?>>> getNotes() async {
    final db = await open();
    return db.query('notes');
  }

  static Future<List<Map<String, Object?>>> getNote(int id) async {
    final db = await open();
    return db.query('notes', where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> update(
      int id, String title, String content, String date) async {
    final db = await open();
    await db.update(
      'notes',
      {
        'title': title,
        'content': content,
        'date': date,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> delete(int id) async {
    final db = await open();
    await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> deleteAll() async {
    final db = await open();
    await db.delete('notes');
  }
}
