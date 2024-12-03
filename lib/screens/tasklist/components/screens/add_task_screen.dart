import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:miutem/core/models/Task/task.dart';
import 'package:miutem/core/models/asignaturas/asignatura.dart';
import 'package:miutem/core/services/asignaturas_service.dart';


class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  Color _color = const Color(0xFFFCF7BB);
  TaskState _state = TaskState.unspecified;
  final DateTime _createdAt = DateTime.now();
  final DateTime _modifiedAt = DateTime.now();

  // Asignatura
  Asignatura? _selectedAsignatura;



  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      final newTask = Task(
        id: null,
        title: _titleController.text,
        content: _contentController.text,
        color: _color,
        state: _state,
        createdAt: _createdAt,
        modifiedAt: _modifiedAt,
      );
      Navigator.of(context).pop(newTask);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Añadir Task'),
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
                      decoration: const InputDecoration(labelText: 'Titulo'),
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
                            labelText: 'Contenido',
                            alignLabelWithHint: true,
                        ),
                        maxLines: 7,
                      ),
                    ),
                    DropdownButtonFormField<TaskState>(
                      value: _state,
                      decoration: const InputDecoration(labelText: 'Estado'),
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
                                title: const Text('Elige un color'),
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