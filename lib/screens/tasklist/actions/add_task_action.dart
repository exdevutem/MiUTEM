import 'package:flutter/material.dart';
import 'package:miutem/core/models/Task/task.dart';
import 'package:miutem/screens/tasklist/components/components.dart';
import 'package:miutem/screens/tasklist/db_helper/db_task.dart';

Future<void> addTask(BuildContext context, Function() onFinish) async {
  final result = await showDialog<Task>(context: context, builder: (BuildContext context) => const AddTaskScreen());

  if(result == null) {
    return;
  }

  // Insert the new task into the database
  await DatabaseHelper().insertTask(result);

  onFinish();
}