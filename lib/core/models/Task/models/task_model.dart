import 'package:flutter/material.dart';
import 'package:miutem/core/models/Task/enums/task_state.dart';

/// todo Agregar fecha limite para la alarma

class Task extends ChangeNotifier {
  final int? id;
  String category;
  String title;
  String content;
  Color color;
  TaskState state;
  final DateTime createdAt;
  DateTime modifiedAt;
  DateTime? reminder;

  ///
  /// INIT TASK
  Task({
    required this.id,
    required this.category,
    required this.title,
    required this.content,
    required this.color,
    required this.state,
    required DateTime createdAt,
    required DateTime modifiedAt,
    this.reminder,
  }) : this.createdAt = createdAt ?? DateTime.now(),
       this.modifiedAt = modifiedAt ?? DateTime.now();


  /// SERIALIZE THE NOTE INTO JSON OBJECT
  Map<String, dynamic> toJson() => {
    'id': id?.toInt(),
    'category': category,
    'title': title,
    'content': content,
    'color': color.value,
    'state': state.index,
    'createdAt': createdAt.toIso8601String(),
    'modifiedAt': modifiedAt.toIso8601String(),
    'reminder': reminder?.toIso8601String(),
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
    modifiedAt: DateTime.parse(map['modifiedAt']),
    reminder: map['reminder'] != null ? DateTime.parse(map['reminder']) : null,
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
      'modifiedAt': modifiedAt.toIso8601String(),
      'reminder': reminder?.toIso8601String(),
    };
  }

}

