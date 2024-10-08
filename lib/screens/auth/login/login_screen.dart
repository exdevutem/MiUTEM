import 'package:flutter/material.dart';
import 'package:miutem/screens/auth/login/widgets/background_video.dart';
import 'package:miutem/screens/auth/login/widgets/login_form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  @override
  void initState() {
    // TODO: Revisar si la sesión está iniciada, si es así redirigir al home screen.
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: BackgroundVideo(child: SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Image.asset('assets/images/utem_logo_color_blanco.png', height: 80),
          ),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: LoginForm(),
          ),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Text("Hecho con <3 por el Club de Desarrollo Experimental junto a SISEI",
              style: TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    )),
  );
}

