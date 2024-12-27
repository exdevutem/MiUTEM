import 'package:miutem/core/models/Task/task.dart';
import 'package:miutem/core/services/asignaturas_service.dart';
import 'package:miutem/core/utils/constants.dart';
import 'package:miutem/screens/tasklist/db_helper/db_task.dart';

class TaskController {
  final AsignaturasService _asignaturaService = AsignaturasService();

  /// Obtiene las asignaturas inscritas y las categorias de las tareas en apuntes guardados
  Future<List<String>> asignaturasCategory() async {
    List<String> asignaturasNames = [];
    try {
      final asignaturas = await _asignaturaService.getAsignaturas();
      asignaturasNames =
          asignaturas.map((asignatura) => asignatura.nombre).toList();
      final categorys = await DatabaseHelper().getCategorys();

      List<Future<void>> futures = categorys.map((category) async {
        asignaturasNames.add(category);
      }).toList();

      await Future.wait(futures);
    } catch (e) {
      logger.e('Error al obtener categorias para Tasks', error: e);
      return [];
    }
    return asignaturasNames;
  }

  /// Agrega un apunte a la base de datos
  Future<void> addTask(Task task) async {
    logger.i('Agregando tarea: $task');
    createReminder(task);
    await DatabaseHelper().insertTask(task);
  }
  
  /// Crea Recordatorio 
  Future<void> createReminder(Task task)  async {
    logger.i('Creando recordatorio: $task');
    if  (task.reminder != null) {
      logger.i('Existe Recordatorio: ${task.reminder}');
    }
    else {
      logger.i('No existe Recordatorio');
    }
  }
}
