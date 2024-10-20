import 'package:flutter/material.dart';
import 'package:miutem/core/models/exceptions/custom_exception.dart';
import 'package:miutem/screens/auth/login/actions/login_action.dart';
import 'package:miutem/screens/auth/login/widgets/login_form_fields.dart';
import 'package:miutem/widgets/loading/loading_dialog.dart';
import 'package:miutem/widgets/navigation/bottom_navbar.dart';
import 'package:miutem/widgets/snackbar.dart';

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
                    onLogin: () async {
                      showLoadingDialog(context);
                      try {
                        await loginAction(
                          usernameController: _usernameController,
                          passwordController: _passwordController,
                          usernameFocus: _usernameFocus,
                          passwordFocus: _passwordFocus,
                        );
                        if(!context.mounted) return;
                        Navigator.popUntil(context, (route) => route.isFirst);
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx) => const BottomNavBar()));
                      } on CustomException catch (e) {
                        if(!context.mounted) return;
                        Navigator.pop(context);
                        showErrorSnackbar(context, e.message);
                      } catch (e) {
                        if(!context.mounted) return;
                        Navigator.pop(context);
                        showErrorSnackbar(context, "Ocurrió un error inesperado. Por favor, intenta nuevamente.");
                      }
                    },
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

}
