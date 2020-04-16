import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:qeydlerim/models/note.dart';

class DatabaseService {
  static DatabaseService _databaseService;
  static Database _database;

  String table = "qeydler";
  String id = "id";
  String title = "title";
  String description = "description";
  String priority = "priority";
  String color = "color";
  String date = "date";

  DatabaseService._createInstance();

  factory DatabaseService() {
    if (_databaseService == null)
      _databaseService = DatabaseService._createInstance();
    return _databaseService;
  }

  Future<Database> get database async {
    if (_database == null) _database = await initializeDatabase();
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + "qeydler.db";

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  void _createDB(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $table($id INTEGER PRIMARY KEY AUTOINCREMENT, $title TEXT, $description TEXT, $priority INTEGER, $color INTEGER, $date TEXT)");
  }

  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await this.database;

    return await db.query(table, orderBy: "$priority ASC");
  }

  Future<int> insert(Note note) async {
    Database db = await this.database;
    return await db.insert(table, note.toMap());
  }

  Future<int> update(Note note) async {
    Database db = await this.database;
    return await db
        .update(table, note.toMap(), where: "$id = ?", whereArgs: [note.id]);
  }

  Future<int> delete(int id) async {
    Database db = await this.database;

    return await db.rawDelete("DELETE FROM $table WHERE $id = $id");
  }

  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery("SELECT COUNT (*) from $table");
    return Sqflite.firstIntValue(x);
  }

  Future<List<Note>> getNoteList() async {
    List<Map<String, dynamic>> noteMapList = await getNoteMapList();

    List<Note> notes = List<Note>();
    for (int i = 0; i < noteMapList.length; i++) {
      notes.add(Note.fromMap(noteMapList[i]));
    }
  }
}
