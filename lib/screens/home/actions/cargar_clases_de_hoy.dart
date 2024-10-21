import 'package:get/get.dart';
import 'package:miutem/core/models/horario.dart';
import 'package:miutem/core/services/horario_service.dart';

Future<List<BloqueHorario>?> cargarClasesDeHoy({ bool forceRefresh = false }) async {
  final horario = await Get.find<HorarioService>().getHorario(forceRefresh: forceRefresh);
  final diaIdx = DateTime.now().weekday - 1;
  if(diaIdx < 0 || diaIdx >= (horario.horario?.first.length ?? 0)) {
    return Future.error("No tienes clases hoy.");
  }

  final clasesDeHoy = horario.horario?.map((row) => row[diaIdx]).toList();
  final bloques = (clasesDeHoy?.asMap().entries.where((entry) => entry.key % 2 == 0).map((entry) => entry.value).toList())?.toList();
  if (clasesDeHoy == null || bloques?.where((bloque) => bloque.asignatura != null).isEmpty == true) {
    return Future.error("No tienes clases hoy.");
  }

  return bloques;
}