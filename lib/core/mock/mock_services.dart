import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:miutem/core/mock/mock_data.dart";
import "package:miutem/core/models/asignaturas/asignatura.dart";
import "package:miutem/core/models/asignaturas/asignatura_malla.dart";
import "package:miutem/core/models/carrera.dart";
import "package:miutem/core/models/evaluacion/grades.dart";
import "package:miutem/core/models/exceptions/custom_exception.dart";
import "package:miutem/core/models/horario.dart";
import "package:miutem/core/models/user/credential.dart";
import "package:miutem/core/models/user/estudiante.dart";
import "package:miutem/core/models/user/persona/persona.dart";
import "package:miutem/core/repositories/secure_storage_repository.dart";
import "package:miutem/core/services/asignaturas_service.dart";
import "package:miutem/core/services/auth_service.dart";
import "package:miutem/core/services/carrera_service.dart";
import "package:miutem/core/services/grades_service.dart";
import "package:miutem/core/services/horario_service.dart";
import "package:miutem/core/services/mi_utem/miutem_auth_service.dart";
import "package:miutem/core/services/mi_utem/miutem_malla_service.dart";

/// Reemplaza en GetX todos los servicios que salen a la red por versiones que
/// devuelven los datos ficticios de `mock_data.dart`.
///
/// Se llama sólo cuando `modoCapturas` es verdadero. Las pantallas y sus estados
/// de carga siguen siendo los reales: lo único que cambia es el origen de los datos.
void registrarServiciosMock() {
  Get.lazyReplace<SecureStorageRepository>(() => MockSecureStorageRepository());
  Get.lazyReplace<AuthService>(() => MockAuthService());
  Get.lazyReplace<CarreraService>(() => MockCarreraService());
  Get.lazyReplace<AsignaturasService>(() => MockAsignaturasService());
  Get.lazyReplace<GradesService>(() => MockGradesService());
  Get.lazyReplace<HorarioService>(() => MockHorarioService());
  Get.lazyReplace<MiUTEMAuthService>(() => MockMiUTEMAuthService());
  Get.lazyReplace<MiUTEMMallaService>(() => MockMiUTEMMallaService());
}

/// Storage en memoria: cada corrida parte sin sesión, así el recorrido de
/// capturas siempre empieza en el login sin depender del estado del simulador.
class MockSecureStorageRepository extends SecureStorageRepository {
  Credentials? _credenciales;
  Estudiante? _estudiante;
  String? _cookies;

  @override
  Future<String?> getMiUTEMCookies() async => _cookies;

  @override
  Future<bool> hasMiUTEMCookies() async => _cookies != null;

  @override
  Future<void> setMiUTEMCookies(String? cookies) async => _cookies = cookies;

  @override
  Future<Estudiante?> getEstudiante() async => _estudiante;

  @override
  Future<bool> hasEstudiante() async => _estudiante != null;

  @override
  Future<void> setEstudiante(Estudiante? estudiante) async => _estudiante = estudiante;

  @override
  Future<Credentials?> getCredentials() async => _credenciales;

  @override
  Future<bool> hasCredentials() async => _credenciales != null;

  @override
  Future<void> setCredentials(Credentials? credential) async => _credenciales = credential;
}

/// Acepta cualquier usuario y clave, y siempre devuelve el mismo estudiante.
class MockAuthService extends AuthService {
  final SecureStorageRepository _storage = Get.find<SecureStorageRepository>();

  bool _logueado = false;

  @override
  Estudiante? get cachedEstudiante => _logueado ? estudianteMock : null;

  @override
  Future<bool> isFirstTime() async => false;

  @override
  Future<bool> isLoggedIn() async => await _storage.getCredentials() != null;

  @override
  Future<Estudiante> login({bool forceRefresh = false}) async {
    if (await _storage.getCredentials() == null) {
      throw CustomException.custom(message: "No se encontraron credenciales.");
    }

    await _storage.setEstudiante(estudianteMock);
    _logueado = true;
    return estudianteMock;
  }

  @override
  Future<String> activeToken() async => estudianteMock.token;

  @override
  Future<void> logout({BuildContext? context}) async {
    _logueado = false;
    await super.logout(context: context);
  }
}

class MockCarreraService extends CarreraService {
  @override
  Future<Carrera> getCarrera({bool forceRefresh = false}) async => carreraMock;
}

class MockAsignaturasService extends AsignaturasService {
  @override
  Future<List<Asignatura>> getAsignaturas({bool forceRefresh = false}) async => asignaturasMock;

  @override
  Future<List<PersonaUtem>> getEstudiantes(Asignatura asignatura, {bool forceRefresh = false}) async => [];
}

class MockGradesService extends GradesService {
  @override
  Future<Grades> getGrades(Asignatura asignatura, {forceRefresh = false}) async => notasMock(asignatura);
}

class MockHorarioService extends HorarioService {
  @override
  Future<Horario> getHorario({bool forceRefresh = false}) async => horarioMock();
}

class MockMiUTEMAuthService extends MiUTEMAuthService {
  @override
  Future<String?> login() async => "sessionid=mock";

  @override
  Future<bool> isLoggedIn() async => true;
}

class MockMiUTEMMallaService extends MiUTEMMallaService {
  @override
  Future<List<AsignaturaMalla>> getMalla({bool forceRefresh = false}) async => mallaMock;
}
