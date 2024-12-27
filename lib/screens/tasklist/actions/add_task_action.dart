import 'package:flutter/material.dart';
import 'package:miutem/core/models/Task/task.dart';
import 'package:miutem/core/services/controllers/task_controller.dart';
import 'package:miutem/screens/tasklist/components/components.dart';
import 'package:miutem/screens/tasklist/db_helper/db_task.dart';

Future<void> addTask(BuildContext context, List<String> categorys, Function() onFinish) async {
  final result = await showDialog<Task>(context: context, builder: (BuildContext context) =>  AddTaskScreen(categorys: categorys));

  if(result == null) {
    return;
  }

  // Insert the new task into the database
  await TaskController().addTask(result);
  
  onFinish();
}