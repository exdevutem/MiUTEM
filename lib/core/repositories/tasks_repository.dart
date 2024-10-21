import 'dart:convert';

import 'package:miutem/core/utils/constants.dart';

class TasksRepository {

  /// Guarda una lista de tareas en el almacenamiento local (SharedPreferences)
  /// Las tareas se guardan en formato de lista de Map<String, dynamic>
  Future<void> saveTaskLists(List<Map<String, dynamic>> taskLists) async {
    await sharedPreferences.setStringList('taskLists', taskLists.map((taskList) => jsonEncode(taskList)).toList());
  }

  /// Obtiene una lista de tareas desde el almacenamiento local (SharedPreferences)
  /// Si no hay tareas guardadas, retorna una lista vacía
  /// Si hay tareas guardadas, las retorna en formato de lista de Map<String, dynamic>
  Future<List<Map<String, dynamic>>> getTaskLists() async {
    List<Map<String, dynamic>> taskLists = [];
    if(await sharedPreferences.containsKey('taskLists')) {
      taskLists = (await sharedPreferences.getStringList('taskLists'))?.map((taskList) => jsonDecode(taskList) as Map<String, dynamic>).toList() ?? [];
    }
    return taskLists;
  }
}
