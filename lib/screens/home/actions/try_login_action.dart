import 'package:get/get.dart';
import 'package:miutem/core/models/user/estudiante.dart';
import 'package:miutem/core/repositories/secure_storage_repository.dart';
import 'package:miutem/core/services/auth_service.dart';

/// Intenta iniciar sesión con las credenciales guardadas en el dispositivo.
Future<Estudiante?> tryLoginWithSavedCredentials() async {
  final credentials = await Get.find<SecureStorageRepository>().getCredentials();
  if(credentials != null) {
    return await Get.find<AuthService>().login();
  }

  return null;
}