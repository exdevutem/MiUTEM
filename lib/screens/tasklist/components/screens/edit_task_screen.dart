import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:miutem/core/models/Task/task.dart';
import 'package:miutem/screens/tasklist/db_helper/db_task.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;

  const EditTaskScreen({required this.task, super.key});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late Color _color;
  late TaskState _state;
  late DateTime _createdAt;
  late DateTime _modifiedAt;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _contentController = TextEditingController(text: widget.task.content);
    _color = widget.task.color;
    _state = widget.task.state;
    _createdAt = widget.task.createdAt;
    _modifiedAt = widget.task.modifiedAt;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      final updatedTask = Task(
        id: widget.task.id,
        category: widget.task.category,
        title: _titleController.text,
        content: _contentController.text,
        color: _color,
        state: _state,
        createdAt: _createdAt,
        modifiedAt: DateTime.now(),
      );
      Navigator.of(context).pop(updatedTask);
    }
  }

  void _deleteTask() async {
    // await DatabaseHelper().deleteTask(widget.task.id!);
    Navigator.of(context).pop(true);
    // Navigator.of(context).pop(widget.task);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Task'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteTask,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(labelText: 'Title'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: TextFormField(
                        controller: _contentController,
                        decoration: const InputDecoration(
                          labelText: 'Content',
                          alignLabelWithHint: true,
                        ),
                        maxLines: 7,
                      ),
                    ),
                    DropdownButtonFormField<TaskState>(
                      value: _state,
                      decoration: const InputDecoration(labelText: 'State'),
                      items: TaskState.values.map((TaskState value) {
                        return DropdownMenuItem<TaskState>(
                          value: value,
                          child: Text(value.toString().split('.').last),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _state = newValue!;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text('Color: '),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () async {
                            final Color? pickedColor = await showDialog<Color>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Pick a color'),
                                content: SingleChildScrollView(
                                  child: BlockPicker(
                                    pickerColor: _color,
                                    onColorChanged: (color) {
                                      setState(() {
                                        _color = color;
                                      });
                                    },
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(_color),
                                    child: const Text('Select'),
                                  ),
                                ],
                              ),
                            );
                            if (pickedColor != null) {
                              setState(() {
                                _color = pickedColor;
                              });
                            }
                          },
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              color: _color,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.palette,
                              color: Colors.black,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _saveTask,
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}