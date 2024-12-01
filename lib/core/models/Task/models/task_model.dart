import 'package:flutter/material.dart';
import 'package:miutem/core/models/Task/enums/task_state.dart';

/// todo Agregar fecha limite para la alarma

class Task extends ChangeNotifier {
  final int? id;
  String title;
  String content;
  Color color;
  TaskState state;
  final DateTime createdAt;
  DateTime modifiedAt;

  ///
  /// INIT TASK
  Task({
    required this.id,
    required this.title,
    required this.content,
    required this.color,
    required this.state,
    required DateTime createdAt,
    required DateTime modifiedAt,
  }) : this.createdAt = createdAt ?? DateTime.now(),
       this.modifiedAt = modifiedAt ?? DateTime.now();


  /// SERIALIZE THE NOTE INTO JSON OBJECT
  Map<String, dynamic> toJson() => {
    'id': id?.toInt(),
    'title': title,
    'content': content,
    'color': color.value,
    'state': state.index,
    'createdAt': createdAt.toIso8601String(),
    'modifiedAt': modifiedAt.toIso8601String(),
  };

  /// TO MAP
  factory Task.fromMap(Map<String, dynamic> map) => Task(
    id: map['id'],
    title: map['title'],
    content: map['content'],
    color: Color(map['color']),
    state: TaskState.values[map['state']],
    createdAt: DateTime.parse(map['createdAt']),
    modifiedAt: DateTime.parse(map['modifiedAt']),
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'color': color.value,
      'state': state.index,
      'createdAt': createdAt.toIso8601String(),
      'modifiedAt': modifiedAt.toIso8601String(),
    };
  }

}

