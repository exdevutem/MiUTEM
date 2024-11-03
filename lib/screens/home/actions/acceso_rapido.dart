import 'package:flutter/material.dart';

import '../../tasklist/task_screen.dart';

void visitarApuntes(BuildContext context) => Navigator.push(context, MaterialPageRoute(builder: (ctx) => const TaskScreen()));