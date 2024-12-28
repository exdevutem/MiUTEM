import 'package:flutter/material.dart';
import 'package:miutem/core/services/controllers/Task/task_controller.dart';
import 'package:miutem/screens/tasklist/components/components.dart';

Future<void> addTask(BuildContext context, List<String> categorys, Function() onFinish) async {
  final result = await showDialog<Map<String,dynamic>>(context: context, builder: (BuildContext context) =>  AddTaskScreen(categorys: categorys));

  if(result == null) {
    return;
  }

  // Insert the new task into the database
  await TaskController().addTask(result);
  
  onFinish();
}