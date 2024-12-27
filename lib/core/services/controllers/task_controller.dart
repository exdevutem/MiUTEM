import 'package:flutter/material.dart';
import 'package:miutem/core/models/Task/task.dart';
import 'package:miutem/core/services/asignaturas_service.dart';
import 'package:miutem/core/services/controllers/local_notifications_controller.dart';
import 'package:miutem/core/utils/constants.dart';
import 'package:miutem/screens/tasklist/db_helper/db_task.dart';

class TaskController {
  final AsignaturasService _asignaturaService = AsignaturasService();

  /// Obtiene las asignaturas inscritas y las categorias de las tareas en apuntes guardados
  Future<Set<String>> asignaturasCategory() async {
    Set<String> asignaturasNames = <String>{};
    try {
      final asignaturas = await _asignaturaService.getAsignaturas();
      asignaturasNames = asignaturas.map((asignatura) => asignatura.nombre).toSet();
      final categorys = await DatabaseHelper().getCategorys();

      List<Future<void>> futures = categorys.map((category) async {
        asignaturasNames.add(category);
      }).toList();

      await Future.wait(futures);
    } catch (e) {
      logger.e('Error al obtener categorias para Tasks', error: e);
      return <String>{};
    }
    return asignaturasNames;
  }

  /// Agrega un apunte a la base de datos

  Future<void> addTask(Map<String, dynamic> task) async {
    logger.i('Agregando tarea: $task');
    if (!isValidTask(task)) {
      logger.e('Tarea invalida');
      return;
    }

    final newTask = Task(
      id: null,
      category: task['category'],
      title: task['title'],
      content: task['content'],
      color: Color(task['color']),
      state: TaskState.APUNTE,
      createdAt: DateTime.parse(task['createdAt']),
      modifiedAt: null,
      reminder: task['reminder'] != null ? DateTime.parse(task['reminder']) : null,
    );

    await createReminder(newTask);
    await DatabaseHelper().insertTask(newTask);
  }

  /// Crea Recordatorio

  Future<void> createReminder(Task task) async {
    if (task.reminder != null && task.reminder!.isAfter(DateTime.now())) {
      logger.i('Recordatorio valido con fecha ${task.reminder}');
      task.state = TaskState.RECORDATORIO;
      NotificationController.scheduleReminderTask(task);
    } else {
      logger.i('No hay recordatorio');
    }
  }

  /// Verifica un apunte
  /// En verdad no verifique nada mucho
  static bool isValidTask(Map<String, dynamic> task) {
    if (task['category'] == null) return false;
    if (task['title'] == null) return false;
    if (task['content'] == null) return false;
    if (task['color'] == null || !(task['color'] is int)) return false;
    if (task['createdAt'] == null) return false;

    return true;
  }
}

