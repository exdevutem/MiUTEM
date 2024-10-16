import 'package:flutter/material.dart';
import 'package:miutem/screens/tasklist/task_list_screen.dart';

void visitarApuntes(BuildContext context) => Navigator.push(context, MaterialPageRoute(builder: (ctx) => const TaskListScreen()));