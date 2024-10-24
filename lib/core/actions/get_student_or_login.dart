import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miutem/core/models/user/estudiante.dart';
import 'package:miutem/core/services/auth_service.dart';
import 'package:miutem/core/utils/constants.dart';
import 'package:miutem/screens/auth/login/login_screen.dart';

/// Intenta obtener el estudiante actual, pero si ocurre un error al
/// obtenerlo, se solicita iniciar sesión nuevamente.
Future<Estudiante> getStudentOrLogin({ required BuildContext context }) async {
  try {
    final estudiante = Get.find<AuthService>().login();
    return estudiante;
  } catch (err) {
    logger.e(err);
    if(context.mounted) {
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx) => const LoginScreen()));
    }
  }

  return Future.error('Error al obtener el estudiante. Por favor, intenta nuevamente.');
}