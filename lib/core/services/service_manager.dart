import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart' show Firebase;
import 'package:miutem/core/models/config/user_config.dart';
import 'package:miutem/core/repositories/secure_storage_repository.dart';
import 'package:miutem/core/services/asignaturas_service.dart';
import 'package:miutem/core/services/auth_service.dart';
import 'package:miutem/core/services/carrera_service.dart';
import 'package:miutem/core/services/controllers/local_notifications_controller.dart';
import 'package:miutem/core/services/controllers/notas_controller.dart';
import 'package:miutem/core/services/firebase/remote_config_service.dart';
import 'package:miutem/core/services/grades_service.dart';
import 'package:miutem/core/services/horario_service.dart';
import 'package:miutem/core/services/mi_utem/miutem_auth_service.dart';
import 'package:miutem/core/services/mi_utem/miutem_credencial_service.dart';
import 'package:miutem/core/services/mi_utem/miutem_malla_service.dart';
import 'package:miutem/core/utils/firebase_options.dart';
import 'package:miutem/core/services/controllers/horario_controller.dart';

/// Inicializa los servicios y los registra en GetX
Future<void> initServices() async {
  // Inicializar Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Get.lazyPut(() => RemoteConfigService());
  await Get.find<RemoteConfigService>().initialize();

  // Repositorios (procesamiento de datos)
  Get.lazyPut(() => SecureStorageRepository());
  // Get.lazyPut(() => TasksRepository());

  // Servicios (solicitud de datos de las APIs)
  Get.lazyPut(() => AuthService());
  Get.lazyPut(() => CarreraService());
  Get.lazyPut(() => AsignaturasService());
  Get.lazyPut(() => GradesService());
  Get.lazyPut(() => HorarioService());

  // Servicios Mi.UTEM
  Get.lazyPut(() => MiUTEMAuthService());
  Get.lazyPut(() => MiUTEMMallaService());
  Get.lazyPut(() => MiUTEMCredencialService());

  // Controladores (lógica de la app)
  Get.lazyPut(() => NotasController(), fenix: true);
  Get.lazyPut(() => HorarioController());
  Get.lazyPut(() => NotificationController());
  await Get.find<NotificationController>().initialize();
  

  // Inicializar preferencias de usuario
  Get.lazyPut(() => UserConfig());
  Get.put(UserConfig()); 

}