
import 'package:flutter/material.dart';
import 'package:miutem/core/models/tasklist.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../task_list_screen.dart';

class TaskCard extends StatelessWidget {
  final TaskList taskList;
  final VoidCallback onDelete;

  const TaskCard({
    required this.taskList,
    required this.onDelete,
    Key? key,
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: taskList.getCategoryColor(),
      margin: const EdgeInsets.all(8),
      child: ListTile(
        title: Text(taskList.task),
        subtitle: Text(taskList.notes),
        trailing: Skeleton.keep(child: IconButton(
          icon: const Icon(Icons.delete_forever_outlined),
          onPressed: onDelete,
        )),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const TaskListScreen())),
      ),
    );
  }
}