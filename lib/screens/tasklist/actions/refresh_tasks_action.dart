import 'package:get/get.dart';
import 'package:miutem/core/repositories/tasks_repository.dart';

import '../models/task_model.dart';

Future<List<Task>> refreshTasks() async {
  final taskLists = await Get.find<TasksRepository>().getTaskLists();
  return taskLists.map((taskList)=> Task.fromMap(taskList)).toList();
}


