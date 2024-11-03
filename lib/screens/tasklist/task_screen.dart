
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miutem/screens/tasklist/actions/refresh_tasks_action.dart';
import 'package:miutem/screens/tasklist/widgets/task_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../core/repositories/tasks_repository.dart';
import 'actions/add_task_action.dart';
import 'models/task_model.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  List<Task> _taskList = [];
  bool loading = false;

  @override
  void initState() {
    _taskList.clear();
    refreshTasks().then((tasks) => setState(() => _taskList = tasks));
    super.initState();
  }

  Future<void> _refresh() async {
    setState(() => loading = true);
    final tasks = await refreshTasks();
    // await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _taskList = tasks;
      loading = false;
    });
  }

  @override
  void dispose() {
    _taskList.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task Screen')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refresh,
                child: Skeletonizer(
                  enabled: loading,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                      ),
                      itemCount: _taskList.length,
                      itemBuilder: (context, index) => TaskCard(
                        taskList: _taskList[index],
                        onDelete: () async {
                          await Get.find<TasksRepository>().saveTaskLists(_taskList.where((taskList)=> taskList.id != _taskList[index].id).map((it) => it.toJson()).toList());
                          _refresh();
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => addTask(context, _refresh),
        child: const Icon(Icons.add),
      ),
    );
  }



}