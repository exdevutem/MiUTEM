
import 'package:flutter/material.dart';
import 'package:miutem/core/models/user/estudiante.dart';
import 'package:miutem/screens/auth/login/login_screen.dart';
import 'package:miutem/screens/home/actions/try_login_action.dart';
import 'package:miutem/screens/home/widgets/acceso_rapido/acceso_rapido.dart';
import 'package:miutem/screens/home/widgets/clases_de_hoy/clases_de_hoy.dart';
import 'package:miutem/screens/home/widgets/saludo.dart';
import 'package:miutem/widgets/navigation/top_navigation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Estudiante? estudiante;

  @override
  void initState() {
    super.initState();

    tryLoginWithSavedCredentials().then((estudiante) {
      if(estudiante == null && context.mounted) {
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx) => const LoginScreen()));
        return;
      }

      setState(() => this.estudiante = estudiante);
    });
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(16),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TopNavigation(estudiante: estudiante),
          const SizedBox(height: 20),
          Saludo(estudiante: estudiante),
          const SizedBox(height: 20),
          const AccesoRapido(),
          const SizedBox(height: 20),
          const ClasesDeHoy(),
        ],
      ),
    ),
  );
}
