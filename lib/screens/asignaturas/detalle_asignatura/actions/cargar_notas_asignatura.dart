import 'package:get/get.dart';
import 'package:miutem/core/models/asignaturas/asignatura.dart';
import 'package:miutem/core/services/grades_service.dart';

Future<Asignatura> cargarAsignaturaConNotas({required Asignatura asignatura, bool forceRefresh = false}) async {
  final grades = await Get.find<GradesService>().getGrades(asignatura, forceRefresh: forceRefresh);
  return asignatura.copyWith(grades: grades);
}