import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static final Logger _logger = Logger();

  static Future<String> getValue(String key) async {
    String value = '';
    await SharedPreferences.getInstance().then((instance) {
      if (instance.containsKey(key)) {
        value = instance.getString(key) ?? '';
      }
    });
    return value;
  }

  /* Storage de Notes */

  static Future<void> saveNotes(List<Map<String, dynamic>> notes) async {
    await SharedPreferences.getInstance().then((instance) {
      instance.setStringList('notes', notes.map((note) => jsonEncode(note)).toList());
    });
  }

  static Future<List<Map<String, dynamic>>> getNotes() async {
    List<Map<String, dynamic>> notes = [];
    await SharedPreferences.getInstance().then((instance) {
      if (instance.containsKey('notes')) {
        notes = instance.getStringList('notes')?.map((note) => jsonDecode(note) as Map<String, dynamic>).toList() ?? [];
      }
    });
    return notes;
  }

/* End Storage de Notes */

  /* Storage de TaskLists */

  static Future<void> saveTaskLists(List<Map<String, dynamic>> taskLists) async {
    await SharedPreferences.getInstance().then((instance) {
      instance.setStringList('taskLists', taskLists.map((taskList) => jsonEncode(taskList)).toList());
    });
  }

  static Future<List<Map<String, dynamic>>> getTaskLists() async {
    List<Map<String, dynamic>> taskLists = [];
    await SharedPreferences.getInstance().then((instance) {
      if (instance.containsKey('taskLists')) {
        taskLists = instance.getStringList('taskLists')?.map((taskList) => jsonDecode(taskList) as Map<String, dynamic>).toList() ?? [];
      }
    });
    return taskLists;
  }

/* End Storage de Notes */
}
