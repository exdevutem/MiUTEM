
import 'package:flutter/material.dart';
import 'package:miutem/screens/tasklist/widgets/view_task_dialog.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../models/task_model.dart';
import '../task_screen.dart';

class TaskCard extends StatelessWidget {
  final Task taskList;
  final VoidCallback onDelete;

  const TaskCard({
    required this.taskList,
    required this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: taskList.color,
      margin: const EdgeInsets.all(8),
      child: ListTile(
        title: Text(taskList.title),
        subtitle: Text(taskList.content),
        trailing: Skeleton.keep(child: IconButton(
          icon: const Icon(Icons.delete_forever_outlined),
          onPressed: onDelete,
        )),
        onTap: () => showDialog(
          context: context,
          builder: (context) => ViewTaskDialog(task: taskList),
        )
      ),
    );
  }
}