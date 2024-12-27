import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';



class AddTaskScreen extends StatefulWidget {
  final List<String> categorys;
  
  const AddTaskScreen({super.key, required this.categorys});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _categoryController = TextEditingController();
  final _reminderController = TextEditingController();

  Color _color = const Color(0xFFFCF7BB);
  final DateTime _createdAt = DateTime.now();
  DateTime? _reminder;



  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _categoryController.dispose();
    _reminderController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        setState(() {
          _reminder = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          _reminderController.text = _reminder!.toIso8601String();
        });
      }
    }
  }

  /// cambiar a que lo haga el controller
  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      final Map<String, dynamic> partialTask = {
        'category': _categoryController.text,
        'title': _titleController.text,
        'content': _contentController.text,
        'color': _color.value,
        'createdAt': _createdAt.toIso8601String(),
        'reminder': _reminder?.toIso8601String(),
      };
      Navigator.of(context).pop(partialTask);
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
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Category'),
                      items: [...widget.categorys].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _categoryController.text = newValue!;
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
                    TextFormField(
                      controller: _reminderController,
                      decoration: const InputDecoration(labelText: 'Reminder'),
                      readOnly: true,
                      onTap: () => _selectDateTime(context),
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