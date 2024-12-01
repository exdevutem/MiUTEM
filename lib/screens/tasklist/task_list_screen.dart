

import 'package:flutter/material.dart';
import 'package:miutem/core/models/Task/task.dart';
import 'package:miutem/screens/tasklist/actions/actions.dart';
import 'package:miutem/screens/tasklist/components/components.dart';
import 'package:miutem/widgets/navigation/top_navigation.dart';
import 'package:skeletonizer/skeletonizer.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {

  bool loading = false;
  List<Task> _taskLists = [];

  @override
  void initState(){
    _taskLists.clear();
    refreshTasks().then((tasks) => setState(() => _taskLists = tasks));
    super.initState();
  }

  Future<void> _refresh() async {
    setState(() => loading = true);
    final tasks = await refreshTasks();
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _taskLists = tasks;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: const TopNavigation(
      title: 'Apuntes',
      isMainScreen: true,
      actions: [],
    ),
    body: SafeArea(child: Column(
      children: [
        const MessageCard(),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _refresh,
            child: Skeletonizer(
              enabled: loading,
              child: ListView.builder(
                itemCount: _taskLists.length,
                itemBuilder: (context, index) => TaskCard(
                  task: _taskLists[index],
                  onDelete: () async {
                    // await Get.find<TasksRepository>().saveTaskLists(_taskLists.where((taskList)=> taskList.id != _taskLists[index].id).map((it) => it.toJson()).toList());
                    // await DatabaseHelper().deleteTask(_taskLists[index].id!);
                    _refresh();
                  },
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () => addTask(context, _refresh),
            child: const Text('Agregar Nota'),
          ),
        )
      ],
    )),
  );
}
