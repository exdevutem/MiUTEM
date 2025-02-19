import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miutem/core/models/horario.dart';
import 'package:miutem/core/models/user/estudiante.dart';
import 'package:miutem/core/services/auth_service.dart';
import 'package:miutem/core/services/firebase/remote_config_service.dart';
import 'package:miutem/core/utils/http/http_client.dart';
import 'package:miutem/screens/auth/login/login_screen.dart';
import 'package:miutem/screens/home/actions/cargar_clases_de_hoy.dart';
import 'package:miutem/screens/home/models/novedad.dart';
import 'package:miutem/screens/home/widgets/acceso_rapido.dart';
import 'package:miutem/screens/home/widgets/clases_de_hoy/seccion_clases_de_hoy.dart';
import 'package:miutem/screens/home/widgets/saludo.dart';
import 'package:miutem/styles/styles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? errorAlCargarHorario;
  Estudiante? estudiante;
  List<BloqueHorario>? bloques;
  List<Novedad>? novedades;

  @override
  void initState() {
    super.initState();

    novedades = Get.find<RemoteConfigService>().fetchNovedades().toList();

    Get.find<AuthService>().login().then((estudiante) {
      setState(() => this.estudiante = estudiante);
      _cargarHorario();
    }, onError: (err) {
      if (mounted) {
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (ctx) => const LoginScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: TopNavigation(estudiante: estudiante, isMainScreen: true, title: 'Inicio'),
    body: Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            this.estudiante = null;
            bloques = null;
            novedades = null;
          });
          await Get.find<RemoteConfigService>().refresh();
          await HttpClient.clearCache();
          final estudiante =
          await Get.find<AuthService>().login(forceRefresh: true);
          await _cargarHorario(forceRefresh: true);
          setState(() {
            this.estudiante = estudiante;
            novedades =
                Get.find<RemoteConfigService>().fetchNovedades().toList();
          });
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          clipBehavior: Clip.none,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Saludo(estudiante: estudiante),
              Space.large,
              const AccesoRapido(),
              Space.large,
              SeccionClasesDeHoy(
                  errorAlCargarHorario: errorAlCargarHorario,
                  bloques: bloques,
                  cargarHorario: _cargarHorario),
              // Space.large,
              //      ListaNovedades(novedades: novedades
              //    ),
            ],
          ),
        ),
      ),
    ),
  );

  _cargarHorario({bool forceRefresh = false}) async {
    setState(() {
      errorAlCargarHorario = null;
      bloques = null;
    });
    await cargarClasesDeHoy(forceRefresh: forceRefresh).then(
        (bloques) => setState(() {
              errorAlCargarHorario = null;
              this.bloques = bloques;
            }),
        onError: (err) => setState(() => errorAlCargarHorario = err));
  }
}
