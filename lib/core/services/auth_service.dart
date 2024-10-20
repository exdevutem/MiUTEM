import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:miutem/core/models/exceptions/custom_exception.dart';
import 'package:miutem/core/models/preferencia.dart';
import 'package:miutem/core/models/user/estudiante.dart';
import 'package:miutem/core/repositories/secure_storage_repository.dart';
import 'package:miutem/core/utils/constants.dart';
import 'package:miutem/core/utils/http/functions.dart';
import 'package:miutem/core/utils/http/http_client.dart';
import 'package:miutem/screens/auth/login/login_screen.dart';

class AuthService {

  final SecureStorageRepository _secureStorageRepository = Get.find<SecureStorageRepository>();

  Future<bool> isFirstTime() async => (await Preferencia.lastLogin.exists()) == false;

  Future<bool> isLoggedIn() async => (await _secureStorageRepository.getEstudiante()) != null;

  Future<Estudiante> login({ bool forceRefresh = false }) async {
    final credentials = await _secureStorageRepository.getCredentials();
    if(credentials == null) {
      logger.d("[AuthService#isLoggedIn]: No se encontraron credenciales.");
      throw CustomException.custom();
    }

    Estudiante? estudiante = await _secureStorageRepository.getEstudiante();
    if (estudiante != null && !forceRefresh) {
      return estudiante;
    }

    try {
      final response = await sigaClientRequest("autenticacion/login/",
        method: 'POST',
        forceRefresh: forceRefresh,
        contentType: Headers.formUrlEncodedContentType,
        extra: {
          'noToken': true,
        },
        sigaParams: credentials.toJson(),
      );

      if(response.statusCode != 200 || response.data['status_code'] != 200) {
        throw CustomException.custom(message: "No logramos autenticarte.");
      }

      estudiante = Estudiante.fromJson(response.data['response'] as Map<String, dynamic>);
      await _secureStorageRepository.setEstudiante(estudiante);
      await Preferencia.lastLogin.set(DateTime.now().toIso8601String());
      return estudiante;
    } on DioError catch (e) {
      if(e.response?.statusCode == 401) {
        throw CustomException(message: "Credenciales incorrectas. Por favor intenta nuevamente.", statusCode: 401);
      }
      throw CustomException(message: e.response?.statusMessage ?? 'Error al iniciar sesión.', statusCode: e.response?.statusCode ?? 0, internalCode: 0.1);
    } catch (e) {
      logger.e(e);
      throw CustomException(message: "Ocurrió un error al autenticar. Por favor intenta más tarde.", internalCode: 0.2);
    }
  }

  /* Obtiene un token activo, si está expirado el actual, obtiene uno nuevo */
  Future<String> activeToken() async {
    Estudiante estudiante = await login();
    if(estudiante.isTokenExpired()) {
      estudiante = await login(forceRefresh: true);
    }

    if(estudiante.isTokenExpired()) {
      throw CustomException.custom(message: "No se pudo obtener un token válido. Por favor intenta más tarde.");
    }

    return estudiante.token;
  }

  Future<void> logout({ BuildContext? context}) async {
    await _secureStorageRepository.setEstudiante(null);
    await _secureStorageRepository.setCredentials(null);
    await Preferencia.onboardingStep.delete();
    await HttpClient.clearCache();

    if(context != null && context.mounted) {
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx) => const LoginScreen()));
    }
  }

}