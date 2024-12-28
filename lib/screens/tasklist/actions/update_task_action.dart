
import 'package:flutter/material.dart';
import 'package:miutem/core/models/Task/task.dart';
import 'package:miutem/screens/tasklist/components/screens/edit_task_screen.dart';
import 'package:miutem/screens/tasklist/db_helper/db_task.dart';

Future<void> updateTask(BuildContext context, Task task, Function() onFinish) async {
  final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => EditTaskScreen(task: task)));

  if(result is Task) {
    await DatabaseHelper().updateTask(result);
    onFinish();
  } else if (result == true) {
    await DatabaseHelper().deleteTask(task.id!);
    onFinish();
  }

  return;
}