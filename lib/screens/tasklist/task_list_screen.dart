import 'package:flutter/material.dart';
import 'package:miutem/core/models/Task/models/task_model.dart';
import 'package:miutem/core/services/controllers/local_notifications_controller.dart';
import 'package:miutem/core/services/controllers/task_controller.dart';
import 'package:miutem/screens/tasklist/actions/refresh_tasks_action.dart';
import 'package:miutem/styles/styles.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../core/utils/utils.dart';
import 'actions/update_task_action.dart';
import 'components/components.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TaskController _taskController = TaskController();

  bool loading = false;
  List<Task> _taskLists = [];
  List<String> categorys = [];

  @override
  void initState(){
    _taskLists.clear();
    refreshTasks().then((tasks) => setState(() => _taskLists = tasks));
    _fetchCategorys();
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


  Future<void> _fetchCategorys() async {
    try {
      final categorys = await _taskController.asignaturasCategory();
      setState(() {
        logger.i('Categorias: $categorys');
        this.categorys = categorys;
      });
    } catch (e) {
      logger.e('Error al obtener categorias para Tasks', error: e);
    }
  }




  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: const TopNavigation(
      title: 'Apuntes',
      isMainScreen: true,
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
                  onTap: () => updateTask(context, _taskLists[index], _refresh),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () => NotificationController.createNotification(),
            //onPressed: () => addTask(context, categorys, _refresh),
            child: const Text('Agregar Nota'),
          ),
        )
      ],
    )),
  );
}
