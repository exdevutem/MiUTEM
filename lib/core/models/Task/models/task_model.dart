import 'package:flutter/material.dart';
import 'package:miutem/core/models/Task/task.dart';


/// todo Agregar fecha limite para la alarma

class Task extends ChangeNotifier {
  final int? id;
  String category;
  String title;
  String content;
  Color color;
  TaskState state;
  final DateTime createdAt;
  DateTime? modifiedAt;
  DateTime? reminder;
  List<TaskFile> files;

  /// INIT TASK
  Task({
    required this.id,
    required this.category,
    required this.title,
    required this.content,
    required this.color,
    required this.state,
    required this.createdAt,
    this.modifiedAt,
    this.reminder,
    this.files = const [],
  });


  /// SERIALIZE THE NOTE INTO JSON OBJECT
  Map<String, dynamic> toJson() => {
    'id': id?.toInt(),
    'category': category,
    'title': title,
    'content': content,
    'color': color.value,
    'state': state.index,
    'createdAt': createdAt.toIso8601String(),
    'modifiedAt': modifiedAt?.toIso8601String(),
    'reminder': reminder?.toIso8601String(),
    'files': files.map((e) => e.toJson()).toList(),
  };

  /// TO MAP
  factory Task.fromMap(Map<String, dynamic> map) => Task(
    id: map['id'],
    category: map['category'],
    title: map['title'],
    content: map['content'],
    color: Color(map['color']),
    state: TaskState.values[map['state']],
    createdAt: DateTime.parse(map['createdAt']),
    modifiedAt: map['modifiedAt'] != null ? DateTime.parse(map['modifiedAt']) : null,
    reminder: map['reminder'] != null ? DateTime.parse(map['reminder']) : null,
    files: map['files'] != null ? List<TaskFile>.from(map['files'].map((x) => TaskFile.fromJson(x))) : [],
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'title': title,
      'content': content,
      'color': color.value,
      'state': state.index,
      'createdAt': createdAt.toIso8601String(),
      'modifiedAt': modifiedAt?.toIso8601String(),
      'reminder': reminder?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Task(id: $id, category: $category, title: $title, content: $content, color: $color, state: $state, createdAt: $createdAt, modifiedAt: $modifiedAt, reminder: $reminder, files: $files)';
  }

}

