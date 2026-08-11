import "package:get/get.dart";
import "package:miutem/core/models/exceptions/custom_exception.dart";
import "package:miutem/core/models/horario.dart";
import "package:miutem/core/services/horario_service.dart";
import "package:miutem/core/utils/utils.dart";

Future<List<BloqueHorario>?> cargarClasesDeHoy({ bool forceRefresh = false }) async {
  try {
    final horario = await Get.find<HorarioService>().getHorario(forceRefresh: forceRefresh);
    final diaIdx = ahora().weekday - 1;
    if(diaIdx < 0 || diaIdx >= (horario.horario?.first.length ?? 0)) {
      throw CustomException(message: "No tienes clases hoy.");
    }

    final clasesDeHoy = horario.horario?.map((row) => row[diaIdx]).toList();
    final bloques = (clasesDeHoy?.asMap().entries.where((entry) => entry.key % 2 == 0).map((entry) => entry.value).toList())?.toList();
    if (clasesDeHoy == null || bloques?.where((bloque) => bloque.asignatura != null).isEmpty == true) {
      throw CustomException(message: "No tienes clases hoy.");
    }

    return bloques;
  } on CustomException catch (e) {
    return Future.error(e.message);
  } catch (e) {
    return Future.error("Error al cargar asignaturas. Por favor intenta más tarde.");
  }
}