import 'dart:convert';

import 'package:get/get.dart';
import 'package:miutem/core/models/asignaturas/asignatura.dart';
import 'package:miutem/core/services/grades_service.dart';
import 'package:miutem/core/services/horario_service.dart';
import 'package:miutem/core/utils/constants.dart';
import 'package:miutem/core/utils/horario_data.dart';
import 'package:miutem/screens/asignaturas/detalle_asignatura/models/horario_bloque.dart';

Future<Asignatura> cargarAsignaturaConNotas({required Asignatura asignatura, bool forceRefresh = false}) async {
  final grades = await Get.find<GradesService>().getGrades(asignatura, forceRefresh: forceRefresh);
  return asignatura.copyWith(grades: grades);
}

Future<List<HorarioBloque>> cargarHorarioBloque({required Asignatura asignatura}) async {
  try {
    final horario = await Get.find<HorarioService>().getHorario();
    Map<num, Map<num, HorarioBloque>> bloquesPorDia = {};
    for(final (idx, filaBloques) in (horario.horario ?? []).indexed) {
      if(filaBloques.isEmpty) continue; // Skip empty rows
      for(final (idxDia, bloque) in filaBloques.indexed) {
        if(bloque.asignatura == null || bloque.asignatura?.nombre.toUpperCase() != asignatura.nombre.toUpperCase() || bloque.asignatura?.codigo.toUpperCase() != asignatura.codigo.toUpperCase()) continue; // Skip empty blocks
        bloquesPorDia[idxDia] ??= {};
        bloquesPorDia[idxDia]![idx] = HorarioBloque(
          dia: diasHorario[idxDia],
          nombreAsignatura: bloque.asignatura?.nombre ?? 'N/A',
          sala: bloque.sala ?? 'N/A',
          horaInicio: bloquesHorario[idx].split('-')[0].trim(),
          horaFin: bloquesHorario[idx].split('-')[1].trim(),
        );
      }
    }

    return bloquesPorDia.values.expand((diaBloques) => diaBloques.values).toList();
  } catch (error) {
    logger.e('Error al cargar horario bloque', error: error);
    return [];
  }
}