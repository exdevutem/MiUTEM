import 'package:get/get.dart';
import 'package:miutem/core/models/asignaturas/asignatura.dart';
import 'package:miutem/core/services/asignaturas_service.dart';
import 'package:miutem/core/services/grades_service.dart';

Future<List<Asignatura>> cargarAsignaturasConNotas({ bool forceRefresh = false }) async {
  final asignaturas = (await Get.find<AsignaturasService>().getAsignaturas(forceRefresh: forceRefresh)).toList();
  for (var i = 0; i < asignaturas.length; i++) {
    final asignatura = asignaturas[i];
    asignaturas[i] = asignatura.copyWith(grades: await Get.find<GradesService>().getGrades(asignatura, forceRefresh: forceRefresh));
  }

  return asignaturas;
}