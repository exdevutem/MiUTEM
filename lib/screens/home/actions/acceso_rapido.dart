import 'package:flutter/material.dart';
import 'package:miutem/screens/notas/notas_screen.dart';
import 'package:miutem/screens/tasklist/task_list_screen.dart';

void visitarApuntes(BuildContext context) => Navigator.push(context, MaterialPageRoute(builder: (ctx) => const TaskListScreen()));

void visitarNotas(BuildContext context) => Navigator.push(context, MaterialPageRoute(builder: (ctx) => const NotasScreen()));