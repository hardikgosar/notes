import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../model/note_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database? _db;
  DatabaseHelper._instance();

  String noteTable = 'note_Table';
  String colId = 'id';
  String colTitle = 'title';
  String colBody = 'body';
  String colDate = 'date';

  Future<Database?> get db async {
    _db ??= await _initDb();
    return _db;
  }

  Future<Database> _initDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + 'note_list.db';
    final noteListDb =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return noteListDb;
  }

  void _createDb(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $noteTable ($colId INTEGER PRIMARY KEY AUTOINCREMENT,$colTitle TEXT ,$colBody TEXT ,$colDate TEXT)');
  }

  // get Notes
  Future<List<Map<String, dynamic>>> getNotesMapList() async {
    Database? db = await this.db;
    final List<Map<String, dynamic>> result =
        await db!.query(noteTable, orderBy: '$colDate DESC');
    return result;
  }

  Future<List<Note>> getNoteList() async {
    final List<Map<String, dynamic>> noteMapList = await getNotesMapList();

    final List<Note> notelist = [];

    for (var element in noteMapList) {
      notelist.add(Note.fromMap(element));
    }

    return notelist;
  }

  Future<int> insertNote(Note note) async {
    Database? db = await this.db;
    final int result = await db!.insert(noteTable, note.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return result;
  }

  Future<int> updateNote(Note note) async {
    Database? db = await this.db;
    final int result = await db!.update(noteTable, note.toMap(),
        where: '$colId = ?', whereArgs: [note.id]);
    return result;
  }

  Future<int> deleteNote(Note note) async {
    Database? db = await this.db;
    final int result =
        await db!.delete(noteTable, where: '$colId = ?', whereArgs: [note.id]);
    return result;
  }
}
