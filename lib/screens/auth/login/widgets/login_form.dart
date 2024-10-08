import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miutem/core/models/user/credential.dart';
import 'package:miutem/core/repositories/secure_storage_repository.dart';
import 'package:miutem/core/services/auth_service.dart';
import 'package:miutem/screens/auth/login/widgets/login_form_fields.dart';
import 'package:miutem/widgets/snackbar.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> with WidgetsBindingObserver {

  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _passwordFocus = FocusNode();

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    setState(() {});
    super.didChangePlatformBrightness();
  }

  @override
  Widget build(BuildContext context) => Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    color: Theme.of(context).scaffoldBackgroundColor,
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Image.asset(MediaQuery.of(context).platformBrightness == Brightness.light ? 'assets/images/miutem_oscuro.png' : 'assets/images/miutem_claro.png', height: 80, fit: BoxFit.fitWidth),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: Text("Por favor ingresa con tus credenciales de Pasaporte.UTEM",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
            Form(
              child: Column(
                children: [
                  LoginFormFields(usernameController: _usernameController, passwordController: _passwordController, passwordFocus: _passwordFocus, onLogin: () async {
                    // Si usuario y clave no están vacíos
                    final username = _usernameController.text;
                    final password = _passwordController.text;

                    if(username.isEmpty) {
                      showErrorSnackbar(context, "Debes ingresar tu usuario!");
                      return;
                    }

                    if(password.isEmpty) {
                      showErrorSnackbar(context, "Debes ingresar tu contraseña!");
                      return;
                    }

                    if(_passwordFocus.hasFocus) {
                      _passwordFocus.unfocus();
                    }

                    // Guardar credenciales
                    await Get.find<SecureStorageRepository>().setCredentials(Credentials(username: username, password: password));

                    try {
                      await Get.find<AuthService>().login(forceRefresh: true);
                    } catch (e) {
                      if(context.mounted) {
                        showErrorSnackbar(context, "Error al iniciar sesión. Por favor intenta nuevamente.");
                      }
                    }
                  }),
                  TextButton(
                    onPressed: () {

                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.secondary,
                    ),
                    child: const Text('¿Olvidaste tu contraseña?'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );

}
