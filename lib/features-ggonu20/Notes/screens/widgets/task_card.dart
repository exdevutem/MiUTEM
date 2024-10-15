
import 'package:flutter/material.dart';
import 'package:miutem/features-ggonu20/Notes/models/tasklist.dart';

import '../tasklist_scren.dart';

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
        trailing: IconButton(
          icon: const Icon(Icons.delete_forever_outlined),
          onPressed: onDelete,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TaskListScreen()
            )
          );
        },
      ),
    );
  }
}