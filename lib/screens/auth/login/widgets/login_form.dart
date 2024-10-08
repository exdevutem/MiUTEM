import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miutem/core/repositories/secure_storage_repository.dart';
import 'package:miutem/core/services/auth_service.dart';
import 'package:miutem/screens/auth/login/actions/login_action.dart';
import 'package:miutem/screens/auth/login/widgets/login_form_fields.dart';
import 'package:miutem/screens/main_screen.dart';
import 'package:miutem/widgets/loading/loading_dialog.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> with WidgetsBindingObserver {

  final TextEditingController _usernameController = TextEditingController();
  final FocusNode _usernameFocus = FocusNode();

  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _passwordFocus = FocusNode();

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _init();
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
                  LoginFormFields(
                    usernameController: _usernameController,
                    passwordController: _passwordController,
                    passwordFocus: _passwordFocus,
                    usernameFocus: _usernameFocus,
                    onLogin: () => loginAction(
                      context: context,
                      usernameController: _usernameController,
                      passwordController: _passwordController,
                      usernameFocus: _usernameFocus,
                      passwordFocus: _passwordFocus,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // launchURL('https://pasaporte.utem.cl/reset');
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

  _init() async {
    final credentials = await Get.find<SecureStorageRepository>().getCredentials();
    if(credentials == null) return;

    _usernameController.text = credentials.username;
    _passwordController.text = credentials.password;


    if(context.mounted) {
      showLoadingDialog(context);
    }

    try {
      Get.find<AuthService>().login();
      if(context.mounted) {
        Navigator.pop(context);
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainScreen()));
      }
    } catch(e) {
      if(context.mounted) {
        Navigator.pop(context);
      }
    }
  }

}
