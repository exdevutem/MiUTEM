// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:miutem/core/models/Task/task.dart';
// import 'package:miutem/core/repositories/tasks_repository.dart';
// import 'package:miutem/screens/tasklist/components/components.dart';
//
//
// Future<void> addTask(BuildContext context, Function() onFinish) async {
//   final result = await showDialog<Task>(context: context, builder: (BuildContext context) => const AddTaskScreen());
//
//   if(result == null) {
//     return;
//   }
//
//   final tasksRepository = Get.find<TasksRepository>();
//   final tasks = await tasksRepository.getTaskLists();
//   await tasksRepository.saveTaskLists([...tasks, result.toJson()]);
//   onFinish();
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miutem/core/models/Task/task.dart';
import 'package:miutem/core/repositories/tasks_repository.dart';
import 'package:miutem/screens/tasklist/components/components.dart';
import 'package:miutem/screens/tasklist/db_helper/db_task.dart';

Future<void> addTask(BuildContext context, Function() onFinish) async {
  final result = await showDialog<Task>(context: context, builder: (BuildContext context) => const AddTaskScreen());

  if(result == null) {
    return;
  }

  final tasksRepository = Get.find<TasksRepository>();
  final tasks = await tasksRepository.getTaskLists();
  await tasksRepository.saveTaskLists([...tasks, result.toJson()]);

  // Insert the new task into the database
  await DatabaseHelper().insertTask(result);

  onFinish();
}