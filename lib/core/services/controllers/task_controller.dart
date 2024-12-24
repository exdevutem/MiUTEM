import 'package:miutem/core/services/asignaturas_service.dart';
import 'package:miutem/core/utils/constants.dart';
import 'package:miutem/screens/tasklist/db_helper/db_task.dart';

class TaskController {
  final AsignaturasService _asignaturaService = AsignaturasService();

  Future<List<String>> asignaturasCategory() async {
    List<String> asignaturasNames = [];
    try {
      final asignaturas = await _asignaturaService.getAsignaturas();
      asignaturasNames = asignaturas.map((asignatura) => asignatura.nombre).toList();
      final categorys = await DatabaseHelper().getCategorys();

      List<Future<void>> futures = categorys.map((category) async {
        asignaturasNames.add(category);
      }).toList();

      await Future.wait(futures);
    } catch (e) {
      logger.e('Error al obtener categorias para Tasks', error: e);
    }
    return asignaturasNames;
  }
}
