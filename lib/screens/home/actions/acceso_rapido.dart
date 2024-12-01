import 'package:flutter/material.dart';
import 'package:miutem/screens/horario/horario_screen.dart';
import 'package:miutem/screens/notas/notas_screen.dart';
import 'package:miutem/screens/widgets_screens.dart';

void visitarApuntes(BuildContext context) => Navigator.push(context, MaterialPageRoute(builder: (ctx) => const TaskListScreen()));

void visitarNotas(BuildContext context) => Navigator.push(context, MaterialPageRoute(builder: (ctx) => const NotasScreen()));

void visitarHorario(BuildContext context) => Navigator.push(context, MaterialPageRoute(builder: (ctx) => const HorarioScreen()));