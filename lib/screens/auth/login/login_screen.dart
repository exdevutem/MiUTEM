import 'package:flutter/material.dart';
import 'package:miutem/screens/auth/login/widgets/background_video.dart';
import 'package:miutem/screens/auth/login/widgets/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
    body: BackgroundVideo(child: Center(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: LoginForm(),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.only(left: 24, right: 24, bottom: 20),
                child: Text("Hecho con ❤️ por el Club de Desarrollo Experimental junto a SISEI",
                  style: TextStyle(color: Colors.white, fontSize: 15),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    )),
  );
}


