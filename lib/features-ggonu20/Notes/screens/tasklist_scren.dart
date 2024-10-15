import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../models/tasklist.dart';
import '../services/storage_service.dart';
import './widgets/task_card.dart';
import 'actions/add_task_dialog.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen>{
  static final _logger = Logger();
  final List<TaskList> _taskLists = [];

  @override
  void initState(){
    super.initState();
    _refresh();
    _logger.i('TaskListScreen initialized');
  }

  Future<void>_refresh() async {
    final taskLists = await StorageService.getTaskLists();
    setState(() {
      if(mounted){
        _logger.i('TaskLists refreshed');
        _taskLists.clear();
      }
      _logger.i('TaskLists charges: $taskLists');
      _taskLists.addAll(taskLists.map((taskList)=> TaskList.fromMap(taskList)).toList());
    });
  }

  Future<void>_addTask() async {
    _logger.i('Adding Task');
    final result = await showDialog<TaskList>(
      context: context,
      builder: (BuildContext context){
        return const AddTaskDialog();
      },
    );
    if (result != null){
      setState(() {
        _taskLists.add(result);
      });
      await StorageService.saveTaskLists(_taskLists.map((taskList)=> taskList.toMap()).toList());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: ListView.builder(
                itemCount: _taskLists.length,
                itemBuilder: (context, index){
                  return TaskCard(
                    taskList: _taskLists[index],
                    onDelete: () {
                      setState(() {
                        _taskLists.removeAt(index);
                      });
                      StorageService.saveTaskLists(_taskLists.map((taskList)=> taskList.toMap()).toList());
                    },
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
                onPressed: _addTask,
                child: const Text('Agregar Nota')
            ),
          )
        ],
      )
    );
  }

  @override
  void dispose(){
    _logger.i('Closing TaskListScreen');
    _taskLists.clear();
    super.dispose();
  }

}