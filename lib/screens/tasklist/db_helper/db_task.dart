
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
  String colCategory = 'category';
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
            '$colCategory TEXT, '
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

  // Update Operation: Update a Note object and save it to database
  Future<int> updateTask(Task task) async {
    var db = await database;
    var result = await db.update(noteTable, task.toMap(), where: '$colId = ?', whereArgs: [task.id]);
    return result;
  }

  // Delete Operation: Delete a Note object from database
  Future<int> deleteTask(int id) async {
    var db = await database;
    int result = await db.rawDelete('DELETE FROM $noteTable WHERE $colId = $id');
    return result;
  }
  
  Future<List<String>> getCategorys() async {
    Database db = await database;
    List<String> categorys = [];
    var result = await db.query(noteTable, columns: [colCategory]);
    if(result.isEmpty) return categorys;
    categorys = result.map((category) => category[colCategory] as String).toSet().toList();
    return categorys;
  }

}
