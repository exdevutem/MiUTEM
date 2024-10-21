import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart'; // Add this line to use UUID

import '../../../../core/models/tasklist.dart';

class AddTaskDialog extends StatefulWidget {
  const AddTaskDialog({super.key});

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _formKey = GlobalKey<FormState>();
  final _taskController = TextEditingController();
  final _notesController = TextEditingController();
  final _uuid = const Uuid();

  String _status = 'In Progress';
  String _type = 'Personal';
  DateTime _selectedDate = DateTime.now();
  bool _isImportant = false;
  bool _isUrgent = false;
  int _priority = 0;

  @override
  void dispose() {
    _taskController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      final newTask = TaskList(
        id: _uuid.v4(),
        status: _status == 'In Progress' ? 0 : 1,
        type: _type.toLowerCase(),
        task: _taskController.text,
        notes: _notesController.text,
        deadline: _selectedDate,
        important: _isImportant ? 1 : 0,
        urgent: _isUrgent ? 1 : 0,
        priority: _priority,
      );
      Navigator.of(context).pop(newTask);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Task'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: _status,
                decoration: const InputDecoration(labelText: 'Status'),
                items: ['In Progress', 'Done'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _status = newValue!;
                  });
                },
              ),
              DropdownButtonFormField<String>(
                value: _type,
                decoration: const InputDecoration(labelText: 'Type'),
                items: ['Personal', 'Work', 'Leisure', 'Others'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _type = newValue!;
                  });
                },
              ),
              TextFormField(
                controller: _taskController,
                decoration: const InputDecoration(labelText: 'Task'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a task';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(labelText: 'Notes'),
              ),
              DropdownButtonFormField<int>(
                value: _priority,
                decoration: const InputDecoration(labelText: 'Priority'),
                items: const [
                  DropdownMenuItem<int>(value: 0, child: Text('Low')),
                  DropdownMenuItem<int>(value: 1, child: Text('Medium')),
                  DropdownMenuItem<int>(value: 2, child: Text('High')),
                ],
                onChanged: (newValue) {
                  setState(() {
                    _priority = newValue!;
                  });
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Text('Deadline: ${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}'),                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ],
              ),
              CheckboxListTile(
                title: const Text('Important'),
                value: _isImportant,
                onChanged: (bool? value) {
                  setState(() {
                    _isImportant = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('Urgent'),
                value: _isUrgent,
                onChanged: (bool? value) {
                  setState(() {
                    _isUrgent = value!;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveTask,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
