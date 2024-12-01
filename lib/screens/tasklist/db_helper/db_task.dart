
import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:miutem/core/models/Task/task.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';


class DatabaseHelper {
  static Database? _database;

  static const String _databaseName = 'tasks.db';
  static const String noteTable = 'task_table';

  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'content';
  String colColor = 'color';
  String colState = 'state';
  String colCreatedAt = 'createdAt';
  String colModifiedAt = 'modifiedAt';

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + _databaseName;

    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $noteTable'
            '($colId INTEGER PRIMARY KEY AUTOINCREMENT, '
            '$colTitle TEXT, '
            '$colDescription TEXT, '
            '$colColor INTEGER, '
            '$colState INTEGER,'
            '$colCreatedAt TEXT, '
            '$colModifiedAt TEXT)'
    );
  }


  // Fetch Operation: Get all note objects from database
  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await database;

    var result = await db.query(noteTable, orderBy: '$colCreatedAt ASC');
    return result;
  }

  // Insert Operation: Insert a Note object to database
  Future<int> insertTask(Task task) async {
    Database db = await database;
    var result = await db.insert(noteTable, task.toMap());
    return result;
  }


}
