import "dart:ui";

import "package:firebase_core/firebase_core.dart" show Firebase, FirebaseOptions;
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import "package:flutter/cupertino.dart";
import "package:get/get.dart";
import "package:get_storage/get_storage.dart";
import "package:miutem/core/mock/mock_services.dart";
import "package:miutem/core/models/config/user_config.dart";
import "package:miutem/core/repositories/secure_storage_repository.dart";
import "package:miutem/core/services/asignaturas_service.dart";
import "package:miutem/core/services/auth_service.dart";
import "package:miutem/core/services/carrera_service.dart";
import "package:miutem/core/services/controllers/local_notifications_controller.dart";
import "package:miutem/core/services/controllers/notas_controller.dart";
import "package:miutem/core/services/credencial_service.dart";
import "package:miutem/core/services/firebase/remote_config_service.dart";
import "package:miutem/core/services/grades_service.dart";
import "package:miutem/core/services/horario_service.dart";
import "package:miutem/core/services/mi_utem/miutem_auth_service.dart";
import "package:miutem/core/services/mi_utem/miutem_malla_service.dart";
import "package:miutem/core/services/controllers/horario_controller.dart";
import "package:miutem/core/utils/constants.dart";

/// Inicializa los servicios y los registra en GetX
Future<void> initServices(FirebaseOptions firebaseOptions) async {
  // Inicializar Firebase (como app default para que los servicios como RemoteConfig, Crashlytics, etc. funcionen correctamente)
  await Firebase.initializeApp(options: firebaseOptions);
  FlutterError.onError = (errorDetails) => FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  // Sin esto, GetStorage lee y escribe sobre un mapa vacío que se reemplaza cuando termina
  // de cargar el archivo: los colores del horario se perdían y todos los ramos salían celestes.
  await GetStorage.init();

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
  Get.lazyPut(() => CredencialService());

  // Servicios Mi.UTEM
  Get.lazyPut(() => MiUTEMAuthService());
  Get.lazyPut(() => MiUTEMMallaService());

  // Controladores (lógica de la app)
  Get.lazyPut(() => NotasController(), fenix: true);
  Get.lazyPut(() => HorarioController());
  Get.lazyPut(() => NotificationController());
  await Get.find<NotificationController>().initialize();
  

  // Inicializar preferencias de usuario
  Get.put(UserConfig());

  // Al generar las capturas para las tiendas se usan datos ficticios en vez de SIGA y Mi.UTEM.
  if (modoCapturas) {
    registrarServiciosMock();
  }
}