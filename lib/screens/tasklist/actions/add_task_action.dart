import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miutem/core/repositories/tasks_repository.dart';

import '../models/task_model.dart';
import '../widgets/add_task_screen.dart';

Future<void> addTask(BuildContext context, Function() onFinish) async {
  final result = await showDialog<Task>(context: context, builder: (BuildContext context) => const AddTaskScreen());

  if(result == null) {
    return;
  }

  final tasksRepository = Get.find<TasksRepository>();
  final tasks = await tasksRepository.getTaskLists();
  await tasksRepository.saveTaskLists([...tasks, result.toJson()]);
  onFinish();
}