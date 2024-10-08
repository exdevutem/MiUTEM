import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miutem/core/models/exceptions/custom_exception.dart';
import 'package:miutem/core/models/user/credential.dart';
import 'package:miutem/core/repositories/secure_storage_repository.dart';
import 'package:miutem/core/services/auth_service.dart';

/// Intenta iniciar sesión con las credenciales recientemente ingresadas en el formulario.
Future<void> loginAction({
  required TextEditingController usernameController,
  required TextEditingController passwordController,
  required FocusNode usernameFocus,
  required FocusNode passwordFocus,
}) async {
  // Si usuario y clave no están vacíos
  final username = usernameController.text;
  final password = passwordController.text;

  if(username.isEmpty) {
    passwordFocus.unfocus();
    usernameFocus.requestFocus();
    throw CustomException(message: "Debes ingresar tu usuario!");
  }

  if(password.isEmpty) {
    usernameFocus.unfocus();
    passwordFocus.requestFocus();

    throw CustomException(message: "Debes ingresar tu contraseña!");
  }

  usernameFocus.unfocus();
  passwordFocus.unfocus();

  // Guardar credenciales
  await Get.find<SecureStorageRepository>().setCredentials(Credentials(username: username, password: password));
  await Get.find<AuthService>().login(forceRefresh: true);
}