import 'package:flutter/material.dart';

import '../../horario/horario_screen.dart';
import '../../tasklist/task_screen.dart';

void visitarApuntes(BuildContext context) => Navigator.push(context, MaterialPageRoute(builder: (ctx) => const TaskScreen()));
void visitarHorario(BuildContext context) => Navigator.push(context, MaterialPageRoute(builder: (ctx) => const HorarioScreen()));

