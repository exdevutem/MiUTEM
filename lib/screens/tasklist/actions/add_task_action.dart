import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miutem/core/models/tasklist.dart';
import 'package:miutem/core/repositories/tasks_repository.dart';
import 'package:miutem/screens/tasklist/widgets/add_task_dialog.dart';

Future<void> addTask(BuildContext context, Function() onFinish) async {
  final result = await showDialog<TaskList>(context: context, builder: (BuildContext context) => const AddTaskDialog());
  if(result == null) {
    return;
  }

  final tasksRepository = Get.find<TasksRepository>();
  final tasks = await tasksRepository.getTaskLists();
  await tasksRepository.saveTaskLists([...tasks, result.toJson()]);
}