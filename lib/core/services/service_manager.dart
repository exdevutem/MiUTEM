
import 'package:get/get.dart';
import 'package:miutem/core/repositories/secure_storage_repository.dart';
import 'package:miutem/core/services/asignaturas_service.dart';
import 'package:miutem/core/services/auth_service.dart';
import 'package:miutem/core/services/carrera_service.dart';
import 'package:miutem/core/services/grades_service.dart';
import 'package:miutem/core/services/horario_service.dart';

/// Inicializa los servicios y los registra en GetX
Future<void> initServices() async {
  // Repositorios (procesamiento de datos)
  Get.lazyPut(() => SecureStorageRepository());

  // Servicios (solicitud de datos de las APIs)
  Get.lazyPut(() => AuthService());
  Get.lazyPut(() => CarreraService());
  Get.lazyPut(() => AsignaturasService());
  Get.lazyPut(() => GradesService());
  Get.lazyPut(() => HorarioService());
  // await Get.find<HorarioService>().getHorario(forceRefresh: true);
}