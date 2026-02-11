import 'package:flutter/material.dart';
import 'package:miutem/screens/auth/login/widgets/utem_email_input_formatter.dart';

class LoginFormFields extends StatelessWidget {
  final TextEditingController usernameController, passwordController;
  final FocusNode usernameFocus, passwordFocus;
  final Function() onLogin;

  const LoginFormFields({super.key, required this.usernameController, required this.passwordController, required this.passwordFocus, required this.onLogin, required this.usernameFocus});

  String get fullEmail => '${usernameController.text}@utem.cl';

  @override
  Widget build(BuildContext context) => AutofillGroup(
    onDisposeAction: AutofillContextAction.commit,
    child: Column(
    children: [
      TextField(
        decoration: const InputDecoration(
          labelText: 'Usuario/Correo',
          hintText: 'usuario',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.alternate_email),
          suffixText: '@utem.cl',
        ),
        controller: usernameController,
        autocorrect: false,
        keyboardType: TextInputType.emailAddress,
        autofillHints: const [AutofillHints.username, AutofillHints.email],
        autofocus: true,
        onSubmitted: (_) => passwordFocus.requestFocus(),
        focusNode: usernameFocus,
        textInputAction: TextInputAction.next,
        inputFormatters: [UtemEmailInputFormatter()],
      ),
      const SizedBox(height: 10),
      TextField(
        decoration: const InputDecoration(
          labelText: 'Contraseña',
          hintText: '••••••••••',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.password),
        ),
        autofillHints: const [AutofillHints.password],
        keyboardType: TextInputType.visiblePassword,
        textInputAction: TextInputAction.go,
        focusNode: passwordFocus,
        obscureText: true,
        obscuringCharacter: '•',
        controller: passwordController,
        onSubmitted: (_) => onLogin(),
      ),
      const SizedBox(height: 10),
      FilledButton(
        onPressed: () => onLogin(),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: const Text('Ingresar'),
      ),
      const SizedBox(height: 10)
    ],
  ));
}
