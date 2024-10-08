import 'package:flutter/material.dart';

class LoginFormFields extends StatelessWidget {
  final TextEditingController usernameController, passwordController;
  final FocusNode passwordFocus;
  final Function onLogin;
  
  const LoginFormFields({super.key, required this.usernameController, required this.passwordController, required this.passwordFocus, required this.onLogin});

  @override
  Widget build(BuildContext context) => Column(
    children: [
      TextField(
        decoration: const InputDecoration(
          labelText: 'Usuario/Correo',
          hintText: 'usuario@utem.cl',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.alternate_email),
        ),
        controller: usernameController,
        autocorrect: false,
        keyboardType: TextInputType.emailAddress,
        autofillHints: const [AutofillHints.email],
        autofocus: true,
        onSubmitted: (_) => passwordFocus.requestFocus(),
      ),
      const SizedBox(height: 10),
      TextField(
        decoration: const InputDecoration(
          labelText: 'Contraseña',
          hintText: '••••••••••',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.password),
        ),
        focusNode: passwordFocus,
        obscureText: true,
        obscuringCharacter: '•',
        controller: passwordController,
      ),
      const SizedBox(height: 10),
      FilledButton(
        onPressed: () => onLogin,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: const Text('Ingresar'),
      ),
      const SizedBox(height: 10)
    ],
  );
}
