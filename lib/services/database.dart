import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:qeydlerim/models/note.dart';

class DatabaseService {
  static DatabaseService _databaseService;
  static Database _database;

  static const COL_ID = "id";
  static const COL_TITLE = "title";
  static const COL_DESCRIPTION = "description";
  static const COL_PRIORITY = "priority";
  static const COL_DATE = "date";
  static const COL_IS_ARCHIEVED = "is_archieved";
  static const COL_IS_DELETED = "is_deleted";

  String notetable = "notes";

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
    String path = directory.path + "notes.db";

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  void _createDB(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $notetable($COL_ID INTEGER PRIMARY KEY AUTOINCREMENT, $COL_TITLE TEXT, $COL_DESCRIPTION TEXT, $COL_PRIORITY INTEGER, $COL_DATE INTEGER, $COL_IS_ARCHIEVED INTEGER, $COL_IS_DELETED INTEGER);");
  }

  Future<int> archieveNote(int id) async {
    Database db = await this.database;
    return await db.rawUpdate(
      "UPDATE $notetable SET $COL_IS_ARCHIEVED = ? WHERE $COL_ID = ?",
      [1, id],
    );
  }

  Future<int> unarchieveNote(int id) async {
    Database db = await this.database;
    return await db.rawUpdate(
        "UPDATE $notetable SET $COL_IS_ARCHIEVED = ? WHERE $COL_ID = ?",
        [0, id]);
  }

  Future<int> insert(Note note) async {
    Database db = await this.database;
    return await db.insert(notetable, note.toMap());
  }

  Future<int> update(Note note) async {
    Database db = await this.database;
    return await db.update(
      notetable,
      note.toMap(),
      where: "$COL_ID = ?",
      whereArgs: [note.id],
    );
  }

  Future<int> deleteCompletely(int id) async {
    Database db = await this.database;
    return await db.rawDelete("DELETE FROM $notetable WHERE $COL_ID = $id");
  }

  // Future<int> getCount() async {
  //   Database db = await this.database;
  //   List<Map<String, dynamic>> x =
  //       await db.rawQuery("SELECT COUNT (*) from $notetable");
  //   return Sqflite.firstIntValue(x);
  // }

  // Future<List<Map<String, dynamic>>> getNoteMapList() async {
  //   Database db = await this.database;

  //   return await db.query(notetable, orderBy: "$COL_PRIORITY ASC");
  // }

  Future<List<Note>> getNoteList() async {
    Database db = await this.database;
    List<Map<String, dynamic>> noteMapList = await db
        .rawQuery("SELECT * FROM $notetable WHERE $COL_IS_ARCHIEVED = ?", [0]);

    List<Note> notes = List<Note>();
    for (int i = 0; i < noteMapList.length; i++) {
      notes.add(Note.fromMap(noteMapList[i]));
    }
    return notes;
  }

  Future<void> moveToDeletedNotes(int id) async {
    Database db = await this.database;
    await db.rawQuery(
        "UPDATE $notetable SET $COL_IS_DELETED = ? WHERE $COL_ID = ?",
        [1, id]);
  }

  Future<List<Note>> getArchievedNotesList() async {
    Database db = await this.database;
    List<Map<String, dynamic>> noteMapList = await db
        .rawQuery("SELECT * FROM $notetable WHERE $COL_IS_ARCHIEVED = ?", [1]);

    List<Note> archievedNotes = new List<Note>();
    for (int i = 0; i < noteMapList.length; i++) {
      archievedNotes.add(Note.fromMap(noteMapList[i]));
    }
    return archievedNotes;
  }

  Future<List<Note>> getDeletedNotesList() async {
    Database db = await this.database;
    List<Map<String, dynamic>> notesMapList = await db
        .rawQuery("SELECT * FROM $notetable WHERE $COL_IS_DELETED = ?", [1]);

    List<Note> deletedNotes = new List<Note>();
    for (int i = 0; i < notesMapList.length; i++) {
      deletedNotes.add(Note.fromMap(notesMapList[i]));
    }
    return deletedNotes;
  }
}
