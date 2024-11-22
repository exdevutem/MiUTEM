import 'package:flutter/material.dart';
import 'package:miutem/screens/tasklist/models/task_model.dart';
import 'package:miutem/screens/tasklist/widgets/edit_task_screen.dart';

class ViewTaskDialog extends StatelessWidget {
  final Task task;

  const ViewTaskDialog({required this.task, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final updatedTask = await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => EditTaskScreen(task: task),
          ),
        );
        if (updatedTask != null) {
          // Handle the updated task (e.g., save it to the repository)
        }
      },
      child: AlertDialog(
        backgroundColor: task.color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        title: Text(task.title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Content: ${task.content}'),
              const SizedBox(height: 10),
              Text('State: ${task.state.toString().split('.').last}'),
              const SizedBox(height: 10),
              Text('Created At: ${task.createdAt}'),
              const SizedBox(height: 10),
              Text('Modified At: ${task.modifiedAt}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}