import 'package:flutter/material.dart';
import 'package:miutem/screens/auth/login/widgets/background_video.dart';
import 'package:miutem/screens/auth/login/widgets/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
    body: BackgroundVideo(child: SafeArea(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 20),
            //child: Image.asset('assets/images/utem_logo_color_blanco.png', height: 80),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: LoginForm(),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.fromLTRB(24,0,24,20),
            child: Text("Hecho con ❤️ por el Club de Desarrollo Experimental junto a SISEI",
              style: TextStyle(color: Colors.white, fontSize: 15),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    )),
  );
}


