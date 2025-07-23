import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miutem/core/models/asignaturas/asignatura.dart';
import 'package:miutem/core/models/user/estudiante.dart';
import 'package:miutem/core/services/asignaturas_service.dart';
import 'package:miutem/core/services/auth_service.dart';
import 'package:miutem/core/utils/utils.dart';
import 'package:miutem/screens/asignaturas/widgets/acceso_rapido.dart';
import 'package:miutem/screens/asignaturas/widgets/asignaturas_en_curso.dart';
import 'package:miutem/screens/auth/login/login_screen.dart';
import 'package:miutem/styles/styles.dart';

class AsignaturasScreen extends StatefulWidget {
  const AsignaturasScreen({super.key});

  @override
  State<AsignaturasScreen> createState() => _AsignaturasScreenState();
}

class _AsignaturasScreenState extends State<AsignaturasScreen> {
  Estudiante? estudiante;
  List<Asignatura>? asignaturas;

  @override
  void initState() {
    super.initState();
    Get.find<AuthService>().login()
        .then((estudiante) => setState(() => this.estudiante = estudiante), onError: (err) {
      if(mounted) {
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx) => const LoginScreen()));
      }
    });
    Get.find<AsignaturasService>()
        .getAsignaturas()
        .then((asignaturas) => setState(() => this.asignaturas = asignaturas),
            onError: (err) {
      logger.e('Error al cargar asignaturas', error: err);
    });
  }


  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: TopNavigation(
          estudiante: estudiante,
          isMainScreen: true,
          title: 'Asignaturas',
          actions: const [],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: RefreshIndicator(
            onRefresh: () async {
              setState(() {
                this.estudiante = null;
                this.asignaturas = null;
              });

        final estudiante = await Get.find<AuthService>().login(forceRefresh: true);
        final asignaturas = await Get.find<AsignaturasService>().getAsignaturas(forceRefresh: true);
        setState(() {
          this.estudiante = estudiante;
          this.asignaturas = asignaturas;
        });
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        clipBehavior: Clip.none,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text("Asignaturas", style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 20),
            const AccesoRapido(),
            const SizedBox(height: 20),
            AsignaturasEnCurso(asignaturas: asignaturas),
          ],
      ),),)
    );
}
