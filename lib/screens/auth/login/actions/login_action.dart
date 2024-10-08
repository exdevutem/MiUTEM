import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miutem/core/models/exceptions/custom_exception.dart';
import 'package:miutem/core/models/user/credential.dart';
import 'package:miutem/core/repositories/secure_storage_repository.dart';
import 'package:miutem/core/services/auth_service.dart';
import 'package:miutem/screens/main_screen.dart';
import 'package:miutem/widgets/loading/loading_dialog.dart';
import 'package:miutem/widgets/snackbar.dart';

Future<void> loginAction({
  required BuildContext context,
  required TextEditingController usernameController,
  required TextEditingController passwordController,
  required FocusNode usernameFocus,
  required FocusNode passwordFocus,
}) async {
  showLoadingDialog(context);
  // Si usuario y clave no están vacíos
  final username = usernameController.text;
  final password = passwordController.text;

  if(username.isEmpty) {
    Navigator.pop(context);
    showErrorSnackbar(context, "Debes ingresar tu usuario!");
    passwordFocus.unfocus();
    usernameFocus.requestFocus();
    return;
  }

  if(password.isEmpty) {
    Navigator.pop(context);
    showErrorSnackbar(context, "Debes ingresar tu contraseña!");
    usernameFocus.unfocus();
    passwordFocus.requestFocus();
    return;
  }

  usernameFocus.unfocus();
  passwordFocus.unfocus();

  // Guardar credenciales
  await Get.find<SecureStorageRepository>().setCredentials(Credentials(username: username, password: password));

  try {
    await Get.find<AuthService>().login(forceRefresh: true);

    if(context.mounted) {
      Navigator.pop(context);
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainScreen()));
    }
  } on CustomException catch(e) {
    if(context.mounted) {
      Navigator.pop(context);
      showErrorSnackbar(context, e.message);
    }
  } catch (e) {
    if(context.mounted) {
      Navigator.pop(context);
      showErrorSnackbar(context, "Error al iniciar sesión. Por favor intenta nuevamente.");
    }
  }
}