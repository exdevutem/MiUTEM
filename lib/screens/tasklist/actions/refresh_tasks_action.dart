import 'package:get/get.dart';
import 'package:miutem/core/models/tasklist.dart';
import 'package:miutem/core/repositories/tasks_repository.dart';

Future<List<TaskList>> refreshTasks() async {
  final taskLists = await Get.find<TasksRepository>().getTaskLists();
  return taskLists.map((taskList)=> TaskList.fromMap(taskList)).toList();
}
