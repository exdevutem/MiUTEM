import 'package:miutem/core/models/Task/task.dart';
import 'package:miutem/screens/tasklist/db_helper/db_task.dart';


Future<List<Task>> refreshTasks() async {
  final taskLists = await DatabaseHelper().getNoteMapList();
  return taskLists.map((taskList)=> Task.fromMap(taskList)).toList();

}


