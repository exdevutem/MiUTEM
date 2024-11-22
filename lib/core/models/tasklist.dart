// import 'package:flutter/material.dart';
//
// class TaskList {
//   final String id;
//   final int status; // 0 Inprogress, 1 Done
//   final String type; // personal, trabajo, oscio, otros
//   final String task; // nombre de la tarea
//   final String notes; // descripción de la tarea
//   final DateTime deadline; // fecha de término
//   final int important; // 0 para sí, 1 para no
//   final int urgent; // 0 para sí, 1 para no
//   final int priority; // High, medium, low
//
//   const TaskList({
//     required this.id,
//     required this.status,
//     required this.type,
//     required this.task,
//     required this.notes,
//     required this.deadline,
//     required this.important,
//     required this.urgent,
//     required this.priority,
//   });
//
//   Map<String, dynamic> toJson() => {
//     'id': id,
//     'status': status,
//     'type': type,
//     'task': task,
//     'notes': notes,
//     'deadline': deadline.toIso8601String(),
//     'important': important,
//     'urgent': urgent,
//     'priority': priority,
//   };
//
//   factory TaskList.fromMap(Map<String, dynamic> map) => TaskList(
//     id: map['id'],
//     status: map['status'],
//     type: map['type'],
//     task: map['task'],
//     notes: map['notes'],
//     deadline: DateTime.parse(map['deadline']),
//     important: map['important'],
//     urgent: map['urgent'],
//     priority: map['priority'],
//   );
//
//   String getCategory() {
//     if (urgent == 0 && important == 0) {
//       return 'Hacer';
//     } else if (urgent == 0 && important == 1) {
//       return 'Delegar';
//     } else if (urgent == 1 && important == 0) {
//       return 'Programar';
//     } else {
//       return 'Eliminar';
//     }
//   }
//
//   Color getCategoryColor() {
//     if (urgent == 0 && important == 0) {
//       return Colors.green;
//     } else if (urgent == 0 && important == 1) {
//       return Colors.lightBlue;
//     } else if (urgent == 1 && important == 0) {
//       return Colors.orange;
//     } else {
//       return Colors.red;
//     }
//   }
//
// }